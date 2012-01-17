require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GitPresenter" do
  before do
    initialise_test_repo
  end

  after do
    clean_up_repo
  end

  describe "initialise" do
    it "should create a .presentation file" do
      Dir.chdir(@presentation_dir) do
        GitPresenter.initialise_presentation(".")
        File.exist?(".presentation").should be_true
      end
    end

    it "file should contain list of commits" do
      Dir.chdir(@presentation_dir) do
        GitPresenter.initialise_presentation(".")
        File.open(".presentation", "r") do |file|
          commits = file.lines.to_a
          commits.should eql @commits.map{|commit| commit.id + "\n"}
        end
      end
    end
  end

  describe "start_presentation" do
    it "should reset the repo head back to the first commit" do
      Dir.chdir(@presentation_dir) do
        setup_presentation_file
        GitPresenter.start_presentation(".")
        repo = Grit::Repo.new(".")
        repo.head.commit.id.should eql @first_commit.id
      end
    end
  end
end
