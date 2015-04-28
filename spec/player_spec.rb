require 'spec_helper'

class ValidPlayer < Reversi::Player::BasePlayer
  def move(board)
    moves = next_moves
    put_disk(*moves.sample) unless moves.empty?
  end
end

class InvalidPlayer1 < Reversi::Player::BasePlayer
  def move(board)
    put_disk(:a, 1)
  end
end

class InvalidPlayer2 < Reversi::Player::BasePlayer
  def move(board)
    put_disk(:d, 4)
  end
end

class InvalidPlayer3 < Reversi::Player::BasePlayer
  def move(board)
    put_disk(:a, 1)
    put_disk(:a, 2)
  end
end

describe Reversi::Player do
  let(:game) { Reversi::Game.new }

  describe ValidPlayer do
    it "exit successfully" do
      Reversi.configure do |config|
        config.player_b = ValidPlayer
      end
      expect(game.start).to eq nil
    end
  end

  describe InvalidPlayer1 do
    it "should raise Reversi::MoveError" do
      Reversi.configure do |config|
        config.player_b = InvalidPlayer1
      end
      message = "A player must flip at least one or more opponent's disks."
      expect{ game.start }.to raise_error(Reversi::MoveError, message)
    end
  end

  describe InvalidPlayer2 do
    it "should raise Reversi::MoveError" do
      Reversi.configure do |config|
        config.player_b = InvalidPlayer2
      end
      message = "When a player can't make a valid move, you must not place a new disk."
      expect{ game.start }.to raise_error(Reversi::MoveError, message)
    end
  end

  describe InvalidPlayer3 do
    it "should raise Reversi::MoveError" do
      Reversi.configure do |config|
        config.player_b = InvalidPlayer3
      end
      message = "A player must place a new disk on the board."
      expect{ game.start }.to raise_error(Reversi::MoveError, message)
    end
  end
end
