module Reversi
  module Configuration

    OPTIONS_KEYS = [
      :player_b,
      :player_w,
      :disk_b,
      :disk_w,
      :disk_color_b,
      :disk_color_w,
      :initial_position,
      :progress,
      :stack_limit
    ].freeze

    DEFAULTS = {
      :player_b => Reversi::Player::RandomAI,
      :player_w => Reversi::Player::RandomAI,
      :disk_b => 'b',
      :disk_w => 'w',
      :disk_color_b => 0,
      :disk_color_w => 0,
      :initial_position => {:black => [[4, 5], [5, 4]], :white => [[4, 4], [5, 5]]},
      :progress => false,
      :stack_limit => 3
    }

    attr_accessor *OPTIONS_KEYS

    # This method is used for setting configuration options.
    def configure
      yield self
    end

    # Create a hash of options.
    def options
      Hash[*OPTIONS_KEYS.map{|key| [key, send(key)]}.flatten]
    end

    # Reset all options to their default values.
    def reset
      DEFAULTS.each do |option, default|
        self.send("#{option}=".to_sym, default)
      end
    end

    # Set default value for the option that is still not set.
    def set_defaults
      DEFAULTS.each do |option, default|
        default.class == String ?
        eval("self.#{option} ||= \'#{default}\'") :
        eval("self.#{option} ||= #{default}")
      end
    end
  end
end
