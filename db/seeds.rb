Game.create!()
2.times do 
    Game.first.teams.create!(score: 0)
end

@questions = { "0" => {text: "How old are you?", points: 100, grade: 6}, 
                "1" => {text: "What sports do you like?", points: 100, grade: 6},
                "2" => {text: "What is your name?", points: 200, grade: 6},
                "3" => {text: "What sport can you play?", points: 200, grade: 6},
                "4" => {text: "When is your birthday?", points: 300, grade: 6},
                "5" => {text: "When do you play sports?", points: 300, grade: 6}}
@questions.each do |key, value|
    Game.first.questions.create!(value)
end