class WhatScraperError < StandardError; end

class WhatScraper

  attr_reader :api_connection, :group_class

  def initialize api_connection, group_class
    @api_connection = api_connection
    @group_class = group_class
  end

  def scrape_group result_group
    group_id = result_group.fetch(:groupId)
    group = api_connection.make_request(action: 'torrentgroup', id: group_id).fetch(:group)

    raise(WhatScraperError, 'mismatch between api responses: id != groupId') unless group[:id] == group_id
    raise(WhatScraperError, 'mismatch between api responses: name != groupName') unless group[:name] == result_group[:groupName]
    raise(WhatScraperError, 'mismatch between api responses: year != groupYear') unless group[:year] == result_group[:groupYear]

    group_class.new(group.merge(result_group))
  end

  def scrape_results filter_params
    response = api_connection.make_request({ action: 'browse', 'filter_cat[1]' => 1 }.merge(filter_params))
    groups = response.fetch(:results).map { |g| group_class.new(g) }
    OpenStruct.new(response.merge(groups: groups))
  end

 end
