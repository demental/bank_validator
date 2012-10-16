require 'spec_helper'

describe BankValidator::Validator do

  A_VALID_BIC = 'AGRIFRPP812'
  A_VALID_IBAN = 'FR76 1120 6200 1012 1495 4641 151'

  def mock_with(fields = {})
    mock(fields.merge errors: mock(add: nil, generate_message: nil))
  end

  describe 'routing validation' do
    let(:options) { {} }
    let(:bankvalidator) { BankValidator::Validator.new(options) }
    subject { bankvalidator }

    context "when has an iban" do
      let(:record) { mock_with(iban: 'FR123') }
      it "uses validate_iban" do
        subject.should_receive(:validate_iban)
        subject.validate(record)
      end
    end
    context "when has not an iban" do
      let(:record) { mock_with }
      it "doesnt uses validate_iban" do
        subject.should_not_receive(:validate_iban)
        subject.validate(record)
      end
    end
    context "when has a bic" do
      let(:record) { mock_with(bic: 'FR123') }
      it "uses validate_bic" do
        subject.should_receive(:validate_bic)
        subject.validate(record)
      end
    end
    context "when has not an bic" do
      let(:record) { mock_with }
      it "doesnt use validate_iban" do
        subject.should_not_receive(:validate_bic)
        subject.validate(record)
      end
    end
  end

  describe '#validate_iban' do
    let(:options) { {} }
    subject { BankValidator::Validator.new(options).send(:validate_iban, record) }
    let(:record) { mock_with(iban: iban) }
    [ 'F76 1120 6200 1012 1495 4641', 'FR76 1120 6200 1012 1495 4641', '93','1234' ].each do |invalid_iban|
      context "iban: #{invalid_iban}" do
        let(:iban) { invalid_iban }
        it "is not valid" do
          record.should_receive :errors
          subject
        end
      end
    end
    [ 'FR7611206200101214954641151', 'FR76 1120 6200 1012 1495 4641 151' ].each do |valid_iban|
      context "iban: #{valid_iban}" do
        let(:iban) { valid_iban }
        it "is valid" do
          record.should_not_receive :errors
          subject
        end
      end
    end
  end
  describe '#validate_bic' do
    let(:options) { {} }
    subject { BankValidator::Validator.new(options).send(:validate_bic, record) }
    let(:record) { mock_with(bic: bic) }
    [ '12RIFRPP812', 'AGRIFRPP81', 'AGRI23PP812' ].each do |invalid_bic|
      context "bic: #{invalid_bic}" do
        let(:bic) { invalid_bic }
        it "is not valid" do
          record.should_receive :errors
          subject
        end
      end
    end
    [ A_VALID_BIC ].each do |valid_bic|
      context "bic: #{valid_bic}" do
        let(:bic) { valid_bic }
        it "is valid" do
          record.should_not_receive :errors
          subject
        end
      end
    end
  end
  describe 'requiring both or none' do
    let(:options) { {} }
    let(:bankvalidator) { BankValidator::Validator.new(options) }
    subject { bankvalidator.validate(record) }
    let(:record) { mock_with(iban: iban, bic: bic) }
    context "when both are missing" do
      let(:bic) { nil }
      let(:iban) { nil }
      it "is valid" do
        record.should_not_receive(:errors)
        subject
      end
    end

    context "when both are missing and allow_nil set to false" do
      let(:options) { {allow_nil: false} }
      let(:bic) { nil }
      let(:iban) { nil }
      it "is not valid" do
        record.should_receive(:errors)
        subject
      end
    end
    context "when both are valid and allow_nil set to false" do
      let(:options) { {allow_nil: false} }
      let(:bic) { A_VALID_BIC }
      let(:iban) { A_VALID_IBAN }
      it "is valid" do
        record.should_not_receive(:errors)
        subject
      end
    end

    context "when bic is missing and iban is valid" do
      let(:bic) { nil }
      let(:iban) { A_VALID_IBAN }
      it "is not valid" do
        record.should_receive(:errors)
        subject
      end
    end

    context "when iban is missing and bic is valid" do
      let(:iban) { nil }
      let(:bic) { A_VALID_BIC }
      it "is not valid" do
        record.should_receive(:errors)
        subject
      end
    end
  end
end