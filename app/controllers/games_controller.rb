class GamesController < ApplicationController
    
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
end
