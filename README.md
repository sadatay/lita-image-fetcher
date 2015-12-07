# lita-image-fetcher

*This project is very much work in progress, and is completely non-functional at the time of the initial commit.  I am setting this up as a space where progress can be viewed and collaboration can be facilitated.*

*lita-image-fetcher* is a [Lita](https://github.com/litaio/lita) handler for the servicing of image queries.  The handler intends to be designed in such a way that extension with new image sources is relatively straightforward.  

Sources intended to be included by default:
* Google CSE (implemented)
* Bing
* Yahoo
* Pixabay (implemented)

All of these sources have strengths and weaknesses, and most have rate limitations that spill over into paid models.  Running this handler for free (or on the cheaps) therefore will require some degree of configuration with regard to when each source should be used.  Relevant links to the various payment models of these sources is forthcoming. 

## Installation

Add lita-image-fetcher to your Lita instance's Gemfile:

``` ruby
gem "lita-image-fetcher"
```

## Configuration

###Configuring Pixabay
To use the Pixabay API you must first register an account with Pixabay.  Once registered, you will see your API key displayed when visiting the [Pixabay API documentation](https://pixabay.com/api/docs/). 

Add the key to your Lita config:
```
Lita.configure do |config|
  config.handlers.image_fetcher.pixabay_key = 'ThisIsATotallyRealKey'
end
```

###Configuring Google CSE
Registering a Google CSE can be a confusing process.  I will be posting a more in-depth explanation here at a future date, but for now let's just say "follow the Google documentation".  You will need a CSE ID and an API key.  Add them to your Lita config as follows.
```
Lita.configure do |config|
  config.handlers.image_fetcher.google_cse_id = 'GoogleID'
  config.handlers.image_fetcher.google_cse_key = 'GoogleKey'
  config.handlers.image_fetcher.google_cse_safe_search = :off
end
```

###Configuring Bing
You can sign up for Bing's free or paid services on the [Azure Marketplace](https://datamarket.azure.com/dataset/5BA839F1-12CE-4CCE-BF57-A49D98D29A44).  Following their instructions will yield an API key that you can then add to your Lita config as follows:
```
Lita.configure do |config|
  config.handlers.image_fetcher.bing_key = 'BingKey'
end
```

## Usage

Not recommended as of yet.
