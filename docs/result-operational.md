For the purposes of this document, we will refer to `result` as the result namespace returned by [`Run`](./instance-methods.md#run) when `RequestOnly=0`. `result` contains information about the request and the response, if any, from the host. Some settings from the request are copied into `result`.
### `rc`
The operational return code. This indicates if `HttpCommand` was able to form and send an HTTP request and process the response from the host. The sign of `rc` indicates:

* `rc=0` no operational error occurred.
* `rc<0` an operational error occurred.
* `rc>0` a Conga error occurred.

`rc` is further described in [Messages and Return Codes](./msgs.md). To verify that an HTTP request was successful, first check that `result.rc=0` and then that [`result.HttpStatus`](./result-response.md#httpstatus) is a HTTP status code you would expect from the host.
### `msg`
The operational status message. If `rc=0`, `msg` will generally be empty (`''`).  `msg` will contain (hopefully) helpful information as to the nature of the error or condition. `msg` is further described in [Messages and Return Codes](./msgs.md).
### `Elapsed`
The number of millseconds that the request took to process.
### `OutFile`
`OutFile` is copied from the [`OutFile` setting](./operational-settings.md#outfile) so that, if the response payload is written to file, the result namespace has a record of the file name.
### `BytesWritten`
If `OutFile` is non-empty, and the HTTP request wassuccessful, `BytesWritten` is the number of bytes written to that file named by `OutFile`.  Otherwise, `BytesWritten` is set to `¯1`. 