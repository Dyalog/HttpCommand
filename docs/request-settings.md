Request-related settings are settings you use to specify attributes of the HTTP request that `HttpCommand` will process.
## Settings
### `Command`
<table><tr>
<td>Description</td>
<td>The case-insensitive HTTP command (method) for the request. <code>Command</code> is not limited to standard HTTP methods like GET, POST, PUT, HEAD, OPTIONS, and DELETE, but can be any string provided that the host has implemented support for it.</td></tr>
<tr><td>Default</td><td><code>'GET'</code></td></tr>
<tr><td>Example(s)</td><td><code>h.Command←'POST'</code></td></tr></table>

### `URL`
<table><tr>
<td>Description</td>
<td>The URL for the request.<br>The general format for <code>URL</code> is: 
<code>[scheme://][userinfo@]host[:port][/path][?query]</code><br>
At a minimum the <code>URL</code> must specify the host.</td></tr>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>h.URL←'dyalog.com'<br>h.URL←'https://user:pwd@adomain.com:8080/apath/endpoint?name=Drake</code></td></tr>
<tr><td>Details</td><td>
A URL has the general format:<br><code>[scheme://][userinfo@]host[:port][/path][?query]</code>
<br><br>
So, a URL can be as simple as just a host name like <code>'dyalog.com'</code> or as complex as <code>'https://username:password@ducky.com:1234/?id=myid&time=1200'</code>
<br><br>
The only mandatory segment is the <code>host</code>; <code>HttpCommand</code> will infer or use default information when it builds the HTTP request to be sent.
<ul>
<li>
scheme - if supplied, it must be either <code>'http'</code>, or <code>'https'</code> for a secure connection.  If not supplied, <code>HttpCommand</code> will use <code>'http'</code> unless you have specified the default HTTPS port (443) or provided SSL certificate parameters.
</li><li>
userinfo - used for HTTP Basic authentication. HTTP Basic authentication has generally been deprecated, but may still be supported by some hosts. If userinfo is supplied, <code>HttpCommand</code> will create a proper Base64-encoded <code>authorization</code> header.
</li><li>
host - the host/domain for the request
</li><li>
port - if not supplied, <code>HttpCommand</code> will use the default HTTP port (80) unless the HTTPS scheme is used or certificate parameters are specified in which case the default HTTPS port (443) is used.
</li><li>
path - the location of the resource within the domain. If not supplied, it's up to the domain's server to determine the default path.
</li><li>
query - the query string for the request. If the HTTP method for the request is <code>'GET'</code> or <code>'HEAD'</code> and request parameters are specified in <code>Params</code>, <code>HttpCommand</code> will properly format them and append them to the query string. If you choose to supply query string parameters directly, they should be properly URLencoded. (see <a href="shared#urlencode"><code>URLencode</code></a>)
</li></ul>
</td></tr></table>

### `Params`
<table>
    <tr>
        <td>Description</td>
        <td>The parameters or payload, if any, for the request. <code>Params</code> can be a set of <a
                href="#namevalue-pairs">name/value pairs</a> or a character vector that is properly formatted for the <a
                href="#contenttype"><code>ContentType</code></a> or <a href="#command"><code>Command</code></a> of the
            request. See details for more information.<br/>
            </td>
    </tr>
    <tr>
        <td>Default</td>
        <td><code>''</code></td>
    </tr>
    <tr>
        <td>Example(s)</td>
        <td>The following examples are
            equivalent:<br /><code>h.Params←(('name' 'dyalog') ('age' 39))</code><br /><code>ns←⎕NS '' ⋄ ns.(name age)←'dyalog' 39 ⋄ h.Params←ns</code>
        </td>
    </tr>
    <tr>
        <td>Details</td>
        <td>If <code>Params</code> is not empty, its interpretation is dependent on <code>Command</code> and the content type of the
            request. The content type is determined by the <a href="#contenttype"><code>ContentType</code></a> setting or
            the presence of a <code>content-type</code> header.<br /><br />
            If <code>Command</code> is <code>'GET'</code> or <code>'HEAD'</code>, the request will generally not have a payload in the message body (and hence no specified content type) and <code>Params</code> will be URLEncoded if necessary and appended to the query string of <code>URL</code>.<br/><br/>
            If <code>Command</code> is neither <code>'GET'</code> nor <code>'HEAD'</code> and no content type has been
                    specified, <code>HttpCommand</code> will attempt to infer the content type as follows:
            <ul><li>If <code>Params</code> is a simple character vector and looks like JSON <code>HttpCommand</code> will set the content type as <code>'application/json'</code>; otherwise it will set the content type to <code>`application/x-www-form-urlencoded'</code>. <code>Params</code> will then be processed as described below.</li><li>Otherwise <code>HttpCommand</code> will set the content type to <code>'application/json'</code> and <code>Params</code> will be processed as described below.</li></ul>
            If the content type is specified, <code>Params</code> is processed based on the content type and inserted as the payload of the request.  If the content type is:<ul>
                        <li><code>'x-www-form-urlencoded'</code>: <code>Params</code> will be formatted using <a
                                href="shared#urlencode"><code>UrlEncode</code></a> unless it already composed completely of valid URLEncoding characters.</li>
                        <li><code>'application/json'</code>:<ul>
                                <li>If <code>Params</code> is a character vector that is a valid JSON representation, it is left unaltered.</li>
                                <li>Otherwise <code>Params</code> will be converted to JSON format using <code>1 ⎕JSON</code>.</li>
                                <li>In the case where <code>Params</code> is an APL character vector that is also valid JSON, you should convert it to JSON prior to setting <code>Params</code>. For example, if you have the character vector <code>'[1,2,3]'</code> and you want it treated as a string in JSON and not the numeric array <code>[1,2,3]</code>, you should process it yourself using <code>1 ⎕JSON</code>.</li>
                            </ul>
                        </li>
                        <li>For any other content type, it is the responsibility of the user to
                            format <code>Params</code> appropriately for that content type.</li>
                    </ul>
                </li>
                           </ul>
                </li>
            </ul>
        </td>
    </tr>
</table>

### `Headers`
<table><tr>
<td>Description</td>
<td>The HTTP headers for the request. Specified as one of:
<ul><li>a set of <a href="#namevalue-pairs">name/value pairs</a>.</li>
<li>a character vector of of one or more name/value pairs in the form <code>'name:value'</code> separated by CRLF  (<code>⎕UCS 13 10</code>).</li>
<li>a vector of character vectors, each in the form <code>'name:value'</code></li>
</td></tr>
<tr><td>Default</td><td>By default, <code>HttpCommand</code> will create the following headers if you have not supplied them yourself:<br/>
<code>Host: </code>the host specified in <code>URL</code><br/>
<code>User-Agent: 'Dyalog/HttpCommand 5.0.1'</code> or whatever the version happens to be</code><br/>
<code>Accept: '*/*'</code><br/><br/>
If the request content type has been specified, <code>HttpCommand</code> will insert an appropriate <code>content-type</code> header.
If the request has content in the request payload, Conga will automatically supply a <code>content-length</code> header.
</td></tr>
<tr><td>Example(s)</td><td>The following examples are equivalent:<br/>
<code>h.Headers←'accept' 'text/html' 'content-type' 'test/plain'</code>
<br/>
<code>h.Headers←('accept' 'text/html')('content-type' 'test/plain')</code>
<br/>
<code>h.Headers←'accept:text/html',(⎕UCS 13 10),'content-type:text/plain'</code>
<br/>
<code>h.Headers←('accept:text/html')('content-type:text/plain')</code></td></tr></table>

### `ContentType`
<table><tr>
<td>Description</td>
<td>This setting is a convenient shortcut for setting the <code>content-type</code> HTTP header of the request. If you happen set both <code>ContentType</code> and a <code>content-type</code> header, <code>ContentType</code> takes precedence.
</td></tr>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>h.ContentType←'application/json; charset=UTF-8'</code></td></tr>
<tr><td>Details</td>
<td>See <a href="/userguide/#content-types">Content Types</a> for additional information.</td></tr>
</table>

### `Auth`
<table><tr>
<td>Description</td>
<td>This setting is the authentication/authorization string appropriate for the authentication scheme specified in <code>AuthType</code>. Used along with <a href="#authtype"><code>AuthType</code></a>, <code>Auth</code> is a shortcut for setting the authorization HTTP header for requests that require authentication.  If <code>Auth</code> is non-empty, <code>HttpCommand</code> will create an <code>'authorization'</code> header and and set its value to <code>AuthType,' ',Auth</code>. If you happen set both <code>Auth</code> and an <code>authorization</code> header, <code>Auth</code> takes precedence.
</td></tr>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>h.Auth←'my-secret-token'</code>
<br/>
<code>h.Auth←h.Base64Encode 'userid:password' ⍝ HTTP Basic Authentication</code><br/>
<code>h.Auth←'userid' 'password' ⍝ HTTP Basic Authentication</code></td></tr>
<tr><td>Details</td>
<td>For HTTP Basic Authentication, <code>Auth</code> can be set to any of<ul><li> <code>HttpCommand.Base64Encode 'userid:password'</code></li>
<li><code>'userid' 'password'</code></li>
<li><code>'userid:password'</code></li></ul>
For the latter two items above:<ul><li>it is permissible to not set <code>AuthType</code> as <code>HttpCommand</code> will infer the authorization scheme is HTTP Basic.</li>
<li><code>HttpCommand</code> will properly format and <code>Base64Encode</code> the header value.</li></ul>
Alternatively, if you provide HTTP Basic credentials in the <code>URL</code> as in <code>'https://username:password@someurl.com'</code>, <code>HttpCommand</code> will automatically generate a proper <code>'authorization'</code> header.  
</td></tr></table>

### `AuthType`
<table><tr>
<td>Description</td>
<td>This setting is used in conjunction with <a href="#auth">Auth</a> and is a character vector indicating the authentication scheme. Three common authentication schemes are:
<ul><li><code>'Basic'</code> for HTTP Basic Authentication</li><li><code>'Bearer'</code> for OAuth 2.0 token authentication</li><li><code>'Token'</code> for other token-based authentication schemes such as GitHub's Personal Access Token scheme</li></ul>
Other values may be used as necessary for your particular HTTP request.</td></tr>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>h.AuthType←'Bearer'</code></td></tr>
<tr><td>Details</td><td>
If <code>AuthType</code> is not set and <code>Auth</code> is set to either a character vector in the form <code>'userid:password'</code> or a 2-element vector of character vectors as in <code>('userid' 'password')</code> <code>HttpCommand</code> will infer the <code>AuthType</code> to be <code>'Basic'</code>.<br/><br/><b>Note: </b>While authentication schemes are supposed to be case insensitive, some servers are not so forgiving and require the authentication scheme to be appropriately cased.</table>

### `UseZip`
<table><tr>
<td>Description</td>
<td><code>UseZip</code> controls whether the request payload is zipped. Valid values are:
<ul><li><code>0</code> = do not zip the request payload.</li>
<li><code>1</code> = use gzip encoding</li>
<li><code>2</code> = use deflate encoding</li>
</ul></td></tr>
<tr><td>Default</td>
<td><code>0</code></td></tr>
<tr><td>Details</td>
<td>The <a href="#ziplevel">ZipLevel</a> setting controls the level of compression when using gzip or deflate encoding.</td></tr>
</table>

### `ZipLevel`
<table><tr>
<td>Description</td>
<td><code>ZipLevel</code> controls the level of compression when using gzip or deflate encoding. Valid values are <code>0</code> through <code>9</code>. Higher values use a higher degree of compression but also consume more CPU.</td></tr>
<tr><td>Default</td>
<td><code>3</code></td></tr>
<tr><td>Details</td>
<td>The <a href="usezip">UseZip</a> setting controls which compression algorithm, if any, is used.</td></tr>
</table>

### `Cookies`
<table><tr>
<td>Description</td>
<td><code>Cookies</code> is a vector of namespaces, each containing a representation of an HTTP cookie. It contains cookies sent by the host that may be used in a series of requests to the same host. This setting should be considered read-only.</td></tr>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>      (c ← HttpCommand.New 'get' 'github.com').Run</code><br/>
<code>[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 299959]
</code><br/>
<code>      ≢ c.Cookies</code><br/>
<code>3</code><br/>

<code>      ↑c.Cookies.(Name Host ('DD-MMM-YYYY'(1200⌶)Creation))</code><br/>
<code> _gh_sess   github.com   05-AUG-2022</code><br/>  
<code> _octo      github.com   05-AUG-2022</code><br/>  
<code> logged_in  github.com   05-AUG-2022</code><br/>  
</td></tr></table>


## Name/Value Pairs
`Params`, for an appropriate content type, and `Headers` can be specified as name/value pairs. `HttpCommand` gives you some flexibility in how you specify name/value pairs. You may use:

* A vector of depth `2` or `¯2` with an even number of elements.<br>      `('name' 'dyalog' 'age' 39)`
* A vector of 2-element vectors, `HttpCommand` will treat each sub-vector as a name/value pair.<br>      `(('name' 'dyalog') ('age' 39))`
* A 2-column matrix where each row represents a name/value pair.<br>      `2 2⍴'name' 'dyalog' 'age' 39`
* A reference to a namespace, `HttpCommand` will treat the variables and their values in the namespace as name/value pairs.<br>      `ns←⎕NS '' ⋄ ns.(name age)←'dyalog' 39`<br>Note that the names will be alphabetical in the formatted output.