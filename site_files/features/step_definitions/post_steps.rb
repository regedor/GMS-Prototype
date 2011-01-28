Given /^the following posts? exists?$/ do |table|
  table.hashes.each do |hash|
    Factory.give_me_a_post(hash)
  end
end
