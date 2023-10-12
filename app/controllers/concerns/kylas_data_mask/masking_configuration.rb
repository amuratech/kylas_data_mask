module KylasDataMask::MaskingConfiguration
  extend ActiveSupport::Concern

  include KylasDataMask::MaskingConfigurationHelper

  included do
    before_action :clear_cache_masking_configuration, if: proc { request.url.include?('sign_out') }
  end
end
