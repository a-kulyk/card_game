FactoryGirl.define do 
  factory :game do
  	sequence(:name) { |i| "Game_#{i}"}
  	sequence(:description) { |i| "this game_#{i} only for pro gamers"}
  end
end