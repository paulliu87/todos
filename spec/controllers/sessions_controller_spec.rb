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
        before do
            @user = User.create(username: "tom", password: "123", password_confirmation: "123")
        end

        it 'redirect to todos view page' do
            post :create, session: {username: "Tom", password: "123"}
            expect(response).to redirect_to("/users/#{@user.id}/todos")
        end
    end
end
