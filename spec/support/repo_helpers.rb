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
