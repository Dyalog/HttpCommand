r←test_timeout dummy;t;result;c
t←#.httpcommand_test
c←#.HttpCommand.New 'get' (t.localhost,'timeout_test')
c.Timeout←1
r←100 t.check(c.Run).rc
c.Timeout←10
r,←0 t.check(c.Run).rc
