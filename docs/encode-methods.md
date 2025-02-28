## Base64 Encoding
Base64 is a binary-to-text encoding scheme that is used to transmit binary data over channels the only reliably support text content. Among Base64's uses are:

* Embed images or other binary assets in HTML files.
* Encode user credentials for HTTP Basic Authentication  

### `Base64Decode` 
Decode a Base64-encoded string or single-byte integer vector.

|--|--|
|Syntax|`out←{cpo} HttpCommand.Base64Decode b64`|
|`b64`|A character vector of Base64-encoded data.|
|`cpo`|(optional) cpo stands for "code points only".  It can be any value, its mere existence is all that is necessary. You would use it in the case where you do not want `Base64Decode` to perform a UTF-8 conversion on the result. In almost all use cases, you can ignore this argument.|
|`out`|A character vector representing the decoded base-64 right argument.|
|Example(s)|<pre style="font-family:APL;">      HttpCommand.Base64Decode 'RHlhbG9nIOKNuuKNtOKMig=='<br>Dyalog ⍺⍴⌊</pre>|

### `Base64Encode` 
Base64 encode a string or integer vector.

|--|--|
|Syntax|`b64←{cpo} HttpCommand.Base64Encode in`|
|`in`|Either an integer vector with values in the range 0-255 or a character vector to be encoded|
|`cpo`|(optional) cpo stands for "code points only". If not supplied, `Base64Encode` will first perform UTF-8 conversion on a character argument. If any value for `cpo` is supplied, no conversion will be performed. If `in` is integer, no conversion is performed. The only use case for this argument is when you have already UTF-8 converted the `in` and you don't want `Base64Encode` to perform a second conversion.|
|`b64`|A character vector representing the base-64 encoding of the right argument.|
|Example(s)|<pre style="font-family:APL;">      HttpCommand.Base64Encode 'Dyalog ⍺⍴⌊'<br/>RHlhbG9nIOKNuuKNtOKMig==|


## URL Encoding
URLs can only be sent over the Internet using the ASCII character set. However, URLs often contain characters outside the ASCII character set. URL encoding converts strings to a format acceptable for transmission over the Internet.  URLEncoding is also used to encode payloads for content-type `'application/x-www-form-urlencoded'`.

### `UrlDecode`

URLDecode a URLEncoded string.

|--|--|
|Syntax|`out←HttpCommand.UrlDecode in`|
|`in`|A URLEncoded string|
|`out`|The URLDecoding of `in`.|
|Example(s)|<pre style="font-family:APL;">      HttpCommand.UrlDecode 'Dyalog%20%E2%8D%BA%E2%8D%B4%E2%8C%8A'<br/>Dyalog ⍺⍴⌊<br/><br/>      HttpCommand.UrlDecode 'name=Donald%20Duck'<br/>name=Donald Duck<br/><br/>      HttpCommand.UrlDecode 'first=Donald&last=O%27Mallard'<br/>first=Donald&last=O'Mallard|


### `UrlEncode`
URLEncode a string or a set of name/value pairs.

|--|--|
|Syntax|`out←{name} HttpCommand.UrlEncode in`|
|`in`|One of:<ul><li>a simple character vector to be URLEncoded</li><li>a set of [name/value pairs](./request-settings.md#namevalue-pairs)</li></ul>|
|`name`|(optional) The name for the URLEncoded right argument. Applies only in the case where `in` is a simple character vector.|
|`out`|The URLEncoding of `in`.|
|Example(s)|<pre style="font-family:APL;">      HttpCommand.UrlEncode 'Dyalog ⍺⍴⌊'<br/>Dyalog%20%E2%8D%BA%E2%8D%B4%E2%8C%8A<br/><br/>      'name' HttpCommand.UrlEncode 'Donald Duck'<br/>name=Donald%20Duck<br/><br/>      HttpCommand.UrlEncode ('first' 'Donald') ('last' 'O''Mallard')<br/>first=Donald&last=O%27Mallard|