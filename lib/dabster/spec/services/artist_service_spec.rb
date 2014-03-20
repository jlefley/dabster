require 'unit_spec_helper'
require 'artist_service'

describe ArtistService do

  let(:group) { double 'group', add_group_artists_to_items: nil, remove_group_artists_from_items: nil,
    match_artists: nil, add_artist: nil, remove_artist: nil, artists_by: {} }
  let(:artist0) { double 'artist 0', :id => 0, :what_updated_at= => nil, :what_id= => nil, :what_name= => nil, :save => nil }
  let(:artist1) { double 'artist 1', id: 1 }
  let(:artist2) { double 'artist 2', id: 2 }
  let(:artist_class) { double 'artist class' }

  subject(:service) { ArtistService.new artist_class }

  describe 'when associating artists according to metadata' do
    before do
      allow(Time).to receive(:now).and_return('current time')
      allow(group).to receive(:what_artists).and_return(artist: [{ id: 0, name: 'a0' }], dj: [{ id: 1, name: 'a1' }])
      allow(artist_class).to receive(:first).with(what_id: 0).and_return(nil)
      allow(artist_class).to receive(:new).and_return(artist0)
      allow(artist_class).to receive(:first).with(what_id: 1).and_return(artist1)
    end

    describe 'when group has existing artist associations not corresponding to any current metadata artists' do

      it 'removes the artist not present in the metadata from the group for each artist type' do
        allow(group).to receive(:artists_by).with(:type).and_return(artist: [artist2], dj: [artist1])
        
        expect(group).to receive(:remove_artist).with(artist2, type: :artist)
        
        service.associate_artists(group)
      end

    end

    describe 'when group has existing artist associations corresponding to current metadata artists' do
      it 'does not remove or add any artists' do
        allow(group).to receive(:artists_by).with(:type).and_return(artist: [artist0], dj: [artist1])
        
        expect(group).not_to receive(:remove_artist)
        expect(group).not_to receive(:add_artist)
        
        service.associate_artists(group)
      end
    end

    describe 'when group does not have existing artist associations corrseponding to current metadata artists' do
      describe 'when artist for metadata artist does not exist' do

        it 'sets the what fields on the new artist to the values from the metadata' do
          expect(artist0).to receive(:what_id=).with(0)
          expect(artist0).to receive(:what_name=).with('a0')

          service.associate_artists(group)
        end

        it 'sets the what updated time on the artist' do
          expect(artist0).to receive(:what_updated_at=).with(Time.now)
          
          service.associate_artists(group)
        end
   
        it 'saves the new artist' do
          expect(artist0).to receive(:save)
          
          service.associate_artists(group)
        end

        it 'adds the new artist to the group with the type' do
          expect(group).to receive(:add_artist).once.with(artist0, type: :artist)
          
          service.associate_artists(group)
        end    

      end

      describe 'when artist for new metadata artist exists' do

        it 'adds the existing artist to the group with the type' do
          expect(group).to receive(:add_artist).once.with(artist1, type: :dj)
          
          service.associate_artists(group)
        end

      end
    end

    it 'returns the group' do
      expect(service.associate_artists(group)).to be(group)
    end

    it 'matches artists in group' do
      expect(group).to receive(:match_artists)
      
      service.associate_artists(group)
    end

    it 'removes group artists from items' do
      expect(group).to receive(:remove_group_artists_from_items)
      
      service.associate_artists(group)
    end

    it 'adds group artists to itmes' do
      expect(group).to receive(:add_group_artists_to_items)
      
      service.associate_artists(group)
    end

  end

end
