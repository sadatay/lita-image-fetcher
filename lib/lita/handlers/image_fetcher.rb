module Lita
  module Handlers
    class ImageFetcher < Handler
      config :pixabay_key, types: [String]
      config :google_cse_key, types: [String]
      config :google_cse_id, types: [String]
      config :google_cse_safe_search, types: [Symbol], default: :high

      route(/(?:image|img)(?:\s+me)? (.+)/i, :fetch, command: true, help: {
        "image QUERY" => "Displays an image matching the query."
      })

      def sources
        {
          pixabay: Handlers::Pixabay.new(api_key: config.pixabay_key),
          google_cse: Handlers::GoogleCSE.new(
            cse_id: config.google_cse_id,
            cse_key: config.google_cse_key,
            cse_safe_search: config.google_cse_safe_search
          )
        }
      end

      def fetch(response)
        reply = "No images found from sources: #{sources.keys.join(', ')}"
        reply_image = nil
        reply_source = nil

        sources.each do |source_name, source_object|
          image_url = source_object.fetch(response)
          if validate(image_url)
            reply_image = image_url
            reply_source = source_name
            break
          end
        end

        if reply_image
          reply = "#{reply_image} (From #{reply_source})"
        end

        response.reply reply
      end

      def validate(url)
        return false if url.nil?
        if [".gif", ".jpg", ".jpeg", ".png"].any? { |ext| url.end_with?(ext) }
          url
        else
          "#{url}#.png"
        end
      end

      Lita.register_handler(ImageFetcher)
    end
  end
end
