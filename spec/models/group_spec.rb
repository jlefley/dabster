require 'db_spec_helper'
require 'group'

describe Group do
  subject(:group) { described_class.new }

  before { group.library_album_id = 5 }
  
  describe 'when associated with library album' do
    it { should be_valid }
  end 
  
  describe 'when not associated with library album' do
    before { group.library_album_id = nil }
    it { should_not be_valid }
  end
  
  describe 'when what_id is present' do
    before do
      group.what_id = 1
      group.what_artist = 'asdf'
      group.what_name = 'asdf'
      group.what_tags = ['asdf']
      group.what_year = 1
      group.what_release_type = 'DJ Mix'
      group.what_artists = { artists: 'asdf' } 
      group.what_confidence = 1.0
    end
    describe 'when what_tags is not an array' do
      before { group.what_tags = 'asdf' }
      it { should_not be_valid }
    end
    describe 'when what_artists is not a hash' do
      before { group.what_artists = 'asdf' }
      it { should_not be_valid }
    end
    describe 'when what_artist is missing' do
      before { group.what_artist = nil }
      it { should_not be_valid }
    end
    describe 'when what_name is missing' do
      before { group.what_name = '' }
      it { should_not be_valid }
    end
    describe 'when what_tags is missing' do
      before { group.what_tags = nil }
      it { should_not be_valid }
    end
    describe 'when what_year is missing' do
      before { group.what_year = nil }
      it { should_not be_valid }
    end
    describe 'when what_release_type is missing' do
      before { group.what_release_type = '   ' }
      it { should_not be_valid }
    end
    describe 'when what_artists is missing' do
      before { group.what_artists = nil }
      it { should_not be_valid }
    end
    describe 'when what_confidence is missing' do
      before { group.what_confidence = nil }
      it { should_not be_valid }
    end
    describe 'when all what fields are present and of correct type' do
      it { should be_valid }
    end
    describe 'when what_release_type is not a valid release type' do
      before { group.what_release_type = 'asdf' }
      it { should_not be_valid }
    end
  end

end
