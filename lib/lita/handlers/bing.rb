require "base64"
module Lita
  module Handlers
    class Bing < Handler
      SOURCE_URL = "https://api.datamarket.azure.com/Bing/Search/Image"
      attr_reader :bing_key

      def initialize(bing_key:)
        @bing_key = Base64.encode64(":#{bing_key}")
      end

      def fetch(response)
        query = response.matches[0][0]

        http_response = http.get do |req|
          req.url SOURCE_URL
          req.headers['Authorization'] = "Basic #{bing_key}"
          req.params['$format'] = 'json'
          req.params['$top'] = 10
          req.params['Query'] = "'#{query}'"
          req.params['Adult'] = "'Strict'"
        end

        parse_response(MultiJson.load(http_response.body))
      end

      def parse_response(data)
        data = data['d']
        if data && data["results"] && data["results"].any?
          choice = data["results"].sample
          if choice
            return choice["MediaUrl"]
          else
            return nil
          end
        end
        nil
      end
    end
  end
end