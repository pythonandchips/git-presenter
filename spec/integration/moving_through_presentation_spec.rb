require "spec_helper"

describe "while giving presentation" do
  let(:presentation_dir){File.dirname(__FILE__) + "/../../presentation"}

  before do
    @helper = GitHelper.new(presentation_dir)
  end

  context "when moving to the next slide" do
    it "should move to the next commit" do
      @helper.start_presentation do |commits, presenter|
        presenter.execute("next")
        expect(@helper.head_position).to eql commits[1].sha
      end
    end

    it "should continue till the last commit" do
      @helper.start_presentation do |commits, presenter|
        presenter.execute("next")
        presenter.execute("next")
        expect(@helper.head_position).to eql commits[2].sha
      end
    end
  end

  context "when a change has been made during a slide" do
    it "should continue till the last commit" do
      @helper.start_presentation do |commits, presenter|
        presenter.execute("next")
        @helper.edit_file("inner commit")
        presenter.execute("next")
        expect(@helper.head_position).to eql commits[2].sha
      end
    end
  end

  context "when the presentation reaches the end" do
    it "should stay on the last commit" do
      @helper.start_presentation do |commits, presenter|
        presenter.execute("next")
        presenter.execute("next")
        presenter.execute("next")
        presenter.execute("next")
        expect(@helper.head_position).to eql commits[2].sha
      end
    end
  end

  context "when going back through the presentation" do
    it "should go back to a previous commit" do
      @helper.start_presentation do |commits, presenter|
        presenter.execute("next")
        presenter.execute("next")
        presenter.execute("back")
        expect(@helper.head_position).to eql commits[1].sha
      end
    end
  end

  context "when going back through the presentation and it reaches the begining" do
    it "should stay on the last commit" do
      @helper.start_presentation do |commits, presenter|
        presenter.execute("next")
        presenter.execute("next")
        presenter.execute("back")
        presenter.execute("back")
        presenter.execute("back")
        presenter.execute("back")
        expect(@helper.head_position).to eql commits[0].sha
      end
    end
  end

  context "when going back to the start of the presention" do
    it "should move to the first commit" do
      @helper.start_presentation do |commits, presenter|
        presenter.execute("next")
        presenter.execute("next")
        presenter.execute("start")
        expect(@helper.head_position).to eql commits[0].sha
      end
    end
  end

  context "when going to the end of the presentation" do
    it "should move the last commit" do
      @helper.start_presentation do |commits, presenter|
        presenter.execute("end")
        expect(@helper.head_position).to eql commits.last.sha
      end
    end
  end

  context "when going to a specific slide" do
    it "should checkout the specific commit" do
      @helper.start_presentation do |commits, presenter|
        presenter.execute("2")
        expect(@helper.head_position).to eql commits[1].sha
      end
    end
  end

  context "list presentation" do
    it "should print a list of commits" do
      @helper.start_presentation do |commits, presenter|
        expected_output = (["*#{commits.first.sha[0..9]}, #{commits.first.message}"] + commits[1..-1].map{|commit| "#{commit.sha[0..9]}, #{commit.message}"}).join("\n")
        presentation = presenter.execute("list")
        expect(presentation).to eql expected_output
      end
    end
  end

  context "when asking for help" do
    it "should print a list of command and there usage" do
      @helper.start_presentation do |commits, presenter|
      help_text = <<-EOH
Git Presenter Reference

next/n: move to next slide
back/b: move back a slide
end/e:  move to end of presentation
start/s: move to start of presentation
list/l : list slides in presentation
help/h: display this message
!(exclimation mark): execute following in terminal
exit: exit from the presentation
EOH
        message = presenter.execute("help")
        expect(message).to eql help_text
      end
    end
  end

  context "when the slide contains a run command only" do
    it "should execute the command" do
      command_line_helper = CommandLineHelper.capture_output
      @helper.start_presentation([:run => "echo hello world"]) do |commits, presenter|
        presenter.execute("next")
        presenter.execute("next")
        expect(presenter.execute("next").strip).to eql "hello world"
      end
    end
  end

  context "when the slide has a commit and a run command" do
    it "should checkout the commit and then execute the command" do
      command_line_helper = CommandLineHelper.capture_output
      @helper.start_presentation([:run => "echo hello world",:on_slide => 2]) do |commits, presenter|
        presenter.execute("next")
        expect(presenter.execute("next")).to eql "#{commits[2].message}\nhello world\n"
      end
    end
  end

  context "when executing a command" do
    it "should run the command in the shell" do
      command_line_helper = CommandLineHelper.capture_output
      @helper.start_presentation do |commits, presenter|
        presenter.execute("!echo hello world")
        expect(command_line_helper.command_output.strip).to end_with "hello world"
      end
    end
  end

  context "when opening an application" do
    it "should open the with launchy" do
      command_line_helper = CommandLineHelper.capture_output
      @helper.start_presentation([:launch => 'readme', :on_slide => 2]) do |commits, presenter|
        expect(Launchy).to receive(:open).with('readme').once
        presenter.execute("next")
        presenter.execute("next")
      end
    end
  end

  context "when exiting a presentation" do
    it "should set the repo back to the master branch" do
      @helper.start_presentation do |commits, presenter|
        presenter.execute("next")
        presenter.execute("exit")
        expect(@helper.current_branch).not_to be_nil
        expect(@helper.current_branch).to eql "master"
      end
    end
  end

  context "when running in command mode" do
    it "should set the current slide to commit" do
      @helper.start_presentation([], 1) do |commits, presenter|
        presenter.execute("list")
        expect(presenter.current_slide.commit).to eql commits[1].sha
      end
    end
  end
end
