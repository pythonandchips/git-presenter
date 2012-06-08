require "spec_helper"

describe "update presentation with any new commits" do

  before do
    @helper = GitHelper.new
  end

  pending "should add the new commits to the presentation" do
    commits = @helper.initialise_presentation
    new_commit = @helper.edit_file_and_commit("forth commit", "d")
    @helper.update_presentation do |yaml|
      yaml["slides"].length.should eql (commits.length + 1)
    end
  end

end
