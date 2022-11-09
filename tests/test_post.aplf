r←test_post dummy;t;c                                               
t←#.httpcommand_test                                                
c←#.HttpCommand.New'post'(t._httpbin,'post')                        
c.TranslateData←1                                                   
c.Params←'origin' 'HttpCommand'                                     
r←0 200 'HttpCommand't.check(c.Run).(rc HttpStatus Data.form.origin)
