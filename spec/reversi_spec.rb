require 'spec_helper'

describe Reversi do
  before do
    Reversi.configure do |config|
      config.player_b = Reversi::Player::RandomAI
      config.player_w = Reversi::Player::RandomAI
    end

    @game = Reversi::Game.new
    @game.board.put_disk(6, 3, :black)
    @game.board.put_disk(6, 5, :black)
    @game.board.put_disk(6, 6, :black)
    @game.board.put_disk(6, 7, :white)
    @game.board.put_disk(7, 4, :black)
    @game.board.put_disk(8, 4, :black)
  end

  describe "石を置く前" do
    it do
      expect(@game.player_w.my_next_moves).to eq [[:c, 5], [:d, 6], [:e, 3], [:f, 4], [:g, 5], [:g, 7]]
      expect(@game.player_w.count_my_disks).to eq 3
      expect(@game.player_b.count_my_disks).to eq 7
    end
  end

  describe "石を置いた後" do
    it do
      @game.player_w.put_my_disk(:f, 4)
      expect(@game.player_w.my_next_moves).to eq [[:c, 5], [:c, 6], [:d, 6], [:f, 2], [:g, 2], [:h, 3]]
      expect(@game.player_w.count_my_disks).to eq 7
      expect(@game.player_b.count_my_disks).to eq 4
    end
  end
end


describe Reversi do
  before do
    Reversi.configure do |config|
      config.player_b = Reversi::Player::RandomAI
      config.player_w = Reversi::Player::RandomAI
    end
    @game = Reversi::Game.new
    @game.board.put_disk(4, 3, :white)
    @game.board.put_disk(4, 6, :white)
  end

  describe "石を置いた後" do
    it do
      @game.player_b.put_my_disk(4, 2)
      expect(@game.player_w.count_my_disks).to eq 2
      expect(@game.player_b.count_my_disks).to eq 5
    end
  end
end

describe Reversi do
  before do
    Reversi.configure do |config|
      config.player_b = Reversi::Player::RandomAI
      config.player_w = Reversi::Player::RandomAI
    end
    @game = Reversi::Game.new
    @game.player_b.put_my_disk(:c, 4); @game.player_w.put_my_disk(:e, 3)
    @game.player_b.put_my_disk(:f, 6); @game.player_w.put_my_disk(:e, 6)
    @game.player_b.put_my_disk(:f, 5); @game.player_w.put_my_disk(:c, 5)
    @game.player_b.put_my_disk(:f, 4); @game.player_w.put_my_disk(:g, 6)
    @game.player_b.put_my_disk(:f, 7); @game.player_w.put_my_disk(:d, 3)
    @game.player_b.put_my_disk(:f, 3); @game.player_w.put_my_disk(:g, 5)
    @game.player_b.put_my_disk(:g, 4); @game.player_w.put_my_disk(:e, 7)
    @game.player_b.put_my_disk(:d, 6); @game.player_w.put_my_disk(:h, 3)
    @game.player_b.put_my_disk(:f, 8); @game.player_w.put_my_disk(:g, 3)
    @game.player_b.put_my_disk(:c, 6); @game.player_w.put_my_disk(:c, 3)
    @game.player_b.put_my_disk(:c, 2); @game.player_w.put_my_disk(:d, 7)
    @game.player_b.put_my_disk(:e, 8); @game.player_w.put_my_disk(:c, 8)
    @game.player_b.put_my_disk(:h, 4); @game.player_w.put_my_disk(:h, 5)
    @game.player_b.put_my_disk(:d, 2); @game.player_w.put_my_disk(:d, 8)
    @game.player_b.put_my_disk(:b, 8); @game.player_w.put_my_disk(:b, 3)
    @game.player_b.put_my_disk(:c, 7); @game.player_w.put_my_disk(:e, 2)
    @game.player_b.put_my_disk(:a, 4); @game.player_w.put_my_disk(:d, 1)
    @game.player_b.put_my_disk(:c, 1); @game.player_w.put_my_disk(:f, 2)
    @game.player_b.put_my_disk(:e, 1); @game.player_w.put_my_disk(:f, 1)
    @game.player_b.put_my_disk(:g, 1); @game.player_w.put_my_disk(:a, 3)
    @game.player_b.put_my_disk(:b, 5); @game.player_w.put_my_disk(:b, 4)
    @game.player_b.put_my_disk(:a, 5); @game.player_w.put_my_disk(:a, 6)
    @game.player_b.put_my_disk(:b, 6); @game.player_w.put_my_disk(:a, 7)
    @game.player_b.put_my_disk(:g, 2); @game.player_w.put_my_disk(:h, 1)
    @game.player_b.put_my_disk(:b, 2); @game.player_w.put_my_disk(:b, 7)
    @game.player_b.put_my_disk(:h, 2); @game.player_w.put_my_disk(:g, 7)
    @game.player_b.put_my_disk(:a, 8); @game.player_w.put_my_disk(:a, 2)
    @game.player_b.put_my_disk(:h, 7); @game.player_w.put_my_disk(:h, 6)
    @game.player_b.put_my_disk(:a, 1); @game.player_w.put_my_disk(:b, 1)
                               @game.player_w.put_my_disk(:g, 8)
    @game.player_b.put_my_disk(:h, 8)
  end

  describe "棋譜" do
    ans = 
      [[2,  2,  2,  2,  2,  2,  2,  2,  2, 2],
       [2, -1, -1, -1, -1, -1, -1, -1, -1, 2],
       [2,  1,  1,  1, -1, -1,  1, -1, -1, 2],
       [2,  1,  1, -1,  1,  1, -1, -1, -1, 2],
       [2,  1, -1,  1,  1, -1, -1, -1, -1, 2],
       [2,  1, -1, -1,  1, -1,  1, -1, -1, 2],
       [2,  1, -1, -1, -1,  1, -1,  1, -1, 2],
       [2,  1, -1, -1,  1,  1,  1, -1, -1, 2],
       [2,  1, -1,  1,  1,  1,  1, -1, -1, 2],
       [2,  2,  2,  2,  2,  2,  2,  2,  2, 2]]
    it do
      expect(@game.board.columns).to eq ans
    end
  end
end
