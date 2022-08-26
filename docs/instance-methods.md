The methods documented in this section are instance methods and may be called from an instance of `HttpCommand`. In the documentation below, we will use the name `instance` to represent an instance of `HttpCommand`. 

### `Run`
`Run` "runs" the HTTP request defined by the instance's settings. `Run` is called internally by the shared "shortcut" methods `Get`, `GetJSON`, and `Do`. 
<table>
<tr><td>Syntax</td>
<td><code>result←instance.Run</code></td><td>&nbsp;</tr>
<tr><td><code>result</code></td>
<td><code>result</code> depends on the <code>RequestOnly</code> setting.<br/><br/>
If <code>RequestOnly=1</code>, <code>Run</code> will return, if possible, the HTTP request that <i>would</i> be sent if <code>RequestOnly</code> was set to <code>0</code>. If <code>HttpCommand</code> cannot form a proper HTTP request, <code>Run</code> will return a <a href="/result">result namespace</a> with pertinent information.<br/><br/>
If <code>RequestOnly=0</code>, <code>Run</code> will return a <a href="/result">result namespace</a> containing the result of attempting to build and send the HTTP request specified by the instance's settings. 
</td></tr>
<tr><td>Examples</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance←HttpCommand.New ''</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.RequestOnly←1</code><br/><br/>
There isn't sufficient information for <code>HttpCommand</code> to build a proper HTTP request.<br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⊢result ← instance.Run</code></br>
<code>[rc: ¯1 | msg: No URL specified | HTTP Status:&nbsp;&nbsp;"" | ⍴Data: 0]</code><br/><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.URL←'dyalog.com'</code><br/>
Now, there's enough information to form a proper HTTP request.<br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⊢result ← instance.Run</code><br/>
<code>GET / HTTP/1.1<br/>
Host: dyalog.com<br/>
User-Agent: Dyalog-HttpCommand/5.0.3<br/>
Accept: */*<br/><br/></code>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.RequestOnly←0</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;⊢result ← instance.Run</code><br/>
<code>[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 23127]</code>
</table>

### `Show` 
Returns the HTTP request that `HttpCommand` would send when `Run` is executed and `RequestOnly` is `0`.  `Show` is equivalent to setting `RequestOnly` to `1` and running `Run`.
<table>
<tr><td>Syntax</td>
<td><code>r←instance.Show</code></td><td>&nbsp;</td></tr>
<tr><td>Example</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance ← HttpCommand.New 'get' 'dyalog.com'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.Show</code><br/>
<code>GET / HTTP/1.1</code><br/><br/>
<code>Host: dyalog.com</code><br/><br/>
<code>User-Agent: Dyalog-HttpCommand/5.0.3</code><br/><br/>
<code>Accept: */*</code>
</td></tr>
</table>

### `Config` 
`Config` returns the current state of all `HttpCommand` settings.
<table>
<tr><td>Syntax</td>
<td><code>r←instance.Config</code></td></tr>
<tr><td><code>r</code></td>
<td>A 2-column matrix where<br/>
<code>[;1] </code>contains the setting names<br/>
<code>[;2] </code>contains the corresponding setting values</td></tr>
<tr><td>Example</td>
<td>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance←HttpCommand.New 'get' 'dyalog.com'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.Config</code><br/>
<code>&nbsp;Auth</code><br/>
<code>&nbsp;AuthType</code><br/>
<code>&nbsp;BufferSize&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;200000</code><br/>
<code>&nbsp;Cert</code><br/>
<code>&nbsp;Command&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;get</code><br/>                    
<code>&nbsp;CongaPath</code><br/>
<code>&nbsp;CongaRef</code><br/>
<code>&nbsp;CongaVersion</code><br/>
<code>&nbsp;ContentType</code><br/>
<code>&nbsp;Cookies</code><br/>
<code>&nbsp;Debug&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0</code><br/>
<code>&nbsp;Headers</code><br/>
<code>&nbsp;KeepAlive&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1</code><br/>                    
<code>&nbsp;LDRC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;not&nbsp;set</code><br/>                    
<code>&nbsp;MaxPayloadSize&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;¯1</code><br/>
<code>&nbsp;MaxRedirections&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10</code><br/>
<code>&nbsp;OutFile</code><br/>
<code>&nbsp;Params</code><br/>
<code>&nbsp;Priority&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;NORMAL:!CTYPE-OPENPGP</code><br/>
<code>&nbsp;PrivateKeyFile</code><br/>
<code>&nbsp;PublicCertFile</code><br/>
<code>&nbsp;RequestOnly&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0</code><br/>
<code>&nbsp;SSLFlags&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;32</code><br/>
<code>&nbsp;SuppressHeaders&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0</code><br/>
<code>&nbsp;Timeout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10</code><br/>
<code>&nbsp;TranslateData&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0</code><br/>
<code>&nbsp;URL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;dyalog.com</code><br/>
<code>&nbsp;WaitTime&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5000</code><br/>
</td></tr>
</table>

