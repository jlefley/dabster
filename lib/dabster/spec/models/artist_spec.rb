require 'db_spec_helper'
require 'artist'

describe Artist do
  subject(:artist) { described_class.new }

  it { should be_valid }

  describe 'when what_id is present' do
    before do
      artist.what_id = 1
      artist.what_name = 'asdf'
      artist.what_updated_at = Time.now
    end
    describe 'when all what fields are present' do
      it { should be_valid }
    end
    describe 'when what_name is missing' do
      before { artist.what_name = nil }
      it { should_not be_valid }
    end
    describe 'when what_updated_at is missing' do
      before { artist.what_updated_at = nil }
      it { should_not be_valid }
    end
  end
end
