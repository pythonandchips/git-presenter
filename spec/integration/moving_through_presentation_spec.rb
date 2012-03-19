require "spec_helper"

describe "while giving presentation" do
  let(:presentation_dir){File.dirname(__FILE__) + "/../../presentation"}

  context "when moving to the next slide" do
    it "should move to the next commit" do
      start_presentation do |commits, presenter|
        presenter.next
        head_position.should eql commits[1].id
      end
    end

    it "should continue till the last commit" do
      start_presentation do |commits, presenter|
        presenter.next
        presenter.next
        head_position.should eql commits[2].id
      end
    end
  end

  context "when the presentation reaches the end" do
    it "should stay on the last commit" do
      start_presentation do |commits, presenter|
        presenter.next
        presenter.next
        presenter.next
        presenter.next
        head_position.should eql commits[2].id
      end
    end
  end

  context "when going back through the presentation" do
    it "should o go back to a previous commit" do
      start_presentation do |commits, presenter|
        presenter.next
        presenter.next
        presenter.previous
        head_position.should eql commits[1].id
      end
    end
  end

  context "when going back to the start of the presention" do
    it "should move to the first commit" do
      start_presentation do |commits, presenter|
        presenter.next
        presenter.next
        presenter.start
        head_position.should eql commits[0].id
      end
    end
  end

  context "when going to the end of the presentation" do
    it "should move the last commit" do
      start_presentation do |commits, presenter|
        presenter.finish
        head_position.should eql commits.last.id
      end
    end
  end

  context "when going to a specific slide" do
    it "should checkout the specific commit" do
      start_presentation do |commits, presenter|
        presenter.commit(2)
        head_position.should eql commits[1].id
      end
    end
  end

  context "list presentation" do
    it "should print a list of commits" do
      start_presentation do |commits, presenter|
        commits[0] = "*#{commits[0]}"
        expected_output = commits.join("\n")
        presentation = presenter.list
        presentation.should eql expected_output
      end
    end
  end
end
