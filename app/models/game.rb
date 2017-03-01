class Game < ApplicationRecord
    has_many :questions, dependent: :delete_all
    has_many :teams, dependent: :delete_all
    accepts_nested_attributes_for :teams
    QUESTIONS_IN_ROUND = 25
        QUESTIONS = { "L1.1" => {text: "What's this?", image: "p.png", points: 1},
                "L2.1" => {text: "I like elephants.", image: nil, points: 1},
                "L3.1" => {text: "インド", image: nil, points: 1},
                "L4.1" => {text: "What animal do you like?", points: 1},
                "L5.1" => {text: "I like _____.", image: "pizza.png", points: 1},
                
                "L1.2" => {text: "What's this?", image: "bear.jpg", points: 2},
                "L2.2" => {text: "October", points: 2},
                "L3.2" => {text: "１２月", image: nil, points: 2},
                "L4.2" => {text: "What time is it?", image: nil, points: 2},
                "L5.2" => {text: "It's _____.", image: "america.png", points: 2},
                
                "L1.3" => {text: "What's this?", image: "january.png", points: 3},
                "L2.3" => {text: "Forty-seven", points: 3},
                "L3.3" => {text: "１０時１０分", points: 3},
                "L4.3" => {text: "When is your birthday?", points: 3},
                "L5.3" => {text: "I can _____.", image: "playthepiano.png", points: 3},
                
                "L1.4" => {text: "What's this?", image: "playsoccer.png", points: 4},
                "L2.4" => {text: "September tenth", points: 4},
                "L3.4" => {text: "野球ができます", points: 4},
                "L4.4" => {text: "Can you swim?", points: 4},
                "L5.4" => {text: "I can't _____.", image: "swim.png", points: 4},

                "L1.5" => {text: "What's this?", image: "one_oclock.png", points: 5},
                "L2.5" => {text: "I can play baseball.", points: 5},
                "L3.5" => {text: "イタリアに行きたいです", points: 5},
                "L4.5" => {text: "Who am I?<br>P.12", points: 5},
                "L5.5" => {text: "My birthday is _____.", image: 'march27th.png', points: 5},
                
                "L1.12" => {text: "What's this?", image: "egypt.jpg", points: 2},
                "L2.12" => {text: "I can't cook.", image: nil, points: 2},
                "L3.12" => {text: "ピアノができますか？", image: nil, points: 2},
                "L4.12" => {text: "Where do you want to go?", points: 2},
                "L5.12" => {text: "I want to go to _____.", image: "france.jpg", points: 2},
                
                "L1.22" => {text: "What's this?", image: "tennis.jpg", points: 4},
                "L2.22" => {text: "I want to go to America.", points: 4},
                "L3.22" => {text: "私の誕生日は、７月１４日", image: nil, points: 4},
                "L4.22" => {text: "Where is the bookstore?<br>p.14", image: nil, points: 4},
                "L5.22" => {text: "I want to eat _____.", image: "gyoza.jpg", points: 4},
                
                "L1.32" => {text: "What's this?", image: "hospital.jpg", points: 6},
                "L2.32" => {text: "My birthday is May 1st.", points: 6},
                "L3.32" => {text: "私は、１時にランチ食べます", points: 6},
                "L4.32" => {text: "What time do you go to bed?", points: 6},
                "L5.32" => {text: "I get up at _____.", image: "six_oclock.png", points: 6},
                
                "L1.42" => {text: "What's this?", image: "big_small.png", points: 8},
                "L2.42" => {text: "I get up at 7:00.", points: 8},
                "L3.42" => {text: "私は医者になりたいです", points: 8},
                "L4.42" => {text: "What do you want to be?", points: 8},
                "L5.42" => {text: "I _____ at 7:20.", image: "watch_tv.jpg", points: 8},

                "L1.52" => {text: "What's this?", image: "take_a_bath.jpg", points: 10},
                "L2.52" => {text: "I want to be a teacher.", points: 10},
                "L3.52" => {text: "何になりたいですか？", points: 10},
                "L4.52" => {text: "Do you have a pen?", points: 10},
                "L5.52" => {text: "I want to be a _____.", image: 'firefighter.jpg', points: 10}}
    
    def setup_game
        QUESTIONS.each do |key, value|
            self.questions.create!(value)
        end
        2.times do
           self.teams.create!(score: 0)
        end
        session[:game_id] = @game.id            #=> Better in Cookies?
        self.is_active = true
        self.teams.first.update_columns(name: params[:game][:team][:team1].capitalize)
        self.teams.second.update_columns(name: params[:game][:team][:team2].capitalize)
        self.save
    end
    
    def answer_all
        self.questions.limit(QUESTIONS_IN_ROUND).each { |question| question.answer }
        self.questions.first.unanswer
    end
    
    def set_round
        question_set = []
        (questions.limit(25).all? {|x| x.answered == true})? round =  25: round = 0
        (0..4).each {|x| question_set << questions.limit(5).offset((5*x) + round)}
        return question_set
    end
end
