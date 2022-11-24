r←test_buffersize dummy;t;c
t←#.httpcommand_test
c←#.HttpCommand.New'get'(t._httpbin,'/get')
c.BufferSize←32
r←1135 0 t.check(c.Run).(rc,⍴Data)
