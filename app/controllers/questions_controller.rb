class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    if @best_answer
      @best_answer = question.best_answer&.with_attached_files
      @answers = question.answers.where.not(id: question.best_answer.id)&.with_attached_files
    else
      @answers = question.answers&.with_attached_files
    end
  end

  def new; end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to question_path(@question), notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path
  end

  def update_best_answer
    question.set_best_answer(params[:answer_id])
    @best_answer = question.best_answer
    @answers = question.answers.where.not(id: question.best_answer_id)
  end

  private

  helper_method :question

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
