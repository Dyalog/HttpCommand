The methods documented in this section are instance methods and may be called from an instance of `HttpCommand`. In the documentation below, we will use the name `instance` to represent an instance of `HttpCommand`. 

### `Run`
`Run` "runs" the HTTP request defined by the instance's settings. `Run` is called internally by the shared "shortcut" methods `Get`, `GetJSON`, and `Do`. 

|--|--|
|Syntax|`result←instance.Run`|
|`result`|`result` depends on the `RequestOnly` setting.<br/><br/>If `RequestOnly=1`, `Run` will return, if possible, the HTTP request that <i>would</i> be sent if `RequestOnly` was set to `0`. If `HttpCommand` cannot form a proper HTTP request, `Run` will return a <a href="/result">result namespace</a> with pertinent information.<br/><br/>If `RequestOnly=0`, `Run` will return a <a href="/result">result namespace</a> containing the result of attempting to build and send the HTTP request specified by the instance's settings.|
|Examples|<pre style="font-family:APL;">      instance←HttpCommand.New ''<br/>      instance.RequestOnly←1</pre>There isn't sufficient information for `HttpCommand` to build a proper HTTP request.<br/><pre style="font-family:APL;">      ⊢result ← instance.Run<br/>[rc: ¯1 &#124; msg: No URL specified &#124; HTTP Status:  "" &#124; ⍴Data: 0]<br/>      instance.URL←'dyalog.com'</pre>Now, there's enough information to form a proper HTTP request.<br/><pre style="font-family:APL;">      ⊢result ← instance.Run<br/>GET / HTTP/1.1<br/>Host: dyalog.com<br/>User-Agent: Dyalog-HttpCommand/5.0.3<br/>Accept: */*<br/>      instance.RequestOnly←0<br/>      ⊢result ← instance.Run<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: 23127]|


### `Show` 
Returns the HTTP request that `HttpCommand` would send when `Run` is executed and `RequestOnly` is `0`.  `Show` is equivalent to setting `RequestOnly` to `1` and running `Run`.

|--|--|
|Syntax|`r←instance.Show`|
|`r`|The result `r` is a character vector representing a properly formatted HTTP request if such a request can be formatted from the instance's settings.<br/>If the request cannot be formatted, `r` is  a namespace containing a non-0 return code, `rc`, and an explanatory message, `msg`.|   
|Example|<pre style="font-family:APL;">      instance ← HttpCommand.New 'get' 'dyalog.com'<br/>      instance.Show<br/>GET / HTTP/1.1<br/><br/>Host: dyalog.com<br/><br/>User-Agent: Dyalog-HttpCommand/5.0.3<br/><br/>Accept: */*</pre>|


### `Config` 
`Config` returns the current state of all `HttpCommand` settings.

|--|--|
|Syntax|`r←instance.Config`|
|`r`|A 2-column matrix where<br/>`[;1] `contains the setting names<br/>`[;2] `contains the corresponding setting values|
|Example|<pre style="font-family:APL;">      instance←HttpCommand.New 'get' 'dyalog.com'<br/>      instance.Config<br/> Auth<br/> AuthType<br/> BufferSize                      200000<br/> Cert<br/> Command                            get<br/> CongaPath<br/> CongaRef<br/> CongaVersion<br/> ContentType<br/> Cookies<br/> Debug                                0<br/> Headers<br/> KeepAlive                            1<br/> LDRC                           not set<br/> MaxPayloadSize                      ¯1<br/> MaxRedirections                     10<br/> OutFile<br/> Params<br/> Priority         NORMAL:!CTYPE-OPENPGP<br/> PrivateKeyFile<br/> PublicCertFile<br/> RequestOnly                          0<br/> Secret                               1<br/> SSLFlags                            32<br/> SuppressHeaders                      0<br/> Timeout                             10<br/> TranslateData                        0<br/> URL                         dyalog.com<br/> WaitTime                          5000</pre>|


### `Init` 
`Init` initializes Conga, Dyalog's TCP/IP utility library. Normally, `HttpCommand` will initialize Conga when `Run` is first  called. `Init` is intended to be used when the user wants to "tweak" Conga prior to `Run` being executed. It's very unlikely that you'll ever need to use `Init`.

