require "spec_helper"

describe GitPresenter::Slide do
  context "when displaying as string" do
    it "should write out the commit id and the message" do
      slide = GitPresenter::Slide.new({"commit" => "012345678901234567890","message" => "message"})
      slide.to_s.should eql "0123456789, message"
    end
  end
end
