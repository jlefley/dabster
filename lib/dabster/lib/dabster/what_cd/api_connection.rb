module WhatCD
  class APIConnection

    attr_reader :db, :ds
    
    def initialize
      @db = Sequel::Model.db
      @ds = info_dataset
    end

    def make_request params
      cookie, last_request = ds.get([:cookie, :last_request])
      
      begin 
        last_request = API.rate_limit(last_request)
        response = API.make_request(cookie, params)
        ds.update(last_request: last_request)
        return response
      rescue WhatCD::API::NotAuthenticated
        last_request = API.rate_limit(last_request)
        cookie = API.login
        ds.update(last_request: last_request, cookie: cookie)
        make_request(params)
      end
    end

    private

    def info_dataset
      ds = db.from(:whatcd_api_info)
      db.create_table?(:whatcd_api_info) { Time :last_request; String :cookie }
      ds.insert(last_request: nil, cookie: nil) if ds.empty?
      raise 'More than one row in what API info table' if ds.count > 1
      ds
    end

  end
end
