Gem::Specification.new do |s|
  s.name          = 'logstash-filter-split_otlp_resourcelogs'
  s.version       = '0.2.0'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Logstash Filter Plugin for Splitting OTLP resourceLogs'
  s.description   = 'Splits OTLP/JSON formatted content, creating a new event per log record.'
  s.homepage      = 'https://github.com/yesmarket/logstash-filter-split_otlp_resourcelogs'
  s.authors       = ['Ryan Bartsch']
  s.email         = 'rbartsch@yandex.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "jsonpath", "~> 1.1"
  s.add_runtime_dependency 'logstash-core-plugin-api', "~> 2.0"
  s.add_runtime_dependency 'logstash-codec-json'
  s.add_development_dependency 'logstash-devutils'
  s.add_development_dependency 'insist'
end
