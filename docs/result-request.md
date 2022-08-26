For the purposes of this document, we will refer to `result` as the result namespace returned by [`Run`](./instance-methods.md#run) when `RequestOnly=0`. `result` contains information about the request and the response, if any, from the host.

Request-related elements in the result namespace are either copied or derived from certain [request settings](./request-settings.md). Not all request settings are included in the result namespace, but they are retained in the `HttpCommand` instance. 

### `Command`
The case-insensitive HTTP command (method) for the request.
### `Host`
The final host to which the HTTP request was sent.  This may be different from the host specified in the `URL` setting if the request was redirected. See [Redirections](./redirections.md) for more information.
### `Path`
The final path for the requested resource.  This may be different from the resource specified in the `URL` setting if the request was redirected. See [Redirections](./redirections.md) for more information.
### `Port`
The port that the request was sent to. If the request was redirected, this may be different from the port specified in the `URL` setting or the original default port if no port was specified in `URL`.  See [Redirections](./redirections.md) for more information.
### `Secure`
A Boolean indicating whether the final request was sent using SSL/TLS. If the request was redirected, this may be reflect a different secure state from the original request. See [Redirections](./redirections.md) for more information.
### `URL`
The final URL of the HTTP request.  If the request was redirected, this may be different from the `URL` setting.  See [Redirections](./redirections.md) for more information.