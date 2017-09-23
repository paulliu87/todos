class Todo < ApplicationRecord
  ActiveRecord::Base.include_root_in_json = false
  validates_presence_of :title, :deadline
  belongs_to :user
  def init
    self.completed  ||= false
    self.overdue ||= false         #will set the default value only if it's nil
  end

  def self.check_overdue(user_id)
    todos = []
    all_todos = User.find(user_id).todos
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

  def is_uncompleted
    self.update(completed: false)
  end

  def search(search)
    todos = []
    self.each do |todo|
      if todo[:title].include?(search) || todo[:detail].include?(search)
        todos.push(todo)
      end
    end
    todos.sort_by(&:deadline)
  end
end
