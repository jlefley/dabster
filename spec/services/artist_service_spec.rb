require 'unit_spec_helper'
require 'artist_service'

describe ArtistService do

  let(:group) { double 'group', add_artist: nil, remove_artist: nil, artists: [] }
  let(:artist0) { double 'artist 0', :id => 0, :what_id= => nil, :what_name= => nil, :save => nil }
  let(:artist1) { double 'artist 1', id: 1 }
  let(:artist2) { double 'artist 2', id: 2 }
  let(:artist_class) { double 'artist class' }

  subject { ArtistService.new artist_class }

  describe 'when associating artists according to metadata' do
    before do
      allow(group).to receive(:what_artists).and_return([{ id: 0, name: 'a0' }, { id: 1, name: 'a1' }])
      allow(artist_class).to receive(:first).with(what_id: 0).and_return(nil)
      allow(artist_class).to receive(:new).and_return(artist0)
      allow(artist_class).to receive(:first).with(what_id: 1).and_return(artist1)
    end

    describe 'when group has existing artist associations not corresponding to any current metadata artists' do
      before do
        allow(group).to receive(:artists).and_return([artist1, artist2])
        allow(artist2).to receive(:groups).and_return(['other group'])
      end

      it 'removes the artist not present in the metadata from the group' do
        expect(group).to receive(:remove_artist).with(artist2)
        
        subject.associate_artists(group)
      end

      describe 'when removed artist does not belong to any groups' do
        it 'deletes the artist' do
          allow(artist2).to receive(:groups).and_return([])
          
          expect(artist2).to receive(:delete)
        
          subject.associate_artists(group)
        end
      end
      
    end

    describe 'when group has existing artist associations corresponding to current metadata artists' do
      it 'does not remove or add any artists' do
        allow(group).to receive(:artists).and_return([artist0, artist1])
        
        expect(group).not_to receive(:remove_artist)
        expect(group).not_to receive(:add_artist)
        
        subject.associate_artists(group)
      end
    end

    describe 'when group does not have existing artist associations corrseponding to current metadata artists' do
      before { allow(group).to receive(:artists).and_return([]) }

      describe 'when artist for metadata artist does not exist' do

        it 'sets the what fields on the new artist to the values from the metadata' do
          expect(artist0).to receive(:what_id=).with(0)
          expect(artist0).to receive(:what_name=).with('a0')

          subject.associate_artists(group)
        end
   
        it 'saves the new artist' do
          expect(artist0).to receive(:save)
          
          subject.associate_artists(group)
        end

        it 'adds the new artist to the group' do
          expect(group).to receive(:add_artist).once.with(artist0)
          
          subject.associate_artists(group)
        end    

      end

      describe 'when artist for new metadata artist exists' do

        it 'adds the existing artist to the group' do
          expect(group).to receive(:add_artist).once.with(artist1)
          
          subject.associate_artists(group)
        end

      end
    end

    it 'returns the group' do
      expect(subject.associate_artists(group)).to be(group)
    end

  end

end
