require 'spec_helper'

describe "presentation should parse all commits for a repo" do
  before do
    @helper = GitHelper.new
  end

  it "should parse more than 10 commits" do
    @helper.initialise_presentation({:no_of_commits => 13}) do |commits, yaml|
      yaml["slides"].length.should eql 13
    end
  end
end
