require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe 'GET #new' do
        it 'render register page' do
            get :new
            expect(response).to render_template(:new)
        end

        it 'return new success' do
            get :new
            expect(response).to have_http_status(:success)
        end
    end

    describe 'POST #create' do
        context "with valid attributes" do
            it "saves a new user in the database" do
                expect{
                    post :create, params: {user: {username: "Tom", password: "123", password_confirmation: "123"}}
                }.to change{User.count}.by(1)
            end
            it "redirects to the user list page page" do
                post :create, params: {user: {username: "Tom", password: "123", password_confirmation: "123"}}
                expect(response).should redirect_to "/users/#{session[:user_id]}/todos"
            end
        end

        context "with invalid attributes" do
            it "does not save a new user in the database" do
                expect{
                    post :create, params: {user: {username: "Tom", password: "123", password_confirmation: "456"}}
                }.to_not change{User.count}
            end
            it "re-renders the :new template" do
                post :create, params: {user: {username: "Tom", password: "123", password_confirmation: "456"}}
                expect(response).should render_template :new
            end
        end
    end
end
