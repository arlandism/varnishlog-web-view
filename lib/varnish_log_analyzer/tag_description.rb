require 'yaml'

module VarnishLogAnalyzer
  class TagDescription
    UNAVAILABLE_MESSAGE = "No description available"
    def self.for(tag)
      first_match = config_file["tags"].select do |tag_info|
        info_for_tag?(tag_info, tag)
      end.first
      if first_match
        first_match["description"]
      else
        UNAVAILABLE_MESSAGE
      end
    end

    def self.info_for_tag?(tag_info, tag)
      tag_info["tag"] == tag
    end

    def self.config_file
      @@config_file ||= YAML.load_file("config/tag_descriptions.yml")
    end
  end
end
