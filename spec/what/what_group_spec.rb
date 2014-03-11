require 'unit_spec_helper'
require 'what_group'

describe WhatGroup do

  let(:result) {
    {
      groupId: 410618,
      groupName: 'Jungle Music',
      torrents: [
        { artists: [{ id: 1460, name: 'Logistics'}] },
        { artists: [{ id: 1460, name: 'Logistics'}] }
      ]
    }
  }

  subject { WhatGroup.new result }

  describe 'when mapping fields' do
    it 'returns data with fields mapped according to specified mapping' do
      expect(subject.map(groupId: :id, groupName: :name)).to eq(id: 410618, name: 'Jungle Music')
    end
  end

  describe 'when getting artist' do
    it 'returns unique array of artists from torrents in data' do
      expect(subject.artists).to eq([{ id: 1460, name: 'Logistics' }])
    end
  end

  describe 'when getting id' do
    it 'returns value of groupId as integer' do
      expect(subject.id).to eq(410618)
    end
  end

end
