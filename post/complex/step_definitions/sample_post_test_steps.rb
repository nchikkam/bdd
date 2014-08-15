require 'rest-client'
require 'rspec-expectations'
require 'nokogiri'
# below ones are for bin format 
require 'openssl'
require 'gzip'

When(/^I send a POST request to "(.*?)" with the following text-xml-xml$/) do |url, text-xml-xml|

  inttResponse = RestClient::Request.execute(:method => :post, :url => url,
                                :xml => text-xml-xml, :headers => { :content_type => 'application/xml' })
  
  xml_doc  = Nokogiri::XML(inttResponse)
  
  @reqOneStatusCode = inttResponse.code
  @handShakeMsgsURL = xml_doc.at_xpath("/*/@url").value #xpath
  @apiCode = xml_doc.at_xpath("/*/@apiCode").value  #apiCode needed only for non tpehandShakeL
  
end

Then /^the intSessionResponse should be "([^\"]*)"$/ do |reqOneStatus|
  expect(@reqOneStatusCode.should).to eq reqOneStatus.to_i
  puts "expectation met for reqOneSessionRequest, Continuing to handShake"
end

Then(/^\/\^I should see "(.*?)" in the responseCode if I query "(.*?)" with below handShakexml$/) do |handShakeStatusCode, handShakeSWAServer, handShakexml|

  # replace handShakeserver with the SWA
  modifiedhandShakeMsgsURL = @handShakeMsgsURL
  #modifiedhandShakeMsgsURL[URI(modifiedhandShakeMsgsURL).host] = handShakeSWAServer
  
  handShakeResponse = RestClient::Request.execute(:method => :post, :url => @handShakeMsgsURL,
                                  :xml => handShakexml, :headers => { :content_type => 'application/xml' })
                                  
  @handShakeStatusCode = handShakeResponse.code
  xml_doc  = Nokogiri::XML(handShakeResponse)
  
  expect(@handShakeStatusCode.should).to eq handShakeStatusCode.to_i
  puts "expectation met for handShakeRequest"
end



############################################################################################
# reqOneiating reqOnesession for handShakeMsgs region Search Criteria
############################################################################################
When(/^I send a POST request to "(.*?)" for subsequent handShake region cases with the following text-xml-xml$/) do |url, text-xml-xml|

  inttResponse = RestClient::Request.execute(:method => :post, :url => url,
                                :xml => text-xml-xml, :headers => { :content_type => 'application/xml' })
  
  xml_doc  = Nokogiri::XML(inttResponse)
  
  @reqOneStatusCode = inttResponse.code
  @handShakeMsgsURL = xml_doc.at_xpath("/*/@url").value #xpath
  @apiCode = xml_doc.at_xpath("/*/@apiCode").value  #apiCode needed only for non tpehandShakeL
  
end

Then /^the intSessionResponse for handShake region cases should be "([^\"]*)"$/ do |reqOneStatus|
  expect(@reqOneStatusCode.should).to eq reqOneStatus.to_i
  puts "expectation met for reqOneSessionRequest, Continuing to handShake"
end

# region Cases
Then(/^\/\^I should see "(.*?)" for each response if I query "(.*?)" for region with below longlats in the standard handShakexml$/) do |handShakeHttpStatus, handShakeSWAServer, regionTable|
  table = regionTable.raw
  head = '<?xml version="1.0" encoding="UTF-8" ?> <hand-shake-messages> <places> '
  tail = '</places><feasibility value="47"/><custom-list unit-temp="C"><custom timestamp="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></custom-list></hand-shake-messages>'
  
  # replace handShakeserver with the SWA
  modifiedhandShakeMsgsURL = @handShakeMsgsURL
  #modifiedhandShakeMsgsURL[URI(modifiedhandShakeMsgsURL).host] = handShakeSWAServer
  
  # compose handShakePaylod for every latlong
  for x in 1..table.count-1 #ignore headings
    lat = table[x][0].split(', ')[0]
    lon = table[x][0].split(', ')[1]
    
    handShakexml = head + '<loc lat="'.concat(lat) + '" lon="' + lon + '"/>' + tail
    #puts handShakexml
    
    handShakeResponse = RestClient::Request.execute(:method => :post, :url => @handShakeMsgsURL,
			      :xml => handShakexml, :headers => { :content_type => 'application/xml' })

    handShakeStatusCode = handShakeResponse.code
    xml_doc  = Nokogiri::XML(handShakeResponse)

    expect(handShakeStatusCode.should).to eq handShakeHttpStatus.to_i
    puts "expectation met for handShakeRequest with " + '<loc lat="'.concat(lat) + '" lon="' + lon + '"/>'
  end

