## Version 5.1
* Added proxy server support. See [Proxy-related Settings](./proxy-settings.md) and [Using a Proxy Server](./proxy.md).
* Changed how `HttpCommand` attempts to determine payload Content-Type if the user has not specified it. <br/>Prior behavior was to always treat it as `x-www-form-urlencoded`. <br/>Now, `HttpCommand` will use a Content-Type of `application/json;charset=utf-8` if the payload either:
    * is simple and looks like JSON
    * is a set of [name/value pairs](./request-settings.md#namevalue-pairs)

      To avoid having `HttpCommand` "guess" improperly, set [`Content-Type`](./request-settings.md#contenttype) explicitly.

* If [`Auth`](./request-settings.md#auth) is either a vector in form `'userid:password'` or a 2-element vector `('userid' 'password')` and [`AuthType`](./request-settings.md#authtype) is either unspecified or `'basic'`, `HttpCommand` will properly `Base64Encode` the credentials for HTTP Basic authentication.

## Version 5.0

* The major version bump from 4 to 5 was due to:
    * swapping the meaning for the `Timeout` and `WaitTime` settings. Previously `Timeout` was used to indicate how long Conga's `Wait` function would wait for a response and `WaitTime` was how long `HttpCommand` would wait for a complete response before timing out.
    * return codes and messages were normalized 
* Added new `Auth` and `AuthType` settings to more easily support token-based authentication.
* Removed half-implemented support for streaming
* Added `GetHeader` function to result namespace
* More complete setting checking
* Better handling of relative redirections
* New documentation