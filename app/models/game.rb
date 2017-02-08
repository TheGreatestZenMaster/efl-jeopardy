class Game < ApplicationRecord
    has_many :questions, dependent: :delete_all
    has_many :teams, dependent: :delete_all
    accepts_nested_attributes_for :teams
end
