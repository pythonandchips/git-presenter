require "spec_helper"

describe "starting a presentation" do
  let(:presentation_dir){File.dirname(__FILE__) + "/../../presentation"}

  before do
    @helper = GitHelper.new(presentation_dir)
  end

  it "should contian the commits for presentations" do
    @helper.initialise_presentation
    Dir.chdir(presentation_dir) do
      presenter = GitPresenter.start_presentation(".")
      presenter.slides.length.should eql 3
    end
  end

  it "first commit should be first commit in file" do
    @helper.start_presentation do |commits, presenter|
      presenter.slides[0].commit.should eql commits[0].id
    end
  end

  it "second commit should be second commit in file" do
    @helper.start_presentation do |commits, presenter|
      presenter.slides[1].commit.should eql commits[1].id
    end
  end

  it "should have the presentation at first commit" do
    @helper.start_presentation do |commits, presenter|
      @helper.head_position.should eql commits.first.id
    end
  end
end
