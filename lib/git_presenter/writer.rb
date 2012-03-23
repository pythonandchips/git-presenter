module GitPresenter
  class Writer
    CONFIG_FILE = ".presentation"

    def initialize(file_path)
      @presentation_dir = file_path
    end

    def output_presenatation_file
      yaml = {"slides" => create_slides}.to_yaml
      File.open(presentation_file_location, "w") do |file|
        file.write(yaml)
      end
    end

    private

    def presentation_file_location
      File.join(@presentation_dir, CONFIG_FILE)
    end

    def create_slides
      repo = Grit::Repo.new(".", "master")
      repo.commits.reverse.map do |commit|
        {"commit" => commit.id }
      end
    end
  end
end
