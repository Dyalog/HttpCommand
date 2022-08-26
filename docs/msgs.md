### `rc` Values 

The value of `rc` may be interpreted as follows:

|Error Type|`rc` Value|Description|
|-|:-:|-|
|No error|`0`|`HttpCommand` was able to format and send the request and receive a response without error.|
|Conga error|`>0`|If `rc` is a positive integer, it is a return code that is signalled by Conga when sending the request and receiving the response. If Conga detects an error at the operating system level, it will return the operating system return code. For instance, 10013 is the Microsoft Windows return code for "port in use".|
|Translation Error|`¯2`|You specified `TranslateData←1` and `HttpCommand` was unable to translate an XML or JSON response payload using `⎕XML` or `⎕JSON` respectively or you used `GetJSON` and response content-type header was not `'application/json'`. | 
|Everything else|`¯1`|This is the generic return code for any error condition that is not signalled by Conga.|

In general if `rc=0` then `msg` will be empty. There are circumstances where `msg` will contain an informational message even if `rc=0`.  These messages are included below.   

In the following message descriptions, items that are enclosed in {} represent the value of that named item.  For instance, {BufferSize} represents the value of the `BufferSize` setting. In many cases, the message text itself is sufficient to explain the condition and its resolution, but we document them nonetheless for completeness. 

### Request-related Messages

#### "Catch All" Messages

<table><tr><td><b>Message</b></td>
<td><code>Unexpected {ERROR} at {location}</code></td></tr>
<tr><td><b>Description</b></td>
<td>You should rarely, if ever, see this message.  It is returned when an error occurred that wasn't anticipated or otherwise handled.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Try to find a consistently reproduceable example and contact Dyalog support.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Invalid HttpCommand setting(s): {setting name(s)}</code></td></tr>
<tr><td><b>Description</b></td>
<td>You passed a namespace argument <code>New</code>, <code>Get</code>, <code>GetJSON</code>, or <code>Do</code> or as a constructor argument to <code>⎕NEW</code> and that namespace contained named elements that are not valid <code>HttpCommand</code> setting names.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Remove the named elements that are not <code>HttpCommand</code> setting names.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Stopped for debugging... (Press Ctrl-Enter)</code></td></tr>
<tr><td><b>Description</b></td>
<td>This message is not returned in the result namespace, but is displayed when you have set <code>Debug←2</code> and <code>HttpCommand</code> has stopped intentionally just prior to establishing the connection to the host.  </td></tr>
<tr><td><b>Resolution</b></td>
<td>Pressing Ctrl-Enter will open the debugger and trace into <code>HttpCommand</code>. Entering <code>→⎕LC+1<code> will resume execution.</td></tr></table>

#### Non-Conga Setting Messages
These messages report problems with settings that prevent `HttpCommand` from creating a proper HTTP request to send to the host. 

