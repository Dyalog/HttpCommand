`HttpCommand` is a utility that executes HTTP requests. It is designed to make it easy for the APL user to send requests to and receive data from web servers and web services. 
`HttpCommand` is included with Dyalog APL as a loadable utility. To bring it into your workspace, simply:
```text
      ]load HttpCommand
```
or under program control:
```text
     ⎕SE.SALT.Load 'HttpCommand' 
```
`HttpCommand` is implemented as a Dyalog class and its typical usage pattern is:

1. Create an instance of `HttpCommand`
2. Set fields appropriate to describe the request
3. Execute the request
4. Examine the result

For example:
```text
      cmd←⎕NEW HttpCommand
      cmd.(Command URL)←'get' 'www.dyalog.com'
      ⊢r←cmd.Run
[rc: 0 | msg: "" | HTTP Status: 200 "OK" | ⍴Data: 21060]
      80↑r.Data ⍝ the Data element of the result contains the payload of the response
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.or
```text
`HttpCommand` includes shortcut methods for common use cases.  For instance, the statement below accomplishes the same as the example above:
```text
      r←HttpCommand.Get 'www.dyalog.com'
```