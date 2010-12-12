module Archaic
  # The configuration object that deals with loading the plugin configuration from a yaml file or accepting the options
  # one at a time through a block.
  class ArchaicConfig
    def initialize()
      @options = {}
    end

    # read the configuration values into the object from a YML file.
    def load_yaml(yaml_file)
      @options = YAML.load_file(yaml_file)
    end

    # allow options to be accessed as if this object is a Hash.
    def [](key_name)
      return @options[key_name.to_s()]
    end

    # allow options to be set as if this object is a Hash.
    def []=(key_name, value)
      @options[key_name.to_s()] = value
    end

    # allow options to be read and set using method calls.  This capability is primarily for
    # allowing the plugin configuration to be defined through a block passed to the config() function
    # from an initializer or similar file.
    def method_missing(key_name, *args)
      key_name = key_name.to_s()
      if key_name =~ /=$/ then
        @options[key_name.chop()] = args[0]
      else
        return @options[key_name]
      end
    end
  end

  if (!defined?(CONFIG))
    CONFIG = ArchaicConfig.new()
  end

  def self.config(yaml_file = nil, &block)    
    CONFIG.load_yaml(yaml_file) if !yaml_file.nil?
    yield CONFIG if block
  end
end