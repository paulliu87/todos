require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_user) {
      User.new(
        username: "Tom",
        password: "123",
        password_confirmation: "123"
      )
  }
  let(:unvalid_user) {
      User.new(
        username: "Tom",
        password: "123",
        password_confirmation: "123"
      )
  }

  describe "validations" do
      it "saves with valid information" do
          expect(valid_user.save).to be true
      end

      it "does not allow without a username" do
          valid_user.username = nil
          expect(valid_user.save).to be false
      end

      it "does not allow without a exited username" do
          valid_user.save
          expect(unvalid_user.save).to be false
      end

      it "does not allow without a password" do
          valid_user.password = nil
          expect(valid_user.save).to be false
      end

      it "does not allow when password does not match the password_confirmation" do
          valid_user.password_confirmation = "456"
          expect(valid_user.save).to be false
      end

  end
end
