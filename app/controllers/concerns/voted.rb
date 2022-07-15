module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[upvote downvote cancel]
  end

  def upvote
    respond_to do |format|
      begin vote(1)
        format.json { success_vote_json }
      rescue ActiveRecord::RecordInvalid
        format.json { error_vote_json(@vote.errors.full_messages) }
      end
    end
  end

  def downvote
    respond_to do |format|
      begin vote(-1)
        format.json { success_vote_json }
      rescue ActiveRecord::RecordInvalid
        format.json { error_vote_json(@vote.errors.full_messages) }
      end
    end
  end

  def cancel
    respond_to do |format|
      if unvote
        format.json { success_vote_json }
      else
        format.json { error_vote_json(['could not unvote']) }
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def vote(value)
    @votable.transaction do
      @votable.lock!
      @vote = @votable.votes.new(user_id: current_user.id, value: value)
      model_klass.update_counters @votable.id, votes_count: value
      @vote.save!
    end
  end

  def unvote
    vote = Vote.cancel(current_user, @votable)
    model_klass.update_counters @votable.id, votes_count: -vote.value if vote
  end

  def success_vote_json
    @votable.reload

    render json: {
      resource: @votable.class.name.downcase,
      id: @votable.id,
      rating: @votable.votes_count
    }
  end

  def error_vote_json(errors)
    render json: {
      errors: errors,
      resource: @votable.class.name.downcase,
      id: @votable.id
    },
      status: :unprocessable_entity
  end
end
