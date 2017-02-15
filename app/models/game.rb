class Game < ApplicationRecord
    has_many :questions, dependent: :delete_all
    has_many :teams, dependent: :delete_all
    accepts_nested_attributes_for :teams
    QUESTIONS_IN_ROUND = 25
    

    def answer_all
        self.questions.limit(QUESTIONS_IN_ROUND).each { |question| question.answer }
    end
    
    def set_round
        question_set = []
        (questions.limit(25).all? {|x| x.answered == true})? round =  25: round = 0
        (0..4).each {|x| question_set << questions.limit(5).offset((5*x) + round)}
        return question_set
    end
end
