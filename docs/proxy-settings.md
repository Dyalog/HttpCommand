Proxy-related settings are settings you use to specify attributes in order to use a proxy server for your request. See [Using a Proxy Server](./proxy.md) for more information on how to use a proxy server with `HttpCommand`.
## Settings

### `ProxyURL`
<table><tr>
<td>Description</td>
<td>The URL for the proxy server which will relay the request.</td></tr>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>h.ProxyURL←'http://someproxyserver.com'</code></td></tr>
<tr><td>Details</td><td>
The format for <code>ProxyURL</code> is the same as <a href="request.settings#URL"><code>URL</code></a>.
</td></tr></table>

### `ProxyHeaders`
<table><tr>
<td>Description</td>
<td>The HTTP headers, if any, specifically for the proxy server's <code>CONNECT</code> request to the host.</td></tr>
<tr><td>Default</td><td><code>0 2⍴⊂''</code>
</td></tr>
<tr><td>Details</td><td>The format for <code>ProxyHeaders</code> is the same as <a href="request.settings#Headers"><code>Headers</code></a>.<br/>If you specify proxy authentication either as a part of <code>ProxyURL</code> or by setting <code>ProxyAuth</code> and <code>ProxyAuthType</code>, <code>HttpCommand</code> will create a <code>Proxy-Authorization</code> header.
</td></tr></table>

### `ProxyAuth`
<table><tr>
<td>Description</td>
<td>This setting is the authentication/authorization string appropriate for the authentication scheme specified in <code>ProxyAuthType</code>. Used along with <a href="#proxyauthtype"><code>ProxyAuthType</code></a>, <code>ProxyAuth</code> is a shortcut for setting the proxy-authorization HTTP header for requests that require proxy authentication.  If <code>ProxyAuth</code> is non-empty, <code>HttpCommand</code> will create a <code>'proxy-authorization'</code> header and and set its value to <code>ProxyAuthType,' ',ProxyAuth</code>. If you happen set both <code>ProxyAuth</code> and a <code>proxy-authorization</code> header, <code>ProxyAuth</code> takes precedence.
</td></tr>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>h.ProxyAuth←'id' 'password' ⍝ HTTP Basic Authentication</code>
<br/>
<code>h.ProxyAuth←h.Base64Encode 'id:password' ⍝ HTTP Basic Authentication</code></td></tr>
<tr><td>Details</td>
<td>For HTTP Basic Authentication, <code>ProxyAuth</code> can be set to any of<ul><li> <code>HttpCommand.Base64Encode 'userid:password'</code></li>
<li><code>'userid' 'password'</code></li>
<li><code>'userid:password'</code></li></ul>
For the latter two items above:<ul><li>it is permissible to not set <code>ProxyAuthType</code> as <code>HttpCommand</code> will infer the authorization scheme is HTTP Basic.</li>
<li><code>HttpCommand</code> will properly format and <code>Base64Encode</code> the header value.</li></ul>
Alternatively, if you provide HTTP Basic credentials in <code>ProxyURL</code> as in <code>'http://username:password@someproxy.com'</code>, <code>HttpCommand</code> will automatically generate a proper <code>'proxy-authorization'</code> header.  
</td></tr></table>

### `ProxyAuthType`
<table><tr>
<td>Description</td>
<td>This setting is used in conjunction with <a href="#proxyauth">ProxyAuth</a> and is a character vector indicating the authentication scheme. Three common authentication schemes are:
<ul><li><code>'basic'</code> for HTTP Basic Authentication</li><li><code>'bearer'</code> for OAuth 2.0 token authentication</li><li><code>'token'</code> for other token-based authentication schemes such as GitHub's Personal Access Token scheme</li></ul>
Other values may be used as necessary for your particular HTTP request.</td></tr>
<tr><td>Default</td><td><code>''</code></td></tr>
<tr><td>Example(s)</td><td><code>h.ProxyAuthType←'basic'</code></td></tr>
<tr><td>Details</td><td>
If <code>ProxyAuthType</code> is not set and <code>ProxyAuth</code> is set to either a character vector in the form <code>'userid:password'</code> or a 2-element vector of character vectors as in <code>('userid' 'password')</code> <code>HttpCommand</code> will infer the <code>ProxyAuthType</code> to be <code>'basic'</code>.</td></table>