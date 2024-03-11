Operational settings affect how `HttpCommand` behaves.

## Instance settings

### `KeepAlive`
<table><tr>
<td>Description</td>
<td>A Boolean which indicates whether <code>HttpCommand</code> close the client connection after receiving the response from the host.<ul><li><code>1</code> = keep connection alive</l1><li><code>0</code> = close connection</li></ul></td></tr>
<tr><td>Default</td>
<td><code>1</code></td></tr>
<tr><td>Example(s)</td>
<td><code>h.KeepAlive←0 ⍝ close the connection</code></td></tr>
<tr><td>Details</td>
<td><code>KeepAlive</code> is only applicable when you persist an instance of <code>HttpCommand</code> and has no effect when you use the shortcut methods <code>Get</code>, <code>GetJSON</code>, or <code>Do</code> as these methods destroy the <code>HttpCommand</code> instance they create when they finish execution. HTTP version 1.1 specifies that connections should be kept alive to improve throughput. Nevertheless, a host may close the connection after sending the response or after a period of inactivity from the client (<code>HttpCommand</code>). If the connection is closed, <code>HttpCommand</code> will open a new connection on a subsequent request.</td></tr></table>

### `MaxPayloadSize`
<table><tr>
<td>Description</td>
<td>The maximum response payload size that <code>HttpCommand</code> will accept.<ul><li><code>¯1</code> = no maximum</li><li><code>≥0</code> = maximum size</li></ul></td></tr>
<tr><td>Default</td>
<td><code>¯1</code></td></tr>
<tr><td>Example(s)</td>
<td><code>h.MaxPayloadSize←100000 ⍝ set a 100,000 byte limit</code></td></tr>
<tr><td>Details</td>
<td>If <code>MaxPayloadSize</code> is set to a value <code>≥0</code> and the response contains a payload, <code>HttpCommand</code> checks the payload size as follows:
<ul><li>If the response contains a <code>content-length</code> header, its value is compared to <code>MaxPayloadSize</code>. If exceeded, <code>HttpCommand</code> will return with a return code of <code>¯1</code> and no payload.</li><li>Otherwise, the response payload is sent in chunks and <code>HttpCommand</code> will accumulate each chunk and compare the total payload size to <code>MaxPayloadSize</code>. If exceeded, <code>HttpCommand</code> will return with a return code of <code>¯1</code> and whatever payload has been accumulated.</li></ul>In either case, if <code>MaxPayloadSize</code> is exceeded, the client connection will be closed.</td></tr>
</table>

### `MaxRedirections`
<table><tr>
<td>Description</td>
<td>The maximum number of redirections that <code>HttpCommand</code> will follow.<br/>
A setting of <code>¯1</code> means there is no limit to the number of redirections followed; exposing the possibility of an infinite redirection loop and eventually a <code>WS FULL</code> error. A setting of <code>0</code> means no redirections will be followed.</tr>
<tr><td>Default</td>
<td><code>10</code></td></tr>
<tr><td>Example(s)</td>
<td><code>h.MaxRedirections←0 ⍝ do not follow any redirections</code>
</td></tr>
<tr><td>Details</td>
<td>If the response HTTP status indicates a redirection (3XX) to another URL, <code>HttpCommand</code> will retain information about the current request in the <a href="../result-response/#redirections"><code>Redirections</code></a> element of the result namespace and issue a new request to the new URL. <code>HttpCommand</code> will do this up to <code>MaxRedirections</code> times.<br/><br/> 
</td></tr></table>

