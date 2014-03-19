require 'unit_spec_helper'
require 'what_scraper'

describe WhatScraper do
  let(:api) { double 'api connection' }
  subject(:scraper) { WhatScraper.new(api, OpenStruct) }

  describe 'when scraping for torrent group by result group' do
    let(:result_group) { { groupId: 55, groupName: 'Abbey Road', artist: 'The Beatles',
      tags: ['rock'], groupYear: 1970, releaseType: 'Album' } }
    
    let(:response) { { group: { id: 55, name: 'Abbey Road', year: 1970, musicInfo: 'ats',
      recordLabel: 'Apple', catalogueNumber: 'AR001', releaseType: 1 } } }
    
    before { allow(api).to receive(:make_request).with(action: 'torrentgroup', id: 55).and_return(response) }
    
    describe 'when torrent group id does not match specified result group id' do
      it 'raises WhatScraperError' do
        allow(api).to receive(:make_request).and_return(group: { id: 0, name: 'Abbey Road', year: 1970 })
        expect { scraper.scrape_group(result_group) }.to raise_error(WhatScraperError)
      end
    end

    describe 'when torrent group name does not match specified result group name' do
      it 'raises WhatScraperError' do
        allow(api).to receive(:make_request).and_return(group: { id: 55, name: 'Other', year: 1970 })
        expect { scraper.scrape_group(result_group) }.to raise_error(WhatScraperError)
      end
    end

    describe 'when torrent group year does not match specified result group year' do
      it 'raises WhatScraperError' do
        allow(api).to receive(:make_request).and_return(group: { id: 55, name: 'Abbey Road', year: 1000 })
        expect { scraper.scrape_group(result_group) }.to raise_error(WhatScraperError)
      end
    end

    it 'returns group with id, name, year, musicInfo, recordLabel and catalogueNumber from torrent group' do
      group = scraper.scrape_group(result_group)
      expect(group.id).to eq(55)
      expect(group.name).to eq('Abbey Road')
      expect(group.year).to eq(1970)
      expect(group.musicInfo).to eq('ats')
      expect(group.recordLabel).to eq('Apple')
      expect(group.catalogueNumber).to eq('AR001')
    end

    it 'returns group with artist, tags and releaseType from specified result group' do
      group = scraper.scrape_group(result_group)
      expect(group.artist).to eq('The Beatles')
      expect(group.tags).to eq(['rock'])
      expect(group.releaseType).to eq('Album')
    end

  end

end
