module Lita
  module Handlers
    class ImageFetcher < Handler
      config :pixabay_key, types: [String]
      config :google_cse_key, types: [String]
      config :google_cse_id, types: [String]
      config :google_cse_safe_search, types: [Symbol], default: :high
      config :bing_key, types: [String]
      config :source_level, types: [Symbol], default: :limited

      route(/(?:image|img)(?:\s+me)? (.+)/i, :fetch, command: true, help: {
        "image QUERY" => "Displays an image matching the query."
      })

      def sources
        {free: {}, limited: {}, paid: {}}.tap do |hash|
          if config.pixabay_key
            hash[:free][:pixabay] ||= Handlers::Pixabay.new(api_key: config.pixabay_key)
          end

          if config.google_cse_id && config.google_cse_safe_search && config.google_cse_key
            hash[:limited][:google_cse] = Handlers::GoogleCSE.new(
              cse_id: config.google_cse_id,
              cse_key: config.google_cse_key,
              cse_safe_search: config.google_cse_safe_search
            )
          end

          if config.bing_key
            hash[:limited][:bing] = Handlers::Bing.new(bing_key: config.bing_key) 
          end
        end
      end

      def source_levels
        {
          free: [:free],
          limited: [:free, :limited],
          paid: [:free, :limited, :paid]
        }
      end

      def fetch(response)
        sources.each do |source_level, source_objects|
          if source_levels[config.source_level].include? source_level
            source_objects.each do |source_name, source_object|
              image_url = source_object.fetch(response)
              if image_url
                response.reply "#{sanitize(image_url)} (From #{source_name})"
                return
              end
            end
          end
        end

        response.reply "No images found from sources: #{source_levels[config.source_level].join(', ')}"
      end

      def sanitize(url)
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
