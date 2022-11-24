r←test_set_cookies_max_age dummy;c;result   
r←''
t←#.httpcommand_test 
c←#.HttpCommand.New 'get' (t.localhost,'set_cookies/max_age')
{}c.Run
:If 0∊⍴ t.getCookies c.Show
    r←'Cookies were left unset.'
:EndIf

⎕DL 3.5                                                            

:If ~ 0∊⍴ t.getCookies c.Show
 r←'Cookies did not expire.'
:EndIf