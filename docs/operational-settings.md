Operational settings affect how `HttpCommand` behaves.

## Instance settings

### `KeepAlive`

|--|--|
|Description|A Boolean which indicates whether `HttpCommand` close the client connection after receiving the response from the host.<ul><li>`1` = keep connection alive</li><li>`0` = close connection</li></ul>|
|Default|`1`|
|Example(s)|`h.KeepAlive←0 ⍝ close the connection`|
|Details|`KeepAlive` is only applicable when you persist an instance of `HttpCommand` and has no effect when you use the shortcut methods `Get`, `GetJSON`, or `Do` as these methods destroy the `HttpCommand` instance they create when they finish execution. HTTP version 1.1 specifies that connections should be kept alive to improve throughput. Nevertheless, a host may close the connection after sending the response or after a period of inactivity from the client (`HttpCommand`). If the connection is closed, `HttpCommand` will open a new connection on a subsequent request.|

### `MaxPayloadSize`

|--|--|
|Description|The maximum response payload size that `HttpCommand` will accept.<ul><li>`¯1` = no maximum</li><li>`≥0` = maximum size</li></ul>|
|Default|`¯1`|
|Example(s)|`h.MaxPayloadSize←100000 ⍝ set a 100,000 byte limit`|
|Details|If `MaxPayloadSize` is set to a value `≥0` and the response contains a payload, `HttpCommand` checks the payload size as follows:
<ul><li>If the response contains a `content-length` header, its value is compared to `MaxPayloadSize`. If exceeded, `HttpCommand` will return with a return code of `¯1` and no payload.</li><li>Otherwise, the response payload is sent in chunks and `HttpCommand` will accumulate each chunk and compare the total payload size to `MaxPayloadSize`. If exceeded, `HttpCommand` will return with a return code of `¯1` and whatever payload has been accumulated.</li></ul>In either case, if `MaxPayloadSize` is exceeded, the client connection will be closed.|

### `MaxRedirections`

|--|--|
|Description|The maximum number of redirections that `HttpCommand` will follow.<br/>A setting of `¯1` means there is no limit to the number of redirections followed; exposing the possibility of an infinite redirection loop and eventually a `WS FULL` error. A setting of `0` means no redirections will be followed.|
|Default|`10`|
|Example(s)|`h.MaxRedirections←0 ⍝ do not follow any redirections`|
|Details|If the response HTTP status indicates a redirection (3XX) to another URL, `HttpCommand` will retain information about the current request in the [`Redirections`](./result-response.md#redirections) element of the result namespace and issue a new request to the new URL. `HttpCommand` will do this up to `MaxRedirections` times.|

### `OutFile`

|--|--|
|Description|`OutFile` has up to 2 elements:<ul><li>`[1] `The name of the file or folder to which `HttpCommand` will write the response payload.  If a folder is specified, the file name will be the same as the resource specified in `URL`. </li><li>`[2] `an optional flag indicating:<ul><li>`0` - do not write to an existing, non-empty file (the default)</li><li>`1` - replace the contents, if any, if the file exists</li><li>`2` - append to the file, if it exists</li></ul></li></ul>|
|Default|`'' 0`|
|Example(s)|<pre style="font-family:APL;">      c ← HttpCommand.New ''<br/>      c.URL←'https://www.dyalog.com/uploads/files/student_competition/2022_problems_phase2.pdf'<br/>      c.OutFile←'/tmp/'<br/>      c.Run<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; 399766 bytes written to c:/tmp/2022_problems_phase2.pdf]<br/><br/>      c.OutFile←'/tmp/problems.pdf' 1 ⍝ overwrite existing file<br/>      c.Run<br/>[rc: 0  &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; 399766 bytes written to c:/tmp/problems.pdf]</pre>|
|Details|Output to file is subject to `MaxPayloadSize`.|

### `RequestOnly`

|--|--|
|Description|If set to 1, `HttpCommand` will return the character vector HTTP request that would be sent, instead of actually sending the request.|
|Default|`0`|
|Example(s)|`h.RequestOnly←1`|
|Details|This setting is useful for debugging a request that isn't behaving as you expect.<br/>Setting the optional left argument of shared methods [`Get`](./shortcut-methods.md#get-issue-an-http-get-request), [`GetJSON`](./shortcut-methods.md#getjson-issue-a-request-to-a-json-based-web-service), [`Do`](./shortcut-methods.md#do-issue-a-generic-http-request), or [`New`](./shortcut-methods.md#new-create-a-new-instance-of-httpcommand) to `1` will have the same effect as setting [`RequestOnly`](./operational-settings.md#requestonly) as will the instance method [`Show`](./instance-methods.md#show).|

### `Secret`

