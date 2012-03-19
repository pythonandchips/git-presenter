def initialise_test_repo(presentation_dir)
  clean_up_repo(presentation_dir)
  code_file = "a_file.rb"
  commits = []
  Dir.mkdir(presentation_dir)
  Dir.chdir(presentation_dir) do
    git_repo = Grit::Repo.init(".")
    File.open(code_file, "w") do |file|
      file.write("a")
    end
    git_repo.add(".")
    git_repo.commit_all("initial commit")
    commits << git_repo.commits[0]
    File.open(code_file, "a") do |file|
      file.write("b")
    end
    git_repo.commit_all("second commit")
    commits << git_repo.commits[1]
    File.open(code_file, "a") do |file|
      file.write("c")
    end
    git_repo.commit_all("third commit")
    commits << git_repo.commits[2]
  end
  commits
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
  File.open(presentation_dir + '/.git/HEAD').lines.first.strip
end

def initialise_presentation
  commits = initialise_test_repo(presentation_dir)
  Dir.chdir(presentation_dir) do
    git_presentation = GitPresenter.initialise_presentation(".")
    file = File.open(File.join(presentation_dir, ".presentation"))
    yield(commits, file) if block_given?
  end
  commits
end

def start_presentation
  commits = initialise_presentation
  Dir.chdir(presentation_dir) do
    presenter = GitPresenter.start_presentation(".")
    yield(commits, presenter) if block_given?
  end
end
