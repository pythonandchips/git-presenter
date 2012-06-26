class GitPresenter::Controller
  CONFIG_FILE = ".presentation"

  def initialize(file_path)
    @presentation_dir = file_path
  end

  def initialise_presentation
    yaml = {"slides" => create_slides}.to_yaml
    File.open(presentation_file_location, "w") do |file|
      file.write(yaml)
    end
    puts "Presentation has been initalised"
    puts "run 'git-presenter start' to begin the presentation"
  end

  def start_presentation
    presenter = nil
    yaml = YAML.parse(File.open(@presentation_dir + "/.presentation", "r")).to_ruby
    presenter = GitPresenter::Presentation.new(yaml)
    puts presenter.start
    presenter
  end

  private

  def presentation_file_location
    File.join(@presentation_dir, CONFIG_FILE)
  end

  def create_slides
    repo = Grit::Repo.new(".", "master")
    repo.commits("master", false).reverse.map do |commit|
      {"slide" =>
        {"commit"  => commit.id,
         "message" => commit.message}
      }
    end
  end
end
