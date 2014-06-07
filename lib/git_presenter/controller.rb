class GitPresenter::Controller
  CONFIG_FILE = ".presentation"

  def initialize(file_path)
    @presentation_dir = file_path
  end

  def initialise_presentation
    yaml = {"slides" => create_slides, "branch" => current_branch}.to_yaml
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
    yaml["slides"] = yaml["slides"] + slides
    yaml["slides"].uniq!
    write_file(yaml.to_yaml)
    puts "Your presentation has been updated"
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
    repo = Git.open(".")
    commits = repo.log.to_a.reverse
    commits = commits.drop_while{|commit| commit.sha != last_commit}[1..-1] unless last_commit.nil?
    commits.map do |commit|
      {"slide" =>
         {"commit"  => commit.sha,
         "message" => commit.message}
      }
    end
  end

  def current_branch
    `git rev-parse --abbrev-ref HEAD`.strip
  end
end
