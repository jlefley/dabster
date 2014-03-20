class WhatScraperError < StandardError; end

class WhatScraper

  attr_reader :api_connection, :group_class, :api_cache

  def initialize api_connection, group_class, api_cache
    @api_connection = api_connection
    @group_class = group_class
    @api_cache = api_cache
  end

  def scrape_group result_group
    group_id = result_group.fetch(:groupId)
   
    if cached_response = api_cache.torrent_group(group_id: group_id)
      group = cached_response.fetch(:group)
    else
      response = api_connection.make_request(action: 'torrentgroup', id: group_id)
      group = response.fetch(:group)
    end
    
    raise(WhatScraperError, 'mismatch between api responses: id != groupId') unless group[:id] == group_id
    raise(WhatScraperError, 'mismatch between api responses: name != groupName') unless group[:name] == result_group[:groupName]
    raise(WhatScraperError, 'mismatch between api responses: year != groupYear') unless group[:year] == result_group[:groupYear]

    api_cache.cache_result_group(group_id: group_id, response: result_group)
    api_cache.cache_torrent_group(group_id: group_id, response: response) if response

    group_class.new(group.merge(result_group))
  end

  def scrape_results filter_params
    response = api_connection.make_request({ action: 'browse', 'filter_cat[1]' => 1 }.merge(filter_params))
    WhatBrowseResponse.new(response)
  end

 end
