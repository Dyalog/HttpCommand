 {r}←test_restful_post dummy;t;params;resp
 t←#.httpcommand_test
 (params←⎕NS'').(title body userId)←'foo' 'bar' 1
 r←(⍕resp)/⍨0 201 Check(resp←#.HttpCommand.Do'post'(t._typicode,'posts')params).(rc HttpStatus)
