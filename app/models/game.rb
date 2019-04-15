class Game < ApplicationRecord
    belongs_to :user

    def without_user_id
        {id: self.id,
        score: self.score,
        word: self.word,
        definition: self.definition}
    end
end
