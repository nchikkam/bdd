Feature: MACHINE_CODE_FORMAT Test Scenarios

  Scenario: Verify return Status code for HANDSHAKE_MESSAGES Server MACHINE_CODE_FORMAT Format
    When I send a POST request to "https://myserver-with-some-endpoint-accepting-post-xml-octetstream-payload" with the following MACHINE_CODE_FORMAT text-xml-payload
      """
      <?xml version="1.0" encoding="UTF-8" ?>
        <sample-session>
          <custom-standard format="MACHINE_CODE_FORMAT">
            <sample-code_0 id="ref-format-code_0" version="1.3"/>
            <sample-code_0 id="ref-format-code_1" version="1.0"/>
            <tool id="tool-format-id-0" version="3.0"/>
            <tool id="tool-format-id-1" version="1.0"/>
          </custom-standard>
        <general>
          <parameter name="region-limit" value="25"/>
          <parameter name="session-limit" value="180"/>
          <parameter name="time-limit" value="30"/>
        </general>
        </sample-session>
    """ 
     Then the intSessionResponse for MACHINE_CODE_FORMAT request should be "200"
     Then /^I should see "200" in the responseCode if I query "<%= handshake-server %>" with below encrypted handshakePayload
     """
    <?xml version="1.0" encoding="UTF-8" ?>
      <hand-shake-messages>
     	<places>
     		<loc lat="48.14111" lon="11.56916"/>
     	</places>
     	<feasibility value="47"/>
     	<my-custom-list unit-temp="C">
     		<custom unixtimeformatstring="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/>
     	</my-custom-list>
      </hand-shake-messages>
"""

Scenario: Verify return Status codes for HANDSHAKE_MESSAGES Server - Region Case MACHINE_CODE_FORMAT Format
When I send a POST request to "https://myserver-with-some-endpoint-accepting-post-xml-octetstream-payload" for subsequent handshake Region cases with the following MACHINE_CODE_FORMAT text-xml-payload
  """
  <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  <sample-session>
    <custom-standard format="MACHINE_CODE_FORMAT" messagesize="50000" sessionsize="1000">
      <sample-code_0 id="ref-format-code_0" version="1.3"/>
      <sample-code_0 id="ref-format-code_1" version="1.0"/>
      <tool id="tool-format-id-0" version="3.0"/>
      <tool id="tool-format-id-1" version="1.0" session-limit="17"/>
    </custom-standard>
    <markets current="DE" destination="FR"/>
    <general>
      <parameter name="region-limit" value="1"/>
      <parameter name="session-limit" value="600"/>
      <parameter name="time-limit" value="0"/>
      <parameter name="frequency" value="180"/>
    </general>
  </sample-session>
""" 
 Then the intSessionResponse for MACHINE_CODE_FORMAT handshake Region cases should be "200"
 Then /^I should see "200" for each response if I query "<%= handshake-server %>" for Region with below longlats in the standard encrypted handshakePayload
|latitude, longitude|
|50.47533, 2.52262|
|26.99285, -104.70077|
|25.53983, -103.42725|
|43.8637, 1.87626|
|25.56135, -103.46032|
|47.90735, -4.01071|
|48.84768, 2.45915|
|10.21446, -64.65079|


Scenario: Verify return Status codes for MACHINE_CODE_FORMAT HANDSHAKE_MESSAGES Server - Route Case MACHINE_CODE_FORMAT Format
When I send a POST request to "https://myserver-with-some-endpoint-accepting-post-xml-octetstream-payload" for subsequent handshake Route case with the following MACHINE_CODE_FORMAT text-xml-payload
  """
  <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  <sample-session>
    <custom-standard format="MACHINE_CODE_FORMAT" messagesize="50000" sessionsize="1000">
      <sample-code_0 id="ref-format-code_0" version="1.3"/>
      <sample-code_0 id="ref-format-code_1" version="1.0"/>
      <tool id="tool-format-id-0" version="3.0"/>
      <tool id="tool-format-id-1" version="1.0" session-limit="17"/>
    </custom-standard>
    <markets current="DE" destination="FR"/>
    <general>
      <parameter name="region-limit" value="1"/>
      <parameter name="session-limit" value="600"/>
      <parameter name="time-limit" value="0"/>
      <parameter name="frequency" value="180"/>
    </general>
  </sample-session>
""" 
 Then the intSessionResponse for MACHINE_CODE_FORMAT handshake Route case should be "200"
 Then /^I should see "200" in the responseCode if I query "<%= handshake-server %>" for Route with below longlats in the standard encrypted handshakePayload
|latitude, longitude|
|52.08097, 12.66870|
|52.08184, 12.66977|
|52.08280, 12.67098|
|52.08395, 12.67253|
|52.08805, 12.67829|


