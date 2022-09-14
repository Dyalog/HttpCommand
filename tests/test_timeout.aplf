 r←test_timeout dummy;t;result;port;url;c
 t←#.httpcommand_test
 url←'http://localhost:8090'
 c←#.HttpCommand.New'get'(url,'/timeout_test')
 c.Timeout←1
 r← 100 t.check (c.Run).rc
 c.Timeout←10
 r,← 0 t.check(c.Run).rc
