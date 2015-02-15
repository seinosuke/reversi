# coding: utf-8

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')     { 'spec' }

  watch(/lib\/(.+)\.rb/)           { 'spec' }
  watch(/lib\/reversi\/(.+)\.rb/)  { 'spec' }
end
