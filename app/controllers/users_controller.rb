class UsersController < ApplicationController
    def new
        @user = User.new
    end
    def create
        @user = User.new(param[:user])
        if @user.save
            redirect_to root_url, notice: "Thank you for signing up!"
        else
            render "new"
        end
    end

    private
        def user_params
            params.require(:user).permit(:username, :password)
        end
end
