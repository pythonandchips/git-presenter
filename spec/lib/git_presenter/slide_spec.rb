require "spec_helper"

describe GitPresenter::Slide do
  context "when displaying as string" do
    it "should write out the commit id and the message" do
      slide = GitPresenter::Slide.new({"commit" => "commit_id","message" => "message"})
      slide.to_s.should eql "commit_id, message"
    end
  end
end
