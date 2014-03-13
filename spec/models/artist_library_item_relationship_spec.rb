require 'db_spec_helper'
require 'artist_library_item_relationship'

describe ArtistLibraryItemRelationship do

  describe 'when type is not a valid type' do
    before { subject.type = 'other' }
    it { should_not be_valid }
  end

  describe 'when type is a valid type' do
    before { subject.type = 'artist' }
    it { should be_valid }
  end

  describe 'when type is missing' do
    it { should_not be_valid }
  end

end
