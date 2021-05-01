require "spec_helper"

describe "update presentation with any new commits" do

  before do
    @helper = GitHelper.new
  end

  it "should add the new commits to the presentation" do
    commits = @helper.initialise_presentation({:delay => true})
    new_commit = @helper.edit_file_and_commit("forth commit", "d")
    @helper.update_presentation do |yaml|
      expect(yaml["slides"].length).to eql (commits.length + 1)
    end
  end

  it "should add the new commits to the end of the presentation" do
    commits = @helper.initialise_presentation({:delay => true})
    new_commit = @helper.edit_file_and_commit("forth commit", "d")
    @helper.update_presentation do |yaml|
      expect(yaml["slides"].last["slide"]["commit"]).to eql new_commit.sha
    end
  end

  it "should not contain any commits that have been removed in the middle of the presentation" do
    commits = @helper.initialise_presentation({:delay => true})
    removed_commit = @helper.remove_from_presentation_at(1)
    new_commit = @helper.edit_file_and_commit("forth commit", "d")
    @helper.update_presentation do |yaml|
      expect(yaml["slides"].length).to eql (commits.length)
    end
  end

  it "should tell inform the user the presentation has been updated" do
    commits = @helper.initialise_presentation({:delay => true})
    removed_commit = @helper.remove_from_presentation_at(1)
    new_commit = @helper.edit_file_and_commit("forth commit", "d")
    @helper.update_presentation
    expect(@command_line.command_output).to include "Your presentation has been updated"
  end

end
