require 'git'
require 'yaml'
require 'readline'
require 'launchy'

class GitPresenter
  require_relative 'git_presenter/presentation'
  require_relative 'git_presenter/controller'
  require_relative 'git_presenter/slide'
  require_relative 'git_presenter/shell'

  def initialize(current_dir, interactive=true)
    @controller = Controller.new(current_dir)
    @interactive = interactive
  end

  def execute(command)
    if command == 'init'
      @controller.initialise_presentation
    elsif command == 'start'
      @presentation = @controller.start_presentation
      if @interactive
        enter_run_loop
      end
    elsif command == 'update'
      @controller.update_presentation
    else
      if @presentation.nil?
        @presentation = @controller.load_presentation
      end
      puts @presentation.execute(command)
    end
    @presentation
  end

  def current_slide
    @presentation.current_slide
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
