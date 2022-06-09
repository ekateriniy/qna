class AnswersController < ApplicationController
  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@answer.question)
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
