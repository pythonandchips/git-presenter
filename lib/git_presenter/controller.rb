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
    yaml = YAML.parse(File.open(@presentation_dir + "/.presentation", "r")).to_ruby
    presenter = GitPresenter::Presentation.new(yaml)
    puts presenter.start
    presenter
  end

  def update_presentation
    yaml = YAML.parse(File.open(@presentation_dir + "/.presentation", "r")).to_ruby
    slides = create_slides(yaml['slides'].last["slide"]["commit"])
    last_commit = yaml["slides"].last
    yaml["slides"] = yaml["slides"] + slides
    yaml["slides"].uniq!
    write_file(yaml.to_yaml)
  end

  private

  def write_file(yaml)
    File.open(presentation_file_location, "w") do |file|
      file.write(yaml)
    end
  end

  def presentation_file_location
    File.join(@presentation_dir, CONFIG_FILE)
  end

  def create_slides(last_commit=nil)
    repo = Grit::Repo.new(".", "master")
    commits = repo.commits("master", false).reverse
    commits = commits.drop_while{|commit| commit.id != last_commit}[1..-1] unless last_commit.nil?
    commits.map do |commit|
      {"slide" =>
        {"commit"  => commit.id,
         "message" => commit.message}
      }
    end
  end
end
