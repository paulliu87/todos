class Todo < ApplicationRecord
    validates_presence_of :title, :deadline
end
