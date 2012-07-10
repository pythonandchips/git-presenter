require "spec_helper"

describe GitPresenter::Slide do
  context "when displaying as string" do
    it "should write out the commit id and the message" do
      slide = GitPresenter::Slide.new({"commit" => "012345678901234567890","message" => "message"})
      slide.to_s.should eql "0123456789, message"
    end

    it "should not blow up if no command exists" do
      slide = GitPresenter::Slide.new({"run" => "echo hello world"})
      slide.to_s.should eql "run: echo hello world"
    end
  end

  describe "execute" do
    context "when slide has only a run command" do
      it "should run that command" do
        command_line_helper = CommandLineHelper.capture_output
        slide = GitPresenter::Slide.new({"run" => "echo hello world"})
        slide.execute.strip.should eql "hello world"
      end
    end

    context "when slide contains both commit and run message" do
      it "should checkout the code then run the command" do
        command_line_helper = CommandLineHelper.capture_output
        slide = GitPresenter::Slide.new({"commit" => "number", "message" => "checkout", "run" => "echo hello world"})
        slide.stub(:checkout).and_return("checkout\n")
        slide.execute.should eql "checkout\nhello world\n"
      end
    end

    context "when slide contains a launch command" do
      it "should launch the application for the file type" do
        command_line_helper = CommandLineHelper.capture_output
        Launchy.should_receive(:open).with("readme").once
        slide = GitPresenter::Slide.new({"launch" => "readme"})
        slide.execute
      end

      it "should not try and launch if no launch supplied" do
        command_line_helper = CommandLineHelper.capture_output
        Launchy.should_receive(:open).with("readme").never
        slide = GitPresenter::Slide.new({"commit" => "number", "message" => "checkout", "run" => "echo hello world"})
        slide.stub(:checkout).and_return("checkout\n")
        slide.execute.should eql "checkout\nhello world\n"
      end
    end

    context "when slide contains only a commit" do
      it "should checkout the code then run the command" do
        command_line_helper = CommandLineHelper.capture_output
        slide = GitPresenter::Slide.new({"commit" => "number", "message" => "checkout"})
        slide.stub(:checkout).and_return("checkout\n")
        slide.execute.should eql "checkout\n"
      end
    end
  end
end
