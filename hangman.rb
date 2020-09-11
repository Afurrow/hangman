class Game
  @@turn = 0

  def initialize
    file_data = File.open("5desk.txt").readlines
    words = file_data.select { |x| 5 < x.length && x.length < 12 }
    @word = @words.sample(1)
    @hidden_word = ["-"] * @word[0].length
  end

end