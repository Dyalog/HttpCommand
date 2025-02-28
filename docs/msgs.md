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

|--|--|
|Message|`Unexpected {ERROR} at {location}`|
|Description|You should rarely, if ever, see this message.  It is returned when an error occurred that wasn't anticipated or otherwise handled.|
|Resolution|Try to find a consistently reproducible example and contact Dyalog support.|

|--|--|
|Message|`Invalid HttpCommand setting(s): {setting name(s)}`|
|Description|You passed a namespace argument `New`, `Get`, `GetJSON`, or `Do` or as a constructor argument to `⎕NEW` and that namespace contained named elements that are not valid `HttpCommand` setting names.|
|Resolution|Remove the named elements that are not `HttpCommand` setting names.|

|--|--|
|Message|`Stopped for debugging... (Press Ctrl-Enter)`|
|Description|This message is not returned in the result namespace, but is displayed when you have set `Debug←2` and `HttpCommand` has stopped intentionally just prior to establishing the connection to the host.  |
|Resolution|Pressing Ctrl-Enter will open the debugger and trace into `HttpCommand`. Entering `→⎕LC+1` will resume execution.|

#### Non-Conga Setting Messages
These messages report problems with settings that prevent `HttpCommand` from creating a proper HTTP request to send to the host. 

|--|--|
|Message|`No URL specified`|
|Description|You didn't specify a `URL` setting.|
|Resolution|Specify a valid [`URL`](./request-settings.md#url).|

|--|--|
|Message|`URL is not a simple character vector`|
|Description|The `URL` setting isn't a simple character vector.|
|Resolution|Make sure `URL` isn't nested or non-character.|

|--|--|
|Message|`Invalid host/port: {host}`|
|Description|You specified a URL that has a hostname followed by a colon (`':'`) followed by something that does not parse as an integer.  For example: `'dyalog.com:ducky'`|
|Resolution|Correct (or omit) the bad port specification.|

|--|--|
|Message|`No host specified`|
|Description|`HttpCommand` couldn't find a host in the `URL` setting.|
|Resolution|Ensure your `URL` conforms to the [specification](./request-settings.md#url).|

|--|--|
|Message|`Invalid port: {port}`|
|Description|The port you specified is not in the range 1-63535.|
|Resolution|Specify an integer port number in the range 1-65535.|

|--|--|
|Message|`Invalid protocol: {protocol}`|
|Description|`HttpCommand` thinks you've specified a protocol other than `'http://'` or `'https://`.|
|Resolution|`HttpCommand` supports only the HTTP and HTTPS protocols. If you have not specified the protocol in your `URL` setting, `HttpCommand` will default to use HTTP. HTTPS will be used if you've specified either the default secure port (443) or supplied certificate information.|

|--|--|
|Message|`Cookies are not character`|
|Description|`Cookies` are specified as [name/value pairs](./request-settings.md#namevalue-pairs). All of the names and values need to be character.|
|Resolution|Make sure `Cookies` names and values are character.|

|--|--|
|Message|`Headers are not character`|
|Description|`Headers` may be specified as [name/value pairs](./request-settings.md#namevalue-pairs). All of the names and values need to be character.|
|Resolution|Make sure `Headers` names and values are character.|

|--|--|
|Message|`Improper header format`|
|Description|You used a value for `Headers` that did not conform to one of the formats described in the [`Headers`](./request-settings.md#headers) specification.|
|Resolution|Ensure that `Headers` conforms to the specification|

|--|--|
|Message|`Output file folder {foldername} does not exist.`|
|Description|The folder in your {OutFile} setting does not exist. `HttpCommand` will create the output file, if necessary, in an existing folder but `HttpCommand` will not create a new folder.|
|Resolution|Either create the folder or change the `OutFile` setting.|

|--|--|
|Message|`No filename specified in OutFile or URL`|
|Description|If you do not specify a file name in `OutFile`, `HttpCommand` will attempt to use the file name specified in `URL`. However, if there is also no file name in `URL`, you will receive this message.|
|Resolution|Specify a file name in either `OutFile` or `URL`.|

|--|--|
|Message|`Output file "{OutFile}" is not empty`|
|Description|You specified the name of an existing, non-empty, file in [`OutFile`](./operational-settings.md#outfile) but did not specify to overwrite or append to the file.|
|Resolution|Either specify a filename of a file that doesn't exist or is empty, or specify that the file is to be overwritten or appended to.|

#### Conga Setting Messages
The messages in this section are related to the Conga settings in `HttpCommand`, not the actual execution of Conga code whose messages  are described in ["Conga Execution"-Related Messages](#conga-execution-messages).

|--|--|
|Message|`CongaRef {CongaRef} does not point to a valid instance of Conga`|
|Description|You specified a `CongaRef` setting that is not the name of, or a reference to, the `Conga` or the `DRC`namespace.|
|Resolution|Check that `CongaRef` is actually the name of, or a reference to, the `Conga` or the `DRC`namespace.|

|--|--|
|Message|`{location}.{namespace} does not point to a valid instance of Conga`|
|Description|`HttpCommand` searches for the Conga API according to [these rules](./conga.md#default-behavior) and found a namespace named either `Conga` or `DRC`, but that namespace is not a valid Conga namespace.|
|Resolution|Either set `CongaRef` to point to a proper `Conga` or `DRC` namespace, or remove/rename the offending namespace.|

|--|--|
|Message|`CongaPath "{CongaPath}" does not exist`|
|Description|You specified a `CongaPath` that could not be found.|
|Resolution|Set `CongaPath` to the name of an existing folder containing the Conga shared libraries, or do not set `CongaPath` and let `HttpCommand` use the Dyalog installation folder.|

|--|--|
|Message|`CongaPath "{CongaPath}" is not a folder`|
|Description|You specified a `CongaPath` that exists, but is not a folder.|
|Resolution|Set `CongaPath` to the name of an existing folder containing the Conga shared libraries, or do not set `CongaPath` and let `HttpCommand` use the Dyalog installation folder.|

|--|--|
|Message|`{Conga API} was copied from {path}, but is not valid`|
|Description|`HttpCommand` was able to copy either the `Conga` or the `DRC` namespace according to the procedure described in Conga [Default Behavior](./conga.md#default-behavior), but the namespace was not a valid Conga API.|
|Resolution|Ensure that conga workspace from which `HttpCommand` attempted to copy the Conga API is proper and the same version as the shared libraries.  See [Integrating `HttpCommand`](./integrating.md).|

|--|--|
|Message|`Neither Conga nor DRC were successfully copied`|
|Description|`HttpCommand` was unable to copy either the `Conga` or the `DRC` namespace according to the procedure described in Conga [Default Behavior](./conga.md#default-behavior).|
|Resolution|The most likely cause is that there is no conga workspace in the paths from which `HttpCommand` tried to copy. See [Integrating `HttpCommand`](./integrating.md).|

|--|--|
|Message|`Not found PublicCertFile "{PublicCertFile}"`<br/>`Not found PrivateKeyFile "{PrivateKeyFile}"`<br/>`Not found PublicCertFile "{PublicCertFile}" and PrivateKeyFile "{PrivateKeyFile}"`|
|Description|One or both of the file names you specified for `PublicCertFile` and `PrivateKeyFile` does not exist.|
|Resolution|Set `PublicCertFile` and `PrivateKeyFile` to the names of certificate files that actually exist.|

|--|--|
|Message|`PublicCertFile is empty`<br/>`PrivateKeyFile is empty`|
|Description|You have specified one of `PublicCertFile` or `PrivateKeyFile`, but not the other.|
|Resolution|Be sure to set both `PublicCertFile` and `PrivateKeyFile`.|

|--|--|
|Message|`Invalid certificate parameter`|
|Description|You specified a value for `Cert` that is not a valid instance of Conga's `X509` class.|
|Resolution|Make sure that `Cert</cert> is a valid instance of the `X509` class.|

|--|--|
|Message|`Unable to decode PublicCertFile "{PublicCertFile}" as certificate`|
|Description|An error occurred when Conga attempted to use `X509Cert.ReadCertFromFile` with the value you specified for `PublicCertFile`.|
|Resolution|Make sure `PublicCertFile` contains a valid certificate. See the [Conga User Guide](https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf) for more information.|

#### Conga Execution Messages
The messages in this section are returned when Conga returns a non-zero return code, or an unexpected Conga event occurs. If there is a non-zero return code from Conga, it is returned in `rc`.

`HttpCommand` uses Conga's "HTTP" mode, where Conga will parse the response from the host.  Some of the messages occur when the host sends an ill-formed response and Conga cannot parse it as HTTP. The ill-formed data is returned in the `Data` element of `HttpCommand`'s result namespace.

|--|--|
|Message|`Could not initialize Conga due to...`|
|Description|Conga could not be initialized for one of many reasons. The remainder of the message should give some indication as to what the problem was. Examples of problems include:<ul><li>the `Conga` or `DRC` namespace that `HttpCommand` found is not a valid Conga interface.</li><li>the `CongaPath` setting does not point to an existing folder containing the Conga shared libraries.</li><li>`HttpCommand` was unable to find a valid `Conga` or `DRC` namespace and could not copy either from the `conga` workspace.</li></ul>|
|Resolution|The resolution will depend on the circumstances described in the message. The [Conga User Guide](https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf) and/or the [Integrating `HttpCommand`](./integrating.md)section could be helpful here.|

|--|--|
|Message|`Conga client creation failed...`|
|Description|This will occur if Conga is not able to create a client connection to the host. The remainder of the message will indicate the specific Conga error message.|
|Resolution|The resolution will depend on the circumstances described in the message. See the [Conga User Guide](https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf). |

|--|--|
|Message|`Conga could not parse the HTTP response`|
|Description|The response from the host is not a properly formatted HTTP message.|
|Resolution|Inspect the data returned by the host in the `Data` element of the result.|

|--|--|
|Message|`Response payload not completely received`|
|Description|This occurs when `HttpCommand` was able to receive and parse the HTTP headers from the host but, during the receipt of the response payload, an error occurred.|
|Resolution|Attempt the request again. If the error persists, examine the headers and payload data, if any, returned by the host.|

|--|--|
|Message|`Conga error processing your request: {Conga return code} `|
|Description|Conga encountered some error that wasn't otherwise diagnosed or trapped.|
|Resolution|See the [Conga User Guide](https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf) for guidance.|

|--|--|
|Message|`Socket closed by server`|
|Description|During processing of the request, the server unexpectedly closed the connection to `HttpCommand`.|
|Resolution|Check that your request is proper for the host. See the [Troubleshooting](./trouble.md) guide.|

|--|--|
|Message|`Unhandled Conga event type: {Conga event}`|
|Description|This should never occur, but for the sake of paranoia, we coded for the possibility of a Conga event that we didn't anticipate.|
|Resolution|Try to find a consistently reproducible example and contact Dyalog support.|

|--|--|
|Message|`Conga wait error: {Conga return code}`|
|Description|An error occurred while Conga was waiting for a response from the host.|
|Resolution|Re-attempt the request. Examine any data or headers that may have been received for clues.|

|--|--|
|Message|`Could not set DecodeBuffers on Conga client "{Conga client name}": {Conga return code}`|
|Description|This is another error that should never occur.|
|Resolution|Try to find a consistently reproducible example and contact Dyalog support.|

|--|--|
|Message|`Conga failed to parse the response HTTP header`|
|Description|Conga received an HTTPHeader event but was unable to parse the received data as HTTP headers.|
|Resolution|The unparsable data is returned in the `Data` element of the result namespace and may provide insight as to the problem.|

|--|--|
|Message|`Conga failed to parse the response HTTP chunk`|
|Description|Conga received an HTTPChunk event but was unable to parse the received data as an HTTP chunk.|
|Resolution|The unparsable data is returned in the `Data` element of the result namespace and may provide insight as to the problem.|

|--|--|
|Message|`Conga failed to parse the response HTTP trailer`|
|Description|Conga received an HTTPTrailer event but was unable to parse the received data as an HTTP trailer.|
|Resolution|The unparsable data is returned in the `Data` element of the result namespace and may provide insight as to the problem.|

|--|--|
|Message|`Conga error while attempting to send request: {Conga return code}`|
|Description|Conga was able to establish a connection to the host, but encountered an error when attempting to send the HTTP request.|
|Resolution|Examine the request being sent as described in the [Troubleshooting](./trouble.md) guide. The [Conga User Guide](https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf) may also be helpful.|

|--|--|
|Message|`Unable to set EventMode on Conga root`|
|Description|This is another message that should never occur.|
|Resolution|Try to find a consistently reproducible example and contact Dyalog support.|

#### Operational Messages
|--|--|
|Message|`{ERROR} while trying to initialize output file "{OutFile}"`|
|Description|You specified an `OutFile` setting and an error occurred while trying to initialize the file.|
|Resolution|{ERROR} should provide information that will help determine the resolution.|

|--|--|
|Message|`Response header size exceeds BufferSize {BufferSize}`|
|Description|The size of the response's HTTPHeader message exceeded the value set for `BufferSize`.|
|Resolution|`BufferSize` is intended to help counteract maliciously large message headers. If the response headers are expected to be very large, increase the value of `BufferSize`.|

|--|--|
|Message|`Payload length exceeds MaxPayloadSize`|
|Description|The `content-length` header in the response had a value that exceeded the `MaxPayload` setting.|
|Resolution|`MaxPayloadSize` is intended to help counteract maliciously large messages. If the response payload is expected to be very large, increase the value of `MaxPayloadSize`|

|--|--|
|Message|`Request timed out before server responded`|
|Description|The host did not respond within the number of seconds specified in the `Timeout` setting.|
|Resolution|If you expect the host to be slow in responding, increase the magnitude of the `Timeout` setting.|

|--|--|
|Message|`Redirection detected, but no "location" header supplied.`|
|Description|The host responded with a 3XX HTTP status (redirection), but the response did not contain a `location` header indicating where to redirect the request.|
|Resolution|This is a server-side problem.|

|--|--|
|Message|`Too many redirections ({MaxRedirections})`|
|Description|The host sent more 3XX HTTP status responses (redirections) than `MaxRedirections` specified.|
|Resolution|`MaxRedirections` is intended to prevent redirection loops or too many redirection hops. If the redirections are legitimate, increase the value of `MaxRedirections`.|

|--|--|
|Message|`TRANSLATION ERROR occurred during response payload conversion (Data was not converted)`|
|Description|This will occur if the response payload contains an invalid UTF-8 sequence or if you are using a Classic interpreter and the response payload contains characters not found in `⎕AVU`. `Data` will contain the response payload as an unconverted vector of single-byte integers.|
|Resolution|If you're using a Classic interpreter, consider using a Unicode interpreter.  Otherwise try to identify the offending characters/sequences and take appropriate action to remove or amend them.|

|--|--|
|Message|`Could not translate XML payload`|
|Description|If you specify `TranslateData←1` and the response content-type header contains `'text/xml'` or `'application/xml'`, `HttpCommand` will attempt to use `⎕XML` to translate the payload.  If `⎕XML` fails, this message is returned and `rc` is set to `¯2`.|
|Resolution|This is probably due to the response payload containing incorrectly formatted XML. The untranslated payload is returned in the `Data` element of the response namespace.|

|--|--|
|Message|`Could not translate JSON payload`|
|Description|If you specify `TranslateData←1` or use the `GetJSON` shared method and the response content-type header contains `'application/json'`, `HttpCommand` will attempt to use `⎕JSON` to translate the payload.  If `⎕JSON` fails, this message is returned and `rc` is set to `¯2`.|
|Resolution|This is probably due to the response payload containing incorrectly formatted JSON. The untranslated payload is returned in the `Data` element of the response namespace.|

|--|--|
|Message|`Response content-type is not application/json`|
|Description|You used `GetJSON` and the response content-type header is not `'application/json'`. `rc` is set to `¯2` and `Data` contains the response payload.|
|Resolution|`GetJSON` expects the response content-type to be `'application/json'`.  If the host is expected to return some other content-type, consider using a method other than `GetJSON`.|

#### Informational Messages
These messages are issued to inform you that, while there was no actual error, 

|--|--|
|Message|`Connection properties changed, connection reset`|
|Description|Unless otherwise specified, an instance of `HttpCommand` will attempt to keep the connection for the last request open. If any of the connection properties change on a subsequent request, the old connection closed and a new connection is established.|
|Resolution|No resolution necessary.|

|--|--|
|Message|`Unhandled content-encoding: {content-encoding}`|
|Description|This message occurs if the response's content-encoding header is something other than `'gzip'` or `'deflate'`.It is intended to inform you that `HttpCommand` did not automatically decode the payload.|
|Resolution|Your application will need to decode the payload.|

### Other Messages
These messages are not found in the `msg` element of result namespace, but are issued when using other features of `HttpCommand`.
 
|--|--|
|Message|`Could not ⎕FIX file: {ERROR}{: Message}`|
|Description|The `Fix` method was not able to `⎕FIX` the file content returned as the response payload.|
|Resolution|Ensure that the requested file contains `⎕FIX`-able contents.|

|--|--|
|Message|`Could not ⎕FIX new HttpCommand: {ERROR}{: Message}`|
|Description|The `Upgrade` method was not able to `⎕FIX` a newer `HttpCommand`.|
|Resolution|See [`Upgrade`](./misc-methods.md#upgrade).  If the problem persists, contact Dyalog support.|

|--|--|
|Message|`Upgraded to {new-version} from {old-version}`|
|Description|The `Upgrade` method was able to `⎕FIX` a newer version of `HttpCommand`.|
|Resolution|See [`Upgrade`](./misc-methods.md#upgrade).|

|--|--|
|Message|`Already using the most current version {version}`|
|Description|The `Upgrade` method did not find a newer version of `HttpCommand`.|
|Resolution|See [`Upgrade`](./misc-methods.md#upgrade).| 