### Params
**`Params`** is the setting used to specify parameters or

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


