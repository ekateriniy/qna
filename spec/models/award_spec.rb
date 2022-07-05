require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to :question }
  it { should belong_to(:user).optional }

  it { should validate_presence_of :title }

  it 'has one attached file' do
    expect(Award.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
