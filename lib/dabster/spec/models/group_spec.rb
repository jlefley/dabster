require 'db_spec_helper'
require 'logic/artist_matching'
require 'models/group'

describe Group do
  subject(:group) { described_class.new }
  let(:valid_what_attributes) {{
    what_id: 1,
    what_artist: 'asdf',
    what_name: 'asdf',
    what_tags: ['asdf'],
    what_year: 1,
    what_release_type: 'DJ Mix',
    what_artists: { artists: 'asdf' },
    what_confidence: 1.0,
    what_updated_at: Time.now
  }}

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
      group.set(valid_what_attributes)
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
    describe 'when what_confidence is not number' do
      before { group.what_confidence = 'asdf' }
      it { should_not be_valid }
    end
    describe 'when what_confidence is greater than 1' do
      before { group.what_confidence = 1.1 }
      it { should_not be_valid }
    end
    describe 'when what_confidence is less than 0' do
      before { group.what_confidence = -0.1 }
      it { should_not be_valid }
    end
    describe 'when all what fields are present and of correct type' do
      it { should be_valid }
    end
    describe 'when what_release_type is not a valid release type' do
      before { group.what_release_type = 'asdf' }
      it { should_not be_valid }
    end
    describe 'when what_updated_at is missing' do
      before { group.what_updated_at = nil }
      it { should_not be_valid }
    end
    describe 'when what_id is not unique' do
      before { described_class.create(valid_what_attributes.merge(library_album_id: 55)) }
      it { should_not be_valid }
    end
  end

  describe 'when updating item artist associations' do

    let(:item0) { double 'item 0' }
    let(:item1) { double 'item 1' }
    before { allow(group).to receive(:library_items).and_return([item0, item1]) }

    describe 'when unmatching group artists from items' do
      it 'removes all artists from each associated item that are associated as group artists' do
        expect(item0).to receive(:remove_all_artists).with(group_artist: true)
        expect(item1).to receive(:remove_all_artists).with(group_artist: true)

        group.remove_group_artists_from_items
      end
    end

    describe 'when matching group artists with items' do
      before do
        group.set(what_artist: 'Herbie Hancock & Wayne Shorter')
        group.set(what_artists: { dj: [{ id: 123, name: 'Herbie Hancock' }, { id: 456, name: 'Wayne Shorter' }] })
      end
      
      let!(:artist0) { Artist.create(what_id: 123, what_name: 'Herbie Hancock', what_updated_at: Time.now) }
      let!(:artist1) { Artist.create(what_id: 456, what_name: 'Wayne Shorter', what_updated_at: Time.now) }

      it 'adds artists matching what_artist to each associated item' do
        expect(item0).to receive(:add_artist).with(artist0, type: :dj, group_artist: true, confidence: 0.99)
        expect(item0).to receive(:add_artist).with(artist1, type: :dj, group_artist: true, confidence: 0.99)
        expect(item1).to receive(:add_artist).with(artist0, type: :dj, group_artist: true, confidence: 0.99)
        expect(item1).to receive(:add_artist).with(artist1, type: :dj, group_artist: true, confidence: 0.99)

        group.add_group_artists_to_items
      end
    end
  end

end
