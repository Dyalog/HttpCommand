For the purposes of this document, we will refer to `result` as the result namespace returned by [`Run`](./instance-methods.md#run) when `RequestOnly=0`. `result` contains information about the request and the response, if any, from the host. Some settings from the request are copied into `result`.

### `HttpStatus`
The integer [HTTP response status code](https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml) returned by the host. Status codes are split into specific ranges:

* 1xx: Informational - Request received, continuing process
* 2xx: Success - The action was successfully received, understood, and accepted
* 3xx: Redirection - Further action must be taken in order to complete the request
* 4xx: Client Error - The request contains bad syntax or cannot be fulfilled
* 5xx: Server Error - The server failed to fulfill an apparently valid request
### `HttpMessage`
A character vector indicating the HTTP message coresponding to the HTTP status code.   
### `HttpVersion`
A character vector indicating the HTTP version used by the host. 
### `Data`
In most cases `Data` will be the response's character vector payload. `Data` is not populated if the `OutFile` setting is set - the payload is instead written, as received, to file.

The `Content-Type` response header will indicate the type of data in the payload and the `Content-Encoding` header, if present, will indicate the compression scheme used if the payload is compressed.

If the response payload is compressed using 'deflate' or 'gzip' encoding `HttpCommand` will uncompress the payload.

If the `Content-Type` header indicates that the UTF-8 character set is used, `HttpCommand` will convert the payload to UTF-8. 

`HttpCommand` can translate certain content types into a format that may be more useful in the APL environment.  If the [`TranslateData`](./operational-settings.md#translatedata) is set to `1`, `HttpCommand` will attempt to convert the response payload for the following content types:

* `application/json` - `HttpCommand` will use `⎕JSON`
* `text/xml` or `application/xml` - `HttpCommand` will use `⎕XML`
* `application/x-www-form-urlencoded` - `HttpCommand` will parse into a namespace.
### `Headers`
`Headers` is the 2-column matrix of response header name/value pairs.

Note: There are two sets of headers in an HTTP request/response transaction - the request headers that are sent to the host, and the response headers that are sent back from the host.
### `∇GetHeader` 
`GetHeader` is a utility function included in the result namespace that makes it easier to extract response header values. `GetHeader` accommodates the case-insensitive nature of header names. If the header does not exist, `GetHeader` returns `''`.

|--|--|
|Syntax|`value ← {headers} result.GetHeader name`|
|`name`|A character vector header name, or vector of header names|
|`headers`|The optional header array to extract from. By default, `GetHeader` will use the response's `Headers` array. You may also pass the `Headers` element of a redirection (see [Redirections](#redirections).|
|`value`|The header value(s) corresponding to the header names specified in `name`, or the empty vector `''` for header name(s) that don't exist.|
|Example(s)|<pre style="font-family:APL;">      result.GetHeader 'content-type'<br/>text/html; charset=utf-8<br/><br/>      ⍝ Note: there is no 'fred' header<br/>      result.GetHeader 'content-type' 'fred' 'server'<br/>┌────────────────────────┬┬──────────────────────┐<br/>│text/html; charset=utf-8││Apache/2.4.18 (Ubuntu)│<br/>└────────────────────────┴┴──────────────────────┘|

### `Cookies`
`Cookies` is a vector of namespaces, one per cookie set by the host. `Cookies ` are frequently used to maintain a state between the client (`HttpCommand`) and the host. When using an instance of `HttpCommand`, the instance will retain a copy of `Cookies` and apply appropriate cookies to subsequent requests.

The sample below shows the names and first 50 characters of the values of 3 cookies returned by GitHub.com. The first cookie holds the session ID.
```
      'Name' 'Value'⍪↑(HttpCommand.Get'github.com').Cookies.(Name((50∘⌊∘≢↑⊢)Value))
 Name       Value                                              
 _gh_sess   A0ZezbnUgtkiq1lBubH7mrXclGhvhcCFKRUbAb045wGNT2Hlma 
 _octo      GH1.1.809596667.1660313286                         
 logged_in  no                                                 

```
### `PeerCert`
If the connection to the host uses HTTPS as its protocol which means it is a secure connection, then `PeerCert` contains the X509 certificate of the host.
```
      ⊃(HttpCommand.Get 'dyalog.com').PeerCert.Formatted.(Issuer Subject)
┌──────────────────────────┬───────────────┐
│C=US,O=Let's Encrypt,CN=R3│CN=*.dyalog.com│
└──────────────────────────┴───────────────┘
```
### `Redirections`
`Redirections` is a vector of namespaces, one per HTTP redirect response from the host. An HTTP redirect is a special kind of response from the host that directs the client to another location for the resource that's being requested. When a web browser like Google Chrome or Mozilla Firefox receives a redirect response, they automatically reissue the request for the resource at the new location. The new location is specified in the response's `Location` header.  A redirection can itself be redirected and can even result in an infinite redirection loop. `HttpCommand` will also follow the redirections, but it also retains information about each redirection in `Redirections`. The [`MaxRedirections`](./operational-settings.md#maxredirections) setting can limit the number of redirections that `HttpCommand` will follow.

Each namespace in `Redirections` has the following elements:

|--|--|
|`HttpStatus`|The HTTP status for the request.|
|`HttpMessage`|The corresponding HTTP status message for the request.|
|`HttpVersion`|The HTTP version that was used in sending the response.|
|`Headers`|The headers that were sent by the host. There should be a `'Location'` header that indicates the redirection location for the requested resource.|
|`URL`|The URL that was used and produced this redirection.|

The example below uses `https://httpbin.org/relative-redirect/2`](https://httpbin.org/relative-redirect/2) to redirect the request twice.

```
      ⊢result ← HttpCommand.Get 'https://httpbin.org/relative-redirect/2'
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 266]
```

Examining the information in the 2 redirections shows that our original `URL`, `'httpbin.org/relative-redirect/2'`, was redirected to `/relative-redirect/1` which was subsequently redirected to `/get`.

```
      'URL' 'Was redirected to'⍪result.(Redirections.URL,⍪Redirections.Headers GetHeader¨⊂'location')
┌───────────────────────────────────────┬────────────────────┐
│URL                                    │Was redirected to   │
├───────────────────────────────────────┼────────────────────┤
│https://httpbin.org/relative-redirect/2│/relative-redirect/1│
├───────────────────────────────────────┼────────────────────┤
│httpbin.org/relative-redirect/1        │/get                │
└───────────────────────────────────────┴────────────────────┘
```