require 'db_spec_helper'
require 'models/artist'

describe Artist do
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
end
