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

    describe 'create' do
        before do
            @user = User.new
        end
        it 'redirect to todos view page' do
            expect(response).to redirect_to("/users/#{@user.id}/todos")
        end
    end
end
