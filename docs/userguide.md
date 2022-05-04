** This page is incomplete **

---
### Shortcut or Instance? 
There are two common ways to use `HttpCommand`. 

* Use one of its shortcut methods (`Get`, `Do`, `GetJSON`) to execute a single HTTP request and examine the response from the host.</br>When you use a shortcut method, `HttpCommand` will create a new local instance of itself, use the instance's `Run` method to send the request and receive the response, then exit thereby destroying the local instance. This is generally fine when your requests are independent of one another and do not require any state to be maintained across requests. 
* Create an instance of `HttpCommand` using `⎕NEW` or the `New` shared method, set whatever parameters are necessary, execute the `Run` method, and examine the response from the host.</br>Creating an instance of `HttpCommand` and using the `Run` method to send the request and receive the response will persist the instance such that state information such as connection information and HTTP cookies will be retained across requests.

### `HttpCommand`'s Result
The result of the `Run` method is a namespace containing information related to the result of the request. The display format (`⎕DF`) of the result presents some useful information.

````
      ⊢r ← HttpCommand.Get 'https://www.dyalog.com'
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 20571]
````
* `r` is the namespace result
* `r.rc` is the `HttpCommand`'s numeric return code. 0 means `HttpCommand` was able to create the request to send to the host. </br>If `rc` is less than 0, it means there was some problem sending the request or processing the response.</br>If `rc` is greater than 0, it is the Conga return code and generally means that Conga returned something unexpected.
* `r.msg` is a (hopefully meaningful) message describing whatever the issue was if `r.rc` is non-zero.
* `r.HttpStatus` is the numeric HTTP status code returned by the host. A status code in the range 200-299 indicates a successful HTTP response with 200 being the most common code.
* `r.HttpMessage` is HTTP status message returned by the host.
* `r.Data` is the payload of the response, if any, returned by the host. 
The result namespace contains other elements which are described in detail [here](result.md).

### Typical Use in Code
Typical use of `HttpCommand` might follow this pattern.

```
 r ← HttpCommand.Get 'some-url'
:If 0 200 ≢ r.(rc HttpStatus)
    ⍝ Request failed take some appropriate action here
:EndIf
    ⍝ process the response
```
   