Scenario Outline: Verify various API return Status codes for HANDSHAKE_MESSAGES Server for MACHINE_CODE_FORMAT Format
    When I POST a MACHINE_CODE_FORMAT API request to "https://myserver-with-some-endpoint-accepting-post-xml-octetstream-payload" with the following text-xml-payload
      """
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <sample-session>
        <custom-standard format="MACHINE_CODE_FORMAT" messagesize="50000" sessionsize="1000">
          <sample-code_0 id="ref-format-code_0" version="1.3"/>
          <sample-code_0 id="ref-format-code_1" version="1.0"/>
          <tool id="tool-format-id-0" version="3.0"/>
          <tool id="tool-format-id-1" version="1.0" session-limit="17"/>
        </custom-standard>
        <markets current="DE" destination="FR"/>
        <general>
          <parameter name="region-limit" value="1"/>
          <parameter name="session-limit" value="600"/>
          <parameter name="time-limit" value="300"/>
          <parameter name="frequency" value="180"/>
        </general>
      </sample-session>
    """ 
     Then the intSessionResponse for the MACHINE_CODE_FORMAT API requested should be "200"
     Then /^I should see: "<expectedHttpStatusCode>" for MACHINE_CODE_FORMAT format if I query "<%= handshake-server %>" with the handshakePayload: "<handshakePayload>" 
     
Examples:
|testCaseType|handshakePayload|expectedHttpStatusCode|
|misspelled tag|<HANDSHAKE_MESSAGES><places><loc lat="48.14111" lon="11.56916"/></places><feasibility value="47"/><my-custom-list unit-temp="C"><custom unixtimeformatstring="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></my-custom-list> </HANDSHAKE_MESSAGES> |400|
|add parameter|<hand-shake-messages unit="m"><places><loc lat="48.14111" lon="11.56916"/></places><feasibility value="47"/><my-custom-list unit-temp="C"><custom unixtimeformatstring="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></my-custom-list> </hand-shake-messages> |400|
|add parameter|<hand-shake-messages version="01.0"><places><loc lat="48.14111" lon="11.56916"/></places><feasibility value="47"/><my-custom-list unit-temp="C"><custom unixtimeformatstring="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></my-custom-list> </hand-shake-messages> |400|




# Text format cases
Scenario: Verify return Status code for HANDSHAKE_MESSAGES Server
    When I send a POST request to "https://myserver-with-some-endpoint-accepting-post-xml-octetstream-payload" with the following text-xml-payload
      """
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <sample-session>
        <Text_CODE_FORMAT format="Text_CODE_FORMATML" textLimit="50000" userOnPageLimit="1000">
          <sample-code_0 id="ref-format-code_0" version="1.3"/>
          <sample-code_0 id="ref-format-code_1" version="1.0"/>
          <app id="tool-format-id-0" version="3.0"/>
          <app id="tool-format-id-1" version="1.0" session-limit="17"/>
        </Text_CODE_FORMAT>
        <places current="DE" destination="FR"/>
        <general>
          <parameter name="region-limit" value="1"/>
          <parameter name="session-limit" value="600"/>
          <parameter name="time-limit" value="300"/>
          <parameter name="repetition-limit" value="180"/>
        </general>
      </sample-session>
    """ 
     Then the intSessionResponse should be "200"
     Then /^I should see "200" in the responseCode if I query "<%= handshake-server %>" with below handshakePayload
     """
    <?xml version="1.0" encoding="UTF-8" ?>
      <hand-shake-messages>
     	<places>
     		<loc lat="48.14111" lon="11.56916"/>
     	</places>
     	<feasibility value="47"/>
     	<my-custom-list unit-temp="C">
     		<custom timestamp="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/>
     	</my-custom-list>
      </hand-shake-messages>
"""

Scenario: Verify return Status codes for HANDSHAKE_MESSAGES Server - Region Case
When I send a POST request to "https://myserver-with-some-endpoint-accepting-post-xml-octetstream-payload" for subsequent handshake Region cases with the following text-xml-payload
  """
  <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  <sample-session>
    <Text_CODE_FORMAT format="Text_CODE_FORMATML" textLimit="50000" userOnPageLimit="1000">
      <sample-code_0 id="ref-format-code_0" version="1.3"/>
      <sample-code_0 id="ref-format-code_1" version="1.0"/>
      <app id="tool-format-id-0" version="3.0"/>
      <app id="tool-format-id-1" version="1.0" session-limit="17"/>
    </Text_CODE_FORMAT>
    <places current="DE" destination="FR"/>
    <general>
      <parameter name="region-limit" value="1"/>
      <parameter name="session-limit" value="600"/>
      <parameter name="time-limit" value="0"/>
      <parameter name="repetition-limit" value="180"/>
    </general>
  </sample-session>
""" 
 Then the intSessionResponse for handshake Region cases should be "200"
 Then /^I should see "200" for each response if I query "<%= handshake-server %>" for Region with below longlats in the standard handshakePayload
