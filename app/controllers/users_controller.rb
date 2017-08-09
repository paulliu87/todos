class UsersController < ApplicationController
    def new
        @user = User.new
        render "new"
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            redirect_to "/users/#{@user.id}/todos", notice: "Thank you for signing up!"
        else
            render "new"
        end
    end

    private
        def user_params
            params.require(:user).permit(:username, :password, :password_confirmation)
        end
end
