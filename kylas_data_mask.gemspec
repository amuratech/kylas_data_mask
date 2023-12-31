require_relative 'lib/kylas_data_mask/version'

Gem::Specification.new do |spec|
  spec.name        = 'kylas_data_mask'
  spec.version     = KylasDataMask::VERSION
  spec.authors     = ['jaydip-makwana-kylas']
  spec.email       = ['jaydip.makwana@kylas.io']
  spec.homepage = 'https://github.com/amuratech/kylas_data_mask'
  spec.summary = 'This gem provides data masking of kylas data in marketplace application.'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/amuratech/kylas_data_mask'
  spec.metadata['changelog_uri'] = 'https://github.com/amuratech/kylas_data_mask'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'pg'
  spec.add_dependency 'phonelib'
  spec.add_dependency 'rails'
  spec.add_dependency 'sidekiq'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'webmock'
end
