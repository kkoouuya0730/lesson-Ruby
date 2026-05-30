class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_unprocessable(e)
    render json: e.record.errors, status: :unprocessable_content
  end

  def render_not_found
    head :not_found
  end
end
