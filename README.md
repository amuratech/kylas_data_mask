# KylasDataMask
The engine for data masking handling in kylas marketplace apps

## Usage
Please refer installation steps.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'kylas_data_mask', git: 'https://github.com/amuratech/kylas_data_mask.git'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install kylas_data_mask
```

In your config/kylas_data_mask.rb,
```ruby
KylasDataMask::Context.setup do |config|
  config.api_url = 'Enter kylas api url'
  config.api_version = 'Enter kylas api version'
  config.marketplace_app_host = 'Enter marketplace app host'
  config.marketplace_app_id = 'Enter marketplace app id'
  config.user_model_name = 'User model name in the application'
  config.tenant_model_name = 'Tenant model name in the application'
  config.webhook_api_key_column_name = 'webhook_api_key column name in the application'
end
```

In your config/routes.rb file,
```ruby
mount KylasDataMask::Engine, at: 'kylas-data-mask'
```

Copy migration from kylas engine to your app
```ruby
bin/rails kylas_data_mask:install:migrations
```

Then run migrations
```ruby
bin/rails db:migrate
```


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