<table><tr><td><b>Message</b></td>
<td><code>No URL specified</code></td></tr>
<tr><td><b>Description</b></td>
<td>You didn't specify a <code>URL</code> setting.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Specify a valid <a href="/request-settings#URL"><code>URL</code></a>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>URL is not a simple character vector</code></td></tr>
<tr><td><b>Description</b></td>
<td>The <code>URL</code> setting isn't a simple character vector.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Make sure <code>URL</code> isn't nested or non-character.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Invalid host/port: {host}</code></td></tr>
<tr><td><b>Description</b></td>
<td>You specified a URL that has a hostname followed by a colon (<code>':'</code>) followed by something that does not parse as an integer.  For example: <code>'dyalog.com:ducky'</code></td></tr>
<tr><td><b>Resolution</b></td>
<td>Correct (or omit) the bad port specification.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>No host specified</code></td></tr>
<tr><td><b>Description</b></td>
<td><code>HttpCommand</code> couldn't find a host in the <code>URL</code> setting.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Ensure your <code>URL</code> conforms to the <a href="/request-settings/#url">specification</a>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Invalid port: {port}</code></td></tr>
<tr><td><b>Description</b></td>
<td>The port you specified is not in the range 1-63535.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Specify an integer port number in the range 1-65535.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Invalid protocol: {protocol}</code></td></tr>
<tr><td><b>Description</b></td>
<td><code>HttpCommand</code> thinks you've specified a protocol other than <code>'http://'</code> or <code>'https://</code>.</td></tr>
<tr><td><b>Resolution</b></td>
<td><code>HttpCommand</code> supports only the HTTP and HTTPS protocols. If you have not specified the protocol in your <code>URL</code> setting, <code>HttpCommand</code> will default to use HTTP. HTTPS will be used if you've specified either the default secure port (443) or supplied certificate information.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Cookies are not character</code></td></tr>
<tr><td><b>Description</b></td>
<td><code>Cookies</code> are specified as <a href="/request-settings/#namevalue-pairs">name/value pairs</a>. All of the names and values need to be character.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Make sure <code>Cookies</code> names and values are character.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Headers are not character</code></td></tr>
<tr><td><b>Description</b></td>
<td><code>Headers</code> may be specified as <a href="/request-settings/#namevalue-pairs">name/value pairs</a>. All of the names and values need to be character.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Make sure <code>Headers</code> names and values are character.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Improper header format</code></td></tr>
<tr><td><b>Description</b></td>
<td>You used a value for <code>Headers</code> that did not conform to one of the formats described in the <a href="/request-settings/#headers"><code>Headers</code> specification</a>.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Ensure that <code>Headers</code> conforms to the specification</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Output file folder {foldername} does not exist.</code></td></tr>
<tr><td><b>Description</b></td>
<td>The folder in your {OutFile} setting does not exist. <code>HttpCommand</code> will create the output file, if necessary, in an existing folder but <code>HttpCommand</code> will not create a new folder.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Either create the folder or change the <code>OutFile</code> setting.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>No filename specified in OutFile or URL</code></td></tr>
<tr><td><b>Description</b></td>
<td>If you do not specify a file name in <code>OutFile</code>, <code>HttpCommand</code> will attempt to use the file name specified in <code>URL</code>. However, if there is also no file name in <code>URL</code>, you will receive this message.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Specify a file name in either <code>OutFile</code> or <code>URL</code>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Output file "{OutFile}" is not empty</code></td></tr>
<tr><td><b>Description</b></td>
<td>You specified the name of an existing, non-empty, file in <a href="/operational-settings/#OutFile"><code>OutFile</code></a> but did not specify to overwrite or append to the file.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Either specify a filename of a file that doesn't exist or is empty, or specify that the file is to be overwritten or appended to.</td></tr></table>

