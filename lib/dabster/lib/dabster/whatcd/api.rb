require 'net/http'
require 'json'

module Whatcd
  module API 

    class NotAuthenticated < StandardError; end

    BASE_URI = 'https://what.cd'

    module_function

    def make_request cookie, query
      endpoint = URI(BASE_URI + '/ajax.php')

      if query.is_a? String
        endpoint.query = query
      else
        endpoint.query = URI.encode_www_form(query)
      end

      response = Net::HTTP.start(endpoint.host, endpoint.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new(endpoint)
        request['Cookie'] = cookie
        http.request(request)
      end

      raise Whatcd::API::NotAuthenticated if response.code == '302'
      raise Whatcd::Error, "http request not successful, received code #{response.code}" unless response.code == '200'
      
      return [] if query[:action] == 'similar_artists' && response.body == 'null'

      data = JSON.parse(response.body, symbolize_names: true)
      
      if data.is_a?(Hash)
        raise Whatcd::Error, "api request not successful: #{data}" unless data[:status] == 'success'
        data[:response]
      else
        data
      end

    end

    def login
      response = Net::HTTP.post_form(URI(BASE_URI + '/login.php'), { username: '***REMOVED***', password: '***REMOVED***' })

      raise Whatcd::Error, "could not login" unless response.code == '302'

      cookie = response['Set-Cookie'].split('; ')

      cookie.each do |e|
        if e.start_with? 'HttpOnly, session='
          e.slice!('HttpOnly, ')
          return e
        end
      end
    end

    def rate_limit last_request=nil
      now = Time.now
      return now if last_request.nil?

      if now - last_request < 2.5 # Don't exceed 5 requests in 10 seconds
        sleep(0.1)
        rate_limit(last_request)
      end

      Time.now
    end

  end
end
