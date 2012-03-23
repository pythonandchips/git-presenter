module GitPresenter
  class Parser
    def initialize(presentation_dir)
      @presentation_dir = presentation_dir
    end

    def presentation
      presenter = nil
      yaml = YAML.parse(File.open(@presentation_dir + "/.presentation", "r")).to_ruby
      commits = yaml["slides"].map{|slide| slide["commit"]}
      presenter = GitPresenter::Presentation.new(commits)
      presenter.start
      presenter
    end

  end
end
