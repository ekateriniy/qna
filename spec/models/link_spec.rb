require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it 'validates url format' do
    expect(build(:link, url: 'plain text', name: 'name')).to be_invalid
  end
end
