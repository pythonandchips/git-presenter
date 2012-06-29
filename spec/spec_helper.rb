require 'rspec'
require "support/git_helpers"
require "support/command_line_helper"
require_relative "../lib/git_presenter"
require 'pry'

RSpec.configure do |config|
  config.before(:each) do
    CommandLineHelper.capture_output
  end
end

