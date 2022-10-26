{r}←test_suppressheaders dummy;t;c;result

t←#.httpcommand_test
c←#.HttpCommand.New 'get' (t._httpbin,'json')
c.SuppressHeaders←1
result←c.Run
r←0 400 t.check result.(rc HttpStatus)
r⍪←('GET /json HTTP/1.1'≢c.Show~⎕ucs 10 13) / 'warning: display of request differs from previous versions' 