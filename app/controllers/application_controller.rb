class ApplicationController < ActionController::Base
  before_action :login_required
  before_bugsnag_notify :add_user_info_to_bugsnag

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
      raise ActionController::MissingRenderer, format unless has_renderer?

      if patch? || put?
        has_errors? ? display_errors : display(resource)
      else
        super
      end
    end

    def default_render
      controller.response.status = :created if post? && format == :json
      super
    end
  end

  self.responder = Responder

  protected

  def login_required
    return true if session[:logged_in]

    if authenticate_with_http_basic { |l, p| l == Rails.application.credentials.budget_user && p == Rails.application.credentials.budget_password }
      session[:logged_in] = true
      return true
    else
      request_http_basic_authentication
    end
  end

  private

  def add_user_info_to_bugsnag(report)
    report.user = {
        id: session[:logged_in]
    }
  end
end
