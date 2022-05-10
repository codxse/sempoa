require 'rails_helper'

describe ApplicationController, type: :controller do
  context "rescue from ActionController::RoutingError" do
    controller do
      def index
        raise ActionController::RoutingError, 'exception'
      end
    end

    it "response 404" do
      get :index

      expect(response).to have_http_status :not_found
    end

    it "response 404" do
      get :index, format: :php

      expect(response).to have_http_status :not_found
    end
  end

  context "rescue from ActiveRecord::RecordNotFound" do
    controller do
      def index
        raise ActiveRecord::RecordNotFound, 'exception'
      end
    end

    it "response 404" do
      get :index

      expect(response).to have_http_status :not_found
    end

    it "response 404 when request format json" do
      get :index, format: :json

      expect(response).to have_http_status :not_found
      expect(response.body).to eq '{"error":"Not Found"}'
    end
  end
end
