require 'spec_helper'

describe Reversi::Game do
  describe "next moves" do
    before do
      @game = Reversi::Game.new
      @game.board.put_disk(6, 3, :black)
      @game.board.put_disk(6, 5, :black)
      @game.board.put_disk(6, 6, :black)
      @game.board.put_disk(6, 7, :white)
      @game.board.put_disk(7, 4, :black)
      @game.board.put_disk(8, 4, :black)
    end

    context "before `player_w` places a piece on position [f4]" do
      it do
        ans = [[3, 5], [4, 6], [5, 3], [6, 4], [7, 5], [7, 7]]
        expect(@game.player_w.next_moves.map{ |move| move[:move] }).to eq ans
      end
      it { expect(@game.player_w.count_disks).to eq 3 }
      it { expect(@game.player_b.count_disks).to eq 7 }
    end

    context "after `player_w` places a piece on position [f4]" do
      before do
        @game.player_w.put_disk(:f, 4)
      end
      it do
        ans = [[3, 5], [3, 6], [4, 6], [6, 2], [7, 2], [8, 3]]
        expect(@game.player_w.next_moves.map{ |move| move[:move] }).to eq ans
      end
      it { expect(@game.player_w.count_disks).to eq 7 }
      it { expect(@game.player_b.count_disks).to eq 4 }
    end
  end

  describe "initial position" do
    it "default" do
      game = Reversi::Game.new
      expect(game.board.at(:e, 4)).to eq :black
      expect(game.board.at(:d, 4)).to eq :white
    end

    it "original position" do
      initial = {:black => [[:a, 1]], :white => [[:h, 8]]}
      options = {:initial_position => initial}
      game = Reversi::Game.new(options)
      expect(game.board.at(:d, 4)).to eq :none
      expect(game.board.at(:a, 1)).to eq :black
      expect(game.board.at(:h, 8)).to eq :white
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
    game.player_b.put_disk(:c, 4); game.player_w.put_disk(:e, 3)
    game.player_b.put_disk(:f, 6); game.player_w.put_disk(:e, 6)
    game.player_b.put_disk(:f, 5); game.player_w.put_disk(:c, 5)
    game.player_b.put_disk(:f, 4); game.player_w.put_disk(:g, 6)
    game.player_b.put_disk(:f, 7); game.player_w.put_disk(:d, 3)
    game.player_b.put_disk(:f, 3); game.player_w.put_disk(:g, 5)
    game.player_b.put_disk(:g, 4); game.player_w.put_disk(:e, 7)
    game.player_b.put_disk(:d, 6); game.player_w.put_disk(:h, 3)
    game.player_b.put_disk(:f, 8); game.player_w.put_disk(:g, 3)
    game.player_b.put_disk(:c, 6); game.player_w.put_disk(:c, 3)
    game.player_b.put_disk(:c, 2); game.player_w.put_disk(:d, 7)
    game.player_b.put_disk(:e, 8); game.player_w.put_disk(:c, 8)
    game.player_b.put_disk(:h, 4); game.player_w.put_disk(:h, 5)
    game.player_b.put_disk(:d, 2); game.player_w.put_disk(:d, 8)
    game.player_b.put_disk(:b, 8); game.player_w.put_disk(:b, 3)
    game.player_b.put_disk(:c, 7); game.player_w.put_disk(:e, 2)
    game.player_b.put_disk(:a, 4); game.player_w.put_disk(:d, 1)
    game.player_b.put_disk(:c, 1); game.player_w.put_disk(:f, 2)
    game.player_b.put_disk(:e, 1); game.player_w.put_disk(:f, 1)
    game.player_b.put_disk(:g, 1); game.player_w.put_disk(:a, 3)
    game.player_b.put_disk(:b, 5); game.player_w.put_disk(:b, 4)
    game.player_b.put_disk(:a, 5); game.player_w.put_disk(:a, 6)
    game.player_b.put_disk(:b, 6); game.player_w.put_disk(:a, 7)
    game.player_b.put_disk(:g, 2); game.player_w.put_disk(:h, 1)
    game.player_b.put_disk(:b, 2); game.player_w.put_disk(:b, 7)
    game.player_b.put_disk(:h, 2); game.player_w.put_disk(:g, 7)
    game.player_b.put_disk(:a, 8); game.player_w.put_disk(:a, 2)
    game.player_b.put_disk(:h, 7); game.player_w.put_disk(:h, 6)
    game.player_b.put_disk(:a, 1); game.player_w.put_disk(:b, 1)
                                   game.player_w.put_disk(:g, 8)
    game.player_b.put_disk(:h, 8)
    ans = [
      [2,  2,  2,  2,  2,  2,  2,  2,  2, 2],
      [2, -1, -1, -1, -1, -1, -1, -1, -1, 2],
      [2,  1,  1,  1, -1, -1,  1, -1, -1, 2],
      [2,  1,  1, -1,  1,  1, -1, -1, -1, 2],
      [2,  1, -1,  1,  1, -1, -1, -1, -1, 2],
      [2,  1, -1, -1,  1, -1,  1, -1, -1, 2],
      [2,  1, -1, -1, -1,  1, -1,  1, -1, 2],
      [2,  1, -1, -1,  1,  1,  1, -1, -1, 2],
      [2,  1, -1,  1,  1,  1,  1, -1, -1, 2],
      [2,  2,  2,  2,  2,  2,  2,  2,  2, 2]
    ]
    it { expect(game.board.columns).to eq ans }
  end
end
