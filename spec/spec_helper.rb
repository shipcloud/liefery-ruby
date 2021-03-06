require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
]

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/bundle'
  #minimum_coverage(99.15)
  refuse_coverage_drop
end

require 'json'
require 'liefery'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  # Disable should syntax
  # https://www.relishapp.com/rspec/rspec-expectations/docs/syntax-configuration
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_results"

  # had to override backtrace_exclusion_patterns because of current
  # directory structure. once this gem has been extracted into a separate
  # respository this can be removed
  config.backtrace_exclusion_patterns = [
    /\/lib\d*\/ruby\//,
    /org\/jruby\//,
    /bin\//,
    /vendor\/bundle\/(.*)\/gems\//,
    /spec\/spec_helper.rb/,
    /lib\/rspec\/(core|expectations|matchers|mocks)/
  ]

  config.after(:each) do
    Liefery.reset!
  end
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def liefery_api_endpoint
  Liefery::Default::SANDBOX_API_ENDPOINT
end

def liefery_api_path
  "api/partner/#{Liefery::Default::API_VERSION}"
end

def liefery_api_url(url)
  url =~ /^http/ ? url : "#{liefery_api_endpoint}/#{liefery_api_path}#{url}"
end

def a_delete(path)
  a_request(:delete, liefery_api_url(path))
end

def a_get(path)
  a_request(:get, liefery_api_url(path))
end

def a_post(path)
  a_request(:post, liefery_api_url(path))
end

def a_put(path)
  a_request(:put, liefery_api_url(path))
end

def stub_delete(path)
  stub_request(:delete, liefery_api_url(path))
end

def stub_get(path)
  stub_request(:get, liefery_api_url(path))
end

def stub_head(path)
  stub_request(:head, liefery_api_url(path))
end

def stub_post(path)
  stub_request(:post, liefery_api_url(path))
end

def stub_put(path)
  stub_request(:put, liefery_api_url(path))
end

def stub_patch(path)
  stub_request(:patch, liefery_api_url(path))
end