end

############################################################################################
# reqOneiating reqOnesession for handShakeMsgs Route Search Criteria
############################################################################################
When(/^I send a POST request to "(.*?)" for subsequent handShake Route case with the following text-xml-xml$/) do |url, text-xml-xml|

  inttResponse = RestClient::Request.execute(:method => :post, :url => url,
                                :xml => text-xml-xml, :headers => { :content_type => 'application/xml' })
  
  xml_doc  = Nokogiri::XML(inttResponse)
  
  @reqOneStatusCode = inttResponse.code
  @handShakeMsgsURL = xml_doc.at_xpath("/*/@url").value #xpath
  @apiCode = xml_doc.at_xpath("/*/@apiCode").value  #apiCode needed only for non tpehandShakeL
  
end

Then /^the intSessionResponse for handShake Route case should be "([^\"]*)"$/ do |reqOneStatus|
  expect(@reqOneStatusCode.should).to eq reqOneStatus.to_i
  puts "expectation met for reqOneSessionRequest, Continuing to handShake"
end

# Route Cases
Then(/^\/\^I should see "(.*?)" in the responseCode if I query "(.*?)" for Route with below longlats in the standard handShakexml$/) do |handShakeHttpStatus, handShakeSWAServer, latlontable|
  table = latlontable.raw
  head = '<?xml version="1.0" encoding="UTF-8" ?> <hand-shake-messages> <places> '
  tail = '</places><feasibility value="47"/><custom-list unit-temp="C"><custom timestamp="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></custom-list></hand-shake-messages>'
  
  # Add Head
  handShakexml = head
  
  # Add latlongs
  for x in 1..table.count-1 #ignore headings
    lat = table[x][0].split(', ')[0]
    lon = table[x][0].split(', ')[1]
    
    handShakexml.concat('<loc lat="'.concat(lat) + '" lon="' + lon + '"/>')
  end
  
  # Add Tail
  handShakexml.concat(tail)
  
  # replace handShakeserver with the SWA
  modifiedhandShakeMsgsURL = @handShakeMsgsURL
  #modifiedhandShakeMsgsURL[URI(modifiedhandShakeMsgsURL).host] = handShakeSWAServer
  handShakeResponse = RestClient::Request.execute(:method => :post, :url => @handShakeMsgsURL,
                                  :xml => handShakexml, :headers => { :content_type => 'application/xml' })
                                    
  handShakeStatusCode = handShakeResponse.code
  xml_doc  = Nokogiri::XML(handShakeResponse)
    
  expect(handShakeStatusCode.should).to eq handShakeHttpStatus.to_i
  puts "expectation met for handShakeRequest"
  
end


###############################################################################################
#   tpehandShakeL API section
###############################################################################################
When(/^I POST a tpehandShakeL API request to "(.*?)" with the following text-xml-xml$/) do |url, text-xml-xml|

  inttResponse = RestClient::Request.execute(:method => :post, :url => url,
                                :xml => text-xml-xml, :headers => { :content_type => 'application/xml' })
  
  xml_doc  = Nokogiri::XML(inttResponse)
  
  @reqOneStatusCode = inttResponse.code
  @handShakeMsgsURL = xml_doc.at_xpath("/*/@url").value #xpath
  @apiCode = xml_doc.at_xpath("/*/@apiCode").value  #apiCode needed only for non tpehandShakeL
  
end

Then /^the intSessionResponse for the tpehandShakeL API requested should be "([^\"]*)"$/ do |reqOneStatus|
  expect(@reqOneStatusCode.should).to eq reqOneStatus.to_i
  #puts "expectation met for reqOneSessionRequest, Continuing to handShake"
end

Then(/^\/\^I should see: "(.*?)" for tpehandShakeL format if I query "(.*?)" with the handShakexml: "(.*?)"$/) do |handShakeHttpStatus, handShakeSWAServer, handShakexml|

  # replace handShakeserver with the SWA
  modifiedhandShakeMsgsURL = @handShakeMsgsURL
  #modifiedhandShakeMsgsURL[URI(modifiedhandShakeMsgsURL).host] = handShakeSWAServer
  
  begin
  	handShakeResponse = RestClient::Request.execute(:method => :post, :url => @handShakeMsgsURL,
	      :xml => handShakexml, :headers => { :content_type => 'application/xml' })
  rescue => e
    handShakeResponse = e.response
  end

  handShakeStatusCode = handShakeResponse.code
  xml_doc  = Nokogiri::XML(handShakeResponse)

  expect(handShakeStatusCode.should).to eq handShakeHttpStatus.to_i
