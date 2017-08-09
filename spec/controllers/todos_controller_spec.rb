require 'rails_helper'

RSpec.describe TodosController, type: :controller do
    describe "GET #show" do
        it "displays a specific todo task" do
            todo = Todo.create(title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), is_completed: false, detail: "Making a Todo List")
            get :show, id: todo
            assigns(:todo).should eq(todo)
        end
        it "renders the :show template" do
            get :show, id: todo
            response.should render_template :show
        end
    end

    describe "GET #new" do
        it "renders the :new template" do
            get :new
            response.should render_template :new
        end
    end

    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new todo in the database" do
                expect{
                    post :create, todo: {title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), is_completed: false, detail: "Making a Todo List"}
                }.to change(Todo,:count).by(1)
            end
            it "redirects to the todo list page page" do
                post :create, todo: {title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), is_completed: false, detail: "Making a Todo List"}
                response.should redirect_to todos_path
            end
        end

        context "with invalid attributes" do
            it "does not save the new contact in the database" do
                expect{
                    post :create, todo: {deadline: DateTime.new(2012, 8, 29, 12, 34, 56), is_completed: false, detail: "Making a Todo List"}
                }.to_not change(Todo,:count)
            end
            it "re-renders the :new template" do
                post :create, todo: {deadline: DateTime.new(2012, 8, 29, 12, 34, 56), is_completed: false, detail: "Making a Todo List"}
                response.should render_template :new
            end
        end
    end
end
