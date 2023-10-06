# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KylasDataMask do
  context 'with correct version' do
    it 'has a version number' do
      expect(KylasDataMask::VERSION).to eq('1.0.0')
    end
  end

  describe '.configure' do
    context 'when api_url is blank' do
      it 'should raise exception' do
        expect do
          described_class.configure do |c|
            c.api_url = nil
          end
        end.to raise_error(
          KylasDataMask::ConfigurationError,
          'API URL is missing in the configuration'
        )
      end
    end

    context 'when api_url is present' do
      it 'should not raise exception' do
        expect do
          described_class.configure do |c|
            c.api_url = 'https://www.examples.io'
          end
        end.not_to raise_error(
          KylasDataMask::ConfigurationError,
          'API URL is missing in the configuration'
        )
      end
    end
  end
end
