class AnswersController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, only: [:create, :destroy]
  authorize_resource

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
    publish_answer
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
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("answers_question_#{question.id}", ApplicationController.render(
      partial: 'answers/answer_body',
      locals: { answer: @answer }
      ))
  end
end
