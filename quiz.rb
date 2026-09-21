require_relative "question"
require_relative "multiple_choice"
require 'sqlite3'
DB_PATH = './sqlite.db'  
class Quiz

  def initialize(db_path)
    if File.exist?(db_path) != true
      @db = SQLite3::Database.new(db_path)
      self.createTable
      self.seeding
    end
    @db = SQLite3::Database.new(db_path)
    @questions = []
    self.loadQuestions
  end

  def grabQuestions
    @questions
  end

  def createSingleQuestion(prompt,answer)
    @questions << Question.new(prompt,answer)
    @db.execute('INSERT INTO squestions (prompt, answer) VALUES (?, ?)',[prompt,answer])
   
  end
  def createMultipleQuestion(prompt,alt,answer)
    @questions << Question.new(prompt,alt,answer)
    @db.execute('INSERT INTO mquestions (prompt,alt, answer) VALUES (?, ?, ?)',[prompt,answer])
   
  end

  def loadQuestions
    @questions = []
    data = @db.execute('SELECT prompt, answer FROM squestions')
    data.each {|question| @questions << Question.new(question[0],question[1])}

    data = @db.execute('SELECT prompt,alt,answer FROM mquestions')

    data.each do |row|
    alt = row[1].split(',')

    @questions << MultipleChoice.new(row[0],alt,row[2])

    end

  end

  def length
    @questions.length
  end

  def createTable
    @db.execute('DROP TABLE IF EXISTS squestions')
    @db.execute('DROP TABLE IF EXISTS mquestions')
    @db.execute('CREATE TABLE sQuestions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            prompt TEXT NOT NULL,
            answer TEXT NOT NULL)')

    @db.execute('CREATE TABLE mquestions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            prompt TEXT NOT NULL,
            alt TEXT NOT NULL,
            answer TEXT NOT NULL)')

  end
  def seeding #testing
    @db.execute('INSERT INTO squestions (prompt, answer) VALUES ("Vad heter huvudstaden i Norge?", "Oslo")')
    @db.execute('INSERT INTO squestions (prompt, answer) VALUES ("Vilket år släpptes Ruby 1.0?", "1996")')
    @db.execute('INSERT INTO squestions (prompt, answer) VALUES ("Vad svarar 5.class?", "Integer")')
    @db.execute('INSERT INTO squestions (prompt, answer) VALUES ("När lanserades den första iphonen?", "2010")')
    @db.execute('INSERT INTO squestions (prompt, answer) VALUES ("Vad heter sveriges huvudstad?", "Stockholm")')
    @db.execute('INSERT INTO squestions (prompt, answer) VALUES ("Vad heter sveriges bättre stad", "Göteborg")')
    @db.execute('INSERT INTO mquestions (prompt, alt, answer) VALUES ("Vad heter sveriges bättre stad","Göteborg,Stockholm", "Göteborg")')
    @db.execute('INSERT INTO mquestions (prompt, alt, answer) VALUES ("Vad heter sveriges bättre nti", "Kronhus,Johanneberg", "Johanneberg")')
  end

end
q = Quiz.new(DB_PATH)
q.createTable
q.seeding
# q.createSingleQuestion("en fråga(svaret är idk)", "idk")
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
      puts "Hint, first letter #{q.hint}"
      tries += 1
      if tries >=2
        puts "Fel. Rätt svar: #{q.answer}"
        break
      end
    end
  end
end

puts "#{score} av #{q.length} rätt."
