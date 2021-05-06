 r←test_get dummy;home
 r←''
 home←##.TESTSOURCE  ⍝ hopefully good enough...
 :If 0=#.⎕NC'HttpCommand'
     {}#.⎕FIX'file://',home,'../HttpCommand.dyalog'
     {}#.⎕FIX'file://',home,'httpcommand_test.dyalog'
 :EndIf
 →0↓⍨0 200 Check(#.HttpCommand.Get #.httpcommand_test._httpbin,'get').(rc HttpStatus)
