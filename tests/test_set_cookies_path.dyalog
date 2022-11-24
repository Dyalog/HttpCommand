{r}←test_set_cookies_path dummy;c;t;result
t←#.httpcommand_test
c←#.HttpCommand.New 'get' (t.localhost,'set_cookies/path')
result←c.Run
:If 0∊⍴result.Cookies
    r←'No cookie namespace when one was expected.'
:Else
    c.URL ← t.localhost,'set_cookies/ping'
    result←c.Run
    r←'Set-Cookie "Path" was not obeyed.'/⍨9∊⎕NC'result.Cookies'
:EndIf
