class QuestionsController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, only: %i[new edit create update destroy update_best_answer]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    gon.question_id = question.id
    if question.best_answer
      @best_answer = question.best_answer
      @answers = question.answers.where.not(id: question.best_answer.id)&.with_attached_files
    else
      @answers = question.answers&.with_attached_files
    end
  end

  def new
    question.links.new
    question.build_award
  end

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

    question.award.give_out_to(@best_answer.author) if question.award.present?
    @answers = question.answers.where.not(id: question.best_answer_id)
  end

  private

  helper_method :question, :answer

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def answer
    @answer ||= params[:answer_id] ? Answer.with_attached_files.find(params[:answer_id]) : Answer.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy], award_attributes: [:id, :title, :file])
  end

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast 'questions', ApplicationController.render(
      partial: 'questions/question',
      locals: { question: question }
      )
  end
end