end




# binary format steps


When(/^I send a POST request to "(.*?)" with the following MACHINE_CODE_FORMAT text-xml-xml$/) do |url, text-xml-xml|

  inttResponse = RestClient::Request.execute(:method => :post, :url => url,
                                :xml => text-xml-xml, :headers => { :content_type => 'application/xml' })
  
  xml_doc  = Nokogiri::XML(inttResponse)
  
  @reqOneStatusCode = inttResponse.code
  @handShakeMsgsURL = xml_doc.at_xpath("/*/@url").value #xpath
  @apiCode = xml_doc.at_xpath("/*/@apiCode").value  #apiCode needed only for non tpehandShakeL
  
  #@handShakeMsgsURL['handShakeMsgs'] = 'handShakebti'
  #@handShakeMsgsURL.concat('&regionParam=marketCode01')
  
  puts "--------------------handShake URL--------------------"
  puts @handShakeMsgsURL
  puts "--------------------handShake apiCode--------------------"
  puts @apiCode
  puts "----------------------------------------------------"
  
end

Then /^the intSessionResponse for MACHINE_CODE_FORMAT request should be "([^\"]*)"$/ do |reqOneStatus|
  expect(@reqOneStatusCode.should).to eq reqOneStatus.to_i
  puts "expectation met for reqOneSessionRequest, Continuing to handShake"
end

Then(/^\/\^I should see "(.*?)" in the responseCode if I query "(.*?)" with below encrypted handShakexml$/) do |handShakeHttpStatusCode, handShakeSWAServer, handShakexml|

  modifiedhandShakeMsgsURL = @handShakeMsgsURL
  #modifiedhandShakeMsgsURL[URI(modifiedhandShakeMsgsURL).host] = handShakeSWAServer
  
  zippedMsgBytes = gzip(handShakexml)
  encryptedMsg = alg_encrypt(zippedMsgBytes, @apiCode, "aaaaaaaaaaaaaaaa") #IV Bytes Fixed for the time being - use random numbers later
  
  puts "----------------------actualbyteSequence-start----------------------------------"
  puts encryptedMsg.unpack('c*')
  puts "----------------------actualbyteSequence-end----------------------------------"

  handShakeResponse = RestClient::Request.execute(:method => :post, :url => @handShakeMsgsURL,
                                    :xml => encryptedMsg, :headers => { :content_type => 'application/octet-stream' })

  handShakeStatusCode = handShakeResponse.code
  xml_doc  = Nokogiri::XML(handShakeResponse)
  
  expect(handShakeStatusCode.should).to eq handShakeHttpStatusCode.to_i
  puts "expectation met for handShakeMsgs, Done with the simple case!"

end
#####################################################################
#                 Helper(s) -Start
#####################################################################
def createPrependHeader(headerValue)
    headContent = nil
    headContent = Array.new(3)
    currentValue = headerValue
    	
    for i in 0..3
      headContent[i] = to_byte(currentValue & 0XFF)
      currentValue >>= 8
    end
    headContent
end

def to_byte(num) #keep number in the byte limit
  (num & ~(1 << 7)) - (num & (1 << 7))
end

def gzip(string)
    return string.gzip.unpack('c*')
end

def alg_encrypt(content, apiCode, iv)
	
  head = createPrependHeader(content.size)
  paddedLength = head.size + content.size
  if paddedLength % (2**4) != 0
    nOfBlocks = (paddedLength / 16) + 1
    paddedLength = nOfBlocks * 16
  end
	
  zeros = Array.new(paddedLength-(content.size+head.size), 0)
  cryptInput = head + content + zeros

  ## Actual AES-2**7-CBC encryption  
  dapiCode = decodeapiCode(apiCode)
  aes = OpenSSL::Cipher::Cipher.new("AES-128-CBC")
  aes.encrypt
  aes.padding = 0
  aes.apiCode = dapiCode.pack('c*')
  aes.iv = iv
	
  encrypted = aes.update(cryptInput.pack('C*')) << aes.final
		
  encryptedBytes = encrypted.unpack('c*')  # bytes
  ivBytes = iv.unpack('c*')

  finalEncryptedResult = ivBytes + encryptedBytes
  finalEncryptedResult.pack('c*')
end

