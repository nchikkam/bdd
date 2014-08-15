require 'rest-client'

When(/^I send a POST request to "(.*?)" with the following$/) do |url, body|
  print url
  print "\n"
  print body
  print "\n"
  
  response = RestClient.get url
  #resp = restClient.get(path: url)
  
  print "------------------"
  print response
  print "------------------"
  
end

Then /^the response should be "([^\"]*)"$/ do |status|
  #last_response.status.should == status.to_i
  #print resp
  print
  print status.to_i
  print
end