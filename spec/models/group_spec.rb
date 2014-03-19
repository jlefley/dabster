require 'db_spec_helper'
require 'artist_matching'
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
      group.what_artist_name = 'asdf'
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
      before { group.what_artist_name = nil }
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

  describe 'when what_artist_id is present' do
    before { group.what_artist_id = 5 }
    describe 'when what_artist_type is present' do
      before { group.what_artist_type = 'dj' }
      it { should be_valid }
    end
    describe 'when what_artist_type is not present' do
      it { should_not be_valid }
    end
  end

  describe 'when what_artist_id is not present' do
    describe 'when what_artist_type is present' do
      before { group.what_artist_type = 'dj' }
      it { should_not be_valid }
    end
    describe 'when what_artist_type is not present' do
      it { should be_valid }
    end
  end

  describe 'when setting what artist association' do
    describe 'when what_artists contains artist matching what_artist_name' do
      before do
        group.update(what_artist_name: 'artist name')
        @matching = group.add_artist({ what_name: 'artist name', what_id: 123 }, :dj)
        group.add_artist({ what_name: 'other', what_id: 1 }, :dj)
        group.add_artist({ what_name: 'artist', what_id: 2 }, :artist)
        group.update_what_artist_association
        group.reload
      end
      it 'updates what_artist_id to id of artist in what_artists matching what_artist_name' do
        expect(group.what_artist_id).to eq(@matching.id)
      end
      it 'updates what_artist_type to type of artist in what_artists matching what_artist_name' do
        expect(group.what_artist_type).to eq(:dj)
      end
    end

    describe 'when what_artists does not contain artist matching what_artist_name' do
      it 'raises error' do
        group.update(what_artist_name: 'abc')
        expect { group.update_what_artist_association }.to raise_error(RuntimeError)
      end
    end
  end

end
