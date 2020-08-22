require 'yaml'

EMOJI_SPEC_DIR = "lib/development/data/emoji_spec"

def spec_to_yaml(spec_file)
  data = YAML.load(File.read(spec_file))
  output_hash = {}

  data.each do |description, data|
    data[:shortcodes].each do |shortcode|
      output_hash[shortcode] = data[:unicode].map { |u| u.split('+').last }
    end
  end

  output_hash
end

require 'pry'
require 'binding_of_caller'

def load_all_yamls_from_spec(version = nil)
  version ||= spec_versions.last
  Dir.glob("#{EMOJI_SPEC_DIR}/#{version}/*.yml").collect do |yml|
    filename = File.basename(yml, ".yml")
    [filename, spec_to_yaml(yml)]
  end.to_h
end

def spec_versions
  Dir.glob("#{EMOJI_SPEC_DIR}/*").map { |d| d.split("/").last }.sort_by(&:to_f)
end

def save_to_yaml(version = nil)
  target = File.join('data','emoji.yaml')
  data = load_all_yamls_from_spec(version)
  File.open(target, 'w') do |f|
    f.write data.to_yaml
  end
end

#pp load_all_yamls_from_spec('14.0')
#p spec_to_yaml('lib/development/data/emoji_spec/14.0/activity.yml')
save_to_yaml