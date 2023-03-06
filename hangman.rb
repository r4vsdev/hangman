# frozen_string_literal: true

require 'yaml'

class Game
  # attr_reader :secret, :tries, :over, :correct, :wrong
  attr_accessor :secret, :tries, :over, :correct, :wrong

  @@words = File.readlines('r.txt')

  def initialize
    @secret = @@words.map(&:chomp).filter { |word| word.size.between?(5, 12) }.sample
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
    print 'Choose a letter: '
    @guess = gets.chomp.downcase
    return unless @guess.size > 1

    puts 'Erroneous input! Try again...'
    player_move
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
    YAML.dump ({
      :secret => @secret,
      :tries => tries,
      :over => over,
      :correct => @correct,
      :wrong => @wrong
    })
  end

  def deserialize(yaml_string)
    data = YAML.load yaml_string
    @secret = data[:secret]
    @tries = data[:tries]
    @over = data[:over]
    @correct = data[:correct]
    @wrong = data[:wrong]
  end
end

game = Game.new
puts 'The game has started. Try to guess the secret word.', ''
game.display

until game.over
  puts ' ', ' ', 'Press Enter to continue playing, 1 to load a file, 2 to save the game'
  action = gets
  puts "#{game.tries} guesses left"
  if action == "\n"
    game.display(game.correct)
    game.player_move
    game.mark
    print "Correct = #{game.correct} ", "Wrong = #{game.wrong} "
    game.over?
  elsif action == "1\n"
    puts 'Loading data...'
    save = File.open('hangman_save', 'r')
    data = game.deserialize(save)
  elsif action == "2\n"
    puts 'Serializing data...'
    yaml = game.serialize
    File.open('hangman_save', 'w') { |save_file| save_file.puts yaml }
  end

end
