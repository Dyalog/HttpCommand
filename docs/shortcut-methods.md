These "shortcut" methods make it easier to issue HTTP requests or create an instance of `HttpCommand`.

### `Get` - issue an HTTP GET request
`Get` is probably `HttpCommand`'s most-used feature.  It issues an HTTP GET request and returns the response from the server. It can be used for many purposes including interacting with web services, downloading files, and returning the contents of web pages.
<table>
<tr><td>Syntax</td>
<td><code>r ←{RequestOnly} HttpCommand.Get args</code></td></tr>
<tr><td><code>args</code></td>
<td>Either<ul><li>a vector of positional settings (only <code>URL</code> is required)<br/>
<code><a href="./request-settings#URL">URL</a>&nbsp;
<a href="./request-settings#Params">Params</a>&nbsp;
<a href="./request-settings#Headers">Headers</a>&nbsp;
<a href="./conga-settings#Cert">Cert</a>&nbsp;
<a href="./conga-settings#SSLFlags">SSLFlags</a>&nbsp;
<a href="./conga-settings#Priority">Priority</a>
</code><br/>
Intermediate positional parameters that are not used should be set to <code>''</code></li>
<li>A namespace containing named variables for the settings for the request.<br/><code>(args ← ⎕NS '').(URL Headers) ← 'someurl.com' ('header1' 'value1')</code>
</li></ul></td></tr>
<tr><td><code>RequestOnly</code></td>
<td>(optional) A Boolean indicating:<ul>
<li><code>0</code> - (default) send the HTTP request and return the response result. 
<li><code>1</code> - return the formatted HTTP request that HttpCommand <i>would</i> send if <code>RequestOnly</code> was <code>0</code>.</li></ul></td></tr>
<tr><td><code>r</code></td>
<td>If RequestOnly is<ul><li><code>0</code> - a namespace containing the request response.</li>
<li><code>1</code> - the formatted HTTP request that <code>HttpCommand</code> would send if <code>RequestOnly</code> was <code>0</code>.</td></tr>
<tr><td>Example(s)</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;args ← ⎕NS ''</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;args.URL ← 'httpbin.org'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;args.Params ← ('name' 'Donald')('species' 'duck')</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.Get args</code></br>
<code>[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 339]</code><br/><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.Get 'httpbin.org/get' (('name' 'Donald')('species' 'duck'))</code><br/>
<code>[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 339]</code><br/><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1 HttpCommand.Get args</code><br/>
<code>GET /get?name=Donald&species=duck HTTP/1.1</code><br/><br/>
<code>Host: httpbin.org</code><br/><br/>
<code>User-Agent: Dyalog-HttpCommand/5.0.2</code><br/><br/>
<code>Accept: */*</code>
</td></tr>
</table>

### `GetJSON` - issue a request to a JSON-based web service
`GetJSON` is used to interact with web services that use JSON for their request and response payloads. It was originally developed as a convenient way to interact with [Jarvis](https://githib.com/dyalog/Jarvis), Dyalog's JSON and REST Service framework. Conveniently, it turns out that there are many web services, including GitHub and Twitter, that use JSON as well. 

When `Command` is something other than `GET` or `HEAD`, `GetJSON` will automatically convert APL `Params` into JSON format. For `GET` and `HEAD`, `HttpCommand` will URLEncode `Params` in the query string of the `URL`. The rationale behind this is that `GET` and `HEAD` requests should not have content; therefore `Params` should be included in the query string of `URL` and it doesn't make a lot of sense to include JSON in the query string.  If you really need JSON in the query string, you can use `⎕JSON` to convert `Params`.

`GetJSON` will attempt to convert any JSON response payload into its equivalent APL representation. 

<table>
<tr><td>Syntax</td>
<td><code>r ←{RequestOnly} HttpCommand.GetJSON args</code></td></tr>
<tr><td><code>args</code></td>
<td>Either<ul><li>a vector of positional settings (<code>Command</code> and <code>URL</code> are required.)<br/>
<code><a href="./request-settings#Command">Command</a>&nbsp;
<a href="./request-settings#URL">URL</a>&nbsp;
<a href="./request-settings#Params">Params</a>&nbsp;
<a href="./request-settings#Headers">Headers</a>&nbsp;
<a href="./conga-settings#Cert">Cert</a>&nbsp;
<a href="./conga-settings#SSLFlags">SSLFlags</a>&nbsp;
<a href="./conga-settings#Priority">Priority</a>
</code><br/>
Intermediate positional parameters that are not used should be set to <code>''</code></li>
<li>A namespace containing named variables for the settings for the request.<br/>
</li></ul></td></tr>
<tr><td><code>RequestOnly</code></td>
<td>(optional) A Boolean indicating:<ul>
<li><code>0</code> - (default) send the HTTP request and return the response result. 
<li><code>1</code> - return the formatted HTTP request that HttpCommand <i>would</i> send if <code>RequestOnly</code> was <code>0</code>.</li></ul></td></tr>
<tr><td><code>r</code></td>
<td>If RequestOnly is<ul><li><code>0</code> - a namespace containing the request response.</li>
<li><code>1</code> - the formatted HTTP request that <code>HttpCommand</code> would send if <code>RequestOnly</code> was <code>0</code>.</td></tr>
<tr><td>Example(s)</td>
<td>These examples assume you have a <a href="https://github.com/dyalog/Jarvis"><code>Jarvis</code></a> service running at <code>http://localhost:8080</code> and a endpoint of <code>#.sum ← {+/⍵}</code>.<br/><br/>
<code>      args ← ⎕NS ''
      args.Command ← 'post'
      args.URL ← 'localhost:8080/sum'
      args.Params ← ⍳1000
      ⊢r ← HttpCommand.GetJSON args
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: ⍬]
      r.Data
500500

      Params ← ('per_page' '3')('page' '1')('sort' 'full_name')
      URL ← 'https://api.github.com/orgs/dyalog/repos'
      ⊢r ← HttpCommand.GetJSON 'get' URL Params
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 3]

      r.Data.full_name
 Dyalog/a3s-Linux  Dyalog/APLCourse  Dyalog/aplssh 
</td></tr>
</table>

### `Do` - issue a generic HTTP request
`Do` is essentially the same as `Get` except that you specify the HTTP method (`Command`) to use.
<table>
<tr><td>Syntax</td>
<td><code>r ←{RequestOnly} HttpCommand.Do args</code></td></tr>

<tr><td><code>args</code></td>
<td>Either<ul><li>a vector of positional settings (<code>Command</code> and <code>URL</code> are required)<br/>
<code><a href="./request-settings#Command">Command</a>&nbsp;
<a href="./request-settings#URL">URL</a>&nbsp;
<a href="./request-settings#Params">Params</a>&nbsp;
<a href="./request-settings#Headers">Headers</a>&nbsp;
<a href="./conga-settings#Cert">Cert</a>&nbsp;
<a href="./conga-settings#SSLFlags">SSLFlags</a>&nbsp;
<a href="./conga-settings#Priority">Priority</a>
</code><br/>
Intermediate positional parameters that are not used should be set to <code>''</code></li>
<li>A namespace containing named variables for the settings for the request.<br/><code>(args ← ⎕NS '').(Command URL Headers) ← 'post' 'someurl.com' ('header1' 'value1')</code>
</li></ul></td></tr>

<tr><td><code>RequestOnly</code></td>
<td>(optional) A Boolean indicating:<ul>
<li><code>0</code> - (default) send the HTTP request and return the response result. 
<li><code>1</code> - return the formatted HTTP request that HttpCommand <i>would</i> send if <code>RequestOnly</code> was <code>0</code>.</li></ul></td></tr>

<tr><td><code>r</code></td>
<td>If RequestOnly is<ul><li><code>0</code> - a namespace containing the request response.</li>
<li><code>1</code> - the formatted HTTP request that <code>HttpCommand</code> would send if <code>RequestOnly</code> was <code>0</code>.</td></tr>

<tr><td>Example(s)</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;args ← ⎕NS ''</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;args.(Command URL) ← 'post' 'httpbin.org/post'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;args.Params ← ('name' 'Donald')('species' 'duck')</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.Do args</code></br>
<code>[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 465]</code><br/><br/>
</td></tr>
</table>

### `New` - create a new instance of `HttpCommand`
`New` is different than the other shortcut methods in that it returns an instance of `HttpCommand`.  `Get`, `GetJSON`, and `Do` all create an instance, run it, return the response namespace, and upon exit the instance is destroyed.

`New` can be useful for maintaining state information, like HTTP cookies across multiple requests or keeping the connection to the host open so that subsequent requests to the host are processed without the overhead of re-establishing the connection.

After specifying the settings in the instance, run the `Run` instance method to execute the request. 
<table>
<tr><td>Syntax</td>
<td><code>instance ←{RequestOnly} HttpCommand.New args</code></td></tr>

<tr><td><code>args</code></td>
<td>Either:<ul>
<li>a vector, possibly empty, of positional settings<br/>
<code><a href="./request-settings#Command">Command</a>&nbsp;
<a href="./request-settings#URL">URL</a>&nbsp;
<a href="./request-settings#Params">Params</a>&nbsp;
<a href="./request-settings#Headers">Headers</a>&nbsp;
<a href="./conga-settings#Cert">Cert</a>&nbsp;
<a href="./conga-settings#SSLFlags">SSLFlags</a>&nbsp;
<a href="./conga-settings#Priority">Priority</a>
</code><br/>
Intermediate positional parameters that are not used should be set to <code>''</code></li>
<li>A namespace containing named variables for the settings for the request.<br/><code>(args ← ⎕NS '').(Command URL Headers) ← 'post' 'someurl.com' ('header1' 'value1')</code>
</li></ul></td></tr>

<tr><td><code>RequestOnly</code></td>
<td>(optional) A Boolean indicating when <code>Run</code> is executed:<ul>
<li><code>0</code> - (default) send the HTTP request and return the response result. 
<li><code>1</code> - return the formatted HTTP request that HttpCommand <i>would</i> send if <code>RequestOnly</code> was <code>0</code>.</li></ul></td></tr>

<tr><td><code>instance</code></td>
<td>An instance of <code>HttpCommmand</code>.</td></tr>

<tr><td>Example(s)</td>
<td>Use a namespace for the request settings:<br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;args ← ⎕NS ''</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;args.(Command URL) ← 'post' 'httpbin.org/post'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;args.Params ← ('name' 'Donald')('species' 'duck')</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cmd ← HttpCommand.New args</code></br>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cmd.Run</code></br>
<code>[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 465]</code><br/><br/>
Create an instance of <code>HttpCommand</code> and set the settings directly:<br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cmd ← HttpCommand.New '' ⍝ synonym for cmd ← ⎕NEW HttpCommand</code></br>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cmd.(Command URL) ← 'post' 'httpbin.org/post'</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cmd.Params ← ('name' 'Donald')('species' 'duck')</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cmd.Run</code></br>
<code>[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 465]</code><br/><br/>
Set RequestOnly, display the request that would be sent, then send it</br>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cmd ← 1 HttpCommand.New 'get' 'dyalog.com'</code></br>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cmd.Run</code></br>
<code>GET / HTTP/1.1</code><br/>
<code>Host: dyalog.com</code><br/>
<code>User-Agent: Dyalog-HttpCommand/5.0.4</code><br/>
<code>Accept: */*</code><br/><br/><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cmd.RequestOnly←0</code><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cmd.Run</code><br/>
<code>[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 23127]</code><br/>
</td></tr>
</table>