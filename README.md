# lita-image-fetcher

**lita-image-fetcher** is a [Lita](https://github.com/litaio/lita) handler for the servicing of image queries.  The handler intends to be designed in such a way that extension with new image sources is relatively straightforward.  If you have an image source you want to add that is not already implemented, feel free to make a pull request!  I'll gladly integrate any valid image source into this plugin.  

**Free services:**
* Pixabay

**Rate limited services:**
* Google CSE (100 images per day)
* Bing (5000 images per month)

**Paid services:**
* Yahoo (not yet implemented)

**Current maximum free images per day:** 261+

All of these sources have strengths and weaknesses, and most have rate limitations that spill over into paid models.  Running this handler for free (or on the cheaps) therefore will require some degree of configuration with regard to when each source should be used.  Relevant links to the various payment models of these sources is forthcoming. 

## History

This project is inspired by [lita-google-images](https://github.com/jimmycuadra/lita-google-images) and its hubot counterpart.  Most "image me" plugins have generally relied on an unlimited access Google API for image searching that has been deprecated since 2011 and finally stopped being available in December 2015.  Now the only way to get images from Google is by registering a rate-limited custom search engine.  This plugin seeks to support a wide array of image sources (and to be easily extensible) so that image searches can be done without having to purchase a premium service from a single provider.  

## Installation

Add lita-image-fetcher to your Lita instance's Gemfile:

``` ruby
gem "lita-image-fetcher", :git => "https://github.com/sadatay/lita-image-fetcher.git"
```

## Configuration

### Configuring Pixabay
Pixabay is an indexing service for images in the public domain.  It returns results for simple queries like "Cuttlefish" but not for more complex queries like "Cuttlefish climbing the Eiffel Tower", or for queries that will likely contain proprietary images like "There's Something About Mary".

Though Pixabay is technically limited to 4000 requests per hour, that's probably going to be an unachievable limit for most corporate or personal chatrooms, so I'm cosidering this source as good as "unlimited".  The fetcher will try to hit unlimited APIs first and will fallback to the more rate-limited APIs if images can't be found.

To use the Pixabay API you must first register an account with Pixabay.  Once registered, you will see your API key displayed when visiting the [Pixabay API documentation](https://pixabay.com/api/docs/). 

Add the key to your Lita config:
``` ruby
Lita.configure do |config|
  config.handlers.image_fetcher.pixabay_key = 'PixabayKey'
end
```

### Configuring Google CSE
Google CSE or "Custom Search Engine" is a way to retrieve Google search results.  The free tier of service is rate limited to 100 images per day and once that limit is reached the API will start throwing back 403's.  More images can be purchase from Google through a separate service, but for now only the free version is supported here.

Registering a Google CSE can be a confusing process.  I will be posting a more in-depth explanation here at a future date, but for now let's just say "follow the Google documentation".  You will need a CSE ID and an API key.  Add them to your Lita config as follows.
``` ruby
Lita.configure do |config|
  config.handlers.image_fetcher.google_cse_id = 'GoogleID'
  config.handlers.image_fetcher.google_cse_key = 'GoogleKey'
  config.handlers.image_fetcher.google_cse_safe_search = :off
end
```

### Configuring Bing
Bing is Microsoft's search engine, and its API can be used to retrieve images.  It is rate limited to 5000 images per month, which is roughly 161 images per day.  It also has paid tiers, which in theory should also be supported here if your API key is associated with a paid plan.  

You can sign up for Bing's free or paid services on the [Azure Marketplace](https://datamarket.azure.com/dataset/5BA839F1-12CE-4CCE-BF57-A49D98D29A44).  Following their instructions will yield an API key that you can then add to your Lita config as follows:
``` ruby
Lita.configure do |config|
  config.handlers.image_fetcher.bing_key = 'BingKey'
end
```

### Configuring source level
You can specify how deep you want the image searching to go.  `lita-image-fetcher` will only use sources that are configured, and it will try them in the order Free -> Limited -> Paid.  However if for some reason your chat is consuming too many paid images, or is consistently going over the limits for a rate-limited source and you want to temporarily disable the source without removing the configuration, you can specify the level as follows:
``` ruby
Lita.configure do |config|
  config.handlers.image_fetcher.source_level = :free
end
```

Possible values are `:free`, `:limited` and `:paid`.  The default is `:limited`.

## Usage

Usage is equivalent to the [lita-google-images](https://github.com/jimmycuadra/lita-google-images) plugin:
```
Lita: image carl the pug
Lita: image me carl the pug
Lita: img carl the pug
Lita: img me carl the pug
```
