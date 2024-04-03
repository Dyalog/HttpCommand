## Shortcut or Instance? 
There are two ways to use `HttpCommand`. 

* Use one of its shortcut methods (`Get`, `Do`, `GetJSON`) to execute a single HTTP request and examine the response from the host. When you use a shortcut method, `HttpCommand` will create a new, local, instance of itself and then use the instance's `Run` method to send the request and receive the response, then exit thereby destroying the local instance. This is generally fine when your requests are independent of one another and do not require any state to be maintained across requests.</br>
* Create an instance of `HttpCommand` using `⎕NEW` or the `New` shared method, set whatever parameters are necessary, execute the `Run` method, and examine the response from the host. Creating an instance of `HttpCommand` and using the `Run` method to send the request and receive the response will persist the instance such that state information like connection information and HTTP cookies will be retained across requests.

## `HttpCommand`'s Result
The result of the `Run` method is a namespace containing information related to the result of the request. The display format (`⎕DF`) of the result presents some useful information.

```
      ⊢r ← HttpCommand.Get 'https://www.dyalog.com'
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 20571]
```
* `r` is the namespace result
* `r.rc` is `HttpCommand`'s numeric return code. 0 means `HttpCommand` was able to create and send the request to the host, send it, and receive and process the response.</br>If `rc` is less than 0, it means there was some problem either composing/sending the request or processing the response.</br>If `rc` is greater than 0, it is the Conga return code and generally means that Conga encountered something unexpected. More information about `rc` can be found [here](msgs.md). 
* `r.msg` is a (hopefully meaningful) message describing whatever the issue was if `r.rc` is non-zero.
* `r.HttpStatus` is the numeric HTTP status code returned by the host. A status code in the range 200-299 indicates a successful HTTP response with 200 being the most common code.
* `r.HttpMessage` is the HTTP status message returned by the host.
* `r.Data` is the payload of the response, if any, returned by the host. 
The result namespace contains other elements which are described in detail on the [Request Results](./result-request.md), [Operational Results](./result-operational.md), and [Response Results](./result-response.md) pages.

## Typical Use in Code
Typical use of `HttpCommand` might follow this pattern.

```
 resp ← HttpCommand.Get 'some-url'
:If resp.IsOK ⍝ use the IsOK function from the result namespace
    ⍝ code to process the response 
:Else
    ⍝ code to handle bad request
:EndIf
```

If you expect to make several `HttpCommand` calls, you may want to create an instance and then update the necessary settings and execute the `Run` method for each call.  This can be useful when the requests are made to the same host as the connection to the host will be kept open, unless the host itself closes it.

```
 hc←HttpCommand.New 'get'  ⍝ here we expect all requests to be HTTP GET
 urls←'url1' 'url2' 'url3'

:For url :In urls ⍝ loop over the URLs
  hc.URL←url ⍝ set this URL
  resp←hc.Run
  :If resp.IsOK
    ⍝ process the response
  :Else
    ⍝ process the exception/error
  :EndIf
:EndFor 
```

## `Timeout` and Long-running Requests
The default `Timeout` setting (10 seconds) is adequate for most requests. There are a couple of patterns of long running requests.  `Timeout` can be set to a positive or negative number.

- Setting `Timeout` to a positive number means that `HttpCommand` will time out after `Timeout` seconds with a return code (`rc`) of 100.  Any partial payload received will returned in `Data` element of the result. 
- Setting `Timeout` to a negative number means that `HttpCommand` will not time out as long as data is being received.  This is useful in the case where a large payload may be received but you are uncertain of how long it will take to receive. If no data is received within a period of `|Timeout` seconds, `HttpCommand` will time out with a return code (`rc`) of 100. Any partial payload received will be returned in the `Data` element of the result.<br/><br/> Using a negative `Timeout` value is useful in the case where a large payload is being received in chunks but has no benefit if the entire payload is sent in one chunk or if the host takes more than `|Timeout` seconds to begin sending its response. In that case, you'll need to set `|Timeout` to a larger value.

## Compressing Response Payload ##
`HttpCommand` can accept and process response payloads that are compressed using either the gzip or deflate compression schemes. To accomplish this, you need to set the `accept-encoding` header to `'gzip, deflate'`.