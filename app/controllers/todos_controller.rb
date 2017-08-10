class TodosController < ApplicationController
    def index
        @todos = Todo.is_overdued
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

    def destroy
        Todo.find_by_id(params[:id]).destroy
        redirect_to "/users/#{params[:user_id]}/todos"
    end

    def update
        @todo = Todo.find_by_id(params[:id])
        @todo.is_completed
        redirect_to "/users/#{params[:user_id]}/todos/#{params[:id]}"
    end

    private
        def todo_params
            params.require(:todo).permit(:title, :deadline, :completed, :detail)
        end
end
