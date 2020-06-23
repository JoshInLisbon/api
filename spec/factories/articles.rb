FactoryBot.define do
  factory :article do
    # previously - title { "My awesome article" }
    sequence(:title) { |n| "My awesome article #{n}" }
    # do the same for others
    sequence(:content) { |n| "MyText content #{n}" }
    sequence(:slug) { |n| "my-slug-#{n}" }
  end
end
