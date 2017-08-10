class Todo < ApplicationRecord
    validates_presence_of :title, :deadline
    def init
      self.completed  ||= false
      self.overdue ||= false         #will set the default value only if it's nil
    end

    def self.is_overdued
        todos = []
        all_todos = Todo.all
        all_todos.each do |todo|
            deadline = DateTime.strptime(todo.deadline.to_s, "%Y-%m-%d %H:%M:%S %Z")
            if deadline <= DateTime.now
                todo.update(overdue: true)
            end
            todos.push(todo)
        end
        todos
    end

    def is_completed
        self.update(completed: true)
    end
end
