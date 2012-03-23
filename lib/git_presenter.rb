require "grit"
require "yaml"

module GitPresenter
  require "git_presenter/presentation"
  require "git_presenter/writer"
  require "git_presenter/parser"
  require "git_presenter/slide"

  def self.initialise_presentation dir
    builder = Writer.new(dir)
    builder.output_presenatation_file
  end

  def self.start_presentation dir
    parser = Parser.new(dir)
    parser.presentation
  end
end
