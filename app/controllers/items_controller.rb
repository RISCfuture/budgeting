class ItemsController < ApplicationController
  before_action :find_item, except: %i[index create]
  respond_to :json

  def index
    @items = item_scope.order(category: :asc, name: :asc)
    respond_with @items
  end

  def create
    @item = item_scope.create(item_params)
    respond_with @item
  end

  def update
    @item.update item_params
    respond_with @item
  end

  def destroy
    @item.destroy
    respond_with @item
  end

  protected

  def item_scope
    Item
  end

  def permitted_attributes
    %i[category name unit_amount amount_cents period_unit quantity period_count notes]
  end

  private

  def find_item
    @item = item_scope.find(params[:id])
  end

  def item_params
    params.require(:item).permit(*permitted_attributes)
  end

  # @private
  class Responder < ApplicationController::Responder
    protected

    def display(resource)
      controller.render "items/#{controller.action_name}"
    end

    def api_location
      resources
    end
  end

  self.responder = Responder
end
