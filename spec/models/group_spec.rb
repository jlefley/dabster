require 'db_spec_helper'
require 'group'

describe Group do

  before { subject.library_album_id = 5 }
  
  describe 'when associated with library album' do
    it { should be_valid }
  end 
  
  describe 'when not associated with library album' do
    before { subject.library_album_id = nil }
    it { should_not be_valid }
  end
  
  describe 'when what_id is present' do
    before do
      subject.what_id = 1
      subject.what_artist = 'asdf'
      subject.what_name = 'asdf'
      subject.what_tags = ['asdf']
      subject.what_year = 1
      subject.what_release_type = 'asdf'
      subject.what_artists = ['asdf']
      subject.what_confidence = 1.0
    end
    describe 'when what_tags is not an array' do
      before { subject.what_tags = 'asdf' }
      it { should_not be_valid }
    end
    describe 'when what_artists is not an array' do
      before { subject.what_artists = 'asdf' }
      it { should_not be_valid }
    end
    describe 'when what_artist is missing' do
      before { subject.what_artist = nil }
      it { should_not be_valid }
    end
    describe 'when what_name is missing' do
      before { subject.what_name = '' }
      it { should_not be_valid }
    end
    describe 'when what_tags is missing' do
      before { subject.what_tags = nil }
      it { should_not be_valid }
    end
    describe 'when what_year is missing' do
      before { subject.what_year = nil }
      it { should_not be_valid }
    end
    describe 'when what_release_type is missing' do
      before { subject.what_release_type = '   ' }
      it { should_not be_valid }
    end
    describe 'when what_artists is missing' do
      before { subject.what_artists = nil }
      it { should_not be_valid }
    end
    describe 'when what_confidence is missing' do
      before { subject.what_confidence = nil }
      it { should_not be_valid }
    end
    describe 'when all what fields are present and of correct type' do
      it { should be_valid }
    end
  end

end
