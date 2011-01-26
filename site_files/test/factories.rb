# Defines
Factory.define :user do |user|
  user.name     'user'
  user.password 'password'
  user.password_confirmation { |user| user.password }
  user.email {|a| "#{a.first_name}@example.com".downcase }
end

Factory.define :post do |post|
  post.title 'post'
  post.body 'test post'
  post.published_at 'now'  
end

Factory.define :page do |page|
  page.title 'page'
  page.body 'test page'
  page.has_comments true
  page.show_in_menu false
end

class Factory
  def self.give_me_a_user(hash=nil)
    user=Factory(:user, hash)
    user.role_id = 3
    user.activate!
    return user
  end
  def self.give_me_an_admin(hash=nil)
    user=Factory(:user, hash)
    user.role_id = 1
    user.activate!
    return user
  end
  def self.give_me_a_post(hash=nil)
    post=Factory(:post, hash)
    return post
  end
  def self.give_me_a_page(hash=nil)
    page=Factory(:page, hash)
    return page
  end
end
