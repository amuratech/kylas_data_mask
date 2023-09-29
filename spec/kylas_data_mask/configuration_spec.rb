# frozen_string_literal: true

require 'spec_helper'
require 'kylas_data_mask/configuration'

RSpec.describe KylasDataMask::Configuration do
  context '#validate!' do
    context 'when api_url is blank' do
      it 'should raise exception' do
        expect do
          described_class.new.validate!
        end.to raise_error(
          KylasDataMask::ConfigurationError,
          'API URL is missing in the configuration'
        )
      end
    end

    context 'when api_url is present' do
      it 'should not raise exception' do
        expect do
          described_class.new(api_url: 'abc').validate!
        end.not_to raise_error(
          KylasDataMask::ConfigurationError,
          'API URL is missing in the configuration'
        )
      end
    end
  end
end
