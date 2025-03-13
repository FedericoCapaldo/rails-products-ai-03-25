class QuestionsController < ApplicationController

  def index
    @questions = current_user.questions
    @question = Question.new
  end
end
