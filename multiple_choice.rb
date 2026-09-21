require_relative './question'
class MultipleChoice
  attr_reader :prompt, :alt, :answer
  def initialize(prompt,alt,answer)
    raise ArgumentError, "Promt can not be empty" if prompt.length == 0
    raise ArgumentError, "Alternatives can not be empty" if alt.length == 0
    raise ArgumentError, "Answer can not be empty" if answer.length == 0
    raise ArgumentError, "Answer must be in alternatives" unless alt.include?(answer)
    @prompt = prompt
    @alt = alt
    @answer = answer
  end
  def ask
    list = [@prompt]
    @alt.each_index {|i| list << "#{i + 1}. #{@alt[i]}"}
    puts list
    gets.chomp
  end
  def correct?(rp)
    if rp.to_i.to_s != rp.to_s
      return false
    end

    if @alt[(rp.to_i) -1].downcase == @answer.downcase
      return true
    else 
      return false
    end
  end
  def hint
    @answer[0]
  end
  def to_s
    "#{@prompt}, #{@alt}, (#{@answer})"
  end
end

