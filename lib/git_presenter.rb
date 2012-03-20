require "grit"

class GitPresenter
  def initialize(commits)
    @commits = commits
    @current_commit = commits.first
  end

  def self.initialise_presentation dir
    File.open(dir + "/.presentation", "w") do |file|
      repo = Grit::Repo.new(".", "master")
      repo.commits.each do |commit|
        file.write("#{commit.id}\n")
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

  def command_for(command)
    return :commit if command =~ /^[0-9]+$/
    {"n" => :next, "next" => :next,
     "back" => :previous, "b" => :previous,
     "start" => :start, "s" => :start,
     "end" => :end, "e" => :end,
     "list" => :list, "l" => :list,
     "help" => :help, "h" => :help
    }[command]
  end

  def execute(user_command)
    command = command_for(user_command)
    return commit(user_command.to_i) if command == :commit
    self.send(command)
  end

  def status_line
    "#{position+1}/#{total_slides} >"
  end

  def position
    commits.index(@current_commit)
  end

  def total_slides
    @commits.length
  end


  def start
    @current_commit = commits.first
    checkout_current
  end

  def help
<<-EOH
Git Presenter Reference

next/n: move to next slide
back/b: move back a slide
end/e:  move to end of presentation
start/s: move to start of presentation
list/l : list slides in presentation
help/h: display this message
EOH
  end

  def end
    @current_commit = commits.last
    checkout_current
  end

  def commit(slide_number)
    @current_commit = commits[slide_number - 1]
    checkout_current
  end

  def next
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
