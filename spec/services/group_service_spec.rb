require 'unit_spec_helper'
require 'group_service'

describe GroupService do

  let(:group) { double 'group', :set_fields => nil, :save => nil, :what_confidence= => nil }
  let(:group_class) { double 'group class' }
  let(:library_album) { double 'library album' }
  let(:library_album_class) { double 'library album class' }
  let(:result_group) { double 'what group 0' }

  subject(:service) { GroupService.new group_class, library_album_class }

  describe 'when associating group' do
    
    let(:group_fields) { [:what_id, :what_artist, :what_name, :what_tags, :what_year,
      :what_release_type, :what_artists, :what_record_label, :what_catalog_number] }

    before do
      allow(library_album_class).to receive(:first!).with(id: 456).and_return(library_album)
      allow(result_group).to receive(:map).with(GroupService::WHAT_GROUP_MAPPING).and_return('mapped group data')
    end

    describe 'when any argument is nil' do
      it 'raises ArgumentError' do
        expect{ service.associate_group(nil, 123, 1.0) }.to raise_error(ArgumentError)
        expect{ service.associate_group(result_group, nil, 1.0) }.to raise_error(ArgumentError)
        expect{ service.associate_group(result_group, 123, nil) }.to raise_error(ArgumentError)
      end
    end

    describe 'when library album does not already have associated group' do

      before do
        allow(group).to receive(:library_album=)
        allow(group_class).to receive(:new).and_return(group)
        allow(library_album).to receive(:group).and_return(nil)
      end

      it 'sets sets group fields with data from result group matching specified result group id' do
        expect(group).to receive(:set_fields).once.with('mapped group data', group_fields)
        
        service.associate_group(result_group, '456', 1.0)
      end

      it 'associates library album matching specified id with group' do
        expect(group).to receive(:library_album=).with(library_album)

        service.associate_group(result_group, '456', 1.0)
      end

      it 'sets what_confidence to specified value' do
        expect(group).to receive(:what_confidence=).with(1.0)
        
        service.associate_group(result_group, '456', 1.0)
      end

      it 'returns the group' do
        expect(service.associate_group(result_group, '456', 1.0)).to be(group)
      end

      it 'saves the group' do
        expect(group).to receive(:save)

        service.associate_group(result_group, '456', 1.0)
      end
      
    end

    describe 'when library album has associated group' do

      before do
        allow(library_album).to receive(:group).and_return(group)
      end

      it 'sets sets group fields with data from result group matching specified result group id' do
        expect(group).to receive(:set_fields).once.with('mapped group data', group_fields)
        
        service.associate_group(result_group, '456', 1.0)
      end

      it 'sets what_confidence to specified value' do
        expect(group).to receive(:what_confidence=).with(1.0)
        
        service.associate_group(result_group, '456', 1.0)
      end

      it 'returns the group' do
        expect(service.associate_group(result_group, '456', 1.0)).to eq(group)
      end

      it 'saves the group' do
        expect(group).to receive(:save)

        service.associate_group(result_group, '456', 1.0)
      end

    end
  end

end
