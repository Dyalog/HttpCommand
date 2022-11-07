{r}←test_maxredirections dummy;t;c;result

t←#.httpcommand_test
c←#.HttpCommand.New 'get' (t._httpbin,'/redirect/5')
c.MaxRedirections←3
result ← c.Run
r←¯1 302 t.check result.(rc HttpStatus)
c.MaxRedirections←7
result ← c.Run
r⍪←0 200 t.check result.(rc HttpStatus)