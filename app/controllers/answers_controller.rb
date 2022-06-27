class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @question = answer.question
    answer.update(answer_params)
  end

  def destroy
    answer.destroy
  end

  private

  helper_method :question, :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
