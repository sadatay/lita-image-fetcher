module Lita
  module Handlers
    class Pixabay < Handler
      SOURCE_URL = "https://pixabay.com/api/"

      def initialize(api_key:)
        @api_key = api_key
      end

      def fetch(response)
        query = response.matches[0][0]

        http_response = http.get(
          SOURCE_URL,
          key: @api_key,
          q: query,
          per_page: 10
        )

        parse_response(MultiJson.load(http_response.body))
      end

      def parse_response(data)
        if data["hits"] && data["hits"].any?
          choice = data["hits"].sample
          if choice
            return choice["webformatURL"]
          else
            return %{No images found for "#{query}".}
          end
        else
          Lita.logger.warn(
            "Couldn't get image from Pixabay."
          )
        end
      end
    end
  end
end