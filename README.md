# BankValidator

This validator using ActiveModel is aimed at validating a model that has BIC and IBAN fields

## Installation

Add this line to your application's Gemfile:

    gem 'bank_validator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bank_validator

## Usage

Include it in your model and call it with validate_with

    class User < ActiveRecord::Base
      include ActiveModel::Validations
      validates_with BankValidator::Validator
    end

## I18n

French and english translations available and loaded.
If you want to add more translations, add a new file at your project's config/locale, nd check the embedded translations for the structure of the yml


## Options

You can pass allow_nil: false if you want the bankdata to be required. True by default.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
