# frozen_string_literal: true

require_relative 'lib/kylas_data_mask/version'

Gem::Specification.new do |spec|
  spec.name = 'kylas_data_mask'
  spec.version = KylasDataMask::VERSION
  spec.authors = ['Jaydip Makwana']
  spec.email = ['']

  spec.summary = 'This gem provides data masking of kylas data in marketplace application.'
  spec.required_ruby_version = '>= 2.6.0'

  spec.homepage = 'https://github.com/amuratech/kylas_data_mask'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/amuratech/kylas_data_mask'
  spec.metadata['changelog_uri'] = 'https://github.com/amuratech/kylas_data_mask'

  spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_development_dependency 'webmock', '~> 3.19'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
