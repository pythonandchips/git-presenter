require "spec_helper"

describe "initializing a presentation" do
  let(:presentation_dir){File.dirname(__FILE__) + "/../../presentation"}

  before do
    @helper = GitHelper.new(presentation_dir)
  end

  context ".presentation file" do
    it "should be written to root directory" do
      @helper.initialise_presentation do
        File.exists?(".presentation").should be_true
      end
    end

    it "should contain a line for each commit to the repository" do
      @helper.initialise_presentation do |commits, file|
        file.lines.to_a.length.should eql commits.length
      end
    end

    it "first line should contain the first commit number" do
      @helper.initialise_presentation(true) do |commits, file|
        file.lines.first.should include commits.first.id
      end
    end

    it "second line should contain the second commit number" do
      @helper.initialise_presentation(true) do |commits, file|
        file.lines.to_a[1].should include commits[1].id
      end
    end
  end
end
