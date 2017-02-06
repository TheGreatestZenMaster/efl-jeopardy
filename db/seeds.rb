Game.create!()
2.times do 
    Game.first.teams.create!()
end