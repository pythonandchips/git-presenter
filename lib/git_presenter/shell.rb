class GitPresenter::Shell
  def run(command)
    `#{command}`.strip
  end
end
