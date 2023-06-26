In general, you will not need to set any of the Conga-related settings since the `HttpCommand`'s defaults will suffice for almost all requests. For more information on Conga, please refer to the <a href="https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf" target="_blank">Conga User Guide</a>.

## Instance Settings

### `BufferSize`
<table><tr>
<td>Description</td>
<td>The maximum number of bytes that <code>HttpCommand</code> will accept for the HTTP status and headers received from the host.</td></tr>
<tr><td>Default</td>
<td><code>200000</code></td></tr>
<tr><td>Example(s)</td>
<td><code>h.BufferSize←50000 ⍝ set a lower threshold</code></td></tr>
<tr><td>Details</td>
<td>By default, when using Conga's HTTP mode, as <code>HttpCommand</code> does, <code>BufferSize</code> applies only to the data received by the <code>HTTPHeader</code> event. The intent is to protect against a maliciously large response from the host.  If the data received by the <code>HTTPHeader</code> event exceeds <code>BufferSize</code>, <code>HttpCommand</code> will exit with a return code of 1135.</td></tr></table>

### `WaitTime`
<table><tr>
<td>Description</td>
<td>The number of milliseconds that Conga will wait (listen) for a response before timing out.</td></tr>
<tr><td>Default</td>
<td><code>5000</code></td></tr>
<tr><td>Example(s)</td>
<td><code>h.WaitTime←10000 ⍝ wait 10 seconds</code></td></tr>
<tr><td>Details</td>
<td>This setting applies only to the time Conga will wait internally for a response. There is generally no reason to modify this setting; if your request is timing out, you should set <a href="../../operational-settings#timeout"><code>Timeout</code></a> setting appropriately.  See <a href="../../conga#timeout-and-waittime">Timeout and WaitTime</a> for more information on the relationship between the <code>Timeout</code> and <code>WaitTime</code> settings.</td></tr></table>

### `Cert`
<table><tr>
<td>Description</td>
<td>The certificate specification to be used for secure communications over SSL/TLS. If set, <code>Cert</code> can be either:
<ul><li>an instance of the Conga <code>X509Cert</code> class</li>
<li>a 2-element vector of character vectors representing the full path names to a public certificate file and a private key file. This is a shortcut that can be used instead of specifying both the <code>PrivateKeyFile</code> and <code>PublicCertFile</code> settings.</li>
</ul></td></tr>
<tr><td>Default</td>
<td><code>''</code></td></tr>
<tr><td>Example(s)</td>
<td><code>h.Init ⍝ initialize the local instance of Conga</code>
<br/>
<code>h.Cert← 1⊃h.LDRC.X509Cert.ReadCertUrls ⍝ use the first MS certificate store cert</code>
<br/><br/>
<code>h.Cert← 'path-to-certfile.pem' 'path-to-keyfile.pem'</code></td></tr>
<tr><td>Details</td>
<td>In most cases when using HTTPS for secure communications, the anonymous certificate that <code>HttpCommand</code> will create for you will suffice and you need not set <code>Cert</code>. It should only be necessary to assign <code>Cert</code> in those cases where you need to specify a certificate for authentication purposes.<br/><br/>
Note: <code>Cert</code> is also a positional argument for the shortcut methods (<code>Get</code>, <code>GetJSON</code>, <code>Do</code>, and <code>New</code>) as well as the <code>HttpCommand</code> constructor. <code>Cert</code> appears after the <code>Headers</code> positional argument.  For example:<br/>
<code>h← HttpCommand.Get 'someurl.com' '' '' ('certfile.pem' 'keyfile.pem')</code></td></tr></table>

### `PublicCertFile`
<table><tr>
<td>Description</td>
<td><code>PublicCertFile</code> is a character vector containing the full path to a public certificate file when using HTTPS for secure communications. <code>PublicCertFile</code> is used in conjunction with <a href="#privatekeyfile"><code>PrivateKeyFile</code></a></td></tr>
<tr><td>Default</td>
<td><code>''</code></td></tr>
<tr><td>Example(s)</td>
<td><code>h.PublicCertFile←'path-to-certfile.pem'</code></td></tr>
<tr><td>Details</td>
<td>The use of <code>Cert</code> and <code>PublicCertFile</code>/<code>PrivateKeyFile</code> are mutually exclusive and you should only one or the other. If both <code>Cert</code> and <code>PublicCertFile</code>/<code>PrivateKeyFile</code> are specified, <code>Cert</code> takes priority.</td></tr></table>

### `PrivateKeyFile`
<table><tr>
<td>Description</td>
<td><code>PrivateKeyFile</code> is a character vector containing the full path to a private key file when using HTTPS for secure communications. <code>PrivateKeyFile</code> is used in conjunction with <a href="#publiccertfile"><code>PublicCertFile</code></a></td></tr>
<tr><td>Default</td>
<td><code>''</code></td></tr>
<tr><td>Example(s)</td>
<td><code>h.PrivateKeyFile←'path-to-keyfile.pem'</code></td></tr>
<tr><td>Details</td>
<td>The use of <code>Cert</code> and <code>PublicCertFile</code>/<code>PrivateKeyFile</code> are mutually exclusive and you should only one or the other. If both <code>Cert</code> and <code>PublicCertFile</code>/<code>PrivateKeyFile</code> are specified, <code>Cert</code> takes priority.</td></tr></table>

