class GitHelper
  PRESENTATION_DIR = File.expand_path(File.dirname(__FILE__) + '/../../presentation')

  def self.presentation_dir
    PRESENTATION_DIR
  end

  def initialize(presentation_dir=GitHelper::PRESENTATION_DIR)
    @presentation_dir = presentation_dir
  end

  def initialise_test_repo(presentation_dir, delay, no_of_commits)
    clean_up_repo(presentation_dir)
    @code_file = "a_file.rb"
    commits = []
    content = ('a'..'z').to_a
    Dir.mkdir(presentation_dir)
    Dir.chdir(presentation_dir) do
      @git_repo = Grit::Repo.init(".")
      (1..no_of_commits).each do |n|
        edit_file_and_commit("commit number #{n}", content[n])
        commits << @git_repo.commits[0]
        #need to make it sleep for a second.
        #git is not accurate enough with the speed of the test
        #to sort correctly only when required
        sleep 1 if delay
      end
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
    @git_repo.commits[0]
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

  def initialise_presentation(params={})
    settings = {:no_of_commits => 3, :delay => false}.merge(params)
    commits = initialise_test_repo(@presentation_dir, settings[:delay], settings[:no_of_commits])
    Dir.chdir(@presentation_dir) do
      presentation = GitPresenter.new(@presentation_dir, false)
      git_presentation = presentation.execute("init")
      yaml = YAML::parse(File.open(File.join(@presentation_dir, ".presentation"))).to_ruby
      yield(commits, yaml) if block_given?
    end
    commits
  end

  def start_presentation(command="", add_command_to_commit=nil)
    commits = initialise_presentation({:delay => true})
    Dir.chdir(@presentation_dir) do
      add_command(command, add_command_to_commit) unless command.empty?
      presenter = GitPresenter.new('.', false)
      presenter = presenter.execute('start')
      yield(commits, presenter) if block_given?
    end
  end

  def update_presentation
    Dir.chdir(@presentation_dir) do
      presentation = GitPresenter.new(@presentation_dir, false)
      presentation.execute("update")
      yaml = YAML::parse(File.open(File.join(@presentation_dir, ".presentation"))).to_ruby
      yield(yaml) if block_given?
    end
  end

  def remove_from_presentation_at(index)
    removed_commit = nil
    Dir.chdir(@presentation_dir) do
      yaml = YAML.parse(File.open(@presentation_dir + "/.presentation", "r")).to_ruby
      removed_commit = yaml['slides'].delete_at(index)
      File.open(File.open(File.join(@presentation_dir, ".presentation")), "w") do |file|
        file.write(yaml.to_yaml)
      end
    end
    removed_commit
  end

  def add_command(command, add_command_to_commit=nil)
    Dir.chdir(PRESENTATION_DIR) do
      presentation = YAML.parse(File.open(".presentation")).to_ruby
      if !add_command_to_commit.nil?
        presentation["slides"][add_command_to_commit]["slide"]["run"] = command
      else
        presentation["slides"] << {"slide" => {"run" => command}}
      end
      File.open(".presentation", "w") do |file|
        file.write(presentation.to_yaml)
      end
    end
  end

  def current_branch
    Dir.chdir(PRESENTATION_DIR) do
      repo = Grit::Repo.init('.')
      repo.head
    end
  end

end
