r←test_set_cookies_path dummy;c;result
r←''
t←#.httpcommand_test
c←#.HttpCommand.New 'get' 'http://localhost:8090/set_cookies/path'
result←c.Run
:If 0∊⍴result.Cookies
    r←'Cookies were left unset.'
:Else
    c.URL←'http://localhost:8090/set_cookies/ping'
    :If ~ 0∊⍴ t.getCookies c.Show
        r←'Set-Cookie "Path" was not obeyed.'
    :EndIf
:EndIf