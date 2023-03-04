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
  attr_reader :words, :secret, :tries, :over

  def initialize
    # @words = File.readlines('r.txt')
    @secret = 'articla' # words.map(&:chomp).filter { |word| word.size.between?(5, 12) }.sample
    @tries = 8
    @over = false
  end

  def display(char = '')
    if char == ''
      puts @secret.split('').join(' ').gsub(/[a-z]/, '_')
    else
      puts @secret.split('').join(' ').gsub(/[a-z]/) { |letter|
        letter == char || letter == ' ' ? char : '_'
      }
    end
  end

  def player_move
    print 'Choose a letter: '
    @guess = gets.chomp
  end

  def mark
    @tries -= 1
    return unless @secret.include?(@guess)

    @tries += 1
    display(@guess)
  end
end

game = Game.new
puts 'The game has started. Try to guess the secret word.', ''

until game.over
  puts "You have #{game.tries} guesses left"
  game.display
  game.player_move
  game.mark
end
