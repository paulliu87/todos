class TodosController < ApplicationController
    before_filter :authorize
    def index
      todos = Todo.check_overdued(params[:user_id])
      if todos.nil?
        @todos = nil
        @recent_todos = nil
      else
        uncompleted_todos = todos.select { |todo| todo.completed == false }
        @todos = {}
        uncompleted_todos.sort_by(&:deadline).each do |todo|
          key = todo.deadline.to_date.to_s.to_sym
          if @todos.key?(key)
            @todos[key].push(todo)
          else
            @todos[key] = []
            @todos[key].push(todo)
          end
        end
        completed_todos = todos.select { |todo| todo.completed == true }
        @recent_todos = completed_todos.sort_by(&:updated_at).reverse!.take(3)
      end
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
        format.json { render json: @todo.as_json(root: false) }
      end
    end

    def uncompleted
      @todo = Todo.find_by_id(params[:id])
      @todo.is_uncompleted
      todos = Todo.check_overdued(params[:user_id])
      completed_todos = todos.select { |todo| todo.completed == true }
      recent_todos = completed_todos.sort_by(&:updated_at).reverse!.take(3)
      respond_to do |format|
        format.html { redirect_to "/users/#{params[:user_id]}/todos/#{params[:id]}" }
        # format.json { render json: { "todo" => @todo.as_json(root: false)}.as_json}
        format.json { render json: { "todo" => @todo.as_json(root: false), "completed_todos" => recent_todos.as_json} }
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
