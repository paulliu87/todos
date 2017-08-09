require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
    describe 'GET #new' do
        it 'render login page' do
            get :new
            expect(response).to render_template(:new)
        end

        it 'return new success' do
            get :new
            expect(response).to have_http_status(:success)
        end
    end

    describe 'POST #create' do
        before :each do
            @user = User.create(username: "Tom", password: "123", password_confirmation: "123")
        end

        it 'redirect to todos view page' do
            post :create, session: {username: "Tom", password: "123"}
            expect(response).to redirect_to("/users/#{@user.id}/todos")
        end

        it 'registes a user_id in session' do
            post :create, session: {username: "Tom", password: "123"}
            expect(session[:user_id]).to equal(@user.id)
        end
    end

    describe "DELETE #delete" do
        before :each do
            session[:user_id] = 1
        end

        it 'removes the user_id from session' do
            expect(session[:user_id]).to equal(nil)
        end
    end
end
