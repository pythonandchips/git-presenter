require "spec_helper"

describe "update presentation with any new commits" do

  before do
    @helper = GitHelper.new
  end

  it "should add the new commits to the presentation" do
    commits = @helper.initialise_presentation({:delay => true})
    new_commit = @helper.edit_file_and_commit("forth commit", "d")
    @helper.update_presentation do |yaml|
      yaml["slides"].length.should eql (commits.length + 1)
    end
  end

  it "should add the new commits to the end of the presentation" do
    commits = @helper.initialise_presentation({:delay => true})
    new_commit = @helper.edit_file_and_commit("forth commit", "d")
    @helper.update_presentation do |yaml|
      yaml["slides"].last["slide"]["commit"].should eql new_commit.id
    end
  end

  it "should not contain any commits that have been removed in the middle of the presentation" do
    commits = @helper.initialise_presentation({:delay => true})
    removed_commit = @helper.remove_from_presentation_at(1)
    new_commit = @helper.edit_file_and_commit("forth commit", "d")
    @helper.update_presentation do |yaml|
      yaml["slides"].length.should eql (commits.length)
    end
  end

end
