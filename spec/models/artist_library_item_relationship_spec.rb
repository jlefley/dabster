require 'db_spec_helper'
require 'artist_library_item_relationship'

describe ArtistLibraryItemRelationship do
  subject(:relationship) { described_class.new }

  describe 'when type is not a valid type' do
    before { relationship.type = 'other' }
    it { should_not be_valid }
  end

  describe 'when type is a valid type' do
    before { relationship.type = 'artist' }
    it { should be_valid }
  end

  describe 'when type is missing' do
    it { should_not be_valid }
  end

end
