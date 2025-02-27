In general, you will not need to set any of the Conga-related settings since the `HttpCommand`'s defaults will suffice for almost all requests. For more information on Conga, please refer to the <a href="https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf" target="_blank">Conga User Guide</a>.

## Instance Settings

### `BufferSize`
|--|--|
| Description | The maximum number of bytes that `HttpCommand` will accept for the HTTP status and headers received from the host.|
| Default |`200000`|
|Example(s)|`h.BufferSize←50000 ⍝ set a lower threshold`|
|Details|By default, when using Conga's HTTP mode, as `HttpCommand` does, `BufferSize` applies only to the data received by the `HTTPHeader` event. The intent is to protect against a maliciously large response from the host.  If the data received by the `HTTPHeader` event exceeds `BufferSize`, `HttpCommand` will exit with a return code of 1135.|

### `WaitTime`
|--|--|
|Description|The number of milliseconds that Conga will wait (listen) for a response before timing out.|
|Default|`5000`|
|Example(s)|`h.WaitTime←10000 ⍝ wait 10 seconds`|
|Details|This setting applies only to the time Conga will wait internally for a response. There is generally no reason to modify this setting; if your request is timing out, you should set [`Timeout`](./operational-settings.md#timeout) setting appropriately.  See [Timeout and WaitTime](./conga.md#timeout-and-waittime) for more information on the relationship between the `Timeout` and `WaitTime` settings.|

### `Cert`
|--|--|
|Description|The certificate specification to be used for secure communications over SSL/TLS. If set, `Cert` can be either:<ul><li>an instance of the Conga `X509Cert` class</li><li>a 2-element vector of character vectors representing the full path names to a public certificate file and a private key file. This is a shortcut that can be used instead of specifying both the `PrivateKeyFile` and `PublicCertFile` settings.</li></ul>|
|Default|`''`|
|Example(s)|`h.Init ⍝ initialize the local instance of Conga`<br/>`h.Cert← 1⊃h.LDRC.X509Cert.ReadCertUrls ⍝ use first MS certificate store cert`<br/><br/>`h.Cert← 'path-to-certfile.pem' 'path-to-keyfile.pem'`|
|Details|In most cases when using HTTPS for secure communications, the anonymous certificate that `HttpCommand` will create for you will suffice and you need not set `Cert`. It should only be necessary to assign `Cert` in those cases where you need to specify a certificate for authentication purposes.<br/><br/>Note: `Cert` is also a positional argument for the shortcut methods (`Get`, `GetJSON`, `Do`, and `New`) as well as the `HttpCommand` constructor. `Cert` appears after the `Headers` positional argument.  For example:<br/>`h← HttpCommand.Get 'someurl.com' '' '' ('certfile.pem' 'keyfile.pem')`|

### `PublicCertFile`
|--|--|
|Description|`PublicCertFile` is a character vector containing the full path to a public certificate file when using HTTPS for secure communications. `PublicCertFile` is used in conjunction with [`PrivateKeyFile`](#privatekeyfile)|
|Default|`''`|
|Example(s)|`h.PublicCertFile←'path-to-certfile.pem'`|
|Details|The use of `Cert` and `PublicCertFile`/`PrivateKeyFile` are mutually exclusive and you should only one or the other. If both `Cert` and `PublicCertFile`/`PrivateKeyFile` are specified, `Cert` takes priority.|

### `PrivateKeyFile`
|--|--|
|Description|`PrivateKeyFile` is a character vector containing the full path to a private key file when using HTTPS for secure communications. `PrivateKeyFile` is used in conjunction with [`PublicCertFile`](#publiccertfile)|
|Default|`''`|
|Example(s)|`h.PrivateKeyFile←'path-to-keyfile.pem'`|
|Details|The use of `Cert` and `PublicCertFile`/`PrivateKeyFile` are mutually exclusive and you should only one or the other. If both `Cert` and `PublicCertFile`/`PrivateKeyFile` are specified, `Cert` takes priority.|

### `SSLFlags`
|--|--|
|Description|`SSLFlags` is used when using HTTPS for secure communications. It is a part of the certificate checking process and determines whether to connect to a server that does not have a valid certificate.|
|Default|`32` which means accept the server certificate without checking it|
|Example(s)|`h.SSLFlags←8`|
|Details|For more information on the interpretation of `SSLFlag` values, see [Conga User Guide](https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf) Appendix C.<br/><br/>Note: `SSLFlags` is also a positional argument for the shortcut methods (`Get`, `GetJSON`, `Do`, and `New`) as well as the `HttpCommand` constructor. `SSLFlags` appears after the `Cert` positional argument.|

### `Priority`
|--|--|
|Description|The GnuTLS priority string that specifies the TLS session's handshake algorithms.|
|Default|`'NORMAL:!CTYPE-OPENPGP'`|
|Example(s)|`h.Priority←'SECURE128:-VERS-TLS1.0'`|
|Details|In general, you would use a different value than the default only in rare and very specific circumstances. See [GnuTLS Priority Strings](https://gnutls.org/manual/html_node/Priority-Strings.html) for more information.<br/><br/>Note: `Priority` is also a positional argument for the shortcut methods (`Get`, `GetJSON`, `Do`, and `New`) as well as the `HttpCommand` constructor. `Priority` appears after the `SSLFlags` positional argument.|

## Shared Settings
Shared settings are set in the `HttpCommand` class and are used by all instances of `HttpCommand`.

### `CongaPath`
|--|--|
|Description|The path to Conga resources|
|Default|`''`|
|Example(s)|`HttpCommand.CongaPath←'/myapp/dlls/'`|
|Details|This setting is intended to be used when Conga is not located in the Dyalog installation folder or the current folder, as might be the case when deploying `HttpCommand` as a part of a runtime application. `CongaPath` is used for two purposes:<ul><li>If the `Conga` or `DRC` namespace is not found in the `HttpCommand`'s parent namespace or in the root namespace (`#`), then `CongaPath` should be the path to the folder containing the `conga` workspace from which `HttpCommand` will copy the `Conga` namespace.</li><li>`CongaPath` should be the path to the folder containing the Conga shared libraries</li></ul>See [HttpCommand and Conga](./conga.md) and/or [Integrating HttpCommand](./integrating.md) for more information.|

### `CongaRef`
|--|--|
|Description|A reference to the `Conga` or `DRC` namespace or to an initialized instance of the `Conga.LIB` class.|
|Default|`''`|
|Example(s)|HttpCommand.CongaRef← #.Utils.Conga|
|Details|This setting is intended to be used when your application has other components that use Conga. To avoid having multiple copies of Conga, you can set `CongaRef` to point to an existing copy of the Conga API.<br/>See [HttpCommand and Conga](./conga.md) and/or [Integrating HttpCommand](./integrating.md) for more information.|

### `LDRC`
|--|--|
|Description|Once `HttpCommand` has been initialized by processing a request, `LDRC` is a reference to the Conga API that `HttpCommand` is using.|
|Default|N/A|
|Example(s)|&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`HttpCommand.Get 'dyalog.com' ⍝ run a request`<br/>&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`HttpCommand.LDRC.Version`<br/>`3 4 1612`|
|Details|`LDRC` should be treated as a read-only setting. It provides a means to access the Conga API which may be helpful for debugging and informational purposes.|

### `CongaVersion`
|--|--|
|Description|Once `HttpCommand` has been initialized by processing a request, `CongaVersion` is the version number, in major.minor format, of the Conga API that `HttpCommand` is using.|
|Default|N/A|
|Example(s)|&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`HttpCommand.Get 'dyalog.com' ⍝ run a request`<br/>&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;`HttpCommand.CongaVersion`<br/>`3.4`|
|Details|`CongaVersion` should be treated as a read-only setting. It provides information which may be helpful for debugging and informational purposes.|