### `Outfile`
<table><tr>
<td>Description</td>
<td><code>Outfile</code> has up to 2 elements:
<ul><li><code>[1] </code>The name of the file or folder to which <code>HttpCommand</code> will write the response payload.  
If a folder is specified, the file name will be the same as the resource specified in <code>URL</code>. </li>
<li><code>[2] </code>an optional flag indicating:
<ul><li><code>0 </code>do not write to an existing, non-empty file (the default)</li>
<li><code>1 </code>replace the contents, if any, if the file exists</li>
<li><code>2 </code>append to the file, if it exists</li></ul></li></ul></td></tr>
<tr><td>Default</td>
<td><code>'' 0</code></td></tr>
<tr><td>Example(s)</td>
<td><code>      c ← HttpCommand.New '' </code><br/>
<code>      c.URL←'https://www.dyalog.com/uploads/files/student_competition/2022_problems_phase2.pdf'</code><br/>
<code>      c.OutFile←'/tmp/'</code><br/>
<code>      c.Run</code><br/>
<code>[rc: 0 | msg:  | HTTP Status: 200 "OK" | 399766 bytes written to c:/tmp/2022_problems_phase2.pdf]</code><br/><br/>
<code>      c.OutFile←'/tmp/problems.pdf' 1</code><br/>
<code>      c.Run</code><br/>
<code>[rc: 0 | msg:  | HTTP Status: 200 "OK" | 399766 bytes written to c:/tmp/problems.pdf]</code><br/>
</td></tr>
<tr><td>Details</td>
<td>Output to file is subject to <code>MaxPayloadSize</code>.</td></tr></table>

### `RequestOnly`
<table><tr>
<td>Description</td>
<td>If set to 1, <code>HttpCommand</code> will return the character vector HTTP request that would be sent, instead of actually sending the request.</td></tr>
<tr><td>Default</td>
<td><code>0</code></td></tr>
<tr><td>Example(s)</td>
<td><code>h.RequestOnly←1</code></td></tr>
<tr><td>Details</td>
<td>This setting is useful for debugging a request that isn't behaving as you expect.<br/><br/>
Setting optional left argument of shared methods <code>Get</code>, <code>GetJSON</code>, <code>Do</code>, or <code>New</code> to <code>1</code> will have the same effect as setting <code>RequestOnly</code> as will the instance method <code>Show</code>.</td></tr></table>

### `Secret`
<table><tr>
<td>Description</td>
<td>If set to 1, <code>HttpCommand</code> will suppress the display of credentials in the Authorization header, instead replacing them with <code>&gt;&gt;&gt; Secret setting is 1 &lt;&lt;&lt;</code>. This applies when using the <a href="./instance-methods.md#show"><code>Show</code></a> or <a href="./instance-methods.md#config"><code>Config</code></a> methods or setting <a href="#requestonly"><code>RequestOnly</code></a> to 1. <code>Secret</code> will not affect the request that is actually sent to the host.</td></tr>
<tr><td>Default</td>
<td><code>1</code></td></tr>
<tr><td>Example(s)</td>
<td>
<pre><code>      h←HttpCommand.New 'get' 'userid:password@someurl.com'
      h.Show
GET / HTTP/1.1
Host: someurl.com
User-Agent: Dyalog-HttpCommand/5.5.0
Accept: */*
Accept-Encoding: gzip, deflate
Authorization: >>> Secret setting is 1 <<<

      h.Secret←0
      h.Show
GET / HTTP/1.1
Host: someurl.com
User-Agent: Dyalog-HttpCommand/5.5.0
Accept: */*
Accept-Encoding: gzip, deflate
Authorization: Basic dXNlcmlkOnBhc3N3b3Jk
</code></pre></td></tr>
<tr><td>Details</td>
<td>This setting is useful when doing an <code>HttpCommand</code> demonstration as it will avoid inadvertently displaying credentials in the APL session.</td></tr></table>

