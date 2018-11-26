FactoryBot.define do
  factory :face_off do
    association :loser, factory: :option
    association :winner, factory: :option
    user
  end
end
