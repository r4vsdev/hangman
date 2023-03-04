# frozen_string_literal: true

class String
  def indexes(sub_string, start = 0)
    index = self[start..].index(sub_string)
    return [] unless index

    [index + start] + indexes(sub_string, index + start + 1)
  end
end

# p 'einstein'.indexes('in') #=> [1, 6]

class Game
  attr_reader :words, :secret, :tries, :over, :guess, :correct_tries, :wrong_tries

  def initialize
    # @words = File.readlines('r.txt')
    @secret = 'articla' # words.map(&:chomp).filter { |word| word.size.between?(5, 12) }.sample
    @tries = 8
    @over = false
    @correct_tries = []
    @wrong_tries = []
  end

  def display(char = @guess)
    if @guess.nil?
      puts @secret.split('').join(' ').gsub(/[a-z]/, '_')
    else
      puts @secret.split('').join(' ').gsub(/[a-z]/) { |letter|
        letter == char || letter == ' ' ? char : '_'
      }
    end
  end

  def player_move
    print 'Choose a letter: '
    @guess = gets.chomp.downcase
  end

  def mark
    if @secret.include?(@guess)
      @correct_tries << @guess
      display(@guess)
    else
      @tries -= 1
      @wrong_tries << @guess
    end
  end
end

game = Game.new
puts 'The game has started. Try to guess the secret word.', ''

until game.over
  puts "#{game.tries} guesses left"
  game.display(game.guess)
  game.player_move
  game.mark
  print "Correct = #{game.correct_tries} ", "Wrong = #{game.wrong_tries} "
end
