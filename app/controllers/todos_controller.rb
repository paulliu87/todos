class TodosController < ApplicationController
    before_filter :authorize
    def index
        @todos = Todo.check_overdued(params[:user_id])
        @recent_todos = @todos.sort_by(&:updated_at).reverse!.take(5)
    end
    def show
        @todo = Todo.find_by_id(params[:id])
    end
    def new
        @todo = Todo.new
    end

    def create
        @todo = User.find(params[:user_id]).todos.new(todo_params)

        if @todo.save
            redirect_to "/users/#{params[:user_id]}/todos"
        else
            render 'new'
        end
    end

    def destroy
        Todo.find_by_id(params[:id]).destroy!
        respond_to do |format|
          format.html { redirect_to user_todos_path, notice: 'Item was successfully deleted.' }
        end
    end

    def completed
        @todo = Todo.find_by_id(params[:id])
        @todo.is_completed
        respond_to do |format|
          format.html { redirect_to "/users/#{params[:user_id]}/todos/#{params[:id]}" }
          format.json { @todo.completed.to_json }
        end
    end

    def edit
        @todo = Todo.find_by_id(params[:id])
    end

    def update
        @todo = Todo.find_by_id(params[:id])
        if @todo.update(todo_params)
            redirect_to user_todo_path
        else
            render 'edit'
        end
    end

    private
        def todo_params
            params.require(:todo).permit(:title, :deadline, :completed, :detail)
        end
end
