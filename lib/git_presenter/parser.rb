module GitPresenter
  class Parser
    def initialize(presentation_dir)
      @presentation_dir = presentation_dir
    end

    def presentation
      presenter = nil
      yaml = YAML.parse(File.open(@presentation_dir + "/.presentation", "r")).to_ruby
      presenter = GitPresenter::Presentation.new(yaml)
      presenter.start
      presenter
    end

  end
end
