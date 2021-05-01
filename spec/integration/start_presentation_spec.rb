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
      expect(presentation.slides.length).to eql 4
    end
  end

  it "first commit should be first commit in file" do
    @helper.start_presentation do |commits, presenter|
      expect(presenter.slides[0].commit).to eql commits[0].sha
    end
  end

  it "second commit should be second commit in file" do
    @helper.start_presentation do |commits, presenter|
      expect(presenter.slides[1].commit).to eql commits[1].sha
    end
  end

  it "the last commit should be a command" do
    command = "echo hello world"
    @helper.start_presentation([:run => command]) do |commits, presenter|
      expect(presenter.slides[3].run).to eql command
    end
  end

  it "should have the presentation at first commit" do
    @helper.start_presentation do |commits, presenter|
      expect(@helper.head_position).to eql commits.first.sha
    end
  end
end
