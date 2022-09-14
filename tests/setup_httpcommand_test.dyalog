 r←setup_httpcommand_test dummy;home
⍝ Setup test
 ⎕IO←⎕ML←1
 r←''
 :Trap 0
     home←##.TESTSOURCE  ⍝ hopefully good enough...

     {}#.⎕FIX'file://',home,'HttpServer.dyalog'
     {}#.⎕FIX'file://',home,'../source/HttpCommand.dyalog'
     {}#.⎕FIX'file://',home,'httpcommand_test.dyalog'

     {}#.server ← HttpServer.New 8090 ⎕THIS
     {}#.server.Run
 :Else
     r←,⍕⎕DM
 :EndTrap
