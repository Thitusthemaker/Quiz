# Quiz

Skapa din kopia med *Use this template* och klona den. 

Jobba i det klonade repot. Committa och pusha minst en gång varje lektion, även om koden inte går att köra.

## 1. En fråga som säger nej

Repot har två filer. Öppna **inte** `question.rb` än.

1. Kör `ruby quiz.rb`. Svara på de tre frågorna.
2. Öppna `quiz.rb`. Lägg till tre egna frågor i listan. Kör igen.
3. Starta `irb` i repots mapp och skriv:

```ruby
require_relative "question"
q = Question.new("Vad heter huvudstaden i Norge?", "Oslo")
q.correct?("oslo")
q.correct?("Bergen")
q.prompt
puts q
q.class
q.method(:correct?).owner
```

Vad är `q`? Vilka meddelanden svarar det på? 

Vem bestämmer vad `correct?` betyder?

### Läs

Nu öppnar du `question.rb`. Läs den med orden från presentationen.

- `class Question ... end`. 
  
  Samma rad som `class Array` förra veckan. 
  
  Allt mellan raderna  blir meddelanden som en `Question` svarar på. 
  Skillnaden: `Array` är en inbyggd klass. `Question` skapas i den här filen.
  
- `def correct?(reply)`. 
  Här bor beslutet. `q.method(:correct?).owner` pekade hit.
  Frågetecknet är en konvention i Ruby, inte en regel: metoder som returnerar `true` eller `false` slutar med frågetecken. Du har sett `even?`, `empty?`, `positive?`. 
  
- `def initialize(prompt, answer)`.
  Det här körs när du skickar `new` till `Question`.
  `new` skapar ett tomt objekt och skickar `initialize` till det, tillsammans med argumenten som skickades till `new`.
  
- `@prompt` och `@answer`. 
  Objektets eget state. 
  
  Varje fråga har sitt eget `@answer`. `@` betyder: det här tillhör objektet, inte metoden.
  
- `def prompt` och `def answer`. Två meddelanden som svarar med vad som står i minnet.
  Utan dem kommer ingen åt `@answer` utifrån. 
  
- def answer=(new_answer)
  Ett meddelande som heter `answer=`, med lika-med i namnet.
   `q.answer = "x"` är kortform för `q.answer=("x")`, precis som `"hej"[0] = "H"`  är en kortform för  `"hej".[]=(0, "H")`. 

### Tuffa till frågan

Frågan är för snäll. Prova i irb:

```ruby
Question.new("", "")
q = Question.new("Vad heter huvudstaden i Norge?", "Oslo")
q.answer = "Bergen"
q.correct?("Oslo")
```

En fråga utan text och utan svar gick att skapa. 
Och vem som helst som håller i `q` kan byta ut det rätta svaret. 

Ingen sa nej. Det är samma butik som i kapitel 1, innan varan lärde sig säga nej.

Två ändringar i `question.rb`:

1. **Vägra bli till utan text.** 

2. **Ta bort möjligheten att byta svar.** 

Kör sedan `ruby quiz.rb`. Fungerar det fortfarande? Om något gick sönder var det en rad
som gick in i frågan utifrån. Hitta den och fundera på om den borde finnas.

Kontrollera:

```ruby
Question.new("", "Oslo")        # ArgumentError: prompt must not be empty
q.answer = "x"                  # NoMethodError: undefined method 'answer='
q.answer                        # => "Oslo"   att läsa går bra, det meddelandet finns
```

### Kortform

`def prompt` och `def answer` är sex rader som gör samma sak. Ruby har en kortform:

```ruby
attr_reader :prompt, :answer
```

En rad, överst i klassen, som skriver de två metoderna åt dig. 

Byt ut dina manuellt skapade prompt och answer-metoder. 

### Frågan skvallrar

Om man kör  `puts q` skrivs svaret ut, varför det?

Ska frågan visa svaret?

Bestäm, ändra eller låt vara, och skriv i loggboken varför. Det är ditt första beslut om vilka meddelanden ett objekt ska svara på.

### Vidare

För dig som är klar.

- **En ledtråd.**
  
  Ge `Question` ett nytt meddelande, `hint`, som svarar med svarets första bokstav. Använd det i `quiz.rb` när någon svarar fel första gången. Vem bestämde hur en ledtråd ser ut, frågan eller quizet?
  
- **Ett quiz som är ett objekt.** 
  
  Bygg om `quiz.rb`: en klass `Quiz` som får listan med frågor när den skapas och svarar på `run`. 
  
  Vad äger den? Vem räknar poängen? Vem ställer frågorna? Skriv i loggboken vad du la i `Quiz` och vad du lät `Question` behålla.
  
- **Frågor ur en databas.** 
  För dig som har sett SQL. Skapa `quiz.db` med en tabell `questions(prompt, answer)` och tre rader. Läs raderna med `sqlite3`-gemen och bygg `Question`-objekt av dem i `quiz.rb`. 
  
  Fråga i loggboken: ska `Question` kunna läsa från databasen själv, eller ska något annat bygga frågor av rader? (Kräver att
  `gem install sqlite3` fungerar på din dator. Om det inte gör det, säg till.)

### Loggbok

De vanliga fyra frågorna, och två till:

- Vem kontrollerar svaret, `Question` eller `quiz.rb`? Behöver `quiz.rb` kunna läsa `answer` över huvud taget? 
  Titta på raden `Rätt svar: #{q.answer}`.
- Vad bestämde du om `to_s`, och varför?
