## Shortcut Methods
`HttpCommand` has several shared "shortcut" methods to perform common operations. An overview of these methods is presented here. See the **Reference** section of the documentation for detailed information on all features of HttpCommand.

`HttpCommand`'s `Get`, `GetJSON`, `Do`, and `New` methods each accept a right argument which is one of:

* a vector of positional arguments
* a namespace containing named arguments. 

Positional arguments must be supplied in the position and order shown.  If you do not need to use an intermediate argument, you should supply `''`. For instance, a request that needs a `Headers` setting, but does not use a `Params` setting would be:

````
      HttpCommand.Get 'www.someurl.com' '' ('accept' 'image/png')
````

To use a namespace argument, create a namespace and assign the appropriate parameters for the request.  For example:
````
      ns←⎕NS ''
      ns.(Command URL)←'post' 'www.someurl.com'
      ns.Params←⎕JSON ⍳10
      ns.Headers←'Content-Type' 'application/json'
      r←HttpCommand.Do ns
````
### **`Get`**
Sends an HTTP request using the HTTP GET method.<br>
`r← [ro] HttpCommand.Get URL [Params [Headers]]`<br>
`r← [ro] HttpCommand.Get namespace`<br>

### **`GetJSON`**
Sends an HTTP request to a JSON-based web service using the HTTP method you specify. Unless otherwise specified, request parameters and response payload are automatically converted between APL and JSON.<br>
`r← [ro] HttpCommand.GetJSON Command URL [Params [Headers]]`<br>
`r← [ro] HttpCommand.GetJSON namespace`<br>
### **`Do`**
Sends an HTTP request using the HTTP method you specify.<br>
`r← [ro] HttpCommand.Do Command URL [Params [Headers]]`<br>
`r← [ro] HttpCommand.Do namespace`<br>

### **`New`**
Creates a new instance of `HttpCommand`.<br>
`h← [ro] HttpCommand.New Command URL [Params [Headers]]`<br>
`h← [ro] HttpCommand.New namespace`<br><br>
Once the instance is created, additional settings can be assigned directly if necessary. Then use the `Run` method to send the request.<br> 
`r← h.Run`

## Arguments
Name | Description | Default Value
---|---|---
`Command` | The HTTP method to use| `'GET'` 
`URL` | The URL to which the request will be sent. If `URL` begins with `'https://'` `HttpCommand` will attempt create a secure connection to the host using either an anonymou)s certificate it creates or `Cert` if it is supplied   | `''`
`Params` | Any parameters that are to be sent with the request. | `''`
`Headers` | Any HTTP headers (name/value pairs) to send with the request | `''` 
`ro` | "Request Only" - when set to 1, `HttpCommand` will compose and return the HTTP request that it would send to the host, but not actually send it.  This is useful for debugging to ensure your request is properly formed. | `0`

See the [Request-related Settings](./request-settings.md) section for more detail on the arguments. 

Each of the above methods also accept 3 additional positional arguments, `[Cert [SSLFlags [Priority]]]`.  These arguments are used to specify settings for secure connections but are seldom used in practice because `HttpCommand` automatically supplies an anonymous certificate when using a secure connection. See [Secure Connections](./secure.md) and [Conga-related Settings](./conga-settings.md) for more information.