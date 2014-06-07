class GitPresenter::Presentation
  attr_reader :slides, :current_slide

  def initialize(presentation)
    @branch = presentation["branch"]
    @slides = presentation["slides"].map{|slide| GitPresenter::Slide.new(slide["slide"])}
    @current_slide = slides.first
  end

  def command_for(command)
    return :commit if command =~ /^[0-9]+$/
    return :command if command[0] == "!"
    {"n" => :next, "next" => :next,
     "back" => :previous, "b" => :previous,
     "start" => :start, "s" => :start,
     "end" => :end, "e" => :end,
     "list" => :list, "l" => :list,
     "help" => :help, "h" => :help,
     "exit" => :exit
    }[command]
  end

  def execute(user_command)
    command = command_for(user_command)
    if command.nil?
      puts "I canny understand ye, gonna try again"
      return
    end
    return commit(user_command.to_i) if command == :commit
    return bash_command(user_command) if command == :command
    self.send(command)
  end

  def bash_command(user_command)
    puts `#{user_command[1..-1]}`
  end

  def status_line
    "#{position+1}/#{total_slides} >"
  end

  def exit
    `git checkout -q #{@branch}`
    :exit
  end

  def position
    slides.index(@current_slide)
  end

  def total_slides
    @slides.length
  end

  def start
    @current_slide = slides.first
    @current_slide.execute
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
!(exclimation mark): execute following in terminal
exit: exit from the presentation
EOH
  end

  def end
    @current_slide = slides.last
    @current_slide.execute
  end

  def commit(slide_number)
    @current_slide = slides[slide_number - 1]
    @current_slide.execute
  end

  def next
    return if position.nil?
    @current_slide = slides[position + 1] || @current_slide
    @current_slide.execute
  end

  def previous
    return @current_slide if position == 0
    @current_slide = slides[position - 1]
    @current_slide.execute
  end

  def list
    @slides.map do |slide|
      if slide == @current_slide
        "*#{slide}"
      else
        slide
      end
    end.join("\n")
  end
end
