class GamesController < ApplicationController
    before_action :game_started, only: [:show]
    before_action :game_exists, only: [:show]

    def new
       @game = Game.new
    end
    
    def create
        @game = Game.create!()
        session[:game_id] = @game.id
        @game.setup_game
        @game.teams.first.update_columns(name: params[:game][:team][:team1].capitalize)
        @game.teams.second.update_columns(name: params[:game][:team][:team2].capitalize)
        redirect_to game_path(@game.id)
    end
    
    def show
        @game = Game.find(params[:id])
        @team1 = @game.teams.first
        @team2 = @game.teams.second
        @question_set = @game.set_round
        
        @game.answer_all  if params[:answer_all]

        if params[:team]
            params[:wrong_answer] ? x = -1 : x = 1
            if params[:team][:id] == '1'
              @team1.score += (params[:team][:points].to_i * x)
              @team1.save
            else
              @team2.score += (params[:team][:points].to_i * x)
              @team2.save
          end
          question = Question.find(params[:team][:question])
          question.answered = true
          question.save
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
