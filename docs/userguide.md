There are two common ways to use `HttpCommand`. The first is to use one of its shared methods (`Get`, `Do`, `GetJSON`) to execute a single HTTP request and examine the response from the host. The other way is to create an instance of `HttpCommand` using `⎕NEW` or the `New` shared method, set whatever parameters are necessary, execute the `Run` method, and examine the response from the host.

When you use one of the shared methods, `HttpCommand` will create a new local instance of itself, use the instance's `Run` method to send the request and receive the response, then exit thereby destroying the local instance. This is generally fine when your requests are independent of one another and do not require any state to be maintained across requests. Creating an instance of `HttpCommand` and using the `Run` method to send the request and receive the response will persist the instance such that state information such as connection information and HTTP cookies will be retained across requests.

### `HttpCommand`'s Result
The result of the `Run` method is a namespace containing information related to the result of the request. The display format (`⎕DF`) of the result presents some useful information.

````
      ⊢r ← HttpCommand.Get 'https://www.dyalog.com'
[rc: 0 | msg:  | HTTP Status: 200 "OK" | ⍴Data: 20571]
````
`rc` is the `HttpCommand`'s return code. 0 means `HttpCommand` was able to create the request to send to the host.




