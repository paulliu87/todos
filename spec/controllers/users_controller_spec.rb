require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe 'new' do
        it 'render register page' do
            expect(response).to render_template(:new)
        end
    end
    
end
