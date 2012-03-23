require "grit"

module GitPresenter
  require "git_presenter/presentation"

  def self.initialise_presentation dir
    File.open(dir + "/.presentation", "w") do |file|
      repo = Grit::Repo.new(".", "master")
      repo.commits.reverse.each do |commit|
        file.write("#{commit.id}\n")
      end
    end
  end

  def self.start_presentation dir
    presenter = nil
    File.open(dir + "/.presentation", "r") do |file|
      commits = file.lines.map{|line| line.strip}
      presenter = GitPresenter::Presentation.new(commits)
      presenter.start
    end
    presenter
  end
end
