require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/image_fetcher"

Lita::Handlers::ImageFetcher.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
