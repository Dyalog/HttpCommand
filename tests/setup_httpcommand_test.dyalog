 r←setup_httpcommand_test home;this;last;findFiles;files;pattern;file;root;folders;roots;folder;paths;path
⍝ Setup test
 ⎕IO←⎕ML←1
 r←''

 :If 0∊⍴home
     :If 0∊⍴home←4⊃5179⌶this←⊃⎕SI
         :If '⍝∇⍣§'≡4↑last←⊃⊢/⎕NR this
             home←2⊃2↑'§'(≠⊆⊢)last
         :EndIf
     :EndIf
 :EndIf
 :If 0∊⍴home
     :If 2=##.⎕NC'TESTSOURCE'   ⍝ use DTest's path to determine home of test
         home←##.TESTSOURCE
     :Else
         home←1 ⎕NPARTS'/git/httpcommand/tests/'
     :EndIf
 :Else
     home←⊃1 ⎕NPARTS home
 :EndIf
     
 findFiles←{
     (names type hidden)←0 1 6(⎕NINFO⍠1)∊1 ⎕NPARTS ⍺,'/',⍵
     names/⍨(~hidden)∧type=2
 }

 roots←#
 paths←,⊂home
 :While ~0∊⍴roots
     root←⊃roots
     path←⊃paths
     files←''
     :For pattern :In '*.apl?' '*.dyalog'
         files,←path findFiles pattern
     :EndFor

     :For file :In files
         :Trap 11
             {}2 root.⎕FIX'file://',file
         :Else
             ⎕←'Unable to load: ',file
         :EndTrap
     :EndFor

     folders←{
         (names type hidden)←0 1 6(⎕NINFO⍠1)∊1 ⎕NPARTS ⍵,'/*'
         names/⍨(~hidden)∧type=1
     }path

     paths←(1↓paths),folders
     roots↓⍨←1

     :For folder :In folders
         roots,←⍎((≢path)↓folder)root.⎕NS''
     :EndFor

 :EndWhile

 :Trap 0
     {}2 #.⎕FIX'file://',home,'../Source/HttpCommand.dyalog'
     #._httpbin←'https://httpbin.org'
     #._typicode←'https://jsonplaceholder.typicode.com/'
     #._websocket←'https://echo.websocket.org/'
 :Else
     r←,⍕⎕DM
 :EndTrap