### `SuppressHeaders`
<table><tr>
<td>Description</td>
<td><code>SuppressHeaders</code> is a Boolean setting indicating whether <code>HttpCommand</code> should suppress the generation of its default HTTP headers for the request.<ul><li><code>1</code> - suppress the default headers</li><li><code>0</code> - generate the default headers</td></tr>
<tr><td>Default</td>
<td><code>0</code> which means <code>HttpCommand</code> will generate its default headers</td></tr>
<tr><td>Example(s)</td>
<td><code>h.SuppressHeaders←1</code></td></tr>
<tr><td>Details</td>
<td><code>HttpCommand</code> will only generate headers that you have not specified yourself. <code>HttpCommand</code> generates the following default headers:<ul><li><code>Host</code> - the host name in the URL. This header <b>must</b> be supplied.</li>
<li><code>User-Agent: Dyalog-HttpCommand/&lt;version&gt;</code></li>
<li><code>Accept: */*</code> By default, <code>HttpCommand</code> will accept any response type</li>
<li><code>Accept-Encoding: gzip, deflate</code> By default, <code>HttpCommand</code> will accept compressed response payloads</li>
<li><code>Authorization</code> set only if you provide HTTP Basic authentication credentials, or set <code>Auth</code> and  <code>AuthType</code></li>
<li><code>Cookie</code> - any saved cookies applicable to the request.</li>
<li><code>Content-Type</code> is conditionally set as described <a href="../../userguide/#content-types">here</a></li></ul>
Setting <code>SuppressHeaders←1</code> will suppress ALL <code>HttpCommand</code>-generated headers which means you will need to specify any necessary request headers yourself.  
<br/>
Individual headers can be suppressed by using the <a href="../../instance-methods/#setheader"><code>SetHeader</code></a> instance method and assigning the header a value of <code>''</code>.<br/><br/>Note: Conga will always insert a <code>Content-Length</code> header for any request that has a payload. 
</td></tr></table>

### `Timeout`
<table><tr>
<td>Description</td>
<td>The number of seconds that <code>HttpCommand</code> will count down to wait for a response from the host. If <code>Timeout</code> is positive, <code>HttpCommand</code> will exit with a return code of 100 (Timeout) if it has not received the complete response from the host before the countdown reaches 0. If <code>Timeout</code> is negative, <code>HttpCommand</code> will check if Conga has received any data and if so, will reset the countdown to <code>|Timeout</code>.</td></tr>
<tr><td>Default</td>
<td><code>10</code></td></tr>
<tr><td>Example(s)</td>
<td>h.Timeout←30</td></tr>
<tr><td>Details</td>
<td>This is the setting to adjust (and not <a href="../../conga-settings#waittime"><code>WaitTime</code></a>) if your request is timing out.  See <a href="../../conga#timeout-and-waittime">Timeout and WaitTime</a> for more information on the relationship between the <code>Timeout</code> and <code>WaitTime</code> settings.
</td></tr></table>

### `TranslateData`
<table><tr>
<td>Description</td>
<td>Set this to <code>1</code> to have <code>HttpCommand</code> attempt to convert the response payload for the following content types.
<ul>
<li><code>'application/json'</code> - <code>HttpCommand</code> will use <code>⎕JSON</code></li>
<li><code>'text/xml'</code> or <code>'application/xml'<code> - <code>HttpCommand</code> will use <code>⎕XML</code></li>
</ul>
</td></tr>
<tr><td>Default</td>
<td><code>0</code></td></tr>
<tr><td>Example(s)</td>
<td><code>
      c←HttpCommand.New 'get' 'https://api.github.com/users/dyalog'<br/><br/>
      c.TranslateData←0<br/>
      50↑(⎕←c.Run).Data<br/>
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 1306]
{"login":"Dyalog","id":4189495,"node_id":"MDEyOk9y<br/>
<br/>
      c.TranslateData←1<br/>
      (⎕←c.Run).Data<br/>
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: ⍬]<br/>
#.[JSON object]
</code>
</td></tr></table>

## Shared Settings
Shared settings are set in the `HttpCommand` class and are used by all instances of `HttpCommand`.

### `Debug`
<table><tr>
<td>Description</td>
<td>Set <code>Debug</code> to 1 to turn off <code>HttpCommand</code>'s error trapping. In this case if an error occurs, execution of <code>HttpCommand</code> will be suspended.  Set <code>Debug</code> to 2 to have <code>HttpCommand</code> stop just before sending the request to the host so that you can examine the request and <code>HttpCommand</code>'s current state.  Both of these settings can be useful for debugging. </td></tr>
<tr><td>Default</td>
<td><code>0</code></td></tr>
<tr><td>Example(s)</td>
<td>
<code>      c←HttpCommand.New 'get' 'https://api.github.com/users/dyalog'</code><br/>
<code>      c.OutFile←0</code><br/>
<code>      c.Debug←1</code><br/>
<code>      c.Run</code><br/>
<code>DOMAIN ERROR: Invalid file or directory name</code><br/>
<code>HttpCmd[130] outFile←∊1 ⎕NPARTS outFile</code><br/>
<code>                        ∧</code><br/>
<br/>
<code>      c.Debug←0</code><br/>
<code>      c.Run</code><br/>
<code>[rc: ¯1 | msg: DOMAIN ERROR while trying to initialize output file '0' | HTTP Status:  "" | ⍴Data: 0]</code>
</td></tr>
</table>