def decodeapiCode(apiCode)
  i = 0
  bytes = Array.new(apiCode.size/2)
  p = 0
  while i < apiCode.size
    c = apiCode[i] + apiCode[i+1]
    i = i + 2
    bytes[p] = c.hex
    p = p + 1
  end
  bytes
end
#####################################################################
#                 Helper(s) -End
#####################################################################


############################################################################################
# reqOneiating reqOnesession for handShakeMsgs region Search Criteria - MACHINE_CODE_FORMAT Format
############################################################################################
When(/^I send a POST request to "(.*?)" for subsequent handShake region cases with the following MACHINE_CODE_FORMAT text-xml-xml$/) do |url, text-xml-xml|

  inttResponse = RestClient::Request.execute(:method => :post, :url => url,
                                :xml => text-xml-xml, :headers => { :content_type => 'application/xml' })
  
  xml_doc  = Nokogiri::XML(inttResponse)
  
  @reqOneStatusCode = inttResponse.code
  @handShakeMsgsURL = xml_doc.at_xpath("/*/@url").value #xpath
  @apiCode = xml_doc.at_xpath("/*/@apiCode").value  #apiCode needed only for non tpehandShakeL
  
end

Then /^the intSessionResponse for MACHINE_CODE_FORMAT handShake region cases should be "([^\"]*)"$/ do |reqOneStatus|
  expect(@reqOneStatusCode.should).to eq reqOneStatus.to_i
  puts "expectation met for reqOneSessionRequest, Continuing to handShake"
end

# MACHINE_CODE_FORMAT region Cases
Then(/^\/\^I should see "(.*?)" for each response if I query "(.*?)" for region with below longlats in the standard encrypted handShakexml$/) do |handShakeHttpStatus, handShakeSWAServer, regionTable|
  table = regionTable.raw
    
  # replace handShakeserver with the SWA
  modifiedhandShakeMsgsURL = @handShakeMsgsURL
  #modifiedhandShakeMsgsURL[URI(modifiedhandShakeMsgsURL).host] = handShakeSWAServer
  
  # compose handShakePaylod for every latlong
  for x in 1..table.count-1 #ignore headings
    lat = table[x][0].split(', ')[0]
    lon = table[x][0].split(', ')[1]
    
    encryptedxml = composehandShakexmlInMACHINE_CODE_FORMATFormatForregion(lat, lon)
    #puts encryptedxml.unpack('c*')
    
    handShakeResponse = RestClient::Request.execute(:method => :post, :url => @handShakeMsgsURL,
			      :xml => encryptedxml, :headers => { :content_type => 'application/octet-stream' })

    handShakeStatusCode = handShakeResponse.code
    xml_doc  = Nokogiri::XML(handShakeResponse)

    expect(handShakeStatusCode.should).to eq handShakeHttpStatus.to_i
    puts "expectation met for MACHINE_CODE_FORMAT handShakeRequest for region Case with " + '<loc lat="'.concat(lat) + '" lon="' + lon + '"/>'
  end

end

def composehandShakexmlInMACHINE_CODE_FORMATFormatForregion(lat, lon)
  head = '<?xml version="1.0" encoding="UTF-8" ?> <hand-shake-messages> <places> '
  tail = '</places><feasibility value="47"/><custom-list unit-temp="C"><custom timestamp="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></custom-list></hand-shake-messages>'

  handShakexml = head + '<loc lat="'.concat(lat) + '" lon="' + lon + '"/>' + tail
  
  zipped = gzip(handShakexml)
  encrypted = alg_encrypt(zipped, @apiCode, "aaaaaaaaaaaaaaaa")
end

############################################################################################
# reqOneiating reqOnesession for handShakeMsgs Route Search Criteria - MACHINE_CODE_FORMAT Format
############################################################################################
When(/^I send a POST request to "(.*?)" for subsequent handShake Route case with the following MACHINE_CODE_FORMAT text-xml-xml$/) do |url, text-xml-xml|

  inttResponse = RestClient::Request.execute(:method => :post, :url => url,
                                :xml => text-xml-xml, :headers => { :content_type => 'application/xml' })
  
  xml_doc  = Nokogiri::XML(inttResponse)
  
  @reqOneStatusCode = inttResponse.code
  @handShakeMsgsURL = xml_doc.at_xpath("/*/@url").value #xpath
  @apiCode = xml_doc.at_xpath("/*/@apiCode").value  #apiCode needed only for non tpehandShakeL
  
end