|latitude, longitude|
|50.47533, 2.52262|
|26.99285, -104.70077|
|25.53983, -103.42725|
|43.8637, 1.87626|
|25.56135, -103.46032|
|47.90735, -4.01071|
|48.84768, 2.45915|
|10.21446, -64.65079|
|43.21953, 2.35115|
|48.75126, 1.95847|

Scenario: Verify return Status codes for HANDSHAKE_MESSAGES Server - Route Case
When I send a POST request to "https://myserver-with-some-endpoint-accepting-post-xml-octetstream-payload" for subsequent handshake Route case with the following text-xml-payload
  """
  <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  <sample-session>
    <Text_CODE_FORMAT format="Text_CODE_FORMATML" textLimit="50000" userOnPageLimit="1000">
      <sample-code_0 id="ref-format-code_0" version="1.3"/>
      <sample-code_0 id="ref-format-code_1" version="1.0"/>
      <app id="tool-format-id-0" version="3.0"/>
      <app id="tool-format-id-1" version="1.0" session-limit="17"/>
    </Text_CODE_FORMAT>
    <places current="DE" destination="FR"/>
    <general>
      <parameter name="region-limit" value="1"/>
      <parameter name="session-limit" value="600"/>
      <parameter name="time-limit" value="0"/>
      <parameter name="repetition-limit" value="180"/>
    </general>
  </sample-session>
""" 
 Then the intSessionResponse for handshake Route case should be "200"
 Then /^I should see "200" in the responseCode if I query "<%= handshake-server %>" for Route with below longlats in the standard handshakePayload
|latitude, longitude|
|52.08097, 12.66870|
|52.08184, 12.66977|
|52.08280, 12.67098|
|52.08395, 12.67253|
|52.08805, 12.67829|
|52.09056, 12.68181|
|52.09215, 12.68404|
|52.09299, 12.68542|
|52.09373, 12.68673|
|52.09563, 12.69050|



Scenario Outline: Verify various API return Status codes for HANDSHAKE_MESSAGES Server for Text_CODE_FORMATML Format
    When I POST a Text_CODE_FORMATML API request to "https://myserver-with-some-endpoint-accepting-post-xml-octetstream-payload" with the following text-xml-payload
      """
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <sample-session>
        <Text_CODE_FORMAT format="Text_CODE_FORMATML" textLimit="50000" userOnPageLimit="1000">
          <sample-code_0 id="ref-format-code_0" version="1.3"/>
          <sample-code_0 id="ref-format-code_1" version="1.0"/>
          <app id="tool-format-id-0" version="3.0"/>
          <app id="tool-format-id-1" version="1.0" session-limit="17"/>
        </Text_CODE_FORMAT>
        <places current="DE" destination="FR"/>
        <general>
          <parameter name="region-limit" value="1"/>
          <parameter name="session-limit" value="600"/>
          <parameter name="time-limit" value="300"/>
          <parameter name="repetition-limit" value="180"/>
        </general>
      </sample-session>
    """ 
     Then the intSessionResponse for the Text_CODE_FORMATML API requested should be "200"
     Then /^I should see: "<expectedHttpStatusCode>" for Text_CODE_FORMATML format if I query "<%= handshake-server %>" with the handshakePayload: "<handshakePayload>" 
     
Examples:
|testCaseType|handshakePayload|expectedHttpStatusCode|
|misspelled tag|<HANDSHAKE_MESSAGES><places><loc lat="48.14111" lon="11.56916"/></places><feasibility value="47"/><my-custom-list unit-temp="C"><custom timestamp="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></my-custom-list> </HANDSHAKE_MESSAGES> |400|
|add parameter|<hand-shake-messages unit="m"><places><loc lat="48.14111" lon="11.56916"/></places><feasibility value="47"/><my-custom-list unit-temp="C"><custom timestamp="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></my-custom-list> </hand-shake-messages> |400|
|add parameter|<hand-shake-messages version="01.0"><places><loc lat="48.14111" lon="11.56916"/></places><feasibility value="47"/><my-custom-list unit-temp="C"><custom timestamp="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></my-custom-list> </hand-shake-messages> |400|
|add parameter|<hand-shake-messages version="1.0"><places><loc lat="48.14111" lon="11.56916"/></places><feasibility value="47"/><my-custom-list unit-temp="C"><custom timestamp="YYYY-MM-DDTHH:MM:SS:ZZZ" lat="48.14111" lon="11.56916" heading="192" velocity="25" temp="18"/></my-custom-list> </hand-shake-messages> |400|
