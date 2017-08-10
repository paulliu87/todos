require 'rails_helper'

RSpec.describe Todo, type: :model do
    let(:user) {
        User.create(
            username: "John",
            password: "123",
            password_confirmation: "123"
        )
    }
    let(:valid_todo) {
        user.todos.new(
          title: "complete take home project",
          deadline: DateTime.new(2012, 8, 29, 12, 34, 56),
          completed: false,
          detail: "Making a Todo List"
        )
    }
    let(:unvalid_todo) {
        user.todos.new(
            deadline: DateTime.new(2012, 8, 29, 12, 34, 56),
            completed: false,
            detail: "Making a Todo List"
        )
    }

    describe "validations" do
        it "saves with valid information" do
            expect(valid_todo.save).to be true
        end

        it "does not allow without a title" do
            expect(unvalid_todo.save).to be false
        end

        it "does not allow without a deadline" do
            valid_todo.deadline = nil
            expect(valid_todo.save).to be false
        end
    end
end
