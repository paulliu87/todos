class User < ApplicationRecord
    has_secure_password

    attr_accessible :username, :password, :password_confirmation

    validates_uniqueness_of :username
end
