# frozen_string_literal: true

module KylasDataMask
  class Engine < ::Rails::Engine
    isolate_namespace KylasDataMask

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
