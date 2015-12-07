module Lita
  module Handlers
    class GoogleCSE < Handler
      SOURCE_URL = "https://www.googleapis.com/customsearch/v1"
      attr_reader :cse_id, :cse_key, :cse_safe_search

      def initialize(cse_id:, cse_key:, cse_safe_search:)
        @cse_id = cse_id
        @cse_key = cse_key
        @cse_safe_search = cse_safe_search
      end

      def fetch(response)
        query = response.matches[0][0]

        http_response = http.get(
          SOURCE_URL,
          q: query,
          searchType: 'image',
          safe: cse_safe_search,
          fields: 'items(link)',
          cx: cse_id,
          key: cse_key
        )

        parse_response(MultiJson.load(http_response.body))
      end

      def parse_response(data)
        if data["items"] && data["items"].any?
          choice = data["items"].sample
          if choice
            return choice["link"]
          else
            return nil
          end
        end
        nil
      end
    end
  end
end