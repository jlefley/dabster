require 'db_spec_helper'
require 'artist'

describe Artist do
  it { should be_valid }

  describe 'when what_id is present' do
    before do
      subject.what_id = 1
      subject.what_name = 'asdf'
    end
    describe 'when all what fields are present' do
      it { should be_valid }
    end
    describe 'when what_name is missing' do
      before { subject.what_name = nil }
      it { should_not be_valid }
    end
  end
end
