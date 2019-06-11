export type Period = 'day' | 'week' | 'month' | 'year'

interface Item {
  id: number
  category: string
  name: string
  quantity: number
  unit_amount: number
  period_unit: Period
  period_count: number
  formatted_period: string
  prorated_amount: number
  notes?: string
}

export interface Income extends Item {}

export interface Expenditure extends Item {
  budget: boolean
  sales_tax: boolean
}

export interface Totals {
  income: number
  gross_expenditures: number
  taxes: number
  net_expenditures: number
  total: number
}

export interface Error {
  name: string
}

export type Errors = {[field: string]: Error[]}
