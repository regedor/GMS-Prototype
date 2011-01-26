Given /^the following pages? exists?$/ do |table|
  table.hashes.each do |hash|
    Factory.give_me_a_page(hash)
  end
end
