# frozen_string_literal: true

class Game
  attr_reader :words, :secret, :guesses, :over

  def initialize
    @words = File.readlines('r.txt')
    @secret = 'article' # words.map(&:chomp).filter { |word| word.size.between?(5, 12) }.sample
    @guesses = 8
    @over = false
  end

  def display
    p @board = @secret.split('').join(' ').gsub(/[a-z]/, '_')
  end

  # def player_move
  #   puts 'Choose a letter: '
  #   @letter = gets.chomp
  # end

  # def mark
  #   if @secret.include?(@letter)
  #     @board.gsub()
  #   end
  # end

end

game = Game.new
puts 'The game has started. Try to guess the secret word.'

unless game.over
  puts "You have #{game.guesses} guesses left"
  game.display
  # game.player_move
  # game.mark
end