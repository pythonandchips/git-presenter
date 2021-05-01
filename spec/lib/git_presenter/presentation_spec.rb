require "spec_helper"

class FakeShell
  attr_reader :ran_commands
  def initialize()
    @ran_commands = []
  end
  def run(command)
    @ran_commands << command
  end
end
describe GitPresenter::Presentation do
  let(:presentation){ {"slides" => [
                          {"slide" => {"commit" => "0"}},
                          {"slide" => {"commit" => "1"}},
                          {"slide" => {"commit" => "2"}}],
                       "branch" => "test"
                      }
                    }
  let(:fake_shell){ FakeShell.new }
  context "when displaying the command line" do
    it "should display the current position" do
      fake_shell.should_receive(:run).with("git rev-parse HEAD").and_return("0")
      presenter = GitPresenter::Presentation.new(presentation, fake_shell)
      expect(presenter.status_line).to eql "1/3 >"
    end
  end


  context "when calculating the position" do
    it "should return the index of the current commit" do
      expect(fake_shell).to receive(:run).with("git rev-parse HEAD").and_return("0")
      presenter = GitPresenter::Presentation.new(presentation, fake_shell)
      expect(presenter.position).to eql 0
    end
  end

  context "when processing a user command" do
    def given_command(command)
      presenter = GitPresenter::Presentation.new(presentation)
      presenter.command_for(command)
    end

    context "with bash command" do
      it { expect(given_command("!echo hello world")).to eql :command }
    end

    context "with next" do
      it { expect(given_command("next")).to eql :next }
    end

    context "with next" do
      it { expect(given_command("n")).to eql :next }
    end

    context "with back" do
      it { expect(given_command("back")).to eql :previous }
    end

    context "with b" do
      it { expect(given_command("b")).to eql :previous }
    end

    context "with start" do
      it { expect(given_command("start")).to eql :start }
    end

    context "with s" do
      it { expect(given_command("s")).to eql :start }
    end

    context "with end" do
      it { expect(given_command("end")).to eql :end }
    end

    context "with e" do
      it { expect(given_command("e")).to eql :end }
    end

    context "with list" do
      it { expect(given_command("list")).to eql :list }
    end

    context "with l" do
      it { expect(given_command("l")).to eql :list }
    end

    context "with any number" do
      it { expect(given_command("6")).to eql :commit}
    end

    context "with h" do
      it { expect(given_command("h")).to eql :help}
    end

    context "with help" do
      it { expect(given_command("help")).to eql :help}
    end

    context "with exit" do
      it { given_command("exit").should eql :exit}
      it 'checks out to the correct branch' do
        presenter = GitPresenter::Presentation.new(presentation)

        expect(presenter).to receive(:'`').with("git checkout -q #{presentation['branch']}")

        presenter.exit
      end
    end
  end
end
