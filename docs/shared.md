** This page is incomplete **

---

In addition to the shared "shortcut" methods listed in [Quick Start](quickstart.md), `HttpCommand` has a few other shared methods are intended to make it easier to manage request and response payload data. 

#### `out←{cpo} HttpCommand.Base64Decode b64`
<table>
<tr><td><code>in</code></td>
<td>Either a single-byte integer or character vector to be encoded</td></tr>
<tr><td><code>cpo</code></td>
<td>(optional) If set to 0 or not supplied, Base64Encode will first perform UTF-8 conversion on a character argument. If set to 1, no conversion will be performed. In almost all cases, you can ignore (and not supply) this argument.</td></tr>
<tr><td><code>b64</code></td>
<td>A character vector representing the base-64 encoding of the right argument.</td></tr>
<tr><td>Example(s)</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.Base64Encode 'Dyalog ⍺⍴⌊'</code><br>
<code>RHlhbG9nIOKNuuKNtOKMig==</code></td></tr>
</table>

#### `b64←{cpo} HttpCommand.Base64Encode in`
<table>
<tr><td><code>in</code></td>
<td>Either a single-byte integer or character vector to be encoded</td></tr>
<tr><td><code>cpo</code></td>
<td>(optional) If set to 0 or not supplied, Base64Encode will first perform UTF-8 conversion on a character argument. If set to 1, no conversion will be performed. In almost all cases, you can ignore (and not supply) this argument.</td></tr>
<tr><td><code>b64</code></td>
<td>A character vector representing the base-64 encoding of the right argument.</td></tr>
<tr><td>Example(s)</td>
<td><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpCommand.Base64Encode 'Dyalog ⍺⍴⌊'</code><br>
<code>RHlhbG9nIOKNuuKNtOKMig==</code></td></tr>
</table>
#### `HttpCommand.UrlDecode`

#### `HttpCommand.UrlEncode`
