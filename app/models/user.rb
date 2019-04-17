class User < ApplicationRecord
    has_secure_password
    has_many :games
    validates :name, presence: true
    validates :password, presence: true

    def total_score
        self.games.sum(:score)
    end
end
