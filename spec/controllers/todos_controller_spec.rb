require 'rails_helper'

RSpec.describe TodosController, type: :controller do
    before :each do
        @user = User.create(username: "Tom", password: "123", password_confirmation: "123")
        @request.session[:user_id] = @user.id
    end
    describe "GET #index" do
        it "returns http success" do
            get :index, params: {user_id: @user.id}
            expect(response).to have_http_status(:success)
        end

        it "displays all the existed todo tasks" do

            Todo.create(title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List")
            Todo.create(title: "make some tests", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List")

            todos = Todo.all
            get :index, params: {user_id: @user.id}
            assigns(:todos).should eq(todos)
        end

        it "renders the :index template" do
            get :index,  params: {user_id: @user.id}
            response.should render_template :index
        end

    end
    describe "GET #show" do
        before :each do
            @todo = @user.todos.create(title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List")
        end
        it "displays a specific todo task" do
            get :show, params: {user_id: @user.id, id: @todo.id}
            assigns(:todo).should eq(@todo)
        end
        it "renders the :show template" do
            get :show, params: {user_id: @user.id, id: @todo.id}
            response.should render_template :show
        end
    end

    describe "GET #new" do
        it "renders the :new template" do
            get :new, params: {user_id: @user.id}
            response.should render_template :new
        end
    end

    describe "POST #create" do
        context "with valid attributes" do
            it "saves the new todo in the database" do
                expect{
                    post :create, params: {user_id: @user.id, todo: {title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List"}}
                }.to change{Todo.count}.by(1)
            end
            it "redirects to the todo list page page" do
                post :create, params: {user_id: @user.id, todo: {title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List"}}
                expect(response).should redirect_to "/users/#{@user.id}/todos"
            end
        end

        context "with invalid attributes" do
            it "does not save the new todo task in the database" do
                expect{
                    post :create, params: {user_id: @user.id, todo: {deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List"}}
                }.to_not change{Todo.count}
            end
            it "re-renders the :new template" do
                post :create, params: {user_id: @user.id, todo: {deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List"}}
                expect(response).should render_template :new
            end
        end
    end
    describe "DELETE #destory" do
        before :each do
            @todo = @user.todos.create(title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List")
        end
        it 'removes the todo from users list' do
            delete :destroy, params: {user_id: @user.id, id: @todo.id}
            expect(Todo.find_by_id(@todo.id)).to equal(nil)
        end

        it 'changes the count of total todos' do
            expect {delete :destroy, params: {user_id: @user.id, id: @todo.id}}.to change{Todo.count}.by(-1)
        end
    end

    describe "UPDATE #iscompleted" do
        before :each do
            @todo = @user.todos.create(title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List")
        end

        it "marks a todo task as completed" do
            expect {put :update, params: {user_id: @user.id, id: @todo.id}}.to change{Todo.find(@todo.id).completed}.from(false).to(true)
        end
    end

    describe "GET #edit" do
        before :each do
            @todo = @user.todos.create(title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List")
        end

        it "returns a 200 status" do
            get :edit, params: {id: @todo.id, user_id: @user.id}
            expect(response).to have_http_status(200)
        end

        it "renders an edit template" do
            get :edit, params: {id: @todo.id, user_id: @user.id}
            expect(response).to render_template :edit
        end
    end

    describe "PUT #update" do
        before :each do
            @todo = @user.todos.create(title: "complete take home project", deadline: DateTime.new(2012, 8, 29, 12, 34, 56), completed: false, detail: "Making a Todo List")
        end

        context "it updates correctly" do
            it "returns a 302 status" do
                @attr = {:title => "this is a test", :deadline => @todo.deadline, :completed => @todo.completed, :detail => @todo.detail}
                put :update, params: {id: @todo.id, user_id: @user.id, todo: @attr}
                expect(response).to have_http_status(302)
            end
            it "redirects to show page" do
                @todo.title = {:title => "this is a test"}
                put :update, params: {id: @todo.id, user_id: @user.id, todo: @todo}
                expect(response).to redirect_to 'show'
            end
            it "updates the information of the todo" do
                @todo.title = {:title => "this is a test"}
                expect {put :update, params: {id: @todo.id, user_id: @user.id, todo: @todo}}.to change{Todo.find(@todo.id).title}.from("complete take home project").to("this is a test")
            end
        end

        context "it does not update correctly" do
            it "returns a 200 status" do
                @todo.title = {:title => ""}
                put :update, params: {id: @todo.id, user_id: @user.id, todo: @todo}
                expect(response).to have_http_status(200)
            end
            it "renders edit page" do
                @todo.title = {:title => ""}
                put :update, params: {id: @todo.id, user_id: @user.id, todo: @todo}
                expect(response).to render_template 'edit'
            end
            it "updates the information of the todo" do
                @todo.title = {:title => ""}
                expect {put :update, params: {id: @todo.id, user_id: @user.id, todo: @todo}}.to not_change
            end
        end
    end
end
