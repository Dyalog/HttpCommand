r←test_get dummy;t
t←#.httpcommand_test
r←0 200 t.check(#.HttpCommand.Get t._httpbin,'get').(rc HttpStatus)
