class QuestionsController < ApplicationController
    
    def show
       @question = params[:id] 
    end
end
