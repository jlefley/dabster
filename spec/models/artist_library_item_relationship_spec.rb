require 'db_spec_helper'

describe Dabster::ArtistLibraryItemRelationship do
  subject(:relationship) { described_class.new }

  before do
    relationship.confidence = 1.0
    relationship.type = 'artist'
  end

  it { should be_valid }
  
  describe 'when type is not a valid type' do
    before { relationship.type = 'other' }
    it { should_not be_valid }
  end

  describe 'when type is missing' do
    before { relationship.type = nil }
    it { should_not be_valid }
  end

  describe 'when confidence is missing' do
    before { relationship.confidence = nil }
    it { should_not be_valid }
  end

end
