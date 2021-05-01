require "spec_helper"

describe "initializing a presentation" do
  let(:presentation_dir){GitHelper.presentation_dir}

  before do
    @helper = GitHelper.new(presentation_dir)
  end

  context ".presentation file" do
    it "should be written to root directory" do
      @helper.initialise_presentation do
        expect(File.exists?(".presentation")).to be_truthy
      end
    end

    it "should have a slides node" do
      @helper.initialise_presentation do |commits, yaml|
        expect(yaml["slides"]).not_to be_nil
      end
    end

    it 'should have a branch note' do
      @helper.initialise_presentation do |commits, yaml|
        expect(yaml["branch"]).not_to be_nil
      end
    end

    it "should contain a line for each commit to the repository" do
      @helper.initialise_presentation do |commits, yaml|
        expect(yaml["slides"].length).not_to eql commits.length
      end
    end

    it "first line should contain the first commit number" do
      @helper.initialise_presentation({:delay => true}) do |commits, yaml|
        expect(yaml["slides"][0]["slide"]["commit"]).to eql commits.first.sha
      end
    end

    it "second line should contain the second commit number" do
      @helper.initialise_presentation({:delay => true}) do |commits, yaml|
        expect(yaml["slides"][1]["slide"]["commit"]).to eql commits[1].sha
      end
    end
  end
end
