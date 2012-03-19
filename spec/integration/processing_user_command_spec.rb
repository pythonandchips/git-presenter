require "spec_helper"

describe "when receiving a user command" do

  def given_command(command)
    presenter = GitPresenter.new([])
    presenter.command_for(command)
  end

  context "with next" do
    it { given_command("next").should eql :next }
  end

  context "with next" do
    it { given_command("n").should eql :next }
  end

  context "with back" do
    it { given_command("back").should eql :previous }
  end

  context "with b" do
    it { given_command("b").should eql :previous }
  end

  context "with start" do
    it { given_command("start").should eql :start }
  end

  context "with s" do
    it { given_command("s").should eql :start }
  end

  context "with end" do
    it { given_command("end").should eql :end }
  end

  context "with e" do
    it { given_command("e").should eql :end }
  end

  context "with list" do
    it { given_command("list").should eql :list }
  end

  context "with l" do
    it { given_command("l").should eql :list }
  end

  context "with any number" do
    it { given_command("6").should eql :commit}
  end

  context "with h" do
    it { given_command("h").should eql :help}
  end

  context "with help" do
    it { given_command("help").should eql :help}
  end
end
