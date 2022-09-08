class Game
  attr_reader :turn, :secret_word, :hidden_word, :used_letters

  def initialize
    @turn = 1
    @secret_word = GetCode()
    @hidden_word = ["_"] * @secret_word.length
    @used_letters = []
    GetGuess()
  end

  def GetCode
    file_data = File.open("5desk.txt").readlines
    words = file_data.select { |x| 5 < x.length && x.length < 12 }
    word = words.sample(1)[0].strip()
  end

  def Display
    scoreboard = "turn: #{@turn} / 8"
    scoreboard << " | guesses: #{@used_letters}" if @used_letters.length > 1
    puts scoreboard
    puts "word: #{@hidden_word.join(" ")}"
  end

  def GetGuess
    return Gameover(true) unless @hidden_word.include?("_")
    return Gameover() if @turn > 8
    Display()
    puts "Please guess a letter or the full word. You can also Save or Load."
    user_guess = gets.chomp.downcase

    if user_guess == "save"
      SaveState()
    elsif user_guess == "load"
      LoadState()
    elsif user_guess.length > 1
      @used_letters << user_guess
      @turn += 1
      return Gameover(true) if user_guess == @secret_word.downcase
    else 
      @secret_word.split("").each_with_index do |x, i| 
        @hidden_word[i] = @secret_word[i] if x.downcase == user_guess
      end
      @used_letters << user_guess
      @turn += 1
    end

    GetGuess()
  end

  def Gameover(victory=false)
    if victory
      puts "Congratulations! You won!"
    else
      puts "You have exhausted your guesses, Game over!\nThe secret word was #{@secret_word}."
    end

    puts "Would you like to play again? (Y/N)"
    user_response = gets.chomp.downcase
    game = initialize() if user_response == "y"
  end

  def SaveState
    require 'yaml'
    save_file = File.open("saved_state.yml", "w")
    File.write(save_file, YAML.dump(self));
  end

  def LoadState
    require 'yaml'

    if File.exists?("saved_state.yml")
      yaml_contents = YAML.load(File.read("saved_state.yml"))
      @turn = yaml_contents.turn
      @secret_word = yaml_contents.secret_word
      @hidden_word = yaml_contents.hidden_word     
      @used_letters = yaml_contents.used_letters
    else 
      puts "No saved state to load."
    end
  end

end

game = Game.new