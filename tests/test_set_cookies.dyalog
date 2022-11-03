{r}←test_set_cookies dummy;c;result
c ← #.HttpCommand.New 'get' 'http://localhost:8090/set_cookies'
{}c.Run
{}c.Run
{}c.Run
r←'Cookies not set'/⍨3≢≢c.Cookies.Value
⎕DL 5
{}c.Run
r⍪←'Cookies did not expire'/⍨1≢≢c.Cookies.Value
