class SessionsController < ApplicationController
    def new
    end
    def create
        user = User.find_by_username(params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect_to root_url, notice: "Log In"
        else
            flash.now.alert = "username or password is incorrect"
            render "new"
        end
    end
end
