class ApiController < ApplicationController
  def render_404
    render json: { error: 'Not Found' }, status: :not_found
  end
end
