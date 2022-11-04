{r}←test_set_cookies_path dummy;c;result
c ← #.HttpCommand.New 'get' 'http://localhost:8090/set_cookies/path'
result ← c.Run
:If 0∊⍴result.Cookies
r←'No cookie namespace when one was expected.'
:Else
 c.URL←'http://localhost:8090/set_cookies/ping'
 result ← c.Run
 r←'Set-Cookie "Path" was not obeyed.'/⍨9∊⎕nc'result.Cookies'
:EndIf
