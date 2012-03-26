module GitPresenter
  class Slide
    attr_reader :commit, :message, :run

    def initialize(slide)
      @commit  = slide["commit"]
      @message = slide["message"]
      @run = slide["run"]
    end

    def execute
      output = ""
      output << checkout unless @commit.nil?
      output << `#{run}` unless @run.nil?
      output
    end

    def to_s
      return "#{@commit[0..9]}, #{@message}" unless @commit.nil?
      "run: #{@run}"
    end

    private

    def checkout
      `git checkout -q . `
      `git checkout -q #{@commit}`
      @message + "\n"
    end
  end
end