Then /^the intSessionResponse for MACHINE_CODE_FORMAT handShake Route case should be "([^\"]*)"$/ do |reqOneStatus|
  expect(@reqOneStatusCode.should).to eq reqOneStatus.to_i
  puts "expectation met for reqOneSessionRequest, Continuing to handShake"
end

# Route Cases
Then(/^\/\^I should see "(.*?)" in the responseCode if I query "(.*?)" for Route with below longlats in the standard encrypted handShakexml$/) do |handShakeHttpStatus, handShakeSWAServer, latlontable|
  table = latlontable.raw
  
  encryptedMsg = composehandShakexmlInMACHINE_CODE_FORMATFormatForRoute(table)
  #puts encryptedMsg.unpack('c*')
  
  # replace handShakeserver with the SWA
  modifiedhandShakeMsgsURL = @handShakeMsgsURL
  #modifiedhandShakeMsgsURL[URI(modifiedhandShakeMsgsURL).host] = handShakeSWAServer
  handShakeResponse = RestClient::Request.execute(:method => :post, :url => @handShakeMsgsURL,
                                  :xml => encryptedMsg, :headers => { :content_type => 'application/octet-stream' })
                                    
  handShakeStatusCode = handShakeResponse.code
  xml_doc  = Nokogiri::XML(handShakeResponse)
    
  expect(handShakeStatusCode.should).to eq handShakeHttpStatus.to_i
  puts "expectation met for handShakeRequest"
  
end

def composehandShakexmlInMACHINE_CODE_FORMATFormatForRoute(table)
  head = '<?xml version="1.0" encoding="UTF-8" ?> <hand-shake-messages> <places> '
  tail = '</places><feasibility value="47"/><custom-list unit-temp="C"><custom timestamp="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></custom-list></hand-shake-messages>'
  
  # Add Head
  handShakexml = head
  
  # Add latlongs
  for x in 1..table.count-1 #ignore headings
    lat = table[x][0].split(', ')[0]
    lon = table[x][0].split(', ')[1]
    
    handShakexml.concat('<loc lat="'.concat(lat) + '" lon="' + lon + '"/>')
  end
  
  # Add Tail
  handShakexml.concat(tail)
  
  # encrypte the whole handShakexml
  zipped = gzip(handShakexml)
  encrypted = alg_encrypt(zipped, @apiCode, "aaaaaaaaaaaaaaaa")
end


###############################################################################################
#   MACHINE_CODE_FORMAT API section
###############################################################################################
When(/^I POST a MACHINE_CODE_FORMAT API request to "(.*?)" with the following text-xml-xml$/) do |url, text-xml-xml|

  inttResponse = RestClient::Request.execute(:method => :post, :url => url,
                                :xml => text-xml-xml, :headers => { :content_type => 'application/xml' })
  
  xml_doc  = Nokogiri::XML(inttResponse)
  
  @reqOneStatusCode = inttResponse.code
  @handShakeMsgsURL = xml_doc.at_xpath("/*/@url").value #xpath
  @apiCode = xml_doc.at_xpath("/*/@apiCode").value  #apiCode needed only for non tpehandShakeL
  
end

Then /^the intSessionResponse for the MACHINE_CODE_FORMAT API requested should be "([^\"]*)"$/ do |reqOneStatus|
  expect(@reqOneStatusCode.should).to eq reqOneStatus.to_i
  #puts "expectation met for reqOneSessionRequest, Continuing to handShake"
end

Then(/^\/\^I should see: "(.*?)" for MACHINE_CODE_FORMAT format if I query "(.*?)" with the handShakexml: "(.*?)"$/) do |handShakeHttpStatus, handShakeSWAServer, handShakexml|

  # replace handShakeserver with the SWA
  modifiedhandShakeMsgsURL = @handShakeMsgsURL
  #modifiedhandShakeMsgsURL[URI(modifiedhandShakeMsgsURL).host] = handShakeSWAServer
  
  # gzip + encrypt the handShakexml
  zipped = gzip(handShakexml)
  encrypted = alg_encrypt(zipped, @apiCode, "aaaaaaaaaaaaaaaa")
  
  begin
  	handShakeResponse = RestClient::Request.execute(:method => :post, :url => @handShakeMsgsURL,
	      :xml => encrypted, :headers => { :content_type => 'application/octet-stream' })
  rescue => e
    handShakeResponse = e.response
  end

  handShakeStatusCode = handShakeResponse.code
  xml_doc  = Nokogiri::XML(handShakeResponse)

  expect(handShakeStatusCode.should).to eq handShakeHttpStatus.to_i
end