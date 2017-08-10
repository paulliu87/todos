class Todo < ApplicationRecord
    validates_presence_of :title, :deadline
    def init
      self.completed  ||= false           #will set the default value only if it's nil
    end
end
