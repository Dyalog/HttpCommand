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
<td>Either a single-byte integer or character vector to be decoded</td></tr>
<tr><td><code>cpo</code></td>
<td>(optional) If set to 0 or not supplied, Base64Decode will perform UTF-8 conversion on the result. If set to 1, no conversion will be performed. In almost all cases, you can ignore (and not supply) this argument.</td></tr>
<tr><td><code>out</code></td>
<td>A character vector representing the decodes base-64 right argument.</td></tr>
<tr><td>Example(s)</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.Base64Decode 'RHlhbG9nIOKNuuKNtOKMig=='</code><br>
<code>Dyalog ⍺⍴⌊</code></td></tr>
</table>

### `Base64Encode` 
Base64 encode a string or integer vector.
<table>
<tr><td>Syntax</td>
<td><code>b64←{cpo} HttpCommand.Base64Encode in</code></td></tr>
<tr><td><code>in</code></td>
<td>Either an integer or character vector to be encoded</td></tr>
<tr><td><code>cpo</code></td>
<td>(optional) If set to 0 or not supplied, Base64Encode will first perform UTF-8 conversion on a character argument. If set to 1, no conversion will be performed. In almost all cases, you can ignore (and not supply) this argument.</td></tr>
<tr><td><code>b64</code></td>
<td>A character vector representing the base-64 encoding of the right argument.</td></tr>
<tr><td>Example(s)</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.Base64Decode 'RHlhbG9nIOKNuuKNtOKMig=='</code><br>
<code>Dyalog ⍺⍴⌊</code></td></tr>
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
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.UrlDecode 'Dyalog%20%E2%8D%BA%E2%8D%B4%E2%8C%8A'</code><br/>
<code>Dyalog ⍺⍴⌊</code><br/><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.UrlDecode 'name=Donald%20Duck'</code><br/>
<code>name=Donald Duck</code><br/><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.UrlDecode 'first=Donald&last=O%27Mallard'</code><br/>
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
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.UrlEncode 'Dyalog ⍺⍴⌊'</code><br/>
<code>Dyalog%20%E2%8D%BA%E2%8D%B4%E2%8C%8A</code><br/><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'name' HttpCommand.UrlEncode 'Donald Duck'</code><br/>
<code>name=Donald%20Duck</code><br/><br/>
<code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.UrlEncode ('first' 'Donald') ('last' 'O''Mallard')</code><br/>
<code>first=Donald&last=O%27Mallard</code><br/>
</td></tr>
</table>