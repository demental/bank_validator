require 'active_model'
module BankValidator
  class Validator < ActiveModel::Validator

    def initialize(options)
      super
      @allow_nil = options[:allow_nil].nil? ? true : options[:allow_nil]
    end

    def validate(record)
      add_error(record, :iban, :blank) unless @allow_nil || record.iban.present?
      add_error(record, :bic, :blank) unless @allow_nil || record.bic.present?
      if record.respond_to?(:iban) && record.respond_to?(:bic)
        add_error(record, :iban, :none_or_both_bic_iban) unless (record.iban.present? == record.bic.present?)
      end
      validate_iban(record) if record.respond_to?(:iban) && record.iban.present?
      validate_bic(record) if record.respond_to?(:bic) && record.bic.present?
    end

    private

    def add_error(record, field, message_key)
      record.errors.add field, record.errors.generate_message(field, message_key)
    end

    def validate_iban(record)
      # IBAN code should start with country code (2letters)
      return add_error(record, :iban, :country_code_missing_in_iban) unless record.iban.to_s =~ /^[A-Z]{2}/i
      iban = record.iban.gsub(/ /,'').gsub(/[A-Z]/) { |p| (p.respond_to?(:ord) ? p.ord : p[0]) - 55 }
      add_error(record, :iban, :invalid) unless (iban[6..iban.length-1].to_s+iban[0..5].to_s).to_i % 97 == 1
    end

    def validate_bic(record)
      add_error(record, :iban, :invalid) unless /^([a-zA-Z]{4}[a-zA-Z]{2}[a-zA-Z0-9]{2}([a-zA-Z0-9]{3})?)$/.match(record.bic)
    end
  end
end
require('active_support/i18n')
I18n.load_path << File.dirname(__FILE__) + '/locale/bank_validator.en.yml'
I18n.load_path << File.dirname(__FILE__) + '/locale/bank_validator.fr.yml'