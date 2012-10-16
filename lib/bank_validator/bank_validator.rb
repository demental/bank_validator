require 'active_model'
module BankValidator
  class Validator < ActiveModel::Validator

    def initialize(options)
      super
      @allow_nil = options[:allow_nil].nil? ? true : options[:allow_nil]
    end

    def validate(record)
      record.errors.add :iban, record.errors.generate_message(:iban, :blank) unless @allow_nil || record.iban.present?
      record.errors.add :bic, record.errors.generate_message(:bic, :blank) unless @allow_nil || record.bic.present?
      if record.respond_to?(:iban) && record.respond_to?(:bic)
        record.errors.add :iban, record.errors.generate_message(:iban, :none_or_both_bic_iban) unless (record.iban.present? == record.bic.present?)
      end
      validate_iban(record) if record.respond_to?(:iban) && record.iban.present?
      validate_bic(record) if record.respond_to?(:bic) && record.bic.present?
    end

    private

    def validate_iban(record)
      # IBAN code should start with country code (2letters)
      record.errors.add :iban, record.errors.generate_message(:iban, :country_code_missing_in_iban) and return unless record.iban.to_s =~ /^[A-Z]{2}/i
      iban = record.iban.gsub(/ /,'').gsub(/[A-Z]/) { |p| (p.respond_to?(:ord) ? p.ord : p[0]) - 55 }
      record.errors.add :iban, record.errors.generate_message(:iban, :invalid) unless (iban[6..iban.length-1].to_s+iban[0..5].to_s).to_i % 97 == 1
    end

    def validate_bic(record)
      record.errors.add :bic, record.errors.generate_message(:bic, :invalid) unless /^([a-zA-Z]{4}[a-zA-Z]{2}[a-zA-Z0-9]{2}([a-zA-Z0-9]{3})?)$/.match(record.bic)
    end
  end
end
require('active_support/i18n')
I18n.load_path << File.dirname(__FILE__) + '/locale/bank_validator.en.yml'
I18n.load_path << File.dirname(__FILE__) + '/locale/bank_validator.fr.yml'