FactoryBot.define do
  factory :todo do
    title { "Simple Todo Title" }
    user
    created_by {user.id.to_s}
  end
end
