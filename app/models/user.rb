class User < ApplicationRecord
    has_secure_password
    validates_uniqueness_of :username
    validates_presence_of :username
    has_many :todos
end
