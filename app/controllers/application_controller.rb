class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :login_required

  rescue_from(ActiveRecord::RecordNotFound) do |error|
    respond_to do |format|
      format.json { render json: {error: error}, status: :not_found }
    end
  end

  # @private
  class Responder < ActionController::Responder
    protected

    def json_resource_errors
      {errors: resource.errors.details}
    end

    def api_behavior
      raise ActionController::MissingRenderer.new(format) unless has_renderer?

      if patch? || put?
        has_errors? ? display_errors : display(resource)
      else
        super
      end
    end

    def default_render
      if post? && format == :json
        controller.response.status = :created
      end
      super
    end
  end

  self.responder = Responder

  protected

  def login_required
    if session[:logged_in]
      return true
    elsif authenticate_with_http_basic { |l, p| l == ENV['BUDGET_USER'] && p == ENV['BUDGET_PASSWORD'] }
      session[:logged_in] = true
      return true
    else
      request_http_basic_authentication
    end
  end
end
