Then /^I (?:should )?receive a response from the OpenID Server$/ do
  server_request_uri = response.headers['Location']
  hash = openid_request(server_request_uri)
  visit(hash[:url], :get, hash[:query_params])
end
