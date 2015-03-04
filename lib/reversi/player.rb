module Reversi
  module Player
    autoload :RandomAI, "reversi/player/random_ai"
    autoload :NegamaxAI, "reversi/player/negamax_ai"
    autoload :Human, "reversi/player/human"
  end
end
