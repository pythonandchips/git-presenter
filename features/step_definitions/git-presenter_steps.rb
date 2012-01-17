require "grit"
require File.dirname(__FILE__) + "/../../spec/support/repo_helpers"

Given /^I have written the code for a presentation$/ do
  initialise_test_repo
end


When /^I initialise the presentation$/ do
  Dir.chdir(@presentation_dir) do
    GitPresenter.initialise_presentation(".")
  end
end

When /^reset the folder to starting possition$/ do
  Dir.chdir(@presentation_dir) do
    GitPresenter.start_presentation(".")
  end
end

Then /^I should be on the first commit$/ do
  Dir.chdir(@presentation_dir) do
    repo = Grit::Repo.new(".")
    repo.commits.first.id.should eql @first_commit.id
  end
end

Given /^I have setup the code for presentation$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I start the presentation$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I move to the next commit$/ do
  pending # express the regexp above with the code you wish you had
end

After do
  `rm -fr #{@presentation_dir}`
end
