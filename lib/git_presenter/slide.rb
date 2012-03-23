module GitPresenter
  class Slide
    attr_reader :commit

    def initialize(slide)
      @commit = slide["commit"]
    end

  end
end
