require_relative "question"
require 'sqlite3'



class Quiz

  def initialize(db_path)
    if File.exist?(db_path) != true
      @db = SQLite3::Database.new(db_path)
      self.createTable
      
    end
    @db = SQLite3::Database.new(db_path)
    @questions = []
    self.loadQuestions
  end

  def grabQuestions
    @questions
  end

  def createQuestion(prompt,answer)
    raise ArgumentError, "prompt must not be empty" if prompt.length == 0
    raise ArgumentError, "answer must not be empty" if answer.length == 0
    @questions << Question.new(prompt,answer)
    @db.execute('INSERT INTO questions (prompt, answer) VALUES (?, ?)',[prompt,answer])
   
    
  end

  def loadQuestions
    @questions = []
    data = @db.execute('SELECT prompt, answer FROM questions')
    data.each {|question| @questions << Question.new(question[0],question[1])}
    

  end

  def length
    @questions.length
  end

  def createTable
    @db.execute('DROP TABLE IF EXISTS questions')
    @db.execute('CREATE TABLE questions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            prompt TEXT NOT NULL,
            answer TEXT NOT NULL)')

  end
  def seeding #testing
    @db.execute('INSERT INTO questions (prompt, answer) VALUES ("Vad heter huvudstaden i Norge?", "Oslo")')
    @db.execute('INSERT INTO questions (prompt, answer) VALUES ("Vilket år släpptes Ruby 1.0?", "1996")')
    @db.execute('INSERT INTO questions (prompt, answer) VALUES ("Vad svarar 5.class?", "Integer")')
    @db.execute('INSERT INTO questions (prompt, answer) VALUES ("När lanserades den första iphonen?", "2010")')
    @db.execute('INSERT INTO questions (prompt, answer) VALUES ("Vad heter sveriges huvudstad?", "Stockholm")')
    @db.execute('INSERT INTO questions (prompt, answer) VALUES ("Vad heter sveriges bättre stad", "Göteborg")')
  end

end
q = Quiz.new('./sqlite.db')
q.createTable
q.seeding
q.createQuestion("en fråga(svaret är idk)", "idk")
q.loadQuestions

score = 0

q.grabQuestions.each do |q|
  tries = 0
  while 1
    reply = q.ask
    if q.correct?(reply)
      puts "Rätt!"
      if tries == 0
        score += 1
      else
        score += 0.5
      end
      break
    else
      puts q.hint
      tries += 1
      if tries >=2
        puts "Fel. Rätt svar: #{q.answer}"
        break
      end
    end
  end
end

puts "#{score} av #{q.length} rätt."
