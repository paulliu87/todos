class TodosController < ApplicationController
    def index
        @todos = Todo.find_all
    end
    def show
        @todo = Todo.find_by_id(params[:id])
    end
    def new
        render "new"
    end

    def create
        @todo = Todo.new(todo_params)

        if @todo.save
            redirect_to "/users/#{params[:user_id]}/todos"
        else
            render 'new'
        end
    end
end
