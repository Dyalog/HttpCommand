 {r}←test_restful_post dummy;t;params
 t←#.httpcommand_test
 (params←⎕NS'').(title body userId)←'foo' 'bar' 1
 r←0 201 t.check(#.HttpCommand.Do'post'(t._typicode,'posts')params).(rc HttpStatus)
