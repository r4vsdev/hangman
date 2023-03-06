# frozen_string_literal: true

class Game
  attr_reader :secret, :tries, :over, :correct, :wrong

  def initialize
    @words = File.readlines('r.txt')
    @secret = @words.map(&:chomp).filter { |word| word.size.between?(5, 12) }.sample
    @tries = 8
    @over = false
    @correct = []
    @wrong = []
  end

  def display(tries_arr = @guess)
    board = secret.gsub(/[a-z]/, '_')
    if tries_arr.nil?
      puts board.split('').join(' ')
    else
      puts secret.gsub(/[a-z]/) { |letter| tries_arr.include?(letter) ? letter : '_' }.split('').join(' ')
    end
  end

  def player_move
    if action == 1
      print 'Choose a letter: '
      @guess = gets.chomp.downcase
      return unless @guess.size > 1

      puts 'Erroneous input! Try again...'
      player_move
    elsif action == 2

    end
  end

  def mark
    if @secret.include?(@guess)
      @correct << @guess
      @correct.uniq!
    else
      @tries -= 1
      @wrong << @guess
      @wrong.uniq!
    end
    display(@correct)
  end

  def over?
    if tries.zero?
      puts ' ', ' ', "Game Over. The word was #{secret} =(", ' '
      @over = true
    end
    return unless secret.split('').uniq.sort == correct.sort

    puts ' ', ' ', 'You Won!', ' '
    @over = true
  end

  def serialize
    YAML::dump(self)
  end

  def deserialize(yaml_string)
    YAML::load(yaml_string)
  end
end

game = Game.new
puts 'The game has started. Try to guess the secret word.', ''
game.display

until game.over
  puts "#{game.tries} guesses left"
  puts 'Press 1 to continue playing, or 2 to save the game' # Add topic number 5
  action = gets.chomp
  
  game.player_move
  game.mark
  print "Correct = #{game.correct} ", "Wrong = #{game.wrong} "
  game.over?
end
