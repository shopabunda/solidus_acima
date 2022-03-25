# Solidus Acima

[![CircleCI](https://circleci.com/gh/solidusio-contrib/solidus_acima.svg?style=shield)](https://circleci.com/gh/solidusio-contrib/solidus_acima)
[![codecov](https://codecov.io/gh/solidusio-contrib/solidus_acima/branch/master/graph/badge.svg)](https://codecov.io/gh/solidusio-contrib/solidus_acima)

<!-- Explain what your extension does. -->

## Installation

Add solidus_acima to your Gemfile:

```ruby
gem 'solidus_acima'
```

Bundle your dependencies and run the installation generator:

```shell
bin/rails generate solidus_acima:install
```

## Basic Setup

### Creating a new Payment Method

Payment methods can accept preferences either directly entered in admin, or from a static source in code.
For most projects we recommend using a static source, so that sensitive account credentials are not stored in the database.

1. Set static preferences in an initializer

```ruby
# config/initializers/solidus_acima.rb
SolidusAcima.configure do |config|
  config.acima_merchant_id =    ENV['ACIMA_MERCHANT_ID']
  config.acima_client_id =      ENV['ACIMA_CLIENT_ID']
  config.acima_client_secret =  ENV['ACIMA_CLIENT_SECRET']
  config.acima_payment_method = Spree::PaymentMethod.find(ENV['ACIMA_PAYMENT_METHOD_ID'])
end

Spree::Config.configure do |config|
  config.static_model_preferences.add(
    SolidusAcima::PaymentMethod,
    'acima_credentials', {
      merchant_id: SolidusAcima.config.acima_merchant_id,
      client_id: SolidusAcima.config.acima_client_id,
      client_secret: SolidusAcima.config.acima_client_secret
    }
  )
end
```

2. Visit `/admin/payment_methods/new`
3. Set `provider` to SolidusAcima::PaymentMethod
4. Click "Save"
5. Choose `acima_credentials` from the `Preference Source` select
6. Click `Update` to save

Alternatively, create a payment method from the Rails console with:

```ruby
SolidusAcima::PaymentMethod.create(
  name: "Acima",
  preference_source: "acima_credentials"
)
```

### How to obtain Acima credentials

[Request to join Acima's Partner Program](https://www.acima.com/partner).

## Usage

The gem adds an iframe at the payment screens, which you can use to pay with Acima.
When the payment flow in the Acima iframe finishes, you will be automatically redirected to the next step in the checkout process.

### Customizing Displayed Payment Method

To customize the display of the payment method in your app create a file `app/views/spree/shared/_acima.html.erb`,
copy the contents from the file in this repo and apply the changes you want. Be careful in keeping the IDs to maintain functionality.

### Removing Confirm Step in Checkout Process

SolidusAcima automatically redirects to `/checkout/confirm` on a successful payment.
In case you removed this step in your checkout process you need to add the following data attributes to the `iframe-container` div:
```
data-amount="<%= @order.total %>"
data-no-confirmation="true"
```

### Custom Redirect URL for Completed Payments

If on a successful payment you'd like to redirect to a different URL than the default one you can add the data attribute
`data-redirect-url` with the desired URL to the `iframe-container` div.

## Development

### Testing the extension

First bundle your dependencies, then run `bin/rake`. `bin/rake` will default to building the dummy
app if it does not exist, then it will run specs. The dummy app can be regenerated by using
`bin/rake extension:test_app`.

```shell
bin/rake
```

To run [Rubocop](https://github.com/bbatsov/rubocop) static code analysis run

```shell
bundle exec rubocop
```

When testing your application's integration with this extension you may use its factories.
Simply add this require statement to your `spec/spec_helper.rb`:

```ruby
require 'solidus_acima/testing_support/factories'
```

Or, if you are using `FactoryBot.definition_file_paths`, you can load Solidus core
factories along with this extension's factories using this statement:

```ruby
SolidusDevSupport::TestingSupport::Factories.load_for(SolidusAcima::Engine)
```

### Running the sandbox

To run this extension in a sandboxed Solidus application, you can run `bin/sandbox`. The path for
the sandbox app is `./sandbox` and `bin/rails` will forward any Rails commands to
`sandbox/bin/rails`.

Here's an example:

```
$ bin/rails server
=> Booting Puma
=> Rails 6.0.2.1 application starting in development
* Listening on tcp://127.0.0.1:3000
Use Ctrl-C to stop
```

### Updating the changelog

Before and after releases the changelog should be updated to reflect the up-to-date status of
the project:

```shell
bin/rake changelog
git add CHANGELOG.md
git commit -m "Update the changelog"
```

### Releasing new versions

Please refer to the dedicated [page](https://github.com/solidusio/solidus/wiki/How-to-release-extensions) on Solidus wiki.

## License

Copyright (c) 2022 [Naokimi], released under the New BSD License.
