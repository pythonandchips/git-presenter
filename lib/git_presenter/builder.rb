module GitPresenter
  class Builder
    def initialize(file_path)
      @presentation_dir = file_path
    end

    def presentation
      yaml = {"slides" => create_slides}.to_yaml
    end

    private

    def create_slides
      repo = Grit::Repo.new(".", "master")
      repo.commits.reverse.map do |commit|
        {"slide" =>
         {"commit"  => commit.id,
          "message" => commit.message}
        }
      end
    end
  end
end
