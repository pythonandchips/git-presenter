require "spec_helper"

describe "when displaying the command line" do
  it "should display the current position" do
    presenter = GitPresenter.new(["0", "1","2"])
    presenter.status_line.should eql "1/3 >"
  end
end
