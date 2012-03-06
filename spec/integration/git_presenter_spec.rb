require_relative "../support/repo_helpers"
require_relative "../../lib/git_presenter"

describe "using git presenter" do
  let(:presentation_dir){File.dirname(__FILE__) + "/../../presentation"}

  context "setting up a presentation" do

    before do
      @commits = initialise_test_repo(presentation_dir)
    end

    subject do
      initialise_presentation(presentation_dir)
      start_presentation(presentation_dir)
    end

    it "should set the repo to the first commit" do
      Dir.chdir(presentation_dir) do
        repo = Grit::Repo.new(".")
        repo.commits.first.id.should eql @commits.first.id
      end
    end
  end

  context "when moving through the presentation" do
    before do
      @commits = initialise_test_repo(presentation_dir)
      initialise_presentation(presentation_dir)
      start_presentation(presentation_dir)
      next_commit(presentation_dir)
    end

    it "should move the head to the next commit" do
      Dir.chdir(presentation_dir) do
        repo = Grit::Repo.new(".")
        repo.commits.first.id.should eql @commits.second.id
      end
    end
  end

  context "when moving back through the presentation" do
    before do
      @commits = initialise_test_repo(presentation_dir)
      initialise_presentation(presentation_dir)
      previous_commit(presentation_dir)
    end

    it "should move the head back to the previous commit" do
    end
  end

  def initialise_presentation(dir)
    Dir.chdir(dir) do
      @git_presentation = GitPresenter.initialise_presentation(".")
    end
  end

  def start_presentation(dir)
    Dir.chdir(dir) do
      @git_presentation = GitPresenter.start_presentation(".")
    end
  end

  def next_commit(dir)
    Dir.chdir(dir) do
      @git_presentation.next(".")
    end
  end

  def previous_commit(dir)
    Dir.chdir(dir) do
      @git_presentation.previous(".")
    end
  end
end
