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

    attr_accessor *OPTIONS_KEYS

    def configure
      yield self
    end

    def options
      Hash[*OPTIONS_KEYS.map{|key| [key, send(key)]}.flatten]
    end

    def set_defaults
      self.player_b         ||= Reversi::Player::RandomAI
      self.player_w         ||= Reversi::Player::RandomAI
      self.disk_b           ||= "b"
      self.disk_w           ||= "w"
      self.disk_color_b     ||= 0
      self.disk_color_w     ||= 0
      self.initial_position ||= {:black => [[:d, 5], [:e, 4]],
                                 :white => [[:d, 4], [:e, 5]]}
      self.progress         ||= false
      self.stack_limit      ||= 3
    end
  end
end
