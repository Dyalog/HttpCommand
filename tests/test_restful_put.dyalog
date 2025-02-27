 {r}←test_restful_put dummy;t;params;result
 t←#.httpcommand_test
 (params←⎕NS'').(title body userId id)←'foo' 'bar' 1 200
 r←(⍕result)/⍨0 200 Check(result←#.HttpCommand.Do'put'(t._typicode,'posts/1')params).(rc HttpStatus)
