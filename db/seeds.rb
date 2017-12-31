require 'securerandom' 
require 'faker'

ADMIN_EMAIL = 'admin@peatio.dev'
ADMIN_PASSWORD = 'Pass@word8'

admin_identity = Identity.find_or_create_by(email: ADMIN_EMAIL)
admin_identity.password = admin_identity.password_confirmation = ADMIN_PASSWORD
admin_identity.is_active = true
admin_identity.save!

admin_member = Member.find_or_create_by(email: ADMIN_EMAIL)
admin_member.authentications.build(provider: 'identity', uid: admin_identity.id)
admin_member.save!

if Rails.env == 'development'
  NORMAL_PASSWORD = 'Pass@word8'

  foo = Identity.create(email: 'foo@peatio.dev', password: NORMAL_PASSWORD, password_confirmation: NORMAL_PASSWORD, is_active: true)
  foo_member = Member.create(email: foo.email)
  foo_member.authentications.build(provider: 'identity', uid: foo.id)
  foo_member.tag_list.add 'vip'
  foo_member.tag_list.add 'hero'
  foo_member.save

  bar = Identity.create(email: 'bar@peatio.dev', password: NORMAL_PASSWORD, password_confirmation: NORMAL_PASSWORD, is_active: true)
  bar_member = Member.create(email: bar.email)
  bar_member.authentications.build(provider: 'identity', uid: bar.id)
  bar_member.tag_list.add 'vip'
  bar_member.tag_list.add 'hero'
  bar_member.save
end

=begin
ADMIN_EMAIL = 'admin@peatio.dev'
ADMIN_PASSWORD = 'Pass@word8'

admin_identity = Identity.find_or_create_by(email: ADMIN_EMAIL)
admin_identity.password = admin_identity.password_confirmation = ADMIN_PASSWORD
admin_identity.is_active = true
admin_identity.save!

admin_member = Member.find_or_create_by(email: ADMIN_EMAIL)
admin_member.authentications.build(provider: 'identity', uid: admin_identity.id)
admin_member.save!

if Rails.env == 'development'
  NORMAL_PASSWORD = 'Pass@word8'

  foo = Identity.create(email: 'foo@peatio.dev', password: NORMAL_PASSWORD, password_confirmation: NORMAL_PASSWORD, is_active: true)
  foo_member = Member.create(email: foo.email)
  foo_member.authentications.build(provider: 'identity', uid: foo.id)
  foo_member.tag_list.add 'vip'
  foo_member.tag_list.add 'hero'
  foo_member.save

  bar = Identity.create(email: 'bar@peatio.dev', password: NORMAL_PASSWORD, password_confirmation: NORMAL_PASSWORD, is_active: true)
  bar_member = Member.create(email: bar.email)
  bar_member.authentications.build(provider: 'identity', uid: bar.id)
  bar_member.tag_list.add 'vip'
  bar_member.tag_list.add 'hero'
  bar_member.save
end
=end
#create n random news articles
Newsarticle.all.destroy_all

BODY_RAW = "People are 'underestimating' bitcoin and it has 'great potential left,' billionaire investor Peter Thiel said on Thursday. 
</br>
Speaking at the Future Investment Initiative in Riyadh, Saudi Arabia, Thiel compared the cryptocurrency bitcoin to gold.
</br>
'I'm skeptical of most of them (cryptocurrencies), I do think people are a little bit … underestimating bitcoin especially because ... it's like a reserve form of money, it's like gold, and it's just a store of value. You don't need to use it to make payments,' Thiel said.
</br>
'If bitcoin ends up being the cyber equivalent of gold it has a great potential left.'
</br>
There has been rising interest in bitcoin this year. The cryptocurrency recently hit a new record high above $6,100 and has rallied over 500 percent this year.
</br>
Thiel said that bitcoin is based on the 'security of the math' which means it can't be hacked and it's secure. The PayPal founder and venture capitalist compared some of bitcoin's features to gold."


@n = 100
for @i in (1..@n) do
  @title = "Bitcoin potential about $10k " + @i.to_s 
  @title_modified = @title.split(' ').join('-')
  @body_raw = BODY_RAW + " " + @i.to_s
  @published_first_at = Time.now
  @status = ["Active", "Paused"].sample
  
  @article = Newsarticle.new 
  @article.title = @title
  @article.title_modified = @title_modified
  @article.body_raw = @body_raw
  @article.published_first_at = @published_first_at
  @article.status = @status
  @article.author_id = 1  

  @article.save
  if @i % 10 == 0 then puts @i.to_s + " news articles saved." end
end






