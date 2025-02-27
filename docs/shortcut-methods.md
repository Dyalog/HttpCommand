These "shortcut" methods make it easier to issue HTTP requests or create an instance of `HttpCommand`.

### `Get` - issue an HTTP GET request
`Get` is probably `HttpCommand`'s most-used feature.  It issues an HTTP GET request and returns the response from the server. It can be used for many purposes including interacting with web services, downloading files, and returning the contents of web pages.

|--|--|
|Syntax|`r ←{RequestOnly} HttpCommand.Get args`|
|`args`|Either<ul><li>a vector of positional settings (only `URL` is required)<br/>[`URL`](./request-settings.md#url)<br/>[`Params`](./request-settings.md#params)<br/>[`Headers`](./request-settings.md#headers)<br/>[`Cert`](./conga-settings.md#cert)<br/>[`SSLFlags`](./conga-settings.md#sslflags)<br/>[`Priority`](./conga-settings.md#priority)<br/>Intermediate positional parameters that are not used should be set to `''`</li><li>A namespace containing named variables for the settings for the request.<br/>`(args ← ⎕NS '').(URL Headers) ← 'someurl.com' ('header1' 'value1')`</li></ul>|
|`RequestOnly`|(optional) A Boolean indicating:<ul><li>`0` - (default) send the HTTP request and return the response result.<li>`1` - return the formatted HTTP request that HttpCommand *would* send if `RequestOnly` was `0`</li></ul>|
|`r`|If `RequestOnly` is<ul><li>`0` - a namespace containing the request response.</li><li>`1` - the formatted HTTP request that `HttpCommand` would send if `RequestOnly` was `0`.|
|Example(s)|<pre style="font-family:APL;">      args ← ⎕NS ''<br/>      args.URL ← 'httpbin.org'<br/>      args.Params ← ('name' 'Donald')('species' 'duck')<br/>      HttpCommand.Get args<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: 339]<br/><br/>      HttpCommand.Get 'httpbin.org/get' (('name' 'Donald')('species' 'duck'))<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: 339]<br/><br/>      1 HttpCommand.Get args<br/>GET /get?name=Donald&species=duck HTTP/1.1<br/><br/>Host: httpbin.org<br/><br/>User-Agent: Dyalog-HttpCommand/5.0.2<br/><br/>Accept: */*|

### `GetJSON` - issue a request to a JSON-based web service
`GetJSON` is used to interact with web services that use JSON for their request and response payloads. It was originally developed as a convenient way to interact with [Jarvis](https://github.com/dyalog/Jarvis), Dyalog's JSON and REST Service framework. Conveniently, it turns out that there are many web services, including GitHub and Twitter, that use JSON as well. 

When `Command` is something other than `GET` or `HEAD`, `GetJSON` will automatically convert APL `Params` into JSON format. For `GET` and `HEAD`, `HttpCommand` will URLEncode `Params` in the query string of the `URL`. The rationale behind this is that `GET` and `HEAD` requests should not have content; therefore `Params` should be included in the query string of `URL` and it doesn't make a lot of sense to include JSON in the query string.  If you really need JSON in the query string, you can use `⎕JSON` to convert `Params`.

`GetJSON` will attempt to convert any JSON response payload into its equivalent APL representation. 

|--|--|
| Syntax | `r ←{RequestOnly} HttpCommand.GetJSON args` |
| `args` | One of:<ul><li>a simple character vector [`URL`](./request-settings.md#url)</li><li>a vector of positional settings (`Command` and `URL` are required.)<br/>[`Command`](./request-settings#command)<br/>[`URL`](./request-settings#url)<br/> [`Params`](./request-settings#params)<br/> [`Headers`](./request-settings#headers)<br/> [`Cert`](./conga-settings#cert)<br/>[`SSLFlags`](./conga-settings#sslflags)<br/>[`Priority`](./conga-settings#priority)<br/>Intermediate positional parameters that are not used should be set to `''`</li><li>A namespace containing named variables for the settings for the request.</li></ul>|
| `RequestOnly` | (optional) A Boolean indicating:<ul><li>`0` - (default) send the HTTP request and return the response result.<li>`1` - return the formatted HTTP request that HttpCommand *would* send if `RequestOnly` was `0`.</li></ul>|
| `r` | If `RequestOnly` is<ul><li>`0` - a namespace containing the request response.</li><li>`1` - the formatted HTTP request that `HttpCommand` would send if `RequestOnly` was `0`.</li></ul>|
| Example(s) | These examples assume you have a [`Jarvis`](https://github.com/dyalog/Jarvis) service running at `http://localhost:8080` and a endpoint of `#.sum ← {+/⍵}`.<br/><pre style="font-family:APL;">      args ← ⎕NS ''<br/>      args.Command ← 'post'<br/>      args.URL ← 'localhost:8080/sum'<br/>      args.Params ← ⍳1000<br/>      ⊢r ← HttpCommand.GetJSON args<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: ⍬]<br/>      r.Data<br/>500500<br/><br/>      Params ← ('per_page' '3')('page' '1')('sort' 'full_name')<br/>      URL ← 'https://api.github.com/orgs/dyalog/repos'<br/>      ⊢r ← HttpCommand.GetJSON 'get' URL Params<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: 3]<br/><br/>      r.Data.full_name<br/> Dyalog/a3s-Linux  Dyalog/APLCourse  Dyalog/aplssh`</pre>|

### `Do` - issue a generic HTTP request
`Do` is essentially the same as `Get` except that you specify the HTTP method (`Command`) to use.

|--|--|
|Syntax|`r ←{RequestOnly} HttpCommand.Do args`|
|`args`|Either<ul><li>a vector of positional settings (`Command` and `URL` are required)<br/>[`Command`](./request-settings.md#command)<br/>[`URL`](./request-settings.md#url)<br/>[`Params`](./request-settings.md#params)<br/>[`Headers`](./request-settings.md#headers)<br/>[`Cert`](./conga-settings.md#cert)<br/>[`SSLFlags`](./conga-settings.md#sslflags)<br/>[`Priority`](./conga-settings.md#priority)<br/>Intermediate positional parameters that are not used should be set to `''`</li><li>A namespace containing named variables for the settings for the request.<br/>`(args ← ⎕NS '').(Command URL Headers) ← 'post' 'someurl.com' ('header1' 'value1')`</li></ul>|
|`RequestOnly`|(optional) A Boolean indicating:<ul><li>`0` - (default) send the HTTP request and return the response result.</li><li>`1` - return the formatted HTTP request that HttpCommand *would* send if `RequestOnly` was `0`.</li></ul>|
|`r`|If `RequestOnly` is<ul><li>`0` - a namespace containing the request response.</li><li>`1` - the formatted HTTP request that `HttpCommand` would send if `RequestOnly` was `0`.|
|Example(s)|<pre style="font-family:APL;">      args ← ⎕NS ''<br/>      args.(Command URL) ← 'post' 'httpbin.org/post'<br/>      args.Params ← ('name' 'Donald')('species' 'duck')<br/>      HttpCommand.Do args<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: 465]|

### `New` - create a new instance of `HttpCommand`
`New` is different than the other shortcut methods in that it returns an instance of `HttpCommand`.  `Get`, `GetJSON`, and `Do` all create an instance, run it, return the response namespace, and upon exit the instance is destroyed.

`New` can be useful for maintaining state information, like HTTP cookies across multiple requests or keeping the connection to the host open so that subsequent requests to the host are processed without the overhead of re-establishing the connection.

After specifying the settings in the instance, run the `Run` instance method to execute the request. 

|--|--|
|Syntax|`instance ←{RequestOnly} HttpCommand.New args`|
|`args`|Either<ul><li>a vector of positional settings (`Command` and `URL` are required)<br/>[`Command`](./request-settings.md#command)<br/>[`URL`](./request-settings.md#url)<br/>[`Params`](./request-settings.md#params)<br/>[`Headers`](./request-settings.md#headers)<br/>[`Cert`](./conga-settings.md#cert)<br/>[`SSLFlags`](./conga-settings.md#sslflags)<br/>[`Priority`](./conga-settings.md#priority)<br/>Intermediate positional parameters that are not used should be set to `''`</li><li>A namespace containing named variables for the settings for the request.<br/>`(args ← ⎕NS '').(Command URL Headers) ← 'post' 'someurl.com' ('header1' 'value1')`</li></ul>|
|`RequestOnly`|(optional) A Boolean indicating:<ul><li>`0` - (default) send the HTTP request and return the response result.</li><li>`1` - return the formatted HTTP request that HttpCommand *would* send if `RequestOnly` was `0`.</li></ul>|
|`instance`|An instance of `HttpCommmand`|
|Example(s)|Use a namespace for the request settings:<br/><pre style="font-family:APL;">      args ← ⎕NS ''<br/>      args.(Command URL) ← 'post' 'httpbin.org/post'<br/>      args.Params ← ('name' 'Donald')('species' 'duck')<br/>      cmd ← HttpCommand.New args<br/>      cmd.Run<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: 465]</pre><br/>Create an instance of `HttpCommand` and set the settings directly:<br/><pre style="font-family:APL;">      cmd ← HttpCommand.New '' ⍝ synonym for cmd ← ⎕NEW HttpCommand<br/>      cmd.(Command URL) ← 'post' 'httpbin.org/post'<br/>      cmd.Params ← ('name' 'Donald')('species' 'duck')<br/>      cmd.Run<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: 465]</pre><br/>Set RequestOnly, display the request that would be sent, then send it<br/><pre style="font-family:APL;">      cmd ← 1 HttpCommand.New 'get' 'dyalog.com'<br/>      cmd.Run<br/>GET / HTTP/1.1<br/>Host: dyalog.com<br/>User-Agent: Dyalog-HttpCommand/5.0.4<br/>Accept: */*<br/><br/>      cmd.RequestOnly←0<br/>      cmd.Run<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: 23127]</pre>|