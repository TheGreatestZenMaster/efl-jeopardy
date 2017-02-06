class Game < ApplicationRecord
    has_many :questions
    has_many :teams
    accepts_nested_attributes_for :teams
end
