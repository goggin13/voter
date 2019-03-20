FactoryBot.define do
  factory :face_off do
    association :loser, factory: :option
    association :winner, factory: :option
    user
    after(:build) do |face_off|
      face_off.list_id = face_off.loser.list_id
    end
  end
end
