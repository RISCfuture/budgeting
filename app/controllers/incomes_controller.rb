class IncomesController < ItemsController
  protected

  def item_scope
    super.where(income: true)
  end
end
