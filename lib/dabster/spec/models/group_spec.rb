require 'db_spec_helper'
require 'logic/artist_matching'
require 'models/group'

describe Group do
  subject(:group) { described_class.new }
  let(:valid_whatcd_attributes) {{
    whatcd_id: 1,
    whatcd_name: 'asdf',
    whatcd_tags: ['asdf'],
    whatcd_year: 1,
    whatcd_release_type_id: 1,
    whatcd_artists: { artists: 'asdf' },
    whatcd_confidence: 1.0,
    whatcd_updated_at: Time.now
  }}

  before { group.library_album_id = 5 }
  
  describe 'when associated with library album' do
    it { should be_valid }
  end 
  
  describe 'when not associated with library album' do
    before { group.library_album_id = nil }
    it { should_not be_valid }
  end

  describe 'when whatcd_id is present' do
    before do
      group.set(valid_whatcd_attributes)
    end
    describe 'when whatcd_tags is not an array' do
      before { group.whatcd_tags = 'asdf' }
      it { should_not be_valid }
    end
    describe 'when whatcd_artists is not a hash' do
      before { group.whatcd_artists = 'asdf' }
      it { should_not be_valid }
    end
    describe 'when whatcd_name is missing' do
      before { group.whatcd_name = '' }
      it { should_not be_valid }
    end
    describe 'when whatcd_tags is missing' do
      before { group.whatcd_tags = nil }
      it { should_not be_valid }
    end
    describe 'when whatcd_year is missing' do
      before { group.whatcd_year = nil }
      it { should_not be_valid }
    end
    describe 'when whatcd_release_type_id is missing' do
      before { group.whatcd_release_type_id = '   ' }
      it { should_not be_valid }
    end
    describe 'when whatcd_artists is missing' do
      before { group.whatcd_artists = nil }
      it { should_not be_valid }
    end
    describe 'when whatcd_confidence is missing' do
      before { group.whatcd_confidence = nil }
      it { should_not be_valid }
    end
    describe 'when whatcd_confidence is not number' do
      before { group.whatcd_confidence = 'asdf' }
      it { should_not be_valid }
    end
    describe 'when whatcd_confidence is greater than 1' do
      before { group.whatcd_confidence = 1.1 }
      it { should_not be_valid }
    end
    describe 'when whatcd_confidence is less than 0' do
      before { group.whatcd_confidence = -0.1 }
      it { should_not be_valid }
    end
    describe 'when all what fields are present and of correct type' do
      it { should be_valid }
    end
    describe 'when whatcd_updated_at is missing' do
      before { group.whatcd_updated_at = nil }
      it { should_not be_valid }
    end
    describe 'when whatcd_id is not unique' do
      before { described_class.create(valid_whatcd_attributes.merge(library_album_id: 55)) }
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
=begin
    describe 'when matching group artists with items' do
      before do
        group.set(whatcd_artist: 'Herbie Hancock & Wayne Shorter')
        group.set(whatcd_artists: { dj: [{ id: 123, name: 'Herbie Hancock' }, { id: 456, name: 'Wayne Shorter' }] })
      end
      
      let!(:artist0) { Artist.create(whatcd_id: 123, whatcd_name: 'Herbie Hancock', whatcd_updated_at: Time.now) }
      let!(:artist1) { Artist.create(whatcd_id: 456, whatcd_name: 'Wayne Shorter', whatcd_updated_at: Time.now) }

      it 'adds artists matching whatcd_artist to each associated item' do
        expect(item0).to receive(:add_artist).with(artist0, type: :dj, group_artist: true, confidence: 0.99)
        expect(item0).to receive(:add_artist).with(artist1, type: :dj, group_artist: true, confidence: 0.99)
        expect(item1).to receive(:add_artist).with(artist0, type: :dj, group_artist: true, confidence: 0.99)
        expect(item1).to receive(:add_artist).with(artist1, type: :dj, group_artist: true, confidence: 0.99)

        group.add_group_artists_to_items
      end
    end
=end
  end

end
