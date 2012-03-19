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

  def commits
    @commits
  end

  def self.start_presentation dir
    presenter = nil
    File.open(dir + "/.presentation", "r") do |file|
      commits = file.lines.map{|line| line.strip}
      presenter = GitPresenter.new(commits)
      presenter.start
    end
    presenter
  end

  def execute(command)

  end

  def start
    @current_commit = commits.first
    checkout_current
  end

  def finish
    @current_commit = commits.last
    checkout_current
  end

  def commit(slide_number)
    @current_commit = commits[slide_number - 1]
    checkout_current
  end

  def next
    position = commits.index(@current_commit)
    return if position.nil?
    @current_commit = commits[position + 1]
    checkout_current
  end

  def previous
    position = commits.index(@current_commit)
    @current_commit = commits[position - 1]
    checkout_current
  end

  def list
    commits = @commits.dup
    position = commits.index(@current_commit)
    commits[position] = "*#{commits[position]}"
    commits.join("\n")
  end

  def checkout_current
    `git checkout #{@current_commit}`
  end
end