### `SSLFlags`
<table><tr>
<td>Description</td>
<td><code>SSLFlags</code> is used when using HTTPS for secure communications. It is a part of the certificate checking process and determines whether to connect to a server that does not have a valid certificate.</td></tr>
<tr><td>Default</td>
<td><code>32</code> which means accept the server certificate without checking it</td></tr>
<tr><td>Example(s)</td>
<td><code>h.SSLFlags←8</code></td></tr>
<tr><td>Details</td>
<td>For more information on the interpretation of <code>SSLFlag</code> values, see <a href="https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf">Conga User Guide</a> Appendix C.<br/><br/>
Note: <code>SSLFlags</code> is also a positional argument for the shortcut methods (<code>Get</code>, <code>GetJSON</code>, <code>Do</code>, and <code>New</code>) as well as the <code>HttpCommand</code> constructor. <code>SSLFlags</code> appears after the <code>Cert</code> positional argument.</td></tr></table>

### `Priority`
<table><tr>
<td>Description</td>
<td>The GnuTLS priority string that specifies the TLS session's handshake algorithms.</td></tr>
<tr><td>Default</td>
<td><code>'NORMAL:!CTYPE-OPENPGP'</code></td></tr>
<tr><td>Example(s)</td>
<td>h.Priority←'SECURE128:-VERS-TLS1.0'</td></tr>
<tr><td>Details</td>
<td>In general, you would use a different value than the default only in rare and very specific circumstances. See <a href="https://gnutls.org/manual/html_node/Priority-Strings.html">GnuTLS Priority Strings"</a> for more information.
<br/><br/>
Note: <code>Priority</code> is also a positional argument for the shortcut methods (<code>Get</code>, <code>GetJSON</code>, <code>Do</code>, and <code>New</code>) as well as the <code>HttpCommand</code> constructor. <code>Priority</code> appears after the <code>SSLFlags</code> positional argument.</td></tr></table>

## Shared Settings
Shared settings are set in the `HttpCommand` class and are used by all instances of `HttpCommand`.

### `CongaPath`
<table><tr>
<td>Description</td>
<td>The path to Conga resources</td></tr>
<tr><td>Default</td>
<td><code>''</code></td></tr>
<tr><td>Example(s)</td>
<td><code>HttpCommand.CongaPath←'/myapp/dlls/'</code></td></tr>
<tr><td>Details</td>
<td>
This setting is intended to be used when Conga is not located in the Dyalog installation folder or the current folder, as might be the case when deploying <code>HttpCommand</code> as a part of a runtime application. <code>CongaPath</code> is used for two purposes:<ul><li>If the <code>Conga</code> or <code>DRC</code> namespace is not found in the <code>HttpCommand</code>'s parent namespace or in the root namespace (<code>#</code>), then <code>CongaPath</code> should be the path to the folder containing the <code>conga</code> workspace from which <code>HttpCommand</code> will copy the <code>Conga</code> namespace.</li>
<li><code>CongaPath</code> should be the path to the folder containing the Conga shared libraries</li></ul>See <a href="/conga">HttpCommand and Conga</a> and/or <a href="/integrating">Integrating HttpCommand</a> for more information.</td></tr></table>

### `CongaRef`
<table><tr>
<td>Description</td>
<td>A reference to the <code>Conga</code> or <code>DRC</code> namespace or to an initialized instance of the <code>Conga.LIB</code> class.</td></tr>
<tr><td>Default</td>
<td><code>''</code></td></tr>
<tr><td>Example(s)</td>
<td>HttpCommand.CongaRef← #.Utils.Conga</td></tr>
<tr><td>Details</td>
<td>This setting is intended to be used when your application has other components that use Conga. To avoid having multiple copies of Conga, you can set <code>CongaRef</code> to point to an existing copy of the Conga API.<br/>See <a href="/conga">HttpCommand and Conga</a> and/or <a href="/integrating">Integrating HttpCommand</a> for more information.</td></tr></table>

### `LDRC`
<table><tr>
<td>Description</td>
<td>Once <code>HttpCommand</code> has been initialized by processing a request, <code>LDRC</code> is a reference to the Conga API that <code>HttpCommand</code> is using.</td></tr>
<tr><td>Default</td>
<td>N/A</td></tr>
<tr><td>Example(s)</td>
<td><code>      HttpCommand.Get 'dyalog.com' ⍝ run a request</code><br/><code>      HttpCommand.LDRC.Version</code><br/>
<code>3 4 1612</td></tr>
<tr><td>Details</td>
<td><code>LDRC</code> should be treated as a read-only setting. It provides a means to access the Conga API which may be helpful for debugging and informational purposes.</td></tr></table>

### `CongaVersion`
<table><tr>
<td>Description</td>
<td>Once <code>HttpCommand</code> has been initialized by processing a request, <code>CongaVersion</code> is the version number, in major.minor format, of the Conga API that <code>HttpCommand</code> is using.</td></tr>
<tr><td>Default</td>
<td>N/A</td></tr>
<tr><td>Example(s)</td>
<td><code>      HttpCommand.Get 'dyalog.com' ⍝ run a request</code><br/><code>      HttpCommand.CongaVersion</code><br/>
<code>3.4</code></td></tr>
<tr><td>Details</td>
<td><code>CongaVersion</code> should be treated as a read-only setting. It provides information which may be helpful for debugging and informational purposes.</td></tr></table>