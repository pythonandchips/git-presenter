class CommandLineHelper

  def self.capture_output
    command_helper = CommandLineHelper.new
    command_helper.set_output_to_string_io
    command_helper
  end

  def set_output_to_string_io
    @command_output = StringIO.new
    $stdout = @command_output
  end

  def command_output
    @command_output.string
  end

end
