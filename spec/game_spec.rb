require 'spec_helper'

describe Reversi::Game do
  describe "next moves" do
    before do
      @game = Reversi::Game.new
      @game.board.put_disk(6, 3, Reversi::Board::DISK[:black])
      @game.board.put_disk(6, 5, Reversi::Board::DISK[:black])
      @game.board.put_disk(6, 6, Reversi::Board::DISK[:black])
      @game.board.put_disk(6, 7, Reversi::Board::DISK[:white])
      @game.board.put_disk(7, 4, Reversi::Board::DISK[:black])
      @game.board.put_disk(8, 4, Reversi::Board::DISK[:black])
    end

    context "before `player_w` places a piece on position [f4]" do
      it do
        ans = [[7, 7], [4, 6], [7, 5], [3, 5], [6, 4], [5, 3]]
        expect(@game.player_w.next_moves).to eq ans
      end
      it { expect(@game.player_w.count_disks).to eq 3 }
      it { expect(@game.player_b.count_disks).to eq 7 }
    end

    context "after `player_w` places a piece on position [f4]" do
      before do
        @game.player_w.put_disk(6, 4)
      end
      it do
        ans = [[4, 6], [3, 6], [3, 5], [8, 3], [7, 2], [6, 2]]
        expect(@game.player_w.next_moves).to eq ans
      end
      it { expect(@game.player_w.count_disks).to eq 7 }
      it { expect(@game.player_b.count_disks).to eq 4 }
    end
  end

  describe "initial position" do
    it "default" do
      game = Reversi::Game.new
      expect(game.board.at(5, 4)).to eq :black
      expect(game.board.at(4, 4)).to eq :white
    end

    it "original position" do
      initial = {:black => [[1, 1]], :white => [[8, 8]]}
      options = {:initial_position => initial}
      game = Reversi::Game.new(options)
      expect(game.board.at(4, 4)).to eq :none
      expect(game.board.at(1, 1)).to eq :black
      expect(game.board.at(8, 8)).to eq :white
    end
  end

  describe "Reversi.reset" do
    it "reset all options to the default values" do
      Reversi.configure{ |config| config.progress = true }
      game = Reversi::Game.new
      expect(game.options[:progress]).to eq true

      Reversi.reset
      game = Reversi::Game.new
      expect(game.options[:progress]).to eq false
    end
  end

  describe "from a record of a reversi game" do
    game = Reversi::Game.new
    game.player_b.put_disk(3, 4); game.player_w.put_disk(5, 3)
    game.player_b.put_disk(6, 6); game.player_w.put_disk(5, 6)
    game.player_b.put_disk(6, 5); game.player_w.put_disk(3, 5)
    game.player_b.put_disk(6, 4); game.player_w.put_disk(7, 6)
    game.player_b.put_disk(6, 7); game.player_w.put_disk(4, 3)
    game.player_b.put_disk(6, 3); game.player_w.put_disk(7, 5)
    game.player_b.put_disk(7, 4); game.player_w.put_disk(5, 7)
    game.player_b.put_disk(4, 6); game.player_w.put_disk(8, 3)
    game.player_b.put_disk(6, 8); game.player_w.put_disk(7, 3)
    game.player_b.put_disk(3, 6); game.player_w.put_disk(3, 3)
    game.player_b.put_disk(3, 2); game.player_w.put_disk(4, 7)
    game.player_b.put_disk(5, 8); game.player_w.put_disk(3, 8)
    game.player_b.put_disk(8, 4); game.player_w.put_disk(8, 5)
    game.player_b.put_disk(4, 2); game.player_w.put_disk(4, 8)
    game.player_b.put_disk(2, 8); game.player_w.put_disk(2, 3)
    game.player_b.put_disk(3, 7); game.player_w.put_disk(5, 2)
    game.player_b.put_disk(1, 4); game.player_w.put_disk(4, 1)
    game.player_b.put_disk(3, 1); game.player_w.put_disk(6, 2)
    game.player_b.put_disk(5, 1); game.player_w.put_disk(6, 1)
    game.player_b.put_disk(7, 1); game.player_w.put_disk(1, 3)
    game.player_b.put_disk(2, 5); game.player_w.put_disk(2, 4)
    game.player_b.put_disk(1, 5); game.player_w.put_disk(1, 6)
    game.player_b.put_disk(2, 6); game.player_w.put_disk(1, 7)
    game.player_b.put_disk(7, 2); game.player_w.put_disk(8, 1)
    game.player_b.put_disk(2, 2); game.player_w.put_disk(2, 7)
    game.player_b.put_disk(8, 2); game.player_w.put_disk(7, 7)
    game.player_b.put_disk(1, 8); game.player_w.put_disk(1, 2)
    game.player_b.put_disk(8, 7); game.player_w.put_disk(8, 6)
    game.player_b.put_disk(1, 1); game.player_w.put_disk(2, 1)
                                  game.player_w.put_disk(7, 8)
    game.player_b.put_disk(8, 8)
    ans = {
      :black =>0x809F_AEC4_D8B4_FBFF,
      :white =>0x7F60_513B_274B_0400
    }
    it do
      expect(game.board.black_getter).to eq ans[:black]
      expect(game.board.white_getter).to eq ans[:white]
    end
  end
end
