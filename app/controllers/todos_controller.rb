class TodosController < ApplicationController
    def index
        @todos = Todo.all
    end
    def show
        @todo = Todo.find_by_id(params[:id])
    end
    def new
        @todo = Todo.new
    end

    def create
        @todo = Todo.new(todo_params)

        if @todo.save
            redirect_to "/users/#{params[:user_id]}/todos"
        else
            render 'new'
        end
    end

    def destory
        Todo.find_by_id(params[:id]).destory
    end
    private
        def todo_params
            params.require(:todo).permit(:title, :deadline, :completed, :detail)
        end
end
