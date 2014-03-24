require 'unit_spec_helper'
require 'ostruct'
require 'scrapers/what_scraper'

describe WhatScraper do
  let(:api) { double 'api connection' }
  let(:api_cache) { double 'what api response cache', cache_result_group: nil, torrent_group: nil }
  subject(:scraper) { WhatScraper.new(api, OpenStruct, api_cache) }

  describe 'when scraping for torrent group by result group' do
    let(:result_group) { { groupId: 55, groupName: 'Abbey Road', artist: 'The Beatles',
      tags: ['rock'], groupYear: 1970, releaseType: 'Album' } }
    
    let(:response) { { group: { id: 55, name: 'Abbey Road', year: 1970, musicInfo: 'ats',
      recordLabel: 'Apple', catalogueNumber: 'AR001', releaseType: 1 } } }
    
    
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



    describe 'when api cache contains torrent group matching id' do
      before { allow(api_cache).to receive(:torrent_group).with(group_id: 55).and_return(response) }
      it 'returns group with id, name, year, musicInfo, recordLabel and catalogueNumber from cached torrent group' do
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
      it 'caches the result group' do
        expect(api_cache).to receive(:cache_result_group).with(group_id: 55, response: result_group)
        
        scraper.scrape_group(result_group)
      end
    end
    
    describe 'when api cache does not contain torrent group matching id' do
      before do
        allow(api_cache).to receive(:cache_torrent_group)
        allow(api_cache).to receive(:torrent_group).with(group_id: 55).and_return(nil)
        allow(api).to receive(:make_request).with(action: 'torrentgroup', id: 55).and_return(response)
      end
      
      it 'returns group with id, name, year, musicInfo, recordLabel and catalogueNumber from fetched torrent group' do
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
      it 'caches torrent group' do
        expect(api_cache).to receive(:cache_torrent_group).with(group_id: 55, response: response)
        
        scraper.scrape_group(result_group)
      end
      it 'caches the result group' do
        expect(api_cache).to receive(:cache_result_group).with(group_id: 55, response: result_group)
        
        scraper.scrape_group(result_group)
      end
    end



  end

end
