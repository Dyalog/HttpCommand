{r}←test_outfile dummy;t;c;result;url;s
⍝ hash: f424ee8

t←#.httpcommand_test
⍝ These should be capable of being dynamically set:
url ← 'json'

c←#.HttpCommand.New 'get' (t._httpbin,url)

⍝ 0 do not write to an existing, non-empty file (the default)
c.OutFile←'/tmp/' 0
result←c.Run
r←0 200 t.check result.(rc HttpStatus)
r⍪←(''≡result.OutFile) / '(OutFile 0) failed: /tmp/',url,' wasn''t written.'

⍝ 1 replace the contents, if any, if the file exists
c.OutFile←'/tmp/' 1
result←c.Run
r⍪←0 200 t.check result.(rc HttpStatus)
r⍪(''≡result.OutFile) / '(OutFile 1) failed: /tmp/',url,' wasn''t written.'

⍝ 2 append to the file, if it exists
c.OutFile←'/tmp/' 2
result←c.Run
r⍪←0 200 t.check result.(rc HttpStatus)
r⍪←(result.Data≡result.BytesWritten) / '(OutFile 2) failed: /tmp/',url,' wasn''t appended to itself.'

:If ⎕nexists '/tmp/',url
 r⍪←(1≠⎕ndelete '/tmp/',url) / '/tmp/',url,' was not correctly deleted.' 
:Else
 r⍪←'/tmp/',url,' was not correctly deleted.' 
:EndIf