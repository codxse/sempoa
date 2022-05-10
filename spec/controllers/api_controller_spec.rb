require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  describe "#index" do
    controller do
      def index
        raise ActiveRecord::RecordNotFound
      end
    end

    it 'should respond with 404 and error message' do
      get :index

      expect(response).to have_http_status :not_found
      expect(response.body).to eq({ error: 'Not Found' }.to_json)      # get :index
    end
  end
end
