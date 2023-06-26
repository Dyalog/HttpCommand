## Base64 Encoding
Base64 is a binary-to-text encoding scheme that is used to transmit binary data over channels the only reliably support text content. Among Base64's uses are:

* Embed images or other binary assets in HTML files.
* Encode user credentials for HTTP Basic Authentication  

### `Base64Decode` 
Decode a Base64-encoded string or single-byte integer vector.
<table>
<tr><td>Syntax</td>
<td><code>out←{cpo} HttpCommand.Base64Decode b64</code></td></tr>
<tr><td><code>b64</code></td>
<td>A character vector of Base64-encoded data.</td></tr>
<tr><td><code>cpo</code></td>
<td>(optional) cpo stands for "code points only".  It can be any value, its mere existence is all that is necessary. You would use it in the case where you do not want <code>Base64Decode</code> to perform a UTF-8 conversion on the result. In almost all use cases, you can ignore this argument.</td></tr>
<tr><td><code>out</code></td>
<td>A character vector representing the decoded base-64 right argument.</td></tr>
<tr><td>Example(s)</td>
<td><code>      HttpCommand.Base64Decode 'RHlhbG9nIOKNuuKNtOKMig=='</code><br>
<code>Dyalog ⍺⍴⌊</code></td></tr>
</table>

### `Base64Encode` 
Base64 encode a string or integer vector.
<table>
<tr><td>Syntax</td>
<td><code>b64←{cpo} HttpCommand.Base64Encode in</code></td></tr>
<tr><td><code>in</code></td>
<td>Either an integer vector with values in the range 0-255 or a character vector to be encoded</td></tr>
<tr><td><code>cpo</code></td>
<td>(optional) cpo stands for "code points only". If not supplied, <code>Base64Encode</code> will first perform UTF-8 conversion on a character argument. If any value for <code>cpo</code> is supplied, no conversion will be performed. If <code>in</code> is integer, no conversion is performed. The only use case for this argument is when you have already UTF-8 converted the <code>in</code> and you don't want <code>Base64Encode</code> to perform a second conversion.</td></tr>
<tr><td><code>b64</code></td>
<td>A character vector representing the base-64 encoding of the right argument.</td></tr>
<tr><td>Example(s)</td>
<td><code>      HttpCommand.Base64Encode 'Dyalog ⍺⍴⌊'</code><br>
<code>RHlhbG9nIOKNuuKNtOKMig==</code></td></tr>
</table>

## URL Encoding
URLs can only be sent over the Internet using the ASCII character set. However, URLs often contain characters outside the ASCII character set. URL encoding converts strings to a format acceptable for transmission over the Internet.  URLEncoding is also used to encode payloads for content-type `'application/x-www-form-urlencoded'`.

### `UrlDecode`
URLDecode a URLEncoded string.
<table>
<tr><td>Syntax</td>
<td><code>out←HttpCommand.UrlDecode in</code></td></tr>
<tr><td><code>in</code></td>
<td>A URLEncoded string</td></tr>
<tr><td><code>out</code></td>
<td>The URLDecoding of <code>in</code>.</td></tr>
<tr><td>Example(s)</td>
<td><code>      HttpCommand.UrlDecode 'Dyalog%20%E2%8D%BA%E2%8D%B4%E2%8C%8A'</code><br/>
<code>Dyalog ⍺⍴⌊</code><br/><br/>
<code>      HttpCommand.UrlDecode 'name=Donald%20Duck'</code><br/>
<code>name=Donald Duck</code><br/><br/>
<code>      HttpCommand.UrlDecode 'first=Donald&last=O%27Mallard'</code><br/>
<code>first=Donald&last=O'Mallard</code><br/>
</td></tr>
</table>

### `UrlEncode`
URLEncode a string or a set of name/value pairs.
<table>
<tr><td>Syntax</td>
<td><code>out←{name} HttpCommand.UrlEncode in</code></td></tr>
<tr><td><code>in</code></td>
<td>One of:<ul>
<li>a simple character vector to be URLEncoded</li>
<li>a set of <a href="/request-settings#namevalue-pairs">name/value pairs</a></li>
</ul></td></tr>
<tr><td><code>name</code></td>
<td>(optional) The name for the URLEncoded right argument. Applies only in the case where <code>in</code> is a simple character vector.</td></tr>
<tr><td><code>out</code></td>
<td>The URLEncoding of <code>in</code>.</td></tr>
<tr><td>Example(s)</td>
<td><code>      HttpCommand.UrlEncode 'Dyalog ⍺⍴⌊'</code><br/>
<code>Dyalog%20%E2%8D%BA%E2%8D%B4%E2%8C%8A</code><br/><br/>
<code>      'name' HttpCommand.UrlEncode 'Donald Duck'</code><br/>
<code>name=Donald%20Duck</code><br/><br/>
<code>      HttpCommand.UrlEncode ('first' 'Donald') ('last' 'O''Mallard')</code><br/>
<code>first=Donald&last=O%27Mallard</code><br/>
</td></tr>
</table>