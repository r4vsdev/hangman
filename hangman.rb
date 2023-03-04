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
  attr_reader :words, :secret, :tries, :over, :guess, :correct, :wrong

  def initialize
    # @words = File.readlines('r.txt')
    @secret = 'articla' # words.map(&:chomp).filter { |word| word.size.between?(5, 12) }.sample
    @tries = 8
    @over = false
    @correct = []
    @wrong = []
  end

  def display(tries_arr = @guess)
    board = secret.gsub(/[a-z]/, '_')
    if tries_arr.nil?
      puts board
    else
      puts secret.gsub(/[a-z]/) { |letter| tries_arr.include?(letter) ? letter : '_' }
    end
  end

  def player_move
    print 'Choose a letter: '
    @guess = gets.chomp.downcase
  end

  def mark
    if @secret.include?(@guess)
      @correct << @guess
      @correct.uniq!
      display(@correct)
    else
      @tries -= 1
      @wrong << @guess
      @wrong.uniq!
      display(@correct)
    end
  end

  def over?
    if tries == 0
      puts ' ', ' ', 'Game Over', ' '
      @over = true
    end
    if secret.split('').uniq.sort == correct.sort
      puts ' ', ' ', 'You Won!', ' '
      @over = true
    end
  end
end

game = Game.new
puts 'The game has started. Try to guess the secret word.', ''
game.display

until game.over
  puts "#{game.tries} guesses left"
  game.player_move
  game.mark
  print "Correct = #{game.correct} ", "Wrong = #{game.wrong} "
  game.over?
end
