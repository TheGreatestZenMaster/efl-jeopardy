class GamesController < ApplicationController
    before_action :game_started, only: [:show]
    before_action :game_exists, only: [:show]
    QUESTIONS = { "L1.1" => {text: "What's this?", image: "p.png", points: 10},
                "L2.1" => {text: "I like Elephants.", image: nil, points: 10},
                "L3.1" => {text: "インド", image: nil, points: 10},
                "L4.1" => {text: "What animal do you like?", points: 10},
                "L5.1" => {text: "I like _____.", image: "pizza.png", points: 10},
                
                "L1.2" => {text: "What's this?", image: "bear.jpg", points: 20},
                "L2.2" => {text: "January", points: 20},
                "L3.2" => {text: "１２月", image: nil, points: 20},
                "L4.2" => {text: "What time is it?", image: nil, points: 20},
                "L5.2" => {text: "It's _____.", image: "america.png", points: 20},
                
                "L1.3" => {text: "What's this?", image: "january.png", points: 30},
                "L2.3" => {text: "Forty-seven", points: 30},
                "L3.3" => {text: "１０時１０分", points: 30},
                "L4.3" => {text: "When is your birthday?", points: 30},
                "L5.3" => {text: "I can _____.", image: "playthepiano.png", points: 30},
                
                "L1.4" => {text: "What's this?", image: "playsoccer.png", points: 40},
                "L2.4" => {text: "September tenth", points: 40},
                "L3.4" => {text: "野球ができます", points: 40},
                "L4.4" => {text: "Can you swim?", points: 40},
                "L5.4" => {text: "I can't _____.", image: "swim.png", points: 40},

                "L1.5" => {text: "What's this?", image: "one_oclock.png", points: 50},
                "L2.5" => {text: "I can play baseball.", points: 50},
                "L3.5" => {text: "イタリアに行きたいです", points: 50},
                "L4.5" => {text: "Who am I?<br>P.12", points: 50},
                "L5.5" => {text: "My birthday is _____.", image: '#', points: 50}}
                
     QUESTIONS2 = { "L1.1" => {text: "What's this?1", image: "p.png", points: 20},
                "L2.1" => {text: "I like Elephants.", image: nil, points: 20},
                "L3.1" => {text: "インド", image: nil, points: 20},
                "L4.1" => {text: "What animal do you like?", points: 20},
                "L5.1" => {text: "I like _____.", image: "pizza.png", points: 20},
                
                "L1.2" => {text: "What's this?", image: "bear.jpg", points: 40},
                "L2.2" => {text: "January", points: 40},
                "L3.2" => {text: "１２月", image: nil, points: 40},
                "L4.2" => {text: "What time is it?", image: nil, points: 40},
                "L5.2" => {text: "It's _____.", image: "america.png", points: 40},
                
                "L1.3" => {text: "What's this?", image: "january.png", points: 60},
                "L2.3" => {text: "Forty-seven", points: 60},
                "L3.3" => {text: "１０時１０分", points: 60},
                "L4.3" => {text: "When is your birthday?", points: 60},
                "L5.3" => {text: "I can _____.", image: "playthepiano.png", points: 60},
                
                "L1.4" => {text: "What's this?", image: "playsoccer.png", points: 80},
                "L2.4" => {text: "September tenth", points: 80},
                "L3.4" => {text: "野球ができます", points: 80},
                "L4.4" => {text: "Can you swim?", points: 80},
                "L5.4" => {text: "I can't _____.", image: "swim.png", points: 80},

                "L1.5" => {text: "What's this?", image: "one_oclock.png", points: 100},
                "L2.5" => {text: "I can play baseball.", points: 100},
                "L3.5" => {text: "イタリアに行きたいです", points: 100},
                "L4.5" => {text: "Who am I?<br>P.12", points: 100},
                "L5.5" => {text: "My birthday is _____.", image: '#', points: 100}}
    def new
       @game = Game.new
    end
    
    def create
        @game = Game.create!()
        QUESTIONS.each do |key, value|
            @game.questions.create!(value)
        end
        2.times do
           @game.teams.create!(score: 0)
        end
        session[:game_id] = @game.id            #=> Better in Cookies?
        @game.is_active = true
        @game.teams.first.update_columns(name: params[:game][:team][:team1].capitalize)
        @game.teams.second.update_columns(name: params[:game][:team][:team2].capitalize)
        redirect_to game_path(@game.id)
    end 
    
    def show
       @game = Game.find(params[:id])
       @team1 = @game.teams.first
       @team2 = @game.teams.second
       @questions = []
       if (@game.questions.all?{|x| x.answered})
            QUESTIONS2.each do |key, value|
                @game.questions.create!(value)
            end
            5.times do |x|
                @questions << @game.questions.offset(5*x + 25).limit(5)
            end
       else
            5.times do |x|
                @questions << @game.questions.offset(5*x).limit(5)
            end
       end
       if params[:game]
           if params[:game][:answered]
                @questions.each do |set|
                    set.each do |question|
                        question.answered = true
                        question.save
                    end
                end
                @questions[0][0].answered = false
                @questions[0][0].save
            end
            redirect_to game_path(@game.id) if params[:game][:round_two]
        end
       
                
       if params[:team]
           if params[:team][:id] == '1'
               @team1.score += params[:team][:points].to_i
               @team1.save
           else
               @team2.score += params[:team][:points].to_i
               @team2.save
           end
           @question = Question.find(params[:team][:question])
           @question.answered = true
           @question.save
       end
    end
    
    def destroy
        if session[:game_id].nil?
            flash[:danger] = "There was a problem"
        else
            @game = Game.find(session[:game_id]) 
            session[:game_id] = nil
            @game.destroy
            flash[:success] = "Game Destroyed"
        end
        redirect_to root_url
    end
        
    private
    
        def game_exists
           redirect_to root_url unless Game.exists?(params[:id])
        end
    
        def game_in_play
            redirect_to(game_path(session[:game_id])) unless session[:game_id].nil?
        end

        def game_started
           redirect_to(root_url) if session[:game_id].nil? 
        end
end