|--|--|
|Description|If set to 1 (the default), `HttpCommand` will suppress the display of credentials in the Authorization header, instead replacing them with `&gt;&gt;&gt; Secret setting is 1 &lt;&lt;&lt;`. This applies when using the [`Show`](./instance-methods.md#show) or [`Config`](./instance-methods.md#config) methods or setting [`RequestOnly`](#requestonly) to 1. `Secret` will not affect the request that is actually sent to the host.|
|Default|`1`|
|Example(s)|<pre style="font-family:APL;">      h←HttpCommand.New 'get' 'userid:password@someurl.com'<br/>      h.Show<br/>GET / HTTP/1.1<br/>Host: someurl.com<br/>User-Agent: Dyalog-HttpCommand/5.5.0<br/>Accept: */*<br/>Accept-Encoding: gzip, deflate<br/>Authorization: >>> Secret setting is 1 <<<<br/><br/>      h.Secret←0<br/>      h.Show<br/>GET / HTTP/1.1<br/>Host: someurl.com<br/>User-Agent: Dyalog-HttpCommand/5.5.0<br/>Accept: */*<br/>Accept-Encoding: gzip, deflate<br/>Authorization: Basic dXNlcmlkOnBhc3N3b3Jk<br/></pre>|
|Details|This setting is useful when doing an `HttpCommand` demonstration as it will avoid inadvertently displaying credentials in the APL session.|

### `SuppressHeaders`

|--|--|
|Description|`SuppressHeaders` is a Boolean setting indicating whether `HttpCommand` should suppress the generation of its default HTTP headers for the request.<ul><li>`1` - suppress the default headers</li><li>`0` - generate the default headers|
|Default|`0` which means `HttpCommand` will generate its default headers|
|Example(s)|`h.SuppressHeaders←1`|
|Details|`HttpCommand` will only generate headers that you have not specified yourself. `HttpCommand` generates the following default headers:<ul><li>`Host` - the host name in the URL. This header <b>must</b> be supplied.</li><li>`User-Agent: Dyalog-HttpCommand/&lt;version&gt;`</li><li>`Accept: */*` By default, `HttpCommand` will accept any response type</li><li>`Accept-Encoding: gzip, deflate` By default, `HttpCommand` will accept compressed response payloads</li><li>`Authorization` set only if you provide HTTP Basic authentication credentials, or set `Auth` and  `AuthType`</li><li>`Cookie` - any saved cookies applicable to the request.</li><li>`Content-Type` is conditionally set as described [here](./content-types.md)</li></ul>Setting `SuppressHeaders←1` will suppress ALL `HttpCommand`-generated headers which means you will need to specify any necessary request headers yourself.  <br/>Individual headers can be suppressed by using the [`SetHeader`](./instance-methods.md#setheader) instance method and assigning the header a value of `''`.<br/><br/>Note: Conga will always insert a `Content-Length` header for any request that has a payload.|

### `Timeout`

|--|--|
|Description|The number of seconds that `HttpCommand` will count down to wait for a response from the host. If `Timeout` is positive, `HttpCommand` will exit with a return code of 100 (Timeout) if it has not received the complete response from the host before the countdown reaches 0.<br/>If `Timeout` is negative, `HttpCommand` will check if Conga has received any data and if so, will reset the countdown to `|Timeout`.|
|Default|`10`|
|Example(s)|`h.Timeout←30 ⍝ wait up to 30 seconds before timing out`<br/>`h.Timeout←¯30 ⍝ keep waiting as long as any data has arrived in a 30-second window`|
|Details|This is the setting to adjust if your request is timing out. [`WaitTime`](./conga-settings.md#waittime) is an internal setting to adjust how long Conga will wait for a response. See [Timeout and WaitTime](./conga.md#timeout-and-waittime) for more information on the relationship between the `Timeout` and `WaitTime` settings.|

### `TranslateData`

|--|--|
|Description|Set this to `1` to have `HttpCommand` attempt to convert the response payload for the following content types.<ul><li>`'application/json'` - `HttpCommand` will use `⎕JSON`</li><li>`'text/xml'` or `'application/xml'` - `HttpCommand` will use `⎕XML`</li></ul>|
|Default|`0`|
|Example(s)|<pre style="font-family:APL;">      c←HttpCommand.New 'get' 'https://api.github.com/users/dyalog'<br/>      c.TranslateData←0<br/>      50↑(⎕←c.Run).Data<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: 1306]<br/>{"login":"Dyalog","id":4189495,"node_id":"MDEyOk9y<br/>      c.TranslateData←1<br/>      (⎕←c.Run).Data<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: ⍬]<br/>#.[JSON object]</pre>|

## Shared Settings
Shared settings are set in the `HttpCommand` class and are used by all instances of `HttpCommand`.

### `Debug`

|--|--|
|Description|Set `Debug` to 1 to turn off `HttpCommand`'s error trapping. In this case if an error occurs, execution of `HttpCommand` will be suspended.  Set `Debug` to 2 to have `HttpCommand` stop just before sending the request to the host so that you can examine the request and `HttpCommand`'s current state.  Both of these settings can be useful for debugging. |
|Default|`0`|
|Example(s)|<pre style="font-family:APL;">      c←HttpCommand.New 'get' 'https://api.github.com/users/dyalog'<br/>      c.OutFile←0 ⍝ invalid setting for OutFile<br/>      c.Debug←1<br/>      c.Run<br/>DOMAIN ERROR: Invalid file or directory name<br/>HttpCmd[130] outFile←∊1 ⎕NPARTS outFile<br/>                        ∧<br/><br/>      c.Debug←0<br/>      c.Run<br/>[rc: ¯1 &#124; msg: DOMAIN ERROR while trying to initialize output file '0' &#124; HTTP Status:  "" &#124; ⍴Data: 0]</pre>|