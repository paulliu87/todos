require 'rails_helper'

RSpec.describe "home/index.html.erb", type: :view do
  describe "rendering home page" do
      it 'displays a sign up form' do
          render
          rendered.should match('Getting Started')
      end
  end
end
