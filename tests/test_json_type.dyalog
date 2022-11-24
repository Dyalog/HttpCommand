{r}←test_json_type dummy;result;t                                                         
t←#.httpcommand_test                                                                      
result←#.HttpCommand.Get t._httpbin,'json'                                                
:Trap 0                                                                                   
    {}⎕JSON result.Data                                                                   
:Else                                                                                     
    r←⎕DM                                                                                 
    →0                                                                                    
:EndTrap                                                                                  
r←(0 200 'application/json')t.check result.(rc HttpStatus),⊂result.GetHeader'Content-Type'
