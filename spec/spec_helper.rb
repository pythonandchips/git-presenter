require 'rspec'
require 'pry'
require "support/git_helpers"
require "support/command_line_helper"
require_relative "../lib/git_presenter"
require 'pry'

RSpec.configure do |config|
  config.before(:each) do
    @command_line = CommandLineHelper.capture_output
  end
end

