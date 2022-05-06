** This page is incomplete **

---
### Shortcut or Instance? 
There are two common ways to use `HttpCommand`. 

* Use one of its shortcut methods (`Get`, `Do`, `GetJSON`) to execute a single HTTP request and examine the response from the host.</br>When you use a shortcut method, `HttpCommand` will create a new local instance of itself, use the instance's `Run` method to send the request and receive the response, then exit thereby destroying the local instance. This is generally fine when your requests are independent of one another and do not require any state to be maintained across requests. 
* Create an instance of `HttpCommand` using `⎕NEW` or the `New` shared method, set whatever parameters are necessary, execute the `Run` method, and examine the response from the host.</br>Creating an instance of `HttpCommand` and using the `Run` method to send the request and receive the response will persist the instance such that state information such as connection information and HTTP cookies will be retained across requests.

### `HttpCommand`'s Result
The result of the `Run` method is a namespace containing information related to the result of the request. The display format (`⎕DF`) of the result presents some useful information.

```
      ⊢r ← HttpCommand.Get 'https://www.dyalog.com'
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 20571]
```
* `r` is the namespace result
* `r.rc` is `HttpCommand`'s numeric return code. 0 means `HttpCommand` was able to create and send the request to the host, send it, and receive and process the response.</br>If `rc` is less than 0, it means there was some problem either composing/sending the request or processing the response.</br>If `rc` is greater than 0, it is the Conga return code and generally means that Conga encountered something unexpected. More information about `rc` can be found [here](msgs.md). 
* `r.msg` is a (hopefully meaningful) message describing whatever the issue was if `r.rc` is non-zero.
* `r.HttpStatus` is the numeric HTTP status code returned by the host. A status code in the range 200-299 indicates a successful HTTP response with 200 being the most common code.
* `r.HttpMessage` is HTTP status message returned by the host.
* `r.Data` is the payload of the response, if any, returned by the host. 
The result namespace contains other elements which are described in detail [here](result.md).

### Typical Use in Code
Typical use of `HttpCommand` might follow this pattern.

```
 resp ← HttpCommand.Get 'some-url'
:If 0 ≠ resp.rc
  ⍝ code to handle bad request
:ElseIf 200 ≠ resp.HttpStatus
  ⍝ code to handle unexpected HTTP status (assuming you expect 200)
:Else
  ⍝ code to process the response 
:EndIf
```

If you expect to make several `HttpCommand` calls, you may want to create an instance and then update the settings and call `Run`.

```
 hc←HttpCommand.New 'get'  ⍝ in this case we expect all requests to be HTTP GET
 urls←'url1' 'url2' 'url3'
:For url :In urls ⍝ loop over the urls
  hc.URL←url ⍝ set the 
  resp←hc.Run
  :If (0 200)≡resp.(rc HttpStatus)
    ⍝ process the response
  :Else
    ⍝ process the exception/error
  :EndIf
:EndFor 
   






