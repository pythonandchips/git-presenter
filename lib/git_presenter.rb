require "grit"

module GitPresenter
  def self.initialise_presentation dir
    File.open(dir + "/.presentation", "w") do |file|
      repo = Grit::Repo.init(".")
      repo.commits.each do |commit|
        file.write(commit.id + "\n")
      end
    end
  end

  def self.start_presentation dir
    File.open(dir + "/.presentation", "r") do |file|
      commits = file.lines.map{|line| line.strip}
      first_commit_id = commits.first
      `git checkout #{first_commit_id}`
    end
  end
end
