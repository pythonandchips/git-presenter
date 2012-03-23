module GitPresenter
  class Slide
    attr_reader :commit, :message

    def initialize(slide)
      @commit  = slide["commit"]
      @message = slide["message"]
    end

    def to_s
      "#{@commit[0..9]}, #{@message}"
    end

  end
end
