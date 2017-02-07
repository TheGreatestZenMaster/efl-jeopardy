Game.create!()
2.times do 
    Game.first.teams.create!(score: 0)
end

@questions = { "L1.1" => {text: "What animal do you like?", image: nil, points: 10},
                "L2.1" => {text: "What's this?", image: "january.png", points: 10},
                "L3.1" => {text: "What's this?", image: "playsoccer.png", points: 10},
                "L4.1" => {text: "L4", image: nil, points: 10},
                "L5.1" => {text: "L5", image: nil, points: 10},
                
                "L1.2" => {text: "What's this?", image: "bear.jpg", points: 20},
                "L2.2" => {text: "What's this?<br>みっか", image: nil, points: 20},
                "L3.2" => {text: "P11 Who am I quiz", image: nil, points: 20},
                "L4.2" => {text: "L4", image: nil, points: 20},
                "L5.2" => {text: "L5", image: nil, points: 20},
                
                "L1.3" => {text: "What are these?<br>m,n,o", points: 30},
                "L2.3" => {text: "what are these?<br>５月、６月、７月", points: 30},
                "L3.3" => {text: "E -> J:<br>やきゅうができます", points: 30},
                "L4.3" => {text: "L4", points: 30},
                "L5.3" => {text: "L5", points: 30},
                
                "L1.4" => {text: "Count from 40-60", points: 40},
                "L2.4" => {text: "What month is your birthday?", points: 40},
                "L3.4" => {text: "L3?", points: 40},
                "L4.4" => {text: "L4", points: 40},
                "L5.4" => {text: "L5", points: 40},

                "L1.5" => {text: "Say the ABCs", points: 50},
                "L2.5" => {text: "When is your birthday?", points: 50},
                "L3.5" => {text: "L3?", points: 50},
                "L4.5" => {text: "L4", points: 50},
                "L5.5" => {text: "L5", points: 50}}
                
@questions.each do |key, value|
    Game.first.questions.create!(value)
end