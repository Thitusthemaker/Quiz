require "minitest/autorun"
require_relative "../question"

class QuestionTest < Minitest::Test
  def test_hint_is_first_letter_of_answer
    q = Question.new("Vad heter huvudstaden i Norge?", "Oslo")
    assert_equal "O", q.hint
  end

  def test_hint_for_another_question
    q = Question.new("Vad heter huvudstaden i Sverige?", "Stockholm")
    assert_equal "S", q.hint
  end

  def test_correct_ignores_case
    q = Question.new("Vad heter huvudstaden i Norge?", "Oslo")
    assert q.correct?("oslo")
    refute q.correct?("bergen")
  end

  def test_refuses_empty_prompt
    assert_raises(ArgumentError) { Question.new("", "Oslo") }
  end
  
  def test_question_snitching
    q = Question.new("Vad heter huvudstaden i Norge?", "Oslo")
    assert_equal "Vad heter huvudstaden i Norge? (Oslo)", q.to_s
  end

end