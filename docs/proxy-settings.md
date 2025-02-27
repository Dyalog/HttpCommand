Proxy-related settings are settings you use to specify attributes in order to use a proxy server for your request. See [Using a Proxy Server](./proxy.md) for more information on how to use a proxy server with `HttpCommand`.
## Settings

### `ProxyURL`

|--|--|
|Description|The URL for the proxy server which will relay the request.|
|Default|`''`|
|Example(s)|`h.ProxyURL←'http://someproxyserver.com'`|
|Details|The format for `ProxyURL` is the same as [`URL`](./request-settings.md#url).|

### `ProxyHeaders`

|--|--|
|Description|The HTTP headers, if any, specifically for the proxy server's `CONNECT` request to the host.|
|Default|`0 2⍴⊂''`|
|Details|The format for `ProxyHeaders` is the same as [`Headers`](./request-settings.md#headers).<br/>If you specify proxy authentication either as a part of `ProxyURL` or by setting `ProxyAuth` and `ProxyAuthType`, `HttpCommand` will create a `Proxy-Authorization` header.|

### `ProxyAuth`

|--|--|
|Description|This setting is the authentication/authorization string appropriate for the authentication scheme specified in `ProxyAuthType`. Used along with [`ProxyAuthType`](#proxyauthtype), `ProxyAuth` is a shortcut for setting the proxy-authorization HTTP header for requests that require proxy authentication.  If `ProxyAuth` is non-empty, `HttpCommand` will create a `'proxy-authorization'` header and and set its value to `ProxyAuthType,' ',ProxyAuth`. If you happen set both `ProxyAuth` and a `proxy-authorization` header, `ProxyAuth` takes precedence.|
|Default|`''`|
|Example(s)|`h.ProxyAuth←'id' 'password' ⍝ HTTP Basic Authentication`<br/>`h.ProxyAuth←h.Base64Encode 'id:password' ⍝ HTTP Basic Authentication`|
|Details|For HTTP Basic Authentication, `ProxyAuth` can be set to any of<ul><li> `HttpCommand.Base64Encode 'userid:password'`</li><li>`'userid' 'password'`</li><li>`'userid:password'`</li></ul>For the latter two items above:<ul><li>it is permissible to not set `ProxyAuthType` as `HttpCommand` will infer the authorization scheme is HTTP Basic.</li><li>`HttpCommand` will properly format and `Base64Encode` the header value.</li></ul>Alternatively, if you provide HTTP Basic credentials in `ProxyURL` as in `'http://username:password@someproxy.com'`, `HttpCommand` will automatically generate a proper `'proxy-authorization'` header.  |

### `ProxyAuthType`

|--|--|
|Description|This setting is used in conjunction with [ProxyAuth](#proxyauth) and is a character vector indicating the authentication scheme. Three common authentication schemes are:<ul><li>`'Basic'` for HTTP Basic Authentication</li><li>`'Bearer'` for OAuth 2.0 token authentication</li><li>`'Token'` for other token-based authentication schemes such as GitHub's Personal Access Token scheme</li></ul>Other values may be used as necessary for your particular HTTP request.|
|Default|`''`|
|Example(s)|`h.ProxyAuthType←'Basic'`|
|Details|If `ProxyAuthType` is not set and `ProxyAuth` is set to either a character vector in the form `'userid:password'` or a 2-element vector of character vectors as in `('userid' 'password')` `HttpCommand` will infer the `ProxyAuthType` to be `'Basic'`.|