require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of :value }

  it 'uniqueness validation' do
    user = FactoryBot.create(:user)
    question = FactoryBot.create(:question)
    vote1 = FactoryBot.create(:vote, votable_id: question.id, votable_type: question.class.name, user: user)
    invalid_vote = FactoryBot.build(:vote, votable_id: question.id, votable_type: question.class.name, user: user)

    expect(invalid_vote).to be_invalid
  end
end
