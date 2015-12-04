module Lita
  module Handlers
    class ImageFetcher < Handler
      config :pixabay_key, types: [String]

      route(/(?:image|img)(?:\s+me)? (.+)/i, :fetch, command: true, help: {
        "image QUERY" => "Displays an image matching the query."
      })

      def get_available_sources
        [
          Handlers::Pixabay.new(api_key: config.pixabay_key)
        ]
      end

      def source
        get_available_sources.first
      end

      def fetch(response)
        response.reply validate(source.fetch(response))
      end

      def validate(data)
        data
      end

      Lita.register_handler(ImageFetcher)
    end
  end
end
