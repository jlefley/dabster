require 'unit_spec_helper'
require 'services/group_service'

describe Dabster::Services::GroupService do

  let(:group) { double 'group', :whatcd_updated_at= => nil, :set_fields => nil, :save => nil, :whatcd_confidence= => nil }
  let(:group_class) { double 'group class' }
  let(:library_album) { double 'library album' }
  let(:result_group) { double 'what group 0' }

  subject(:service) { described_class.new group_class }

  describe 'when associating group' do
    
    let(:group_fields) { [:whatcd_id, :whatcd_name, :whatcd_tags, :whatcd_year,
      :whatcd_release_type_id, :whatcd_artists, :whatcd_record_label, :whatcd_catalog_number] }

    before do
      allow(Time).to receive(:now).and_return('current time')
      allow(result_group).to receive(:map).with(described_class::WHAT_GROUP_MAPPING).and_return('mapped group data')
    end

    describe 'when any argument is nil' do
      it 'raises ArgumentError' do
        expect { service.associate_group(nil, 123, 1.0) }.to raise_error(ArgumentError)
        expect { service.associate_group(result_group, nil, 1.0) }.to raise_error(ArgumentError)
        expect { service.associate_group(result_group, 123, nil) }.to raise_error(ArgumentError)
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
        
        service.associate_group(result_group, library_album, 1.0)
      end

      it 'associates library album matching specified id with group' do
        expect(group).to receive(:library_album=).with(library_album)

        service.associate_group(result_group, library_album, 1.0)
      end

      it 'sets whatcd_confidence to specified value' do
        expect(group).to receive(:whatcd_confidence=).with(1.0)
        
        service.associate_group(result_group, library_album, 1.0)
      end
      
      it 'sets whatcd_updated_at to current time' do
        expect(group).to receive(:whatcd_updated_at=).with(Time.now)
        
        service.associate_group(result_group, library_album, 1.0)
      end
      
      it 'returns the group' do
        expect(service.associate_group(result_group, library_album, 1.0)).to be(group)
      end

      it 'saves the group' do
        expect(group).to receive(:save)

        service.associate_group(result_group, library_album, 1.0)
      end
      
    end

    describe 'when library album has associated group' do

      before do
        allow(library_album).to receive(:group).and_return(group)
      end

      it 'sets sets group fields with data from result group matching specified result group id' do
        expect(group).to receive(:set_fields).once.with('mapped group data', group_fields)
        
        service.associate_group(result_group, library_album, 1.0)
      end

      it 'sets whatcd_confidence to specified value' do
        expect(group).to receive(:whatcd_confidence=).with(1.0)
        
        service.associate_group(result_group, library_album, 1.0)
      end

      it 'sets whatcd_updated_at to current time' do
        expect(group).to receive(:whatcd_updated_at=).with(Time.now)
        
        service.associate_group(result_group, library_album, 1.0)
      end
      
      it 'returns the group' do
        expect(service.associate_group(result_group, library_album, 1.0)).to eq(group)
      end

      it 'saves the group' do
        expect(group).to receive(:save)

        service.associate_group(result_group, library_album, 1.0)
      end

    end
  end

end
