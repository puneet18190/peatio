# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsarticle do
    title "MyText"
    title_modified "MyText"
    body_raw "MyText"
    published_first_at "2017-10-21 23:20:45"
    status "MyString"
    author_id 1
  end
end
