module Reversi
  module Player
    autoload :RandomAI, "reversi/player/random_ai"
    autoload :NegaMaxAI, "reversi/player/nega_max_ai"
    autoload :MinMaxAI, "reversi/player/min_max_ai"
    autoload :Human, "reversi/player/human"
  end
end
