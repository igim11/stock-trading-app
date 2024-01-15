IEX::Api.configure do |config|
  config.publishable_token = 'pk_8ffc8b1159ea41f08c9167e7d1cea3c7' # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
  config.secret_token = 'sk_e92468512b3043c3ac2104a9a1d12697' # defaults to ENV['IEX_API_SECRET_TOKEN']
  config.endpoint = 'https://cloud.iexapis.com/v1' # use 'https://sandbox.iexapis.com/v1' for Sandbox
end