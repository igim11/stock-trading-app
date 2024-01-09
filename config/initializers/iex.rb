IEX::Api.configure do |config|
  config.publishable_token = 'pk_28432911a33d4e58a546ae4a261bd3dc' # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
  config.secret_token = 'sk_91c66919e98d4d5093a8872d5077f931' # defaults to ENV['IEX_API_SECRET_TOKEN']
  config.endpoint = 'https://cloud.iexapis.com/v1' # use 'https://sandbox.iexapis.com/v1' for Sandbox
end