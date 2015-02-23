require "reversi/version"
require "reversi/player"
require "reversi/player/base_player"
require "reversi/board"
require "reversi/configuration"
require "reversi/game"

module Reversi
  extend Configuration

  class << self
    def new(options = {})
      Reversi::Game.new(options)
    end
  end
end
