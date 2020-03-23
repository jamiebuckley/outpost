FactoryBot.define do
  factory :organisation do
    name { Faker::Lorem.word }

    factory :organisation_with_services do
      name { Faker::Lorem.word }

      after(:create) do |organisation|
        create_list(:service, 5, organisation: organisation)
      end
    end
  end
end