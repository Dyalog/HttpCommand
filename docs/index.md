`HttpCommand` is a utility is designed to make it easy for the APL user to send requests to and receive responses from HTTP servers like web servers and web services. `HttpCommand` is included with Dyalog APL as a loadable utility. To bring it into your workspace, simply do:
```APL
      ]load HttpCommand
```
or, under program control do:
```APL
     ⎕SE.SALT.Load 'HttpCommand' 
```
Beginning with Dyalog v18.2, you can also use the `]get` user command:
```APL
      ]get HttpCommand
```

`HttpCommand` is implemented as a Dyalog class and its typical usage pattern is:

1. Create an instance of `HttpCommand`
1. Set fields appropriate to describe the request
1. Send the request
1. Examine the response result

For example:
```APL
      cmd←HttpCommand.New ''   ⍝ create an instance
      cmd.Command←'get'        ⍝ specify the HTTP method 
      cmd.URL←'www.dyalog.com' ⍝ specify the URL

      ⊢response←cmd.Run        ⍝ send the request
[rc: 0 | msg: "" | HTTP Status: 200 "OK" | ⍴Data: 21060]

      50↑response.Data         ⍝ examine the response payload
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Trans      
```
The result of `HttpCommand.Run` is a namespace containing information about the response from server.  The display format for the namespace gives some useful information about the success of the request.  The server's response data, also known as the content or payload, is found in the `Data` element of the namespace.

`HttpCommand` has several "shortcut" shared methods to perform common operations. For instance, the above example can be accomplished by using `HttpCommand.Get`.

```APL
      50↑(HttpCommand.Get 'www.dyalog.com').Data
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Trans      
```
#### Philosophy
`HttpCommand` has been designed to be easy to integrate into your application by having a small footprint (it's a single class) and making almost no assumptions about the environment in which you'll use it. `HttpComand` attempts to use sensible default values for request settings while still giving the user full control should he need it.  `HttpCommand`'s feature set has expanded over time as new use cases and feature requests have arisen. We expect this trend to continue and encourage you to submit feature requests or report any bugs via [GitHub](https://github.com/Dyalog/HttpCommand/issues).

#### Further Reading
`HttpCommand` uses Conga, Dyalog's TCP/IP utility library, for communication. This documentation does not attempt to be an in-depth examination of either Conga or the HTTP protocol.

* For more information on Conga, see: [Conga User Guide](https://docs.dyalog.com/latest/Conga%20User%20Guide.pdf)
* There are many resources available to learn about HTTP; a good one is found on the [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/HTTP)