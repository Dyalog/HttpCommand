# Reference



## Miscellaneous Notes

### **Params** and **Command** and `content-type`
The interpretation of the **`Params`** configuration parameter is dependent the **`Command`** parameter (HTTP method) and the content-type HTTP header, if present. If the HTTP method is GET or HEAD, there is no content in the request and **`Params`** is interpreted to be query parameters for the URL.  For any method other than GET or HEAD, the interpretation of **`Params`** is dependent on the content-type HTTP header. 

The content-type header specifies the content type of the body of the HTTP request. **HttpCommand** recognizes two specific content-types for the convenience of its users - `'application/x-www-form-urlencoded'` and `'application/json'`. If the user does not specify a content-type, **HttpCommand** uses a default content type of `'application/x-www-form-urlencoded'`. 

When content-type header is `'application/x-www-form-urlencoded'`, **`Params`** are name/value pairs and may be represented in several ways:
1. a 2-column matrix of [;1] name [;2] value pairs - `Params←2 2⍴'foo' 'goo' 'moo' '⍺*⎕'`
2. a vector of 2-item vectors of (name value) pairs - `Params←(('foo' 'goo')('moo' '⍺*⎕'))`
3. a vector with an even number of elements of alternating names and values - `Params←'foo' 'goo' 'moo' '⍺*⎕'`
4. a namespace with named elements assigned values - `(Params←⎕NS'').(foo moo)←'goo' '⍺*⎕'`
5. a properly formatted and URL-encoded character vector - `Params←'foo=goo&moo=%E2%8D%BA*%E2%8E%95'`

**HttpCommand** will properly format and encode the parameters if you use forms 1-4. 

If the content-type header is specified as `'application/json'`, **HttpCommand** will convert non-JSON **`Params`** to JSON format and include them in the body of the request.

For all other content-types, it is incumbent upon the user to properly format **Params** for the content-type in use.

### Secure Connections

### URLs
A URL (Uniform Resource Locator) indicates "where" or "what" the request should act upon.  A URL is in the general format: 
**`[scheme://][userinfo@]host[:port][/path][?query]`**

So, a URL can be as simple as just a host name like fs`'dyalog.com'` or as complex as `'https://username:password@ducky.com:1234?id=myid&time=1200'`

The only mandatory segment is the host - **HttpCommand** will infer or use default information when it builds the HTTP request to be sent.

- scheme - if supplied, it must be either `'http'` or `'https'` for a secure connection.  If not supplied, **HttpCommand** will use `'http'` unless you have specified the default HTTPS port (443) or provided SSL certificate parameters.
- userinfo - used for HTTP Basic authentication
- host - the host/domain for the request
- port - if not supplied, **HttpCommand** will use the default HTTP port (80) unless the HTTPS scheme or certificate parameters are specified, in which case the default HTTPS port (443) is used.
- path - the location of the resource within the domain. If not supplied, it's up to the domain's server to determine the default path.
- query - the query string for the request. If the HTTP method for the request is GET and request parameters are specified in the Params configuration setting, **HttpCommand
- ** will properly format them in the query string.
