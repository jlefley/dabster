require 'db_spec_helper'
require 'artist'

describe Dabster::Artist do
  subject(:artist) { described_class.new }

  it { should be_valid }

  describe 'when whatcd_id is present' do
    before do
      artist.whatcd_id = 1
      artist.whatcd_name = 'asdf'
      artist.whatcd_updated_at = Time.now
    end
    describe 'when all what fields are present' do
      it { should be_valid }
    end
    describe 'when whatcd_name is missing' do
      before { artist.whatcd_name = nil }
      it { should_not be_valid }
    end
    describe 'when whatcd_updated_at is missing' do
      before { artist.whatcd_updated_at = nil }
      it { should_not be_valid }
    end
  end

  describe 'when determining if artist is associated with tracks belonging to a specified library album' do
    describe 'when artist is associated with tracks belonging to specified library album' do
      it 'returns the number of items the artist is associated with' do
      end
    end
    describe 'when artist is not associated with any tracks belonging to library album' do
      it 'returns false' do
      end
    end
  end
end
