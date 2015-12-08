module Lita
  module Handlers
    class ImageFetcher < Handler
      config :pixabay_key, types: [String]
      config :google_cse_key, types: [String]
      config :google_cse_id, types: [String]
      config :google_cse_safe_search, types: [Symbol], default: :high
      config :bing_key, types: [String]

      route(/(?:image|img)(?:\s+me)? (.+)/i, :fetch, command: true, help: {
        "image QUERY" => "Displays an image matching the query."
      })

      def sources
        @sources ||= {}
        @sources[:pixabay] ||= Handlers::Pixabay.new(api_key: config.pixabay_key) if config.pixabay_key.present?
        @sources[:google_cse] ||= Handlers::GoogleCSE.new(
            cse_id: config.google_cse_id,
            cse_key: config.google_cse_key,
            cse_safe_search: config.google_cse_safe_search
          ) if config.google_cse_id.present? && config.google_cse_safe_search.present? && config.google_cse_key.present?
        @sources[:bing] ||= Handlers::Bing.new(bing_key: config.bing_key) if config.bing_key.present?
        @sources
      end

      def fetch(response)
        sources.each do |source_name, source_object|
          image_url = source_object.fetch(response)
          if validate(image_url)
            response.reply "#{image_url} (From #{source_name})"
            return
          end
        end

        response.reply "No images found from sources: #{sources.keys.join(', ')}"
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
