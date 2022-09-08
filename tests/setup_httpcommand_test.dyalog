 r←setup_httpcommand_test dummy;home
⍝ Setup test
 ⎕IO←⎕ML←1
 r←''
 :Trap 0
     home←##.TESTSOURCE  ⍝ hopefully good enough...
     {}#.⎕FIX'file://',home,'../source/HttpCommand.dyalog'
     {}#.⎕FIX'file://',home,'httpcommand_test.dyalog'
 :Else
     r←,⍕⎕DM
 :EndTrap
