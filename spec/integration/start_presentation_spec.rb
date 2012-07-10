require "spec_helper"

describe "starting a presentation" do
  let(:presentation_dir){File.dirname(__FILE__) + "/../../presentation"}

  before do
    @helper = GitHelper.new(presentation_dir)
  end

  it "should contian the commits for presentations" do
    @helper.initialise_presentation
    @helper.add_command("echo hello world")
    Dir.chdir(presentation_dir) do
      presenter = GitPresenter.new(".", false)
      presentation = presenter.execute('start')
      presentation.slides.length.should eql 4
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

  it "the last commit should be a command" do
    command = "echo hello world"
    @helper.start_presentation([:run => command]) do |commits, presenter|
      presenter.slides[3].run.should eql command
    end
  end

  it "should have the presentation at first commit" do
    @helper.start_presentation do |commits, presenter|
      @helper.head_position.should eql commits.first.id
    end
  end
end
