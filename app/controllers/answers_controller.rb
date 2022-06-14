class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(question), notice: 'Your answer successfully posted'
    else
      render 'questions/show'
    end
  end

  private

  helper_method :question

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
