class Question
  attr_reader :prompt, :answer
  def initialize(prompt, answer)
    raise ArgumentError, "prompt must not be empty" if prompt.length == 0
    raise ArgumentError, "answer must not be empty" if answer.length == 0
    @prompt = prompt
    @answer = answer
  end
  def hint
    "Hint, first letter #{answer[0]}"
  end
  def ask
    puts prompt
    gets.chomp
  end

  def correct?(reply)
    reply.strip.downcase == answer.downcase
  end

  def to_s
    "#{prompt} (#{answer})"
  end
end
