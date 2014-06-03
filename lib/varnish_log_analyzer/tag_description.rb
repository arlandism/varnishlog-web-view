require 'yaml'

module VarnishLogAnalyzer
  class TagDescription
    def self.for(tag)
      first_match = config_file["tags"].select do |tag_info|
        info_for_tag?(tag_info, tag)
      end.first
      first_match["description"] if first_match
    end

    def self.info_for_tag?(tag_info, tag)
      tag_info["tag"] == tag
    end

    def self.config_file
      @@config_file ||= YAML.load_file("config/tag_descriptions.yml")
    end
  end
end
