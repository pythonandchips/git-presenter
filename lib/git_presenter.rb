require "grit"
require "yaml"
require "readline"

class GitPresenter
  require "git_presenter/presentation"
  require "git_presenter/controller"
  require "git_presenter/slide"

  def initialize(current_dir, interactive=true)
    @controller = Controller.new(current_dir)
    @interactive = interactive
  end

  def execute(command)
    if command == "init"
      @controller.initialise_presentation
    elsif command == "start"
      @presentation = @controller.start_presentation
      if @interactive
        enter_run_loop
      end
    elsif command == "update"
      @controller.update_presentation
    else
      puts @presentation.execute(command)
    end
    @presentation
  end

  private

  def enter_run_loop
    while command = Readline.readline(@presentation.status_line, true)
      result = @presentation.execute(command)
      exit if result == :exit
      puts result
    end
  end
end
