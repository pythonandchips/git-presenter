class GitHelper
  PRESENTATION_DIR = File.expand_path(File.dirname(__FILE__) + '/../../presentation')

  def self.presentation_dir
    PRESENTATION_DIR
  end

  def initialize(presentation_dir)
    @presentation_dir = presentation_dir
  end

  def initialise_test_repo(presentation_dir, delay)
    clean_up_repo(presentation_dir)
    @code_file = "a_file.rb"
    commits = []
    Dir.mkdir(presentation_dir)
    Dir.chdir(presentation_dir) do
      @git_repo = Grit::Repo.init(".")
      edit_file_and_commit("initial commit", "a")
      commits << @git_repo.commits[0]
      #need to make it sleep for a second.
      #git is not accurate enough with the speed of the test
      #to sort correctly
      sleep 1 if delay
      edit_file_and_commit("second commit", "b")
      commits << @git_repo.commits[0]
      sleep 1 if delay
      edit_file_and_commit("third commit", "c")
      commits << @git_repo.commits[0]
    end
    commits
  end

  def edit_file(content)
    File.open(@code_file, "a") do |file|
      file.write(content)
    end
  end

  def edit_file_and_commit(commit_message, content)
    edit_file(content)
    @git_repo.add(".")
    @git_repo.commit_all(commit_message)
  end

  def setup_presentation_file(commits)
    File.open(".presentation", "w") do |file|
      @commits.each do |commit|
        file.write(commit.id + "\n")
      end
    end
  end

  def clean_up_repo(dir)
    `rm -fr #{dir}`
  end

  def head_position
    File.open(@presentation_dir + '/.git/HEAD').lines.first.strip
  end

  def initialise_presentation(delay=false)
    commits = initialise_test_repo(@presentation_dir, delay)
    Dir.chdir(@presentation_dir) do
      git_presentation = GitPresenter.initialise_presentation(".")
      yaml = YAML::parse(File.open(File.join(@presentation_dir, ".presentation"))).to_ruby
      yield(commits, yaml) if block_given?
    end
    commits
  end

  def start_presentation
    commits = initialise_presentation(true)
    Dir.chdir(@presentation_dir) do
      presenter = GitPresenter.start_presentation(".")
      yield(commits, presenter) if block_given?
    end
  end
end
