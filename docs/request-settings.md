Request-related settings are settings you use to specify attributes of the HTTP request that `HttpCommand` will process.
## Instance Settings
### `Command`
|--|--|
| Description | The case-insensitive HTTP command (method) for the request. `Command` is not limited to standard HTTP methods like GET, POST, PUT, HEAD, OPTIONS, and DELETE, but can be any string provided that the host has implemented support for it.|
| Default |`'GET'`|
| Example(s) | `h.Command←'POST'`|

### `URL`
|--|--|
| Description | The URL for the request.<br/>The general format for `URL` is: `[scheme://][userinfo@]host[:port][/path][?query]`<br/>At a minimum the `URL` must specify the host.|
| Default | `''`|
| Example(s) | `h.URL←'dyalog.com'`<br/>`h.URL←'https://user:pwd@adomain.com:8080/apath/endpoint?name=Drake`|
| Details | A URL has the general format:<br/>`[scheme://][userinfo@]host[:port][/path][?query]`<br/><br/>So, a URL can be as simple as just a host name like `'dyalog.com'` or as complex as `'https://username:password@ducky.com:1234/?id=myid&time=1200'`<br/><br/>The only mandatory segment is the `host`; `HttpCommand` will infer or use default information when it builds the HTTP request to be sent.<ul><li>scheme - if supplied, it must be either `'http'`, or `'https'` for a secure connection.  If not supplied, `HttpCommand` will use `'http'` unless you have specified the default HTTPS port (443) or provided SSL certificate parameters.</li><li>userinfo - used for HTTP Basic authentication. HTTP Basic authentication has generally been deprecated, but may still be supported by some hosts. If userinfo is supplied, `HttpCommand` will create a proper Base64-encoded `authorization` header.</li><li>host - the host/domain for the request</li><li>port - if not supplied, `HttpCommand` will use the default HTTP port (80) unless the HTTPS scheme is used or certificate parameters are specified in which case the default HTTPS port (443) is used.</li><li>path - the location of the resource within the domain. If not supplied, it's up to the domain's server to determine the default path.</li><li>query - the query string for the request. If the HTTP method for the request is `'GET'` or `'HEAD'` and request parameters are specified in `Params`, `HttpCommand` will properly format them and append them to the query string. If you choose to supply query string parameters directly, they should be properly URLencoded. (see [`URLEncode`](./encode-methods.md#urlencode)).</li></ul>|

### `Params`
|--|--|
| Description | The parameters or payload, if any, for the request. `Params` can be a set of [name/value pairs](#namevalue-pairs) or a character vector that is properly formatted for the [`ContentType`](#contenttype) or [`Command`](#command) of the request. See details for more information.<br/>|
| Default | `''`|
| Example(s) | The following examples are equivalent:<br/>`h.Params←(('name' 'dyalog') ('age' 39))`<br/>`ns←⎕NS '' ⋄ ns.(name age)←'dyalog' 39 ⋄ h.Params←ns`|
| Details | If `Params` is not empty, its interpretation is dependent on `Command` and the content type of the request. The content type is determined by the [`ContentType`](#contenttype) setting or the presence of a `content-type` header.<br/><br/>If `Command` is `'GET'` or `'HEAD'`, the request will generally not have a payload in the message body (and hence no specified content type) and `Params` will be URLEncoded if necessary and appended to the query string of `URL`.<br/><br/>If `Command` is neither `'GET'` nor `'HEAD'` and no content type has been specified, `HttpCommand` will attempt to infer the content type as follows:<ul><li>If `Params` is a simple character vector and looks like JSON `HttpCommand` will set the content type as `'application/json'`; otherwise it will set the content type to ``application/x-www-form-urlencoded'`. `Params` will then be processed as described below.</li><li>Otherwise `HttpCommand` will set the content type to `'application/json'` and `Params` will be processed as described below.</li></ul>If the content type is specified, `Params` is processed based on the content type and inserted as the payload of the request.  If the content type is:<ul><li>`'x-www-form-urlencoded'`: `Params` will be formatted using [`URLEncode`](./encode-methods.md#urlencode) unless it already composed completely of valid URLEncoding characters.</li><li>`'application/json'`:<ul><li>If `Params` is a character vector that is a valid JSON representation, it is left unaltered.</li><li>Otherwise `Params` will be converted to JSON format using `1 ⎕JSON`.</li><li>In the case where `Params` is an APL character vector that is also valid JSON, you should convert it to JSON prior to setting `Params`. For example, if you have the character vector `'[1,2,3]'` and you want it treated as a string in JSON and not the numeric array `[1,2,3]`, you should process it yourself using `1 ⎕JSON`.</li></ul></li><li>For any other content type, it is the responsibility of the user to format `Params` appropriately for that content type.</li></ul></li></ul></li></ul>|

### `Headers`
|--|--|
| Description | The HTTP headers for the request. Specified as one of:<ul><li>a set of [name/value pairs](#namevalue-pairs)</li><li>a character vector of of one or more name/value pairs in the form `'name:value'` separated by CRLF  (`⎕UCS 13 10`).</li><li>a vector of character vectors, each in the form `'name:value'`</li>|
| Default | By default, `HttpCommand` will create the following headers if you have not supplied them yourself:<br/>`Host: `*the host specified in `URL`*<br/>`User-Agent: Dyalog/HttpCommand` *HttpCommandVersionNumber*<br/>`Accept: */*`<br/><br/>If the request content type has been specified, `HttpCommand` will insert an appropriate `content-type` header. If the request has content in the request payload, Conga will automatically supply a `content-length` header.|
| Example(s) | The following examples are equivalent:<br/>`h.Headers←'accept' 'text/html' 'content-type' 'test/plain'`<br/>`h.Headers←('accept' 'text/html')('content-type' 'test/plain')`<br/>`h.Headers←'accept:text/html',(⎕UCS 13 10),'content-type:text/plain'`<br/>`h.Headers←('accept:text/html')('content-type:text/plain')`|

### `ContentType`
|--|--|
| Description | This setting is a convenient shortcut for setting the `content-type` HTTP header of the request. If you happen set both `ContentType` and a `content-type` header, `ContentType` takes precedence.| 
| Default| `''`| 
| Example(s)| `h.ContentType←'application/json; charset=UTF-8'`| 
| Details | See [Content Types](./content-types.md) for additional information.| 

### `Auth`
|--|--|
| Description | This setting is the authentication/authorization string appropriate for the authentication scheme specified in `AuthType`. Used along with [`AuthType`](#authtype), `Auth` is a shortcut for setting the authorization HTTP header for requests that require authentication.  If `Auth` is non-empty, `HttpCommand` will create an `'authorization'` header and and set its value to `AuthType: Auth`. If you happen set both `Auth` and an `'authorization'` header, `Auth` takes precedence.<br/><br/>You may specify an environment variable whose value is to be used for `Auth` by enclosing the environment variable name according to the [`HeaderSubstitution`](#headersubstitution) setting.. This helps avoid the need to hardcode credentials in your code.| 
| Default| `''`| 
| Example(s)| `h.Auth←'my-secret-token'`<br/>`h.Auth←h.Base64Encode 'userid:password' ⍝ HTTP Basic Authentication`<br/>`h.Auth←'userid' 'password' ⍝ HTTP Basic Authentication`| 
| Details | For HTTP Basic Authentication, `Auth` can be set to any of<ul><li> `HttpCommand.Base64Encode 'userid:password'`</li><li>`'userid' 'password'`</li><li>`'userid:password'`</li></ul>For the latter two items above:<ul><li>it is permissible to not set `AuthType` as `HttpCommand` will infer the authorization scheme is HTTP Basic.</li><li>`HttpCommand` will properly format and `Base64Encode` the header value.</li></ul>Alternatively, if you provide HTTP Basic credentials in the `URL` as in `'https://username:password@someurl.com'`, `HttpCommand` will automatically generate a proper `'authorization'` header.| 

### `AuthType`
|--|--|
| Description | This setting is used in conjunction with <a href="#auth">Auth</a> and is a character vector indicating the authentication scheme. Three common authentication schemes are:<ul><li>`'Basic'` for HTTP Basic Authentication</li><li>`'Bearer'` for OAuth 2.0 token authentication</li><li>`'Token'` for other token-based authentication schemes such as GitHub's Personal Access Token scheme</li></ul>Other values may be used as necessary for your particular HTTP request.| 
| Default| `''`| 
| Example(s)| `h.AuthType←'Bearer'`| 
| Details| If `AuthType` is not set and `Auth` is set to either a character vector in the form `'userid:password'` or a 2-element vector of character vectors as in `('userid' 'password')` `HttpCommand` will infer the `AuthType` to be `'Basic'`.<br/><br/>**Note:** While authentication schemes are supposed to be case insensitive, some servers are not so forgiving and require the authentication scheme to be appropriately cased.|

### `UseZip`
|--|--|
| Description | `UseZip` controls whether the request payload is zipped. Valid values are:<ul><li>`0` = do not zip the request payload.</li><li>`1` = use gzip encoding</li><li>`2` = use deflate encoding</li></ul>| 
| Default | `0`| 
| Details | The <a href="#ziplevel">`ZipLevel`</a> setting controls the level of compression when using gzip or deflate encoding.| 

### `ZipLevel`
|--|--|
| Description | `ZipLevel` controls the level of compression when using gzip or deflate encoding. Valid values are `0` through `9`. Higher values use a higher degree of compression but also consume more CPU.| 
| Default | `1`| 
| Details | The [`UseZip`](#usezip) setting controls which compression algorithm, if any, is used.| 

### `BaseURL`
|--|--|
| Description | `BaseURL` can be used when making multiple requests to similar-named endpoints. Set `BaseURL` to the common root of the URLs that you will be using and then set [`URL`](#url) to the remaining portion of the specific URL. `BaseURL` will be prepended to [`URL`](#url) to form the complete URL for the request.  Subsequent calls to other endpoints can be made by setting [`URL`](#url).| 
| Default | `''`| 
| Example(s)|<pre style="font-family:APL;">      h.BaseURL←'https://api.github.com/'<br/>      h.URL←'orgs/Dyalog/repos'<br/>      h.Run<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ≢Data: 153884]<br/>      h.URL←'orgs/Dyalog/members'<br/>      h.Run<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ≢Data: 1911]<br/><br/>      h.BaseURL←'https://api.github.com/repos/Dyalog/HttpCommand/'<br/>      h.URL←'commits'<br/>      h.Run<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ≢Data: 98869]<br/>      h.URL←'branches'<br/>      h.Run<br/>[rc: 0 &#124;  msg:  &#124; HTTP Status: 200 "OK" &#124; ≢Data: 867]</pre>| 
| Details | If `URL` begins with `'http://'` or `'https://'`, `BaseURL` will not be prepended to `URL`.| 

### `Cookies`
|--|--|
| Description | `Cookies` is a vector of namespaces, each containing a representation of an HTTP cookie. It contains cookies sent by the host that may be used in a series of requests to the same host. This setting should be considered read-only.| 
| Default| `''`| 
| Example(s)|<pre style="font-family:APL;">      (c ← HttpCommand.New 'get' 'github.com').Run<br/>[rc: 0 &#124; msg:  &#124; HTTP Status: 200 "OK" &#124; ⍴Data: 299959]<br/>      ≢ c.Cookies<br/>3<br/>      ↑c.Cookies.(Name Host ('DD-MMM-YYYY'(1200⌶)Creation))<br/> _gh_sess   github.com   05-AUG-2022<br/> _octo      github.com   05-AUG-2022<br/> logged_in  github.com   05-AUG-2022</pre>| 

### `ChunkSize`
|--|--|
| Description | A non-zero `ChunkSize` will make `HttpCommand` use "chunked" transfer-encoding and send the payload of the request in chunks of `ChunkSize` bytes. |
| Default | `0` meaning do not use "chunked" transfer-encoding |
| Details | Using a non-zero `ChunkSize` will cause `HttpCommand` to format the payload of the request according to the specification for "chunked" transfer-encoding. This involves breaking the payload into `ChunkSize`-sized chunks each preceded by the hexadecimal length of the chunk. <br><br>**Note:** In the current implementation, the entire, reformatted, payload is sent in a single request to the host. | 

## Shared Settings
### `HeaderSubstitution`
|--|--|
| Description |In the following text, the phrase "environment variable" is taken to mean either an environment variable or a Dyalog configuration setting as both of these are retrieved using the same technique (`2 ⎕NQ # 'GetEnvironment')`.<br/>`HeaderSubstitution` provides a shorthand technique to inject environment variable values into the request's HTTP header names and values. If `HeaderSubstitution` is `''` (the default), no substitution is done. When `HeaderSubstitution` has a non-empty value, it denotes the beginning and ending delimiteres between which you may use the name of an environment variable. If `HeaderSubstitution` is a single character, that character is used as both the beginning and ending delimiter.<br/>
You may also use the delimiters in the [`Auth`](#auth) setting as `Auth` is used to format the HTTP Authorization header.| 
| Default | `''`| 
| Example(s) | For these examples, assume we have an environment variable named "MyVariable" which has a value of `'0123456789'`.<br/><pre style="font-family:APL;">      HttpCommand.HeaderSubstitution←'' ⍝ no substitutions done<br/>      h←HttpCommand.New 'get' 'someurl.com'<br/>      'name' h.SetHeader '%MyVariable%'<br/>      h.Show<br/>GET / HTTP/1.1<br/>name: %MyVariable%<br/>Host: someurl.com<br/>User-Agent: Dyalog-HttpCommand/5.7.0<br/>Accept: */*<br/>Accept-Encoding: gzip, deflate</pre>Now let's specify a delimiter...<br/><pre style="font-family:APL;">      HttpCommand.HeaderSubstitution←'%' ⍝ specify a delimiter<br/>      h.Show<br/>GET / HTTP/1.1<br/>name: 0123456789<br/>Host: someurl.com<br/>User-Agent: Dyalog-HttpCommand/5.7.0<br/>Accept: */*<br/>Accept-Encoding: gzip, deflate</pre>The delimiters do not have to be single characters...<br/><pre style="font-family:APL;">      HttpCommand.HeaderSubstitution←'env:[' ']'<br/>      'name' h.SetHeader 'env:[MyVariable]'<br/>      h.Show<br/>GET / HTTP/1.1<br/>name: 0123456789<br/>Host: someurl.com<br/>User-Agent: Dyalog-HttpCommand/5.7.0<br/>Accept: */*<br/>Accept-Encoding: gzip, deflate</pre><br/>Alternatively, you can use the `GetEnv` method to retrieve environment variables and/or Dyalog configuration settings.<br/><pre style="font-family:APL;">      'name' h.SetHeader GetEnv 'MyAPIKey'</pre>| 
| Details | Many web services require an API key. It is generally considered bad practice to hard-code such API keys in your application code. Storing the keys as environment variables allows them to be retrieved more securely.<br/>If no environment variable matches the name between the delimiters, no substitution is performed.| 

## Name/Value Pairs
`Params`, for an appropriate content type, and `Headers` can be specified as name/value pairs. `HttpCommand` gives you some flexibility in how you specify name/value pairs. You may use:

* A vector of depth `2` or `¯2` with an even number of elements.<br>      `('name' 'dyalog' 'age' 39)`
* A vector of 2-element vectors, `HttpCommand` will treat each sub-vector as a name/value pair.<br>      `(('name' 'dyalog') ('age' 39))`
* A 2-column matrix where each row represents a name/value pair.<br>      `2 2⍴'name' 'dyalog' 'age' 39`
* A reference to a namespace, `HttpCommand` will treat the variables and their values in the namespace as name/value pairs.<br>      `ns←⎕NS '' ⋄ ns.(name age)←'dyalog' 39`<br>Note that the names will be alphabetical in the formatted output.