require "spec_helper"

describe GitPresenter::Presentation do
  let(:presentation){ {"slides" => [
                          {"commit" => "0"},
                          {"commit" => "1"},
                          {"commit" => "2"}]
                      }
                    }
  context "when displaying the command line" do
    it "should display the current position" do
      presenter = GitPresenter::Presentation.new(presentation)
      presenter.status_line.should eql "1/3 >"
    end
  end


  context "when calculating the position" do
    it "should return the index of the current commit" do
      presenter = GitPresenter::Presentation.new(presentation)
      presenter.position.should eql 0
    end
  end

  context "when processing a user command" do
    def given_command(command)
      presenter = GitPresenter::Presentation.new(presentation)
      presenter.command_for(command)
    end

    context "with bash command" do
      it { given_command("!echo hello world").should eql :command }
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
end
