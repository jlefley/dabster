require 'unit_spec_helper'
require 'group_service'

describe GroupService do

  let(:group) { double 'group', :what_artists= => nil, :set_fields => nil, :save => nil }
  let(:group_class) { double 'group class' }
  let(:library_album) { double 'library album' }
  let(:library_album_class) { double 'library album class' }
  let(:result_group0) { double 'what group 0', id: 999 }
  let(:result_group1) { double 'what group 1', id: 123 }

  subject { GroupService.new group_class, library_album_class }

  describe 'when associating group' do
    
    let(:parameters) { { result_group_id: '123', library_album_id: '456', result_groups: [result_group0, result_group1] } }
    let(:group_fields) { [:what_id, :what_artist, :what_name, :what_tags, :what_year, :what_release_type] }

    before do
      allow(library_album_class).to receive(:first!).with(id: 456).and_return(library_album)
      allow(result_group1).to receive(:map).with(GroupService::WHAT_GROUP_MAPPING).and_return('mapped group data')
      allow(result_group1).to receive(:artists_hashes).and_return('artists')
    end

    describe 'when parameters contains nil value for required key' do
      it 'raises KeyError' do
        expect{ subject.associate_group(result_group_id: 2, result_groups: [], library_album_id: nil) }.to raise_error(KeyError)
      end
    end

    describe 'when result group matching specified result group id is not present' do
      it 'raises ArgumentError' do
        expect{ subject.associate_group(result_group_id: 2, result_groups: [], library_album_id: 3) }.to raise_error(StandardError)
      end
    end

    describe 'when library album does not have associated group' do

      before do
        allow(group).to receive(:library_album=)
        allow(group_class).to receive(:new).and_return(group)
        allow(library_album).to receive(:group).and_return(nil)
      end

      it 'sets sets group fields with data from result group matching specified result group id' do
        expect(group).to receive(:set_fields).once.with('mapped group data', group_fields)
        
        subject.associate_group(parameters)
      end

      it 'sets group artists from selected result group' do
        expect(group).to receive(:what_artists=).with('artists')
        
        subject.associate_group(parameters)
      end

      it 'associates library album matching specified id with group' do
        expect(group).to receive(:library_album=).with(library_album)

        subject.associate_group(parameters)
      end

      it 'sets additional fields from parameters' do
        expect(group).to receive(:set_fields).once.with(parameters, [:what_confidence])
        
        subject.associate_group(parameters)
      end

      it 'returns the group' do
        expect(subject.associate_group(parameters)).to be(group)
      end

      it 'saves the group' do
        expect(group).to receive(:save)

        subject.associate_group(parameters)
      end
      
    end

    describe 'when library album has associated group' do

      before do
        allow(library_album).to receive(:group).and_return(group)
      end

      it 'sets sets group fields with data from result group matching specified result group id' do
        expect(group).to receive(:set_fields).once.with('mapped group data', group_fields)
        
        subject.associate_group(parameters)
      end

      it 'sets group artists from selected result group' do
        expect(group).to receive(:what_artists=).with('artists')
        
        subject.associate_group(parameters)
      end

      it 'sets additional fields from parameters' do
        expect(group).to receive(:set_fields).once.with(parameters, [:what_confidence])
        
        subject.associate_group(parameters)
      end

      it 'returns the group' do
        expect(subject.associate_group(parameters)).to eq(group)
      end

      it 'saves the group' do
        expect(group).to receive(:save)

        subject.associate_group(parameters)
      end

    end
  end

end
