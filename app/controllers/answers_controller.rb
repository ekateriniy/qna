class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  # def show
  #   answer
  # end

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to question_path(question), notice: 'Your answer successfully posted'
    else
      render 'questions/show', locals: { question: question }
    end
  end

  def destroy
    answer.destroy
    redirect_to question_path(answer.question)
  end

  private

  helper_method :question, :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
