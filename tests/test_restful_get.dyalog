 {r}←test_restful_get dummy;host;rc;t
 t←#.httpcommand_test
 r←0 200 t.check rc←(#.HttpCommand.Get t._typicode,'posts').(rc HttpStatus)
