require "reversi/reversi"
require "reversi/version"
require "reversi/player"
require "reversi/player/base_player"
require "reversi/board"
require "reversi/configuration"
require "reversi/game"

module Reversi
  extend Configuration

  class MoveError < StandardError; end
end
