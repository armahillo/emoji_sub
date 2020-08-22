require 'yaml'
require 'pry'
require 'binding_of_caller' 

module EmojiYamlParsr
  EMOJI_SPEC_DIR = "lib/development/data/emoji_spec"
  CUSTOM_DEFINITIONS = "lib/development/data/custom_definitions.yml"

  def spec_to_yaml(spec_file)
    data = YAML.load(File.read(spec_file))
    output_hash = {}

    data.each do |description, data|
      data[:shortcodes].each do |shortcode|
        output_hash[shortcode[1...-1].to_sym] = data[:unicode].map { |u| u.split('+').last }
      end
    end

    output_hash
  end

  def load_all_yamls_from_spec(version = nil)
    version ||= spec_versions.last
    spec_definitions = Dir.glob("#{EMOJI_SPEC_DIR}/#{version}/*.yml").collect do |yml|
      filename = File.basename(yml, ".yml")
      [filename, spec_to_yaml(yml)]
    end.to_h
  end

  def spec_versions
    Dir.glob("#{EMOJI_SPEC_DIR}/*").map { |d| d.split("/").last }.sort_by(&:to_f)
  end

  def update_data(version = nil)
    target = File.join('data','emoji.yaml')
    data = load_all_yamls_from_spec(version)
    data["custom definitions"] = YAML.load(File.read(CUSTOM_DEFINITIONS))
    
    final_flat_hash = data.values.inject({}) do |memo,a| 
      memo.merge(a) 
    end
    File.open(target, 'w') do |f|
      f.write final_flat_hash.to_yaml
    end
  end

  module_function :spec_to_yaml, :update_data, :load_all_yamls_from_spec, :spec_versions
end


#yaml = YAML.load(File.read(EmojiYamlParsr::CUSTOM_DEFINITIONS))
#yaml.each do |shortcode,unicode|

#end


#EmojiYamlParsr.spec_to_yaml()
