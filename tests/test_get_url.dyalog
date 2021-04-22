 {r}←test_get_url dummy;t;z;param;url
 ⍝ test url arguments
 t←#.httpcommand_test
 :For (url param) :In ('?one=test&two=two%20words' '')('?one=test'('two' 'two words'))(''({t←⎕NS'' ⋄ t.(one two)←'test' 'two words' ⋄ t}''))('' 'one=test&two=two%20words')
     →0↓⍨0∊⍴r←0 200 t.check(z←#.HttpCommand.Get(t._httpbin,'get',url)param).(rc HttpStatus)
     :Trap (~##.halt)/0
         →0↓⍨0∊⍴r←(⎕JSON z.Data).args.(one two)t.check'test' 'two words'
     :Else
         →0⊣r←''t.check(⊃⎕DM)
     :EndTrap
 :EndFor
