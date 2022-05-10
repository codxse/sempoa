module Api
  class UsersController < ApiController
    def index
      users = []
      users << "Nadiar"
      render json: { users: users }.to_json, status: :ok
    end

    def show
    end

    def create
    end

    def update
    end

    def destroy
    end
  end
end
