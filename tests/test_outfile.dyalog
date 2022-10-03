{r}←test_outfile dummy;t;result;url;s
t←#.httpcommand_test
url ← 'uuid'
c←#.HttpCommand.New 'get' (t._httpbin,url)

c.OutFile←'/tmp/' 0
result←c.Run

r←0 200 t.check result.(rc HttpStatus)
r⍪←(''≡result.OutFile) / '(OutFile 0) failed: /tmp/',url,' wasn''t written.'

c.OutFile←'/tmp/' 1
result←c.Run

r⍪←0 200 t.check result.(rc HttpStatus)
r⍪(''≡result.OutFile) / '(OutFile 1) failed: /tmp/',url,' wasn''t written.'

s ← ⍴⊃⎕nget '/tmp/',url ⍝ Pre append size

c.OutFile←'/tmp/' 2
result←c.Run

r⍪←0 200 t.check result.(rc HttpStatus)
r⍪←((s+result.BytesWritten)≠⍴⊃⎕nget '/tmp/',url) / '(OutFile 2) failed: /tmp/',url,' wasn''t appended to itself.'

:If ⎕nexists '/tmp/',url
 r⍪←(1≠⎕ndelete '/tmp/',url) / '/tmp/',url,' was not correctly deleted.' 
:Else
 r⍪←'/tmp/',url,' was not correctly deleted.' 
:EndIf