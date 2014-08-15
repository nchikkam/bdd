


Feature: Testing POST REST with Cucumber

Scenario: post data to url
When I send a POST request to "google.com" with the following
  """
  abcd
  """
Then the response should be "200"