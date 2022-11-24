{r}←test_restful_put dummy;t;params
t←#.httpcommand_test
(params←⎕NS'').(title body userId id)←'foo' 'bar' 1 200
r←0 200 t.check(#.HttpCommand.Do'put'(t._typicode,'posts/1')params).(rc HttpStatus)
