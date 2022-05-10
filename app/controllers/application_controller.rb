class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound do |e|
    Rails.logger.error e.message
    Rails.logger.error "stacktrace: #{e.backtrace.take(10).join('\n')}"
    render_404
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def render_404
    request.format = :html unless %i[html json].include?(request.format.to_sym)

    respond_to do |format|
      format.html do
        render file: Rails.root.join("public/404.html"), layout: false, status: :not_found
      end

      format.json do
        render json: { error: 'Not Found' }, status: :not_found
      end

      format.all do
        render head: :not_found
      end
    end
  end
end
