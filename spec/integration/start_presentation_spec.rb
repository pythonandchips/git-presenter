require "spec_helper"

describe "starting a presentation" do
  let(:presentation_dir){File.dirname(__FILE__) + "/../../presentation"}

  it "should contian the commits for presentations" do
    initialise_presentation
    Dir.chdir(presentation_dir) do
      presenter = GitPresenter.start_presentation(".")
      presenter.commits.length.should eql 3
    end
  end

  it "first commit should be first commit in file" do
    start_presentation do |commits, presenter|
      presenter.commits[0].should eql commits[0].id
    end
  end

  it "second commit should be second commit in file" do
    start_presentation do |commits, presenter|
      presenter.commits[1].should eql commits[1].id
    end
  end

  it "should have the presentation at first commit" do
    start_presentation do |commits, presenter|
      head_position.should eql commits.first.id
    end
  end
end
