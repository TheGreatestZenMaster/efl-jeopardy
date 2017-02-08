class GamesController < ApplicationController
    before_action :game_started, only: [:show]
    before_action :game_exists, only: [:show]
    QUESTIONS = { "L1.1" => {text: "What animal do you like?", image: nil, points: 10},
                "L2.1" => {text: "What's this?", image: "january.png", points: 10},
                "L3.1" => {text: "What's this?", image: "playsoccer.png", points: 10},
                "L4.1" => {text: "L4", image: nil, points: 10},
                "L5.1" => {text: "L5", image: nil, points: 10},
                
                "L1.2" => {text: "What's this?", image: "bear.jpg", points: 20},
                "L2.2" => {text: "What's this?<br>みっか", image: nil, points: 20},
                "L3.2" => {text: "P11 Who am I quiz", image: nil, points: 20},
                "L4.2" => {text: "L4", image: nil, points: 20},
                "L5.2" => {text: "L5", image: nil, points: 20},
                
                "L1.3" => {text: "What are these?<br>m,n,o", points: 30},
                "L2.3" => {text: "what are these?<br>５月、６月、７月", points: 30},
                "L3.3" => {text: "E -> J:<br>やきゅうができます", points: 30},
                "L4.3" => {text: "L4", points: 30},
                "L5.3" => {text: "L5", points: 30},
                
                "L1.4" => {text: "Count from 40-60", points: 40},
                "L2.4" => {text: "What month is your birthday?", points: 40},
                "L3.4" => {text: "L3?", points: 40},
                "L4.4" => {text: "L4", points: 40},
                "L5.4" => {text: "L5", points: 40},

                "L1.5" => {text: "Say the ABCs", points: 50},
                "L2.5" => {text: "When is your birthday?", points: 50},
                "L3.5" => {text: "L3?", points: 50},
                "L4.5" => {text: "L4", points: 50},
                "L5.5" => {text: "L5", points: 50}}
                
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
       5.times do |x|
           @questions << @game.questions.offset(5*x).limit(5)
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
