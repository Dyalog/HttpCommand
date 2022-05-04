** This page is incomplete **

---

**`HttpCommand`**'s configuration settings are grouped into four categories - Request, Conga, Operational, and Streaming.

Examples below that use an instance of **`HttpCommand`** will refer to it as `h` as if created using `h←HttpCommand.New ''`

### Request-related Settings
Request-related settings are settings you use to specify attributes of the HTTP request that `HttpCommand` will process.

#### `Command`
<table><tr>
<td>Description</td>
<td>The case-insensitive HTTP command (method) for the request. <code>Command</code> is not limited to standard HTTP methods like GET, POST, PUT, HEAD, OPTIONS, and DELETE, but can be any string provided that the host has implemented support for it.</td></tr>
<tr><td>Default</td><td><code>'GET'</code></td></tr>
<tr><td>Example(s)</td><td><code>h.Command←'POST'</code></td></tr></table>
#### `URL`
[details](#url-details)
<table><tr>
<td>Description</td>
<td>The URL for the request.<br>The general format for <code>URL</code> is: 
<code>[scheme://][userinfo@]host[:port][/path][?query]</code><br>
At a minimum the <code>URL</code> must specify the host.</td></tr>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>h.URL←'dyalog.com'<br>h.URL←'https://user:pwd@adomain.com:8080/apath/?name=Drake</code></td></tr></table>

#### `Params`
[details](#params-details)
<table><tr>
<td>Description</td>
<td>The parameters or payload, if any, for the request. The interpretation of <code>Params</code> is dependent on <code>Command</code> and on the <code>content-type</code> HTTP header. <code>Params</code> is interpreted as follows:
<ul><li>If <code>Command</code> is either <code>'GET'</code> or <code>'HEAD'</code> then <code>HttpCommand</code> will URLencode <code>Params</code> and append it to the query string of the <code>URL</code>. (See <a href="#params-details">details</a>)</li>
<li>If the <code>content-type</code> HTTP header is <code>'application/x-www-form-urlencoded'</code> (the default), <code>HttpCommand</code> will URLencode <code>Params</code> and insert it into the body of the HTTP request. (See <a href="#params-details">details</a>)</li>
<li>If the <code>content-type</code> HTTP header is <code>'application/json' Params</code> will be converted to JSON format using <code>⎕JSON</code> and inserted in the body of the request.</li>
<li>Otherwise, <code>Params</code> will be formatted using <code>∊⍕</code> and inserted into the body of the request.</li></ul>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>h.Params←(('name' 'dyalog') ('age' 39))</code><br><code>h.Params←'name=dyalog&age=39'</code><br>
<code>ns←⎕NS '' ⋄ ns.(name age)←'dyalog' 39 ⋄ h.Params←ns</code></td></tr></table>

#### `Headers`
[details](#headers-details)
<table><tr>
<td>Description</td>
<td>The HTTP headers for the request. Specified as <a href="#namevalue-pairs">name/value pairs</a>.
</td></tr>
<tr><td>Default</td><td>By default, <code>HttpCommand</code> will create the following headers:</br>
<code>Host: </code>the host specified in <code>URL</code></br>
<code>User-Agent: 'Dyalog/HttpCommand'</code></br>
<code>Accept: '*/*'</code></br></br>
If <code>Command</code> is not either <code>'GET'</code> or <code>'HEAD'</code>, <code>HttpCommand</code> will specify 
<code>content-type: x-www-form-urlencoded</code></br>
except in the case where you use the <code>GetJSON</code> shortcut command, then <code>HttpCommand</code> will assign <code>content-type: application/json</code><br><br><code>HttpCommand</code> will assign these headers at execution time only if you haven't specified them yourself.<br><br>
If the request has content in the request body, Conga will automatically supply a <code>content-length</code> header.
</td></tr>
<tr><td>Example(s)</td><td><code>h.Headers←('accept' 'text/html')('authorization' 'mytoken')</code></td></tr></table>

#### `ContentType`
<table><tr>
<td>Description</td>
<td>This setting is a convenient shortcut for setting the <code>content-type</code> HTTP header of the request. If you happen set both <code>ContentType</code> and a <code>content-type</code> header, <code>ContentType</code> takes precedence.
</td></tr>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>h.ContentType←'application/json; charset=UTF-8'</code></td></tr></table>

### Conga-related Parameters
#### `BufferSize`
<table><tr>
<td>Description</td>
<td>The size limit for the HTTP header of the server's response. If the header exceeds this size, <code>HttpCommand</code> will issue a return code of 1135.</td></tr>
<tr><td>Default</td><td><code>100000</code></td></tr>
<tr><td>Example(s)</td><td><code>h.URL←'dyalog.com'<br>h.URL←'https://user:pwd@adomain.com:8080/apath/?name=Drake</code></td></tr></table>

#### `DOSLimit`
#### `TimeOut`
#### `Cert`
#### `SSLFlags`
#### `Priority`
#### `PublicCertFile`
#### `PrivateKeyFile`

### Operational Parameters
#### `SuppressHeaders`
#### `WaitTime`
#### `RequestOnly`
#### `OutFile`
#### `MaxRedirections`
#### `KeepAlive`
#### `TranslateData`
#### `Debug` 
### Streaming Parameters
#### `Stream`
#### `StreamFn`
#### `StreamLimit`
## Details

#### URL Details
A URL has the general format:<br>`[scheme://][userinfo@]host[:port][/path][?query]`

So, a URL can be as simple as just a host name like `'dyalog.com'` or as complex as `'https://username:password@ducky.com:1234?id=myid&time=1200'`

The only mandatory segment is the `host`; `HttpCommand` will infer or use default information when it builds the HTTP request to be sent.

- scheme - if supplied, it must be either `'http'` or `'https'` for a secure connection.  If not supplied, `HttpCommand` will use `'http'` unless you have specified the default HTTPS port (443) or provided SSL certificate parameters.
- userinfo - used for HTTP Basic authentication. HTTP Basic authentication has generally been deprecated, but may still be supported by some hosts. If userinfo is supplied, `HttpCommand` will create a proper Base64-encoded `authorization` header.
- host - the host/domain for the request
- port - if not supplied, `HttpCommand` will use the default HTTP port (80) unless the HTTPS scheme is used or certificate parameters are specified in which case the default HTTPS port (443) is used.
- path - the location of the resource within the domain. If not supplied, it's up to the domain's server to determine the default path.
- query - the query string for the request. If the HTTP method for the request is `'GET'` or `'HEAD'` and request parameters are specified in `Params`, `HttpCommand` will properly format them and append them to the query string. If you choose to supply query string parameters directly, they should be properly URLencoded. (See [`HttpCommand.URLencode`](reference#urlencode))

#### Params Details
If `Params` is to be URLencoded, either because `Command` is `'GET'` or `'HEAD'`, or the `'content-type'` HTTP header is `'x-www-form-urlencoded'`, `HttpCommand` will parse `Params` as follows. If `Params` is:

* A simple character vector, `HttpCommand` will leave it unaltered if it consists only of valid URLencode characters (as found in `HttpCommand.ValidFormUrlEncodedChars`).  Otherwise it will URLencode it using [`HttpCommand.URLencode`](reference#urlencode).
* A [Name/Value Pairs](#namevalue-pairs) specification.

If the `'content-type'` HTTP header is `'application/json'`, `HttpCommand` will interpret `Params` as follows:

* If `Params` is a simple character vector that is a valid JSON representation, it is left unaltered and inserted in the body of the request.
* Otherwise, the result of `1 ⎕JSON Params` inserted in the body of the request.

In all other cases, the results of `∊⍕Params` is inserted in the body of the request. Any further preparation of `Params`, like Base64-encoding, is the responsibility of the user.

#### Headers Details


#### Name/Value Pairs
`Headers` and, in some cases, `Params` are treated as name/value pairs. `HttpCommand` gives you some flexibility in how you specify name/value pairs. You may use:

* A vector of depth 2 or ¯2 with an even number of elements.<br> For example: `('name' 'dyalog' 'age' 39)`
* A vector of 2-element vectors, `HttpCommand` will treat each sub-vector as a name/value pair.<br>For example: `(('name' 'dyalog') ('age' 39))`
* A 2-column matrix where each row represents a name/value pair.<br>For example: `2 2⍴'name' 'dyalog' 'age' 39`
* A reference to a namespace, `HttpCommand` will treat the variables and their values in the namespace as name/value pairs.<br>For example: `ns←⎕NS '' ⋄ ns.(name age)←'dyalog' 39`<br>Note that the names will be alphabetical in the formatted output.