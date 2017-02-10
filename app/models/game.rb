class Game < ApplicationRecord
    has_many :questions, dependent: :delete_all
    has_many :teams, dependent: :delete_all
    accepts_nested_attributes_for :teams
    QUESTIONS_IN_ROUND = 25
    

    def answer_all
        self.questions.limit(QUESTIONS_IN_ROUND).each { |question| question.answer }
    end
end
