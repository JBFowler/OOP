# Blackjack is a card game where the goal of the game is to beat the dealer (person dealing the cards).  # The game can involve many players, but for the players the only competition
# is the dealer and not any of the other players at the table.  Start with a shuffled deck of cards.  Deal one card to the player face up, and then one card to the dealer face up.
# Deal another card to the player face up, and one more card to the dealer face down.  The player will get cards until he decides to stop, trying not to go over 21.  Once he says stay
# and his total is still under 21, the dealer will draw cards until his total is greater than 16.  The dealers total and the players total are compared, and the winner is the one with
# the highest total without going over 21.

class Card
  attr_accessor :suit, :face_value

  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end

  def find_suit
    ret_val =
      case suit
      when 'H'
        'Hearts'
      when 'D'
        'Diamonds'
      when 'S'
        'Spaids'
      when 'C'
        'Clubs'
      end
    ret_val
  end

  def pretty_output
    "The #{face_value} of #{find_suit}"
  end

  def to_s
    pretty_output
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

  def size
    cards.size
  end

end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end

  def total
    face_values = cards.map { |card| card.face_value }

    total = 0
    face_values.each do |val|
      if val == 'A'
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    face_values.select {|val| val == "A"}.count.times do
      break if total <= Blackjack::BLACKJACK_AMOUNT
      total -= 10
    end

    total
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
  end

  def add_card(new_card)
    cards << new_card
  end
end

class Player  
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "blank"
    @cards = []
  end

  def show_flop
    show_hand
  end

end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def show_flop
    puts "---- Dealer's Hand ----"
    puts "=> First card is hidden"
    puts "=> Second card is #{cards[1]}"
  end
end

class Blackjack

  attr_accessor :deck, :player, :dealer

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def set_player_name
    puts "What's your name?"
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry, dealer hit blackjack.  #{player.name} loses."
      else
        puts "Congrajulations, #{player.name} hit blackjack!  #{player.name} wins!"
      end
      play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Player)
        puts "Sorry, #{player.name} busted.  #{player.name} loses."
      else
        puts "Congrajulations, the dealer busted!  #{player.name} wins!"
      end
      play_again?
    end 
  end

  def player_turn
    puts "#{player.name}'s turn."

    blackjack_or_bust?(player)

    while !player.is_busted?
      puts "Would you like to hit or stay?(h/s)"
      response = gets.chomp.downcase

      if !['h', 's'].include?(response)
        puts "Error: you must enter h or s"
        next
      end

      if response == 's'
        puts "#{player.name} chose to stay."
        break
      end

      #hit
      new_card = deck.deal_one
      puts "Dealing card to #{player.name}: #{new_card}"
      player.add_card(new_card)
      puts "#{player.name}'s total is now #{player.total}."

      blackjack_or_bust?(player)
    end
    puts "#{player.name} stays at #{player.total}."
  end

  def dealer_turn
    puts "Dealer's turn."
    puts "Dealer's first card is #{dealer.cards[0]}, making his total #{dealer.total}."

    blackjack_or_bust?(dealer)

    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal_one
      puts "Dealing card to dealer: #{new_card}"
      dealer.add_card(new_card)
      puts "Dealer's total is now #{dealer.total}."

      blackjack_or_bust?(dealer)
    end
    puts "Dealer Stays at #{dealer.total}."
  end

  def who_won?
    if player.total > dealer.total
      puts "Congrajulations, #{player.name} wins!"
    elsif player.total < dealer.total
      puts "Sorry, #{player.name} loses."
    else
      puts "It's a tie!"
    end
    play_again?
  end

  def play_again?
    puts ""
    puts "Would you like to play again? (y/n)"
    if gets.chomp == 'y'
      puts "starting new game..."
      puts ""
      deck = Deck.new
      player.cards = []
      dealer.cards = []
      start
    else
      puts "Goodbye!"
      exit
    end
  end

  def start
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end

end

game = Blackjack.new
game.start