|--|--|
|Syntax|`r←instance.Init`|
|`r`|a 2-element vector of<br/><ul><li>`[1]` the return code. `0` means Conga is initialized. Non-`0` indicates some error occurred in Conga initialization.</li><li>`[2]` a message describing what went wrong if the return code is not `0`</li></ul>|
|Example|<pre style="font-family:APL;">      instance←HttpCommand.New ''<br/>      instance.CongaPath←'/doesnotexist'<br/>      instance.Init<br/>¯1  CongaPath "c:/doesnotexist/" does not exist</pre>|


## Header-related Methods
There are two sets of headers associated with an HTTP request - the request headers and the response headers. The methods described here deal with **request headers**.

`HttpCommand`'s request headers are stored in the `Headers` setting which is a 2-column matrix of name/value pairs. Header names are case-insensitive; header values are not. While you can manipulate the `Headers` array directly, `HttpCommand` has three methods to manage `Headers` that accommodate the case-insensitive nature of header names.

By default, `HttpCommand` will automatically generate several request headers if you haven't specified values for them.  See [`SuppressHeaders`](operational-settings.md#suppressheaders) for the list of these headers.  To suppress the generation of specific headers, you can set its value to `''`.

Note: The examples below were run using `]boxing on`.

### `AddHeader` 
`AddHeader` will add a header if a user-defined header with that name does not already exist. Use `SetHeader` to set a header regardless if one with the same name already exists.

|--|--|
|Syntax|`{hdrs}←name instance.AddHeader value`|
|`value`|the value for the header|
|`name`|the name for the header|
|`hdrs`|the updated matrix of user-specified headers|
|Example|<pre style="font-family:APL;">      instance←HttpCommand.New ''<br/>      'My-Header' instance.AddHeader 'Drake Mallard'<br/>      instance.Headers<br/>┌─────────┬─────────────┐<br/>│My-Header│Drake Mallard│<br/>└─────────┴─────────────┘</pre>`AddHeader` will not replace an existing header with the same case-insensitive name.<br/><pre style="font-family:APL;">      'my-header' instance.AddHeader 'Daffy Duck'<br/>      instance.Headers<br/>┌─────────┬─────────────┐<br/>│My-Header│Drake Mallard│<br/>└─────────┴─────────────┘</pre>Setting the value of an `HttpCommand`-generated header that to `''` will suppress that header from being sent in the request.<br/><pre style="font-family:APL;">      'accept-encoding' instance.SetHeader ''</pre>|


### `SetHeader` 
`SetHeader` will set a header, replacing one of the same name if it already exists.

|--|--|
|Syntax|`{hdrs}←name instance.SetHeader value`|
|`value`|the value for the header|
|`name`|the name for the header|
|`hdrs`|the updated matrix of user-specified headers|
|Example|<pre style="font-family:APL;">      instance←HttpCommand.New ''<br/>      ⊢'My-Header' instance.SetHeader 'Drake Mallard'<br/>┌─────────┬─────────────┐<br/>│My-Header│Drake Mallard│<br/>└─────────┴─────────────┘</pre>`SetHeader` will replace an existing header with the same case-insensitive name<br/><pre style="font-family:APL;">       ⊢'my-header' instance.SetHeader 'Daffy Duck'<br/>┌─────────┬──────────┐<br/>│My-Header│Daffy Duck│<br/>└─────────┴──────────┘</pre>Setting the value of an `HttpCommand`-generated header that to `''` will suppress that header from being sent in the request.<br/><pre style="font-family:APL;">      'accept-encoding' instance.SetHeader ''</pre>|


### `RemoveHeader` 
`RemoveHeader` removes a user-specified header. If the header does not exist, `RemoveHeader` has no effect. `RemoveHeader` does not affect the `HttpCommand`-generated headers.

|--|--|
|Syntax|`{hdrs}←instance.RemoveHeader name`|
|`name`|the case-insensitive name of the header to remove</td|
|`hdrs`|the updated matrix of user-specified headers|
|Example|<pre style="font-family:APL;">      'My-Header' instance.SetHeader 'Daffy Duck'<br/>      'another' instance.SetHeader 'some value'<br/>      instance.Headers<br/>┌─────────┬──────────┐<br/>│My-Header│Daffy Duck│<br/>├─────────┼──────────┤<br/>│another  │some value│<br/>└─────────┴──────────┘<br/>      instance.RemoveHeader 'my-header'<br/>      instance.Headers<br/>┌───────┬──────────┐<br/>│another│some value│<br/>└───────┴──────────┘</pre>|