### `Init` 
`Init` initializes Conga, Dyalog's TCP/IP utility library. Normally, `HttpCommand` will initialize Conga when `Run` is first  called. `Init` is intended to be used when the user wants to "tweak" Conga prior to `Run` being executed. It's very unlikely that you'll ever need to use `Init`.
<table>
<tr><td>Syntax</td>
<td><code>r←instance.Init</code></td></tr>
<tr><td><code>r</code></td>
<td>a 2-element vector of<br/><ul><li><code>[1]</code> the return code. <code>0</code> means Conga is initialized. Non-<code>0</code> indicates some error occurred in Conga initialization.</li>
<li><code>[2]</code> a message describing what went wrong if the return code is not <code>0</code></li>
</ul></td></tr>
<tr><td>Example</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance←HttpCommand.New ''</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.CongaPath←'/doesnotexist'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.Init</code><br/>
<code>¯1  CongaPath "c:/doesnotexist/" does not exist</code>
</td></tr>
</table>

## Header-related Methods
There are two sets of headers associated with an HTTP request - the request headers and the response headers. The methods described here deal with request headers.

`HttpCommand`'s request headers are stored in the `Headers` setting which is a 2-column matrix of name/value pairs. Header names are case-insensitive; header values are not. While you can manipulate the `Headers` array directly, `HttpCommand` has three methods to manage `Headers` that accommodate the case-insensitive nature of header names.

Note: The examples below were run using `]boxing on`.

### `AddHeader` 
`AddHeader` will add a header if a header with that name does not already exist. Use `SetHeader` to set a header regardless if one with the same name already exists.
<table>
<tr><td>Syntax</td>
<td><code>name instance.AddHeader value</code></td></tr>
<tr><td><code>value</code></td>
<td>the value for the header</td></tr>
<tr><td><code>name</code></td>
<td>the name for the header</td></tr>
<tr><td>Example</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance←HttpCommand.New ''</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'My-Header' instance.AddHeader 'Drake Mallard'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.Headers</code><br/>
<code>┌─────────┬─────────────┐</code><br/>
<code>│My-Header│Drake Mallard│</code><br/>
<code>└─────────┴─────────────┘</code><br/>
<code>AddHeader</code> will not replace an existing header with the same case-insensitive name<br/> 
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'my-header' instance.AddHeader 'Daffy Duck'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.Headers</code><br/>
<code>┌─────────┬─────────────┐</code><br/>
<code>│My-Header│Drake Mallard│</code><br/>
<code>└─────────┴─────────────┘</code><br/>
</td></tr>
</table>

### `SetHeader` 
`SetHeader` will set a header, replacing one of the same name if it already exists.
<table>
<tr><td>Syntax</td>
<td><code>name instance.SetHeader value</code></td></tr>
<tr><td><code>value</code></td>
<td>the value for the header</td></tr>
<tr><td><code>name</code></td>
<td>the name for the header</td></tr>
<tr><td>Example</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance←HttpCommand.New ''</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'My-Header' instance.SetHeader 'Drake Mallard'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.Headers</code><br/>
<code>┌─────────┬─────────────┐</code><br/>
<code>│My-Header│Drake Mallard│</code><br/>
<code>└─────────┴─────────────┘</code><br/><code>SetHeader</code> will replace an existing header with the same case-insensitive name<br/> 
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'my-header' instance.SetHeader 'Daffy Duck'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.Headers</code><br/>
<code>┌─────────┬──────────┐</code><br/>
<code>│My-Header│Daffy Duck│</code><br/>
<code>└─────────┴──────────┘</code><br/>
<code>
</td></tr>
</table>

### `RemoveHeader` 
`RemoveHeader` removes a header. If the header does not exist, `RemoveHeader` has no effect.
<table>
<tr><td>Syntax</td>
<td><code>instance.RemoveHeader name</code></td></tr>
<tr><td><code>name</code></td>
<td>the case-insensitive name of the header to remove</td</tr>
<tr><td>Example</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'My-Header' instance.SetHeader 'Daffy Duck'</code></br>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'another' instance.SetHeader 'some value'</code></br>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.Headers</code><br/>
<code>┌─────────┬──────────┐</code><br/>
<code>│My-Header│Daffy Duck│</code><br/>
<code>├─────────┼──────────┤</code><br/>
<code>│another&nbsp;&nbsp;│some value│</code><br/>
<code>└─────────┴──────────┘</code></br>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.RemoveHeader 'my-header'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;instance.Headers</code><br/>
<code>┌───────┬──────────┐</code><br/>
<code>│another│some value│</code><br/>
<code>└───────┴──────────┘</code><br/>
</td></tr>
</table>