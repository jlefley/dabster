require 'net/http'
require 'json'

module WhatAPI
    
    class AuthenticationError < StandardError; end
    class Error < StandardError; end
    class Failure < StandardError; end

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

        raise Error unless response.code == '200'

        data = JSON.parse(response.body, symbolize_names: true)

        raise Failure, data unless data[:status] == 'success'

        data[:response]
    end

    def login
        response = Net::HTTP.post_form(URI(BASE_URI + '/login.php'), { username: '***REMOVED***', password: '***REMOVED***' })
        
        raise AuthenticationError unless response.code == '302'

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

=begin
def login
    cookie = File.read('what_cookie')

    begin
        last_request = WhatAPI.rate_limit($last_request)
        WhatAPI.make_request(cookie, action: 'index')
    rescue WhatAPI::InvalidResponse
        last_request = WhatAPI.rate_limit(last_request)
        cookie = WhatAPI.login
        File.write('what_cookie', cookie)
    end

    $last_request = last_request
    return cookie
end
=end
