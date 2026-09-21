require "minitest/autorun"
require_relative "../multiple_choice"

class Multiple_Choice_Test < Minitest::Test
  def test_multiple_choice
    q = MultipleChoice.new("Prompt", ["alt1","svar", "alt3", "alt4"], "svar") 

    assert q.alt.include?("svar")
    refute q.alt.include?("this")
    assert_equal q.answer,"svar"
  end
  def test_another_multiple_choice
    q = MultipleChoice.new("Prompt", ["alt1","alt2", "answer", "alt4"], "answer") 
    
    assert q.alt.include?("answer")
    refute q.alt.include?("correct")
    assert_equal q.answer, "answer"
  end
  def test_answer_must_be_in_alternatives
      
    assert_raises(ArgumentError) { MultipleChoice.new("Prompt", ["alt1","al2", "alt3", "alt4"], "svar") }
  end
  
  def test_correct
    q = MultipleChoice.new("Prompt", ["alt1","alt2", "answer", "alt4"], "answer") 

    assert q.correct?(3)
    refute q.correct?(2)

    assert q.correct?("3")
    refute q.correct?("2")

    refute q.correct?("abc")
    refute q.correct?("2.")
    refute q.correct?("3.")
    refute q.correct?("a3")
  end
  def test_refuses_empty_prompt
    assert_raises(ArgumentError) { MultipleChoice.new("",[], "Oslo") }
  end
  def test_refuses_empty_alternatives
    assert_raises(ArgumentError) { MultipleChoice.new("Prompt",[], "Oslo") }
  end
  def test_refuses_empty_answer
    assert_raises(ArgumentError) { MultipleChoice.new("Prompt",["ah","uh"], "") }
  end
  
end
