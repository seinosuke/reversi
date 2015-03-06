# Reversi

[![Gem Version](https://badge.fury.io/rb/reversi.svg)](http://badge.fury.io/rb/reversi)  
A Ruby Gem to play reversi game. You can enjoy a game on the command line or easily make your original reversi game programs.  

![reversi](https://github.com/seinosuke/reversi/blob/master/images/reversi.gif)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'reversi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install reversi

## Usage

Run a demo program in this introduction.

```ruby
require 'reversi'

Reversi.configure do |config|
  config.disk_color_b = 'cyan'
  config.disk_b = "O"
  config.disk_w = "O"
  config.progress = true
end

game = Reversi::Game.new
game.start
puts "black #{game.board.status[:black].size}"
puts "white #{game.board.status[:white].size}"
```

### Configuration

Use `Reversi.configure` to configure setting for a reversi game.  

`name` description... (default value)  

* `player_b` A player having the first move uses this class object. ( Reversi::Player::RandomAI )
* `player_w` A player having the passive move uses this class object. ( Reversi::Player::RandomAI )
* `disk_b` A string of the black disks. ( 'b' )
* `disk_w` A string of the black disks. ( 'w' )
* `disk_color_b` A color of the black disks. ( 0 )
* `disk_color_w` A color of the black disks. ( 0 )
* `initial_position` The initial positions of each disk on the board. ( {:black => [[:d, 5], [:e, 4]], :white => [[:d, 4], [:e, 5]]} )
* `progress` Whether or not the progress of the game is displayed. ( false )
* `stack_limit` The upper limit number of times of use `Reversi::Board#undo!` . ( 3 )

A string and a color of the disks are reflected on `game.board.to_s` .  
You can choose from 9 colors, black, red, green, yellow, blue, magenda, cyan, white and gray.  

Using `Reversi.reset` method, you can reset all options to the default values.

### Human vs Computer

Set `Reversi::Player::Human` to player_b or player_w, and run. Please input your move (for example: d3). This program is terminated when this game is over or when you input `q` or `exit`.  

```ruby
Reversi.configure do |config|
  config.player_b = Reversi::Player::Human
end

game = Reversi::Game.new
game.start
```

### Your Original Player

You can make your original player class by inheriting `Reversi::Player::BasePlayer` and defining `move` method.  

`next_moves` method returns an array of the next moves information. A player places a supplied color's disk on specified position, and flips the opponent's disks by using `put_disk` method. You can get the current game board state from a `board` variable.

 * Example of Random AI

```ruby
class MyAI < Reversi::Player::BasePlayer
  def move(board)
    moves = next_moves.map{ |v| v[:move] }
    put_disk(*moves.sample) unless moves.empty?
  end
end

Reversi.configure do |config|
  config.player_b = MyAI
end

game = Reversi::Game.new
game.start
```

 * Example of Negamax Algorithm  
Please see `Reversi::Player::NegamaxAI` .

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
