class Item < ApplicationRecord
  REFERENCE_DATE = Time.zone.local(2001, 1, 1) # first day of week, month, & year
  private_constant :REFERENCE_DATE

  enum period_unit: %i[day week month year]

  validates :category, :name,
            presence: true,
            length:   {maximum: 126}
  validates :name,
            uniqueness: {scope: :category}
  validates :unit_amount,
            presence:     true,
            numericality: {greater_than: 0}
  validates :quantity, :period_count,
            presence:     true,
            numericality: {only_integer: true, greater_than: 0}
  validates :period_unit,
            presence: true
  validates :notes,
            length:    {maximum: 1000},
            allow_nil: true

  def amount(include_tax: false)
    gross = unit_amount*quantity
    (include_tax && sales_tax?) ? gross*(1+Budgeting::SALES_TAX) : gross
  end

  def expenditure?() !income? end

  def prorated_amount(interval: :monthly, include_tax: false)
    amount(include_tax: include_tax) * proration_factor(interval)
  end

  # Calculates a multiplicative factor to divide a time period over a recurring
  # interval. `period` is the time period (such as one month or 3 years)
  # and `interval` is a recurring interval (such as daily or monthly). Note
  # that even though they are both similar, `period` is really a calendar
  # duration and `interval` is a calendar frequency. (A **calendar**
  # duration/frequency meaning that the arithmetic is applied to calendar
  # components and not measures of time.)
  #
  # This multiplicative factor can then be applied to a cost or budget to divide
  # it up evenly over the time period at a frequency equal to the time interval.
  #
  # `interval` is taken to be the indivisible basis for the time division. For
  # instance, a one-year period (`period` = 1 year) divided on a monthly
  # basis (`interval` = `:monthly`) results in a proration factor of 1/12;
  # namely, in each month, 1/12 of the total cost is applied, regardless of the
  # number of days in that month.
  #
  # An optional `date` can be provided to be used as the date for which the
  # prorated amount is being calculated. This becomes necessary when, for
  # example, distributing a monthly period over a daily interval. To know how
  # much of the period applies daily, we must know how many days are in the
  # month for this period.
  #
  # When necessary, the start date for cyclic calculations is assumed to be
  # Monday, January 1, 2001. This becomes necessary when, for example,
  # distributing a bi-monthly period over a daily interval. To know what portion
  # of the period applies daily, we must know if the 2-month period consists of
  # this month and last month, or this month and next month, as those two
  # periods may have a different number of days. In this case, the two-month
  # period is assumed to be a recurring period that began on 1/1/2001, and is
  # iterated forward to the subsequent cycle including `date`.
  #
  # @param [ActiveSupport::Duration] period The time period over which (e.g.) a
  #   budget or bill applies.
  # @param [Symbol] interval The frequency at which the budget is contributed to
  #   or the bill is paid during that time period (daily, weekly, biweekly,
  #   monthly, quarterly, or annually).
  # @param [Date] date The date at which a given payment or contribution is
  #   made.
  # @return [Float] The fraction of the total cost that applies over the given
  #   interval.
  # @raise [ArgumentError] If `period` contains multiple components (such as
  #   "1 month and 1 day").
  # @raise [ArgumentError] If `period` contains components smaller than a day
  #   (such as "3 hours").
  # @raise [ArgumentError] If `interval` is not a known interval.

  def self.proration_factor(period, interval, date: Date.current)
    raise ArgumentError, "Periods must have one part only" unless period.parts.size == 1

    from_unit     = period.parts.keys.first
    from_quantity = period.parts.values.first.to_f

    case from_unit
      when :days, :weeks
        from_days = case from_unit
                      when :days then 1
                      when :weeks then 7
                    end
        case interval
          when :daily, :weekly, :biweekly
            to_days = case interval
                        when :daily then 1
                        when :weekly then 7
                        when :biweekly then 14
                      end

            to_days/(from_quantity*from_days)
          when :monthly
            to_days = date.end_of_month.day
            to_days/(from_quantity*from_days)
          when :quarterly
            to_days = date.end_of_quarter - date.beginning_of_quarter + 1
            to_days/(from_quantity*from_days)
          when :annually
            if from_unit == :days
              to_days = Time.days_in_year(date.year)
              to_days/from_quantity
            else # weeks
              from_quantity*52
            end

          else
            raise ArgumentError, "Unsupported interval #{interval.inspect}"
        end

      when :months
        case interval
          when :daily, :weekly, :biweekly
            divisor = case interval
                        when :daily then 1
                        when :weekly then 7
                        when :biweekly then 14
                      end
            period_start, period_end = proration_period(period, date)
            divisor/(period_end - period_start).to_f
          when :monthly, :quarterly, :annually
            divisor = case interval
                        when :monthly then 1
                        when :quarterly then 3
                        when :annually then 12
                      end
            divisor/from_quantity
          else
            raise ArgumentError, "Unsupported interval #{interval.inspect}"
        end

      when :years
        case interval
          when :daily
            period_start, period_end = proration_period(period, date)
            1/(period_end - period_start).to_f
          when :weekly, :biweekly
            period_start, period_end = proration_period(period, date)
            weeks = (period_end.year - period_start.year)*52.0
            divisions = weeks/((interval == :weekly) ? 1 : 2)
            1/divisions
          when :monthly, :quarterly, :annually
            multiplier = case interval
                           when :monthly then 12
                           when :quarterly then 4
                           when :annually then 1
                         end
            1/(from_quantity*multiplier)
          else
            raise ArgumentError, "Unsupported interval #{interval.inspect}"
        end

      else
        raise ArgumentError, "Unsupported period #{period}"
    end
  end

  # @private
  def self.proration_period(period, date)
    leap = period.parts.each_with_object({}) { |(k, v), h| h[k] = v } # duplicate the hash and remove the default of 0 as that screws up `advance`
    start_date = REFERENCE_DATE
    prev_date  = REFERENCE_DATE
    until start_date > date
      prev_date  = start_date
      start_date = start_date.advance(leap)
    end
    return [prev_date.to_date, start_date.to_date]
  end

  private

  def period
    period_count.send(period_unit)
  end

  def proration_factor(interval, date: Date.current)
    self.class.proration_factor period, interval, date: date
  end
end
