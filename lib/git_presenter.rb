require "grit"

class GitPresenter
  def initialize(commits)
    @commits = commits
    @current_commit = commits.first
  end

  def self.initialise_presentation dir
    File.open(dir + "/.presentation", "w") do |file|
      repo = Grit::Repo.init(".")
      repo.commits.each do |commit|
        file.write(commit.id + "\n")
      end
    end
  end

  def self.start_presentation dir
    presenter = nil
    File.open(dir + "/.presentation", "r") do |file|
      commits = file.lines.map{|line| line.strip}
      presenter = GitPresenter.new(commits)
      presenter.checkout_current
      presenter.run
    end
  end

  def run
    while(continue)
      puts "command>>"
      command = gets
      process_command(command)
      continue = false
    end
  end

  def process_command(command)
    if command == "n"
      @presenter.next
    end
  end

  def next
    position = commits.index(commit_id)
    @current_commit = commits[position + 1]
    checkout_current
  end

  def previous
    position = commits.index(commit_id)
    @current_commit = commits[position - 1]
    checkout_current
  end

  def checkout_current
    `git checkout #{current_commit}`
  end

end
