r←test_set_cookies_expires dummy;c;result   
r←''
t←#.httpcommand_test 
c←#.HttpCommand.New 'get' (t.localhost,'set_cookies/expires')
{}c.Run
:If 0∊⍴ t.getCookies c.Show
    r←'Cookies were left unset.'
:EndIf

⎕DL 3.5                                                            

:If ~ 0∊⍴ t.getCookies c.Show
 r←'Cookies did not expire.'
:EndIf