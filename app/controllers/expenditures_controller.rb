class ExpendituresController < ItemsController
  protected

  def item_scope
    super.where(income: false)
  end

  def permitted_attributes
    super + %i[budget sales_tax]
  end
end
