require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :menage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    it { should_not be_able_to :menage, :all }
    it { should be_able_to :read, :all }

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :create_comment, Answer }
      it { should be_able_to [:update, :destroy], create(:answer, author: user) }

      it { should_not be_able_to [:update, :destroy], create(:answer, author: other_user) }    
    end

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create_comment, Question }
      it { should be_able_to [:update, :destroy, :update_best_answer], create(:question, author: user) }

      it { should_not be_able_to [:update, :destroy, :update_best_answer], create(:question, author: other_user) }
    end

    context 'vote' do
      it { should be_able_to [:upvote, :downvote, :cancel], create(:answer, author: other_user) }
      it { should_not be_able_to [:upvote, :downvote, :cancel], create(:answer, author: user) }

      it { should be_able_to [:upvote, :downvote, :cancel], create(:question, author: other_user) }
      it { should_not be_able_to [:upvote, :downvote, :cancel], create(:question, author: user) }
    end
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :menage, :all }
  end
end