#### Conga Setting Messages
The messages in this section are related to the Conga settings in `HttpCommand`, not the actual execution of Conga code whose messages  are described in ["Conga Execution"-Related Messages](#conga-execution-related-errors).

<table><tr><td><b>Message</b></td>
<td><code>CongaRef {CongaRef} does not point to a valid instance of Conga</code></td></tr>
<tr><td><b>Description</b></td>
<td>You specified a <code>CongaRef</code> setting that is not the name of, or a reference to, the <code>Conga</code> or the <code>DRC</code>namespace.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Check that <code>CongaRef</code> is actually the name of, or a reference to, the <code>Conga</code> or the <code>DRC</code>namespace.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>{location}.{namespace} does not point to a valid instance of Conga</code></td></tr>
<tr><td><b>Description</b></td>
<td><code>HttpCommand</code> searches for the Conga API according to <a href="/conga/#default-behavior">these rules</a> and found a namespace named either <code>Conga</code> or <code>DRC</code>, but that namespace is not a valid Conga namespace.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Either set <code>CongaRef</code> to point to a proper <code>Conga</code> or <code>DRC</code> namespace, or remove/rename the offending namespace.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>CongaPath "{CongaPath}" does not exist</code></td></tr>
<tr><td><b>Description</b></td>
<td>You specified a <code>CongaPath</code> that could not be found.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Set <code>CongaPath</code> to the name of an existing folder containing the Conga shared libraries, or do not set <code>CongaPath</code> and let <code>HttpCommand</code> use the Dyalog installation folder.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>CongaPath "{CongaPath}" is not a folder</code></td></tr>
<tr><td><b>Description</b></td>
<td>You specified a <code>CongaPath</code> that exists, but is not a folder.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Set <code>CongaPath</code> to the name of an existing folder containing the Conga shared libraries, or do not set <code>CongaPath</code> and let <code>HttpCommand</code> use the Dyalog installation folder.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>{Conga API} was copied from {path}, but is not valid</code></td></tr>
<tr><td><b>Description</b></td>
<td><code>HttpCommand</code> was able to copy either the <code>Conga</code> or the <code>DRC</code> namespace according to the procedure described in Conga <a href="/conga#default-behavior">Default Behavior</a>, but the namespace was not a valid Conga API.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Ensure that conga workspace from which <code>HttpCommand</code> attempted to copy the Conga API is proper and the same version as the shared libraries.  See <a href="/integrating">Integrating <code>HttpCommand</code></a>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Neither Conga nor DRC were successfully copied</code></td></tr>
<tr><td><b>Description</b></td>
<td><code>HttpCommand</code> was unable to copy either the <code>Conga</code> or the <code>DRC</code> namespace according to the procedure described in Conga <a href="/conga#default-behavior">Default Behavior</a>.</td></tr>
<tr><td><b>Resolution</b></td>
<td>The most likely cause is that there is no conga workspace in the paths from which <code>HttpCommand</code> tried to copy. See <a href="/integrating">Integrating <code>HttpCommand</code></a>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Not found PublicCertFile "{PublicCertFile}"</code><br/>
<code>Not found PrivateKeyFile "{PrivateKeyFile}"</code><br/>
<code>Not found PublicCertFile "{PublicCertFile}" and PrivateKeyFile "{PrivateKeyFile}"</code></td></tr>
<tr><td><b>Description</b></td>
<td>One or both of the file names you specified for <code>PublicCertFile</code> and <code>PrivateKeyFile</code> does not exist.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Set <code>PublicCertFile</code> and <code>PrivateKeyFile</code> to the names of certificate files that actually exist.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>PublicCertFile is empty</code><br/>
<code>PrivateKeyFile is empty</code></td></tr>
<tr><td><b>Description</b></td>
<td>You have specified one of <code>PublicCertFile</code> or <code>PrivateKeyFile</code>, but not the other.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Be sure to set both <code>PublicCertFile</code> and <code>PrivateKeyFile</code>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Invalid certificate parameter</code></td></tr>
<tr><td><b>Description</b></td>
<td>You specified a value for <code>Cert</code> that is not a valid instance of Conga's <code>X509</code> class.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Make sure that <code>Cert</cert> is a valid instance of the <code>X509</code> class.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Unable to decode PublicCertFile "{PublicCertFile}" as certificate</code></td></tr>
<tr><td><b>Description</b></td>
<td>An error occurred when Conga attempted to use <code>X509Cert.ReadCertFromFile</code> with the value you specified for <code>PublicCertFile</code>.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Make sure <code>PublicCertFile</code> contains a valid certificate. See the <a href="https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf">Conga User Guide</a> for more information.</td></tr></table>

#### Conga Execution Messages
The messages in this section are returned when Conga returns a non-zero return code, or an unexpected Conga event occurs. If there is a non-zero return code from Conga, it is returned in `rc`.

`HttpCommand` uses Conga's "HTTP" mode, where Conga will parse the response from the host.  Some of the messages occur when the host sends an ill-formed response and Conga cannot parse it as HTTP. The ill-formed data is returned in the `Data` element of `HttpCommand`'s result namespace.

<table><tr><td><b>Message</b></td>
<td><code>Could not initialize Conga due to...</code></td></tr>
<tr><td><b>Description</b></td>
<td>Conga could not be initialized for one of many reasons. The remainder of the message should give some indication as to what the problem was. Examples of problems include:
<ul>
<li>the <code>Conga</code> or <code>DRC</code> namespace that <code>HttpCommand</code> found is not a valid Conga interface.</li>
<li>the <code>CongaPath</code> setting does not point to an existing folder containing the Conga shared libraries.</li>
<li><code>HttpCommand</code> was unable to find a valid <code>Conga</code> or <code>DRC</code> namespace and could not copy either from the <code>conga</code> workspace.</li>
</ul></td></tr>
<tr><td><b>Resolution</b></td>
<td>The resolution will depend on the circumstances described in the message. The <a href="https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf">Conga User Guide</a> and/or the <a href="/integrating">Integrating <code>HttpCommand</code></a>section could be helpful here.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Conga client creation failed...</code></td></tr>
<tr><td><b>Description</b></td>
<td>This will occur if Conga is not able to create a client connection to the host. The remainder of the message will indicate the specific Conga error message.</td></tr>
<tr><td><b>Resolution</b></td>
<td>The resolution will depend on the circumstances described in the message. See the <a href="https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf">Conga User Guide</a>. </td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Conga could not parse the HTTP response</code></td></tr>
<tr><td><b>Description</b></td>
<td>The response from the host is not a properly formatted HTTP message.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Inspect the data returned by the host in the <code>Data</code> element of the result.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Response payload not completely received</code></td></tr>
<tr><td><b>Description</b></td>
<td>This occurs when <code>HttpCommand</code> was able to receive and parse the HTTP headers from the host but, during the receipt of the response payload, an error occurred.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Attempt the request again. If the error persists, examine the headers and payload data, if any, returned by the host.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Conga error processing your request: {Conga return code} </code></td></tr>
<tr><td><b>Description</b></td>
<td>Conga encountered some error that wasn't otherwise diagnosed or trapped.</td></tr>
<tr><td><b>Resolution</b></td>
<td>See the <a href="https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf">Conga User Guide</a> for guidance.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Socket closed by server</code></td></tr>
<tr><td><b>Description</b></td>
<td>During processing of the request, the server unexpectedly closed the connection to <code>HttpCommand</code>.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Check that your request is proper for the host. See the <a href="/trouble">Troubleshooting</a> guide.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Unhandled Conga event type: {Conga event}</code></td></tr>
<tr><td><b>Description</b></td>
<td>This should never occur, but for the sake of paranoia, we coded for the possibility of a Conga event that we didn't anticipate.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Try to find a consistently reproduceable example and contact Dyalog support.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Conga wait error: {Conga return code}</code></td></tr>
<tr><td><b>Description</b></td>
<td>An error occurred while Conga was waiting for a response from the host.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Re-attempt the request. Examine any data or headers that may have been received for clues.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Could not set DecodeBuffers on Conga client "{Conga client name}": {Conga return code}</code></td></tr>
<tr><td><b>Description</b></td>
<td>This is another error that should never occur.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Try to find a consistently reproduceable example and contact Dyalog support.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Conga failed to parse the response HTTP header</code></td></tr>
<tr><td><b>Description</b></td>
<td>Conga received an HTTPHeader event but was unable to parse the received data as HTTP headers.</td></tr>
<tr><td><b>Resolution</b></td>
<td>The unparseable data is returned in the <code>Data</code> element of the result namespace and may provide insight as to the problem.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Conga failed to parse the response HTTP chunk</code></td></tr>
<tr><td><b>Description</b></td>
<td>Conga received an HTTPChunk event but was unable to parse the received data as an HTTP chunk.</td></tr>
<tr><td><b>Resolution</b></td>
<td>The unparseable data is returned in the <code>Data</code> element of the result namespace and may provide insight as to the problem.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Conga failed to parse the response HTTP trailer</code></td></tr>
<tr><td><b>Description</b></td>
<td>Conga received an HTTPTrailer event but was unable to parse the received data as an HTTP trailer.</td></tr>
<tr><td><b>Resolution</b></td>
<td>The unparseable data is returned in the <code>Data</code> element of the result namespace and may provide insight as to the problem.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Conga error while attempting to send request: {Conga return code}</code></td></tr>
<tr><td><b>Description</b></td>
<td>Conga was able to establish a connection to the host, but encountered an error when attempting to send the HTTP request.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Examine the request being sent as described in the <a href="/trouble">Troubleshooting</a> guide. The <a href="https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf">Conga User Guide</a> may also be helpful.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Unable to set EventMode on Conga root</code></td></tr>
<tr><td><b>Description</b></td>
<td>This is another message that should never occur.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Try to find a consistently reproduceable example and contact Dyalog support.</td></tr></table>

#### Operational Messages
<table><tr><td><b>Message</b></td>
<td><code>{ERROR} while trying to initialize output file "{OutFile}"</code></td></tr>
<tr><td><b>Description</b></td>
<td>You specified an <code>OutFile</code> setting and an error occured while trying to initialize the file.</td></tr>
<tr><td><b>Resolution</b></td>
<td>{ERROR} should provide information that will help determine the resolution.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Response header size exceeds BufferSize {BufferSize}</code></td></tr>
<tr><td><b>Description</b></td>
<td>The size of the response's HTTPHeader message exceeded the value set for <code>BufferSize</size>.</td></tr>
<tr><td><b>Resolution</b></td>
<td><code>BufferSize</code> is intended to help counteract maliciously large message headers. If the response headers are expected to be very large, increase the value of <code>BufferSize</code>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Payload length exceeds MaxPayloadSize</code></td></tr>
<tr><td><b>Description</b></td>
<td>The <code>content-length</code> header in the response had a value that exceeded the <code>MaxPayload</code> setting.</td></tr>
<tr><td><b>Resolution</b></td>
<td><code>MaxPayloadSize</code> is intended to help counteract maliciously large messages. If the response payload is expected to be very large, increase the value of <code>MaxPayloadSize</code></td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Request timed out before server responded</code></td></tr>
<tr><td><b>Description</b></td>
<td>The host did not respond within the number of seconds specified in the <code>Timeout</code> setting.</td></tr>
<tr><td><b>Resolution</b></td>
<td>If you expect the host to be slow in responding, increase the magnitude of the <code>Timeout</code> setting.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Redirection detected, but no "location" header supplied.</code></td></tr>
<tr><td><b>Description</b></td>
<td>The host responded with a 3XX HTTP status (redirection), but the response did not contain a <code>location</code> header indicating where to redirect the request.</td></tr>
<tr><td><b>Resolution</b></td>
<td>This is a server-side problem.</td></tr></table>


<table><tr><td><b>Message</b></td>
<td><code>Too many redirections ({MaxRedirections})</code></td></tr>
<tr><td><b>Description</b></td>
<td>The host sent more 3XX HTTP status responses (redirections) than <code>MaxRedirections</code> specified.</td></tr>
<tr><td><b>Resolution</b></td>
<td><code>MaxRedirections</code> is intended to prevent redirection loops or too many redirection hops. If the redirections are legitimate, increase the value of <code>MaxRedirections</code>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Could not translate XML payload</code></td></tr>
<tr><td><b>Description</b></td>
<td>If you specify <code>TranslateData←1</code> and the response content-type header contains <code>'text/xml'</code> or <code>'application/xml'</code>, <code>HttpCommand</code> will attempt to use <code>⎕XML</code> to translate the payload.  If <code>⎕XML</code> fails, this message is returned and <code>rc</code> is set to <code>¯2</code>.</td></tr>
<tr><td><b>Resolution</b></td>
<td>This is probably due to the response payload containing incorrectly formatted XML. The untranslated payload is returned in <code>Data</code>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Could not translate JSON payload</code></td></tr>
<tr><td><b>Description</b></td>
<td>If you specify <code>TranslateData←1</code> or use the <code>GetJSON</code> shared method and the response content-type header contains <code>'application/json'</code>, <code>HttpCommand</code> will attempt to use <code>⎕JSON</code> to translate the payload.  If <code>⎕JSON</code> fails, this message is returned and <code>rc</code> is set to <code>¯2</code>.</td></tr>
<tr><td><b>Resolution</b></td>
<td>This is probably due to the response payload containing incorrectly formatted JSON. The untranslated payload is returned in <code>Data</code>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Response content-type is not application/json</code></td></tr>
<tr><td><b>Description</b></td>
<td>You used <code>GetJSON</code> and the response content-type header is not <code>'application/json'</code>. <code>rc</code> is set to <code>¯2</code> and <code>Data</code> contains the response payload.</td></tr>
<tr><td><b>Resolution</b></td>
<td><code>GetJSON</code> expects the response content-type to be <code>'application/json'</code>.  If the host is expected to return some other content-type, consider using a method other than <code>GetJSON</code>.</td></tr></table>

#### Informational Messages
These messages are issued to inform you that, while there was no actual error, 


<table><tr><td><b>Message</b></td>
<td><code></code></td></tr>
<tr><td><b>Description</b></td>
<td></td></tr>
<tr><td><b>Resolution</b></td>
<td></td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Connection properties changed, connection reset</code></td></tr>
<tr><td><b>Description</b></td>
<td>Unless otherwise specified, an instance of <code>HttpCommand</code> will attempt to keep the connection for the last request open. If any of the connection properties change on a subsequent request, the old connection closed and a new connection is established.</td></tr>
<tr><td><b>Resolution</b></td>
<td>No resolution necessary.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Unhandled content-encoding: {content-encoding}</code></td></tr>
<tr><td><b>Description</b></td>
<td>This message occurs if the response's content-encoding header is something other than <code>'gzip'</code> or <code>'deflate'</code>.It is intended to inform you that <code>HttpCommand</code> did not automatically decode the payload.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Your application will need to decode the payload.</td></tr></table>

### Other Messages
These messages are not found in the <code>msg</code> element of result namespace, but are issued when using other features of <code>HttpCommand</code>.
 
<table><tr><td><b>Message</b></td>
<td><code>Could not ⎕FIX file: {ERROR}{: Message}</code></td></tr>
<tr><td><b>Description</b></td>
<td>The <code>Fix</code> method was not able to <code>⎕FIX</code> the file content returned as the response payload.</td></tr>
<tr><td><b>Resolution</b></td>
<td>Ensure that the requested file contains <code>⎕FIX</code>-able contents.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Could not ⎕FIX new HttpCommand: {ERROR}{: Message}</code></td></tr>
<tr><td><b>Description</b></td>
<td>The <code>Upgrade</code> method was not able to <code>⎕FIX</code> a newer <code>HttpCommand</code>.</td></tr>
<tr><td><b>Resolution</b></td>
<td>See <a href="/misc-methods#upgrade"><code>Upgrade</code></a>.  If the problem persists, contact Dyalog support.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Upgraded to {new-version} from {old-version}</code></td></tr>
<tr><td><b>Description</b></td>
<td>The <code>Upgrade</code> method was able to <code>⎕FIX</code> a newer version of <code>HttpCommand</code>.</td></tr>
<tr><td><b>Resolution</b></td>
<td>See <a href="/misc-methods#upgrade"><code>Upgrade</code></a>.</td></tr></table>

<table><tr><td><b>Message</b></td>
<td><code>Already using the most current version {version}</code></td></tr>
<tr><td><b>Description</b></td>
<td>The <code>Upgrade</code> method did not find a newer version of <code>HttpCommand</code>.</td></tr>
<tr><td><b>Resolution</b></td>
<td>See <a href="/misc-methods#upgrade"><code>Upgrade</code></a>.</td></tr></table> 