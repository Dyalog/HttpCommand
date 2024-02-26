 r←setup_httpcommand_test dummy;home
⍝ Setup test
 ⎕IO←⎕ML←1
 r←''
 :Trap 0
     :If 0=##.⎕NC'TESTSOURCE'
         home←SourceFolder⊃⎕SI
     :Else
         home←##.TESTSOURCE
     :EndIf
     {}#.⎕FIX'file://',home,'../Source/HttpCommand.dyalog'
     {}#.⎕FIX'file://',home,'httpcommand_test.dyalog'
 :Else
     r←,⍕⎕DM
 :EndTrap
