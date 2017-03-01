class Question < ApplicationRecord
    belongs_to :game
    
    
    def answer
        self.answered = true
        self.save
    end
    
    def unanswer
        self.answered = false
        self.save
    end
end
