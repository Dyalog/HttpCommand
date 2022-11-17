:Class HttpServer
⍝ Bare Bones HTTP Server

    (⎕ML ⎕IO)←1 1

  ⍝ User hooks settings
    :Field Public BrokerFn←''                                  ⍝ name or reference to user-defined broker function
    :Field Public InitFn←''                                    ⍝ name of initialization function (execute after server creation but before server serving)
    :Field Public LogFn←''                                     ⍝ Log function name, leave empty to use built in logging

  ⍝ Operational settings
    :Field Public AllowEndpoints←1                             ⍝ 1 = allow functions in CodeLocation as endpoints, 0 = everything is passed to BrokerFn
    :Field Public CodeLocation←#                               ⍝ default code location
    :Field Public Shared Debug←0                               ⍝ 0 = all errors are trapped, 1 = stop on an error, 2 = stop on intentional error before processing request
    :Field Public ErrorInfoLevel←1                             ⍝ level of information to provide if an APL error occurs, 0=none, 1=⎕EM, 2=⎕SI
    :Field Public Folder←''                                    ⍝ folder that user supplied if CodeLocation is a folder
    :Field Public Hostname←''                                  ⍝ external-facing host name
    :Field Public HTTPAuthentication←'basic'                   ⍝ valid settings are currently 'basic' or ''
    :Field Public KeepAlive←0                                  ⍝ ms to keep a connection alive
    :Field Public Logging←1                                    ⍝ turn logging on/off
    :Field Public Verbose←0                                    ⍝ turn console messages on/off

  ⍝ Conga-related settings
    :Field Public AcceptFrom←⍬                                 ⍝ IP addresses to accept requests from - empty means accept from any IP address
    :Field Public BufferSize←200000                            ⍝ Conga buffer size for DRC.Wait
    :Field Public DenyFrom←⍬                                   ⍝ IP addresses to refuse requests from - empty means deny none
    :Field Public DOSLimit←¯1                                  ⍝ Conga DOSLimit
    :Field Public Port←8080                                    ⍝ Default port to listen on
    :Field Public RootCertDir←''                               ⍝ Root CA certificate folder
    :field Public Priority←'NORMAL:!CTYPE-OPENPGP'             ⍝ Priorities for GnuTLS when negotiation connection
    :Field Public Secure←0                                     ⍝ 0 = use HTTP, 1 = use HTTPS
    :field Public ServerCertSKI←''                             ⍝ Server cert's Subject Key Identifier from store
    :Field Public ServerCertFile←''                            ⍝ public certificate file
    :field Public ServerConfig←''                              ⍝ server configuration file path, if any
    :Field Public ServerKeyFile←''                             ⍝ private key file
    :Field Public SSLValidation←64                             ⍝ request, but do not require a client certificate
    :Field Public ServerSpace←''                               ⍝ when initialized, this is a server namespace for the user's use
    :Field Public WaitTimeout←2500                             ⍝ ms for server wait loop

    :Field Public Shared LDRC                                  ⍝ HttpServer-set reference to Conga after CongaRef has been resolved
    :Field Public Shared CongaPath←''                          ⍝ user-supplied path to Conga workspace and/or shared libraries
    :Field Public Shared CongaRef←''                           ⍝ user-supplied reference to Conga library instance
    :Field CongaVersion←''                                     ⍝ Conga version

  ⍝↓↓↓ some of these private fields are also set in ∇init so that a server can be stopped, updated, and restarted
    :Field _rootFolder←''                ⍝ root folder for relative file paths
    :Field _configLoaded←0               ⍝ indicates whether config was already loaded by Autostart
    :Field _stop←0                       ⍝ set to 1 to stop server
    :Field _started←0                    ⍝ is the server started
    :Field _stopped←1                    ⍝ is the server stopped
    :field _paused←0                     ⍝ is the server paused
    :Field _serverThread←¯1              ⍝ thread for the HTTP server
    :Field _taskThreads←⍬                ⍝ vector of thread handling requests
    :Field _connections                  ⍝ namespace containing open connections
    :Field _connectionThread←¯1          ⍝ thread for the connection monitor if persistent connections are used

    ∇ r←Version
      :Access public shared
      r←'HttpServer' '1.0.1' '2022-04-05'
    ∇

    ∇ r←Config
    ⍝ returns current configuration
      :Access public
      r←↑{⍵(⍎⍵)}¨⎕THIS⍎'⎕NL ¯2.2'
    ∇

    ∇ r←{value}DebugLevel level
    ⍝  monadic: return 1 if level is within Debug (powers of 2)
    ⍝    example: stopIf DebugLevel 2  ⍝ sets a stop if Debug contains 2
    ⍝  dyadic:  return value unless level is within Debug (powers of 2)
    ⍝    example: :Trap 0 DebugLevel 5 ⍝ set Trap 0 unless Debug contains 1 or 4 in its
      :Access public
      r←∨/(2 2 2⊤⊃Debug)∨.∧2 2 2⊤level
      :If 0≠⎕NC'value'
          r←value/⍨~r
      :EndIf
    ∇

    ∇ {r}←{level}Log msg;ts
      :Access public overridable
      :If Logging>0∊⍴msg
          ts←fmtTS ⎕TS
          :If 1=≢⍴msg←⍕msg
          :OrIf 1=⊃⍴msg ⋄ r←ts,' ',(2⊃⎕SI),'[',(⍕2⊃⎕LC),'] - ',msg
          :Else ⋄ r←ts,∊(⎕UCS 13),msg
          :EndIf
          ⎕←r
      :EndIf
    ∇

    ∇ make
      :Access public
      :Implements constructor
      MakeCommon
    ∇

    ∇ make1 args;rc;msg;char;t
      :Access public
      :Implements constructor
    ⍝ args is one of
    ⍝ - a simple character vector which is the name of a configuration file
    ⍝ - a reference to a namespace containing named configuration settings
    ⍝ - a depth 1 or 2 vector of
    ⍝   [1] integer port to listen on
    ⍝   [2] charvec function folder or ref to code location
      MakeCommon
      →0⍴⍨0∊⍴args
      :If char←isChar args ⍝ character argument?  it's either config filename or CodeLocation folder
          :If ~⎕NEXISTS args
              →0⊣Log'Unable to find "',args,'"'
          :ElseIf 2=t←1 ⎕NINFO args ⍝ normal file
              :If (lc⊢/⎕NPARTS args)∊'.json' '.json5' ⍝ json files are configuration
                  :If 0≠⊃(rc msg)←LoadConfiguration ServerConfig←args
                      Log'Error loading configuration: ',msg
                  :EndIf
              :Else
                  CodeLocation←args ⍝ might be a namespace script or class
              :EndIf
          :ElseIf 1=t ⍝ folder means it's CodeLocation
              CodeLocation←args
          :Else ⍝ not a file or folder
              Log'Invalid constructor argument "',args,'"'
          :EndIf
      :ElseIf 9.1={⎕NC⊂,'⍵'}args ⍝ namespace?
          :If 0≠⊃(rc msg)←LoadConfiguration args
              Log'Error loading configuration: ',msg
          :EndIf
      :Else
          :If 326=⎕DR args
          :AndIf 0∧.=≡¨2↑args   ⍝ if 2↑args is (port ref) (both scalar)
              args[1]←⊂,args[1] ⍝ nest port so ∇default works properly
          :EndIf
          (Port CodeLocation)←args default Port CodeLocation
      :EndIf
    ∇

    ∇ MakeCommon
      ServerSpace←⎕NS''
      :Trap 11 ⋄ JSONin←{⎕JSON⍠('Dialect' 'JSON5')⊢⍵} ⋄ {}JSONin 1
      :Else
          JSONin←⎕JSON
      :EndTrap
    ∇

    ∇ r←args default defaults
      args←,⊆args
      r←(≢defaults)↑args,(≢args)↓defaults
    ∇

    ∇ r←New args
    ⍝ Shared method to create new HttpServer
      :Access public shared
      r←⎕NEW ⎕THIS args
    ∇


    ∇ Close
      :Implements destructor
      {0:: ⋄ {}LDRC.Close ServerName}⍬
    ∇

    ∇ r←Run args;msg;rc
    ⍝ args is one of
    ⍝ - a simple character vector which is the name of a configuration file
    ⍝ - a reference to a namespace containing named configuration settings
    ⍝ - a depth 1 or 2 vector of
    ⍝   [1] integer port to listen on
    ⍝   [2] charvec function folder or ref to code location
    ⍝   [3] paradigm to use ('JSON' or 'REST')
      :Access shared public
      :Trap 0 DebugLevel 1
          (rc msg)←(r←⎕NEW ⎕THIS args).Start
      :Else
          (r rc msg)←'' ¯1 ⎕DMX.EM
      :EndTrap
      r←(r(rc msg))
    ∇

    ∇ (rc msg)←Start;html;homePage
      :Access public
     
      :If _started
          :If 0(,2)≡LDRC.GetProp ServerName'Pause'
              rc←1⊃LDRC.SetProp ServerName'Pause' 0
              →0 If(rc'Failed to unpause server')
              (rc msg)←0 'Server resuming operations'
              →0
          :EndIf
          →0 If(rc msg)←¯1 'Server thinks it''s already started'
      :EndIf
     
      :If _stop
          →0 If(rc msg)←¯1 'Server is in the process of stopping'
      :EndIf
     
      :If 'CLEAR WS'≡⎕WSID ⋄ _rootFolder←⊃1 ⎕NPARTS SourceFile
      :Else ⋄ _rootFolder←⊃1 ⎕NPARTS ⎕WSID
      :EndIf
     
      →0 If(rc msg)←LoadConfiguration ServerConfig
      →0 If(rc msg)←CheckPort
      →0 If(rc msg)←LoadConga
      →0 If(rc msg)←CheckCodeLocation
     
      →0 If(rc msg)←StartServer
     
      Log'HttpServer started on port ',⍕Port
      Log'Serving code in ',(⍕CodeLocation),(Folder≢'')/' (populated with code from "',Folder,'")'
    ∇

    ∇ (rc msg)←Stop;ts
      :Access public
      :If _stop
          →0⊣(rc msg)←¯1 'Server is already stopping'
      :EndIf
      :If ~_started
          →0⊣(rc msg)←¯1 'Server is not running'
      :EndIf
      ts←⎕AI[3]
      _stop←1
      Log'Stopping server...'
      :While ~_stopped
          :If 10000<⎕AI[3]-ts
              →0⊣(rc msg)←¯1 'Server seems stuck'
          :EndIf
      :EndWhile
      (rc msg)←0 'Server stopped'
    ∇

    ∇ (rc msg)←Pause;ts
      :Access public
      :If 0 2≡2⊃LDRC.GetProp ServerName'Pause'
          →0⊣(rc msg)←¯1 'Server is already paused'
      :EndIf
      :If ~_started
          →0⊣(rc msg)←¯1 'Server is not running'
      :EndIf
      ts←⎕AI[3]
      LDRC.SetProp ServerName'Pause' 2
      Log'Pausing server...'
      (rc msg)←0 'Server paused'
    ∇

    ∇ (rc msg)←Reset
      :Access Public
      ⎕TKILL _serverThread,_taskThreads,_connectionThread
      _stopped←~_stop←_started←0
      (rc msg)←0 'Server reset (previously set options are still in effect)'
    ∇

    ∇ r←Running
      :Access public
      r←~_stop
    ∇

    ∇ (rc msg)←CheckPort;p
    ⍝ check for valid port number
      (rc msg)←3('Invalid port: ',∊⍕Port)
      →0 If 0=p←⊃⊃(//)⎕VFI⍕Port
      →0 If{(⍵>32767)∨(⍵<1)∨⍵≠⌊⍵}p
      (rc msg)←0 ''
    ∇

    ∇ (rc msg)←{force}LoadConfiguration value;config;public;set;file
      :Access public
      :If 0=⎕NC'force' ⋄ force←0 ⋄ :EndIf
      (rc msg)←0 ''
      →(_configLoaded>force)⍴0 ⍝ did we already load from AutoStart?
      :Trap 0 DebugLevel 1
          :If isChar value
              :If '#.'≡2↑value ⍝ check if a namespace reference
              :AndIf 9.1=⎕NC⊂value ⋄ →Load⊣config←⍎value
              :EndIf
     
              file←ServerConfig
              :If ~0∊⍴value ⋄ file←value ⋄ :EndIf
     
              →∆EXIT If 0∊⍴file
              :If ⎕NEXISTS file ⋄ config←JSONin⊃⎕NGET file
              :Else ⋄ →0⊣(rc msg)←6('Configuation file "',file,'" not found')
              :EndIf
          :ElseIf 9.1={⎕NC⊂,'⍵'}value ⋄ config←value ⍝ namespace?
          :EndIf
     Load:
          public←⎕THIS⍎'⎕NL ¯2.2' ⍝ find all the public fields in this class
          :If ~0∊⍴set←public{⍵/⍨⍵∊⍺}config.⎕NL ¯2 ¯9 ⋄ config{⍎⍵,'←⍺⍎⍵'}¨set ⋄ :EndIf
          _configLoaded←1
      :Else ⋄ →∆EXIT⊣(rc msg)←⎕DMX.EN ⎕DMX.('Error loading configuration: ',EM,(~0∊⍴Message)/' (',Message,')')
      :EndTrap
     ∆EXIT:
    ∇

    ∇ (rc msg)←LoadConga;ref;root;nc;n;ns;congaCopied;class;path
      ⍝↓↓↓ Check if LDRC exists (VALUE ERROR (6) if not), and is LDRC initialized? (NONCE ERROR (16) if not)
     
      (rc msg)←1 ''
     
      :Hold 'HttpServerInitConga'
          :If {6 16 999::1 ⋄ ''≡LDRC:1 ⋄ 0⊣LDRC.Describe'.'}''
              LDRC←''
              :If ~0∊⍴CongaRef  ⍝ did the user supply a reference to Conga?
                  LDRC←ResolveCongaRef CongaRef
                  →∆END↓⍨0∊⍴msg←(''≡LDRC)/'CongaRef (',(⍕CongaRef),') does not point to a valid instance of Conga'
              :Else
                  :For root :In ##.## #
                      ref nc←root{1↑¨⍵{(×⍵)∘/¨⍺ ⍵}⍺.⎕NC ⍵}ns←'Conga' 'DRC'
                      :If 9=⊃⌊nc ⋄ :Leave ⋄ :EndIf
                  :EndFor
     
                  :If 9=⊃⌊nc
                      LDRC←ResolveCongaRef root⍎∊ref
                      →∆END↓⍨0∊⍴msg←(''≡LDRC)/(⍕root),'.',(∊ref),' does not point to a valid instance of Conga'
                      →∆COPY↓⍨{999::0 ⋄ 1⊣LDRC.Describe'.'}'' ⍝ it's possible that Conga was saved in a semi-initialized state
                      Log'Conga library found at ',(⍕root),'.',∊ref
                  :Else
     ∆COPY:
                      class←⊃⊃⎕CLASS ⎕THIS
                      congaCopied←0
                      :For n :In ns
                          :For path :In (1+0∊⍴CongaPath)⊃(⊂CongaPath)((DyalogRoot,'ws/')'') ⍝ if CongaPath specified, use it exclusively
                              :Trap Debug↓0
                                  n class.⎕CY path,'conga'
                                  LDRC←ResolveCongaRef class⍎n
                                  →∆END↓⍨0∊⍴msg←(''≡LDRC)/n,' was copied from ',path,'conga but is not valid'
                                  Log n,' copied from ',path,'conga'
                                  →∆COPIED⊣congaCopied←1
                              :EndTrap
                          :EndFor
                      :EndFor
                      →∆END↓⍨0∊⍴msg←(~congaCopied)/'Neither Conga nor DRC were successfully copied from [DYALOG]/ws/conga'
     ∆COPIED:
                  :EndIf
              :EndIf
          :EndIf
          CongaVersion←⊃(//)⎕VFI 1↓∊{'.',⍕⍵}¨2↑LDRC.Version
          LDRC.X509Cert.LDRC←LDRC ⍝ reset X509Cert.LDRC reference
          Log'Local Conga reference is ',⍕LDRC
          rc←0
     ∆END:
      :EndHold
    ∇

    ∇ LDRC←ResolveCongaRef CongaRef;z;failed
    ⍝ Attempt to resolve what CongaRef refers to
    ⍝ CongaRef can be a charvec, reference to the Conga or DRC namespaces, or reference to an iConga instance
    ⍝ LDRC is '' if Conga could not be initialized, otherwise it's a reference to the the Conga.LIB instance or the DRC namespace
     
      LDRC←'' ⋄ failed←0
      :Select nameClass CongaRef ⍝ what is it?
      :Case 9.1 ⍝ namespace?  e.g. CongaRef←DRC or Conga
     ∆TRY:
          :Trap 0 DebugLevel 1
              :If ∨/'.Conga'⍷⍕CongaRef ⋄ LDRC←CongaPath CongaRef.Init'HttpServer' ⍝ is it Conga?
              :ElseIf 0≡⊃CongaPath CongaRef.Init'' ⋄ LDRC←CongaRef ⍝ DRC?
              :Else ⋄ →∆EXIT⊣LDRC←''
              :End
          :Else ⍝ if HttpCommand is reloaded and re-executed in rapid succession, Conga initialization may fail, so we try twice
              :If failed ⋄ →∆EXIT⊣LDRC←''
              :Else ⋄ →∆TRY⊣failed←1
              :EndIf
          :EndTrap
      :Case 9.2 ⍝ instance?  e.g. CongaRef←Conga.Init ''
          LDRC←CongaRef ⍝ an instance is already initialized
      :Case 2.1 ⍝ variable?  e.g. CongaRef←'#.Conga'
          :Trap 0 DebugLevel 1
              LDRC←ResolveCongaRef(⍎∊⍕CongaRef)
          :EndTrap
      :EndSelect
     ∆EXIT:
    ∇

    ∇ (rc msg secureParams)←CreateSecureParams;cert;certs;msg;mask;matchID
    ⍝ return Conga parameters for running HTTPS, if Secure is set to 1
     
      LDRC.X509Cert.LDRC←LDRC ⍝ make sure the X509 instance points to the right LDRC
      (rc secureParams msg)←0 ⍬''
      :If Secure
          :If ~0∊⍴RootCertDir ⍝ on Windows not specifying RootCertDir will use MS certificate store
              →∆EXIT If(rc msg)←'RootCertDir'Exists RootCertDir
              →∆EXIT If(rc msg)←{(⊃⍵)'Error setting RootCertDir'}LDRC.SetProp'.' 'RootCertDir'RootCertDir
          :ElseIf 0∊⍴ServerCertSKI
              →∆EXIT If(rc msg)←'ServerCertFile'Exists ServerCertFile
              →∆EXIT If(rc msg)←'ServerKeyFile'Exists ServerKeyFile
              :Trap 0 DebugLevel 1
                  cert←⊃LDRC.X509Cert.ReadCertFromFile ServerCertFile
              :Else
                  (rc msg)←⎕DMX.EN('Unable to decode ServerCertFile "',(∊⍕ServerCertFile),'" as a certificate')
                  →∆EXIT
              :EndTrap
              cert.KeyOrigin←'DER'ServerKeyFile
          :ElseIf isWin
              certs←LDRC.X509Cert.ReadCertUrls
              :If 0∊⍴certs
                  →∆EXIT⊣(rc msg)←8 'No certificates found in Microsoft Certificate Store'
              :Else
                  matchID←{'id=(.*);'⎕S'\1'⍠'Greedy' 0⊢2⊃¨z.CertOrigin}2⊃¨certs.CertOrigin
                  mask←ServerCertSKI{∨/¨(⊂⍺)⍷¨2⊃¨⍵}certs.CertOrigin
                  :If 1≠+/mask
                      rc←9
                      msg←(0 2⍸+/mask)⊃('Certificate with id "',ServerCertSKI,'" was not found in the Microsoft Certificate Store')('There is more than one certificate with Subject Key Identifier "',ServerCertSKI,'" in the Microsoft Certificate Store')
                      →∆EXIT
                  :EndIf
                  cert←certs[⊃⍸mask]
              :EndIf
          :Else ⍝ ServerCertSKI is defined, but we're not running Windows
              →∆EXIT⊣(rc msg)←10 'ServerCertSKI is currently valid only under Windows'
          :EndIf
          secureParams←('X509'cert)('SSLValidation'SSLValidation)('Priority'Priority)
      :EndIf
     ∆EXIT:
    ∇

    ∇ (rc msg)←CheckCodeLocation;root;m;res;tmp;t;path
      (rc msg)←0 ''
      :If 0∊⍴CodeLocation
          :If 0∊⍴ServerConfig ⍝ if there's a configuration file, use its folder for CodeLocation
              CodeLocation←#
          :Else
              CodeLocation←⊃1 ⎕NPARTS ServerConfig
          :EndIf
      :EndIf
      :Select ⊃{⎕NC'⍵'}CodeLocation ⍝ need dfn because CodeLocation is a field and will always be nameclass 2
      :Case 9 ⍝ reference, just use it
      :Case 2 ⍝ variable, could be file path or ⍕ of reference from ServerConfig
          :If 326=⎕DR tmp←{0::⍵ ⋄ '#'≠⊃⍵:⍵ ⋄ ⍎⍵}CodeLocation
          :AndIf 9={⎕NC'⍵'}tmp ⋄ CodeLocation←tmp
          :Else
              root←(isRelPath CodeLocation)/_rootFolder
              path←∊1 ⎕NPARTS root,CodeLocation
              :Trap 0 DebugLevel 1
                  :If 1=t←1 ⎕NINFO path ⍝ folder?
                      CodeLocation←⍎'CodeLocation'#.⎕NS''
                      →∆EXIT If(rc msg)←CodeLocation LoadFromFolder Folder←path
                  :ElseIf 2=t ⋄ CodeLocation←#.⎕FIX'file://',path ⍝ file?
                  :Else ⋄ →∆EXIT⊣(rc msg)←5('CodeLocation "',(∊⍕CodeLocation),'" is not a folder or script file.')
                  :EndIf
              :Case 22 ⋄ →∆EXIT⊣(rc msg)←6('CodeLocation "',(∊⍕CodeLocation),'" was not found.') ⍝ file name error
              :Else ⋄ →∆EXIT⊣(rc msg)←7((⎕DMX.(EM,' (',Message,') ')),'occured when validating CodeLocation "',(∊⍕CodeLocation),'"') ⍝ anything else
              :EndTrap
          :EndIf
      :Else ⋄ →∆EXIT⊣(rc msg)←5 'CodeLocation is not valid, it should be either a namespace/class reference or a file path'
      :EndSelect
     
      :If ~0∊⍴InitFn
          :If 3≠CodeLocation.⎕NC InitFn ⋄ msg,←(0∊⍴msg)↓',"CodeLocation.',InitFn,'" was not found ' ⋄ :EndIf
      :EndIf
     
      :If ~0∊⍴BrokerFn
          :If 3≠CodeLocation.⎕NC BrokerFn ⋄ msg,←(0∊⍴msg)↓',"CodeLocation.',BrokerFn,'" was not found ' ⋄ :EndIf
      :EndIf
     
      →∆EXIT If rc←8×~0∊⍴msg
     
      :If ~0∊⍴InitFn  ⍝ initialization function specified?
          :If 1 0 0≡⊃CodeLocation.⎕AT InitFn ⍝ result-returning niladic?
              stopIf DebugLevel 2
              :If 0≠⊃res ⋄ →∆EXIT⊣(rc msg)←2↑res,(≢res)↓¯1('"',(⍕CodeLocation),'.',InitFn,'" did not return a 0 return code')
              :EndIf
          :Else ⋄ →∆EXIT⊣(rc msg)←8('"',(⍕CodeLocation),'.',InitFn,'" is not a niladic result-returning function')
          :EndIf
      :EndIf
     ∆EXIT:
    ∇

    Exists←{0:: ¯1 (⍺,' "',⍵,'" is not a valid folder name.') ⋄ ⎕NEXISTS ⍵:0 '' ⋄ ¯1 (⍺,' "',⍵,'" was not found.')}


    ∇ (rc msg)←StartServer;r;cert;secureParams;accept;deny;mask;certs;options
      msg←'Unable to start server'
      accept←'Accept'ipRanges AcceptFrom
      deny←'Deny'ipRanges DenyFrom
      →∆EXIT If⊃(rc msg secureParams)←CreateSecureParams
     
      {}LDRC.SetProp'.' 'EventMode' 1 ⍝ report Close/Timeout as events
     
      options←''
      :If 3.3≤CongaVersion ⍝ can we set DecodeBuffers at server creation?
          options←⊂'Options' 5 ⍝ DecodeBuffers + WSAutoAccept
      :EndIf
     
      _connections←⎕NS''
     
      :If 0=rc←1⊃r←LDRC.Srv'' ''Port'http'BufferSize,secureParams,accept,deny,options
     
          ServerName←2⊃r
     
          :If 3.3>CongaVersion
              {}LDRC.SetProp ServerName'FIFOMode' 0 ⍝ deprecated in Conga v3.2
              {}LDRC.SetProp ServerName'DecodeBuffers' 15 ⍝ 15 ⍝ decode all buffers
              {}LDRC.SetProp ServerName'WSFeatures' 1 ⍝ auto accept WS requests
          :EndIf
          :If 0∊⍴Hostname ⍝ if Host hasn't been set, set it to the default
              Hostname←'http',(~Secure)↓'s://',(2 ⎕NQ'.' 'TCPGetHostID'),((~Port∊80 443)/':',⍕Port),'/'
          :EndIf
          RunServer
          msg←''
      :Else
          →∆EXIT⊣msg←'Error creating server',(rc∊98 10048)/': port ',(⍕Port),' is already in use' ⍝ 98=Linux, 10048=Windows
      :EndIf
     ∆EXIT:
    ∇

    ∇ RunServer
      _serverThread←Server&⍬
      :If 0<KeepAlive
          _connectionThread←Monitor&0
      :EndIf
    ∇

    ∇ Server arg;wres;rc;obj;evt;data;ref;ip
      (_started _stopped)←1 0
      :While ~_stop
          :Trap 0 DebugLevel 1
              wres←LDRC.Wait ServerName 2500 ⍝ Wait for WaitTimeout before timing out
          ⍝ wres: (return code) (object name) (command) (data)
              (rc obj evt data)←4↑wres
              :Select rc
              :Case 0
                  :Select evt
                  :Case 'Error'
                      _stop←ServerName≡obj
                      :If 0≠4⊃wres
                          Log'RunServer: DRC.Wait reported error ',(⍕4⊃wres),' on ',(2⊃wres),GetIP obj
                      :EndIf
                      _connections.⎕EX obj
     
                  :Case 'Connect'
                      obj _connections.⎕NS''
                      (_connections⍎obj).IP←2⊃2⊃LDRC.GetProp obj'PeerAddr'
                      (_connections⍎obj).LastTime←⎕AI[3]
     
                  :CaseList 'HTTPHeader' 'HTTPTrailer' 'HTTPChunk' 'HTTPBody'
                      (_connections⍎obj).LastTime←⎕AI[3]
                      _taskThreads←⎕TNUMS∩_taskThreads,(_connections⍎obj){⍺ HandleRequest ⍵}&wres
     
                  :Case 'Closed'
                      _connections.⎕EX obj
     
                  :Case 'Timeout'
     
                  :Else ⍝ unhandled event
                      Log'Unhandled Conga event:'
                      Log⍕wres
                  :EndSelect ⍝ evt
     
              :Case 1010 ⍝ Object Not found
                  :If ~_stop
                      Log'Object ''',ServerName,''' has been closed - HttpServer shutting down'
                      _stop←1
                  :EndIf
     
              :Else
                  Log'Conga wait failed:'
                  Log wres
              :EndSelect ⍝ rc
          :Else
              Log'*** Server error ',(⎕JSON⍠'Compact' 0)⎕DMX
          :EndTrap
      :EndWhile
      Close
      (_stop _started _stopped)←0 0 1
    ∇

    ∇ Monitor dummy;ns;names;refs;kill
    ⍝ monitor connections
      :While ~_stopped
          :If 9=_connections.⎕NC ServerName ⍝
              ns←_connections⍎ServerName
              :If ~0∊⍴names←ns.⎕NL ¯9.1
                  refs←ns⍎⍕names
                  :If ∨/kill←refs.{6::0 ⋄ (Req.Complete∧.=2)∧⍵<⎕AI[3]-LastTime}KeepAlive
                      ns KillConnection¨kill/names
                  :EndIf
              :EndIf
          :EndIf
          ⎕DL 2
      :EndWhile
    ∇

    ∇ ns KillConnection obj
      :Hold obj
          {}{0::0 ⋄ LDRC.Close ServerName,'.',⍵}obj
          ns.⎕EX obj
      :EndHold
    ∇

    :Section RequestHandling

    ∇ req←MakeRequest args
    ⍝ create a request, use MakeRequest '' for interactive debugging
      :Access public
      :If 0∊⍴args
          req←⎕NEW Request
      :Else
          req←⎕NEW Request args
      :EndIf
      req.(Server ErrorInfoLevel)←⎕THIS ErrorInfoLevel
    ∇

    ∇ ns HandleRequest req;data;evt;obj;rc;cert;fn
      (rc obj evt data)←req ⍝ from Conga.Wait
      :Hold obj
          ns.LastTime←⎕AI[3]
          :Select evt
          :Case 'HTTPHeader'
              ns.Req←MakeRequest data
              ns.Req.PeerCert←''
              ns.Req.PeerAddr←2⊃2⊃LDRC.GetProp obj'PeerAddr'
              ns.Req.Server←⎕THIS
              ns.Req.Object←obj
     
              :If Secure
                  (rc cert)←2↑LDRC.GetProp obj'PeerCert'
                  :If rc=0
                      ns.Req.PeerCert←cert
                  :Else
                      ns.Req.PeerCert←'Could not obtain certificate'
                  :EndIf
              :EndIf
     
          :Case 'HTTPBody'
              ns.Req.ProcessBody data
          :Case 'HTTPChunk'
              ns.Req.ProcessChunk data
          :Case 'HTTPTrailer'
              ns.Req.ProcessTrailer data
          :EndSelect
     
          :If 1=ns.Req.Complete
     
              :If ns.Req.Charset≡'utf-8'
                  ns.Req.Body←'UTF-8'⎕UCS ⎕UCS ns.Req.Body
              :EndIf
     
              fn←1↓'.'@('/'∘=)ns.Req.Endpoint
     
              fn RequestHandler ns
     
              obj Respond ns.Req
     
              ns.Req.Complete←2
     
              :If 0=KeepAlive
                  _connections.⎕EX obj
              :EndIf
          :EndIf
      :EndHold
    ∇

    ∇ fn RequestHandler ns;payload;resp;valence;nc;debug;ind;file
      :If 0∊⍴fn
          →0 If'No valid endpoint specified'ns.Req.Fail 400×0∊⍴BrokerFn
          fn←BrokerFn
      :EndIf
      →0 If('Invalid endpoint "',fn,'"')ns.Req.Fail CheckFunctionName fn
      →0 If('Invalid endpoint "',fn,'"')ns.Req.Fail 404×3≠⌊|{0::0 ⋄ CodeLocation.⎕NC⊂⍵}fn  ⍝ is it a function?
      valence←⊃CodeLocation.⎕AT fn
      →0 If('"',fn,'" is not a monadic or ambivalent function')ns.Req.Fail 400×∧/valence[2 3]∘≢¨(1 0)(¯2 0)
      resp←''
      :Trap 0 DebugLevel 1
          :Trap 85
              stopIf DebugLevel 2
              resp←{1 CodeLocation.(85⌶)fn,' ⍵'}ns.Req ⍝ intentional stop for application-level debugging
              ns.Req.Response.Payload←∊⍕resp
          :EndTrap
      :Else
          Log(⊂'Error in endpoint'),2↑⎕DM
          (1+⊃⎕LC)⎕STOP⊃⎕SI
          ('Endpoint ',fn,' ',⊃⎕DM)ns.Req.Fail 500
      :EndTrap
    ∇

    ∇ obj Respond req;status;z;res
      :If req.Sent ⍝ if the endpoint sent the response already
          {}LDRC.Close⍣(KeepAlive⍱req.Closed)⊢obj
          →0
      :EndIf
      res←req.Response
      status←(⊂'HTTP/1.1'),res.((⍕Status)StatusText)
      res.Headers⍪←'server'(⊃Version)
      res.Headers⍪←'date'(2⊃LDRC.GetProp'.' 'HttpDate')
      :If 0≠1⊃z←LDRC.Send obj(status,res.Headers res.Payload)(KeepAlive=0)
          Log'Conga error when sending response to ',GetIP obj
          Log⍕z
      :EndIf
    ∇

    :EndSection ⍝ Request Handling

    ∇ ip←GetIP objname
      ip←{6::'' ⋄ ' (IP Address ',(⍕(_connections⍎⍵).IP),')'}objname
    ∇

    ∇ r←CheckFunctionName fn
    ⍝ checks the requested function name and returns
    ⍝    0 if the function is allowed
    ⍝  403 (forbidden) if fn is in the list of disallowed functions
      :Access public
      r←0
      fn←,⊆fn
      →0 If r←403×fn∊InitFn LogFn
    ∇

    :class Request
        :Field Public Instance Boundary←''       ⍝ boundary for content-type 'multipart/XXX'
        :Field Public Instance Charset←''        ⍝ content charset (defaults to 'utf-8' if content-type is application/json)
        :Field Public Instance Complete←0        ⍝ do we have a complete request?
        :Field Public Instance ContentType←''    ⍝ content-type header value
        :Field Public Instance URL←''            ⍝ request URL (without the scheme)
        :Field Public Instance Headers←0 2⍴⊂''   ⍝ HTTPRequest header fields (plus any supplied from HTTPTrailer event)
        :Field Public Instance Method←''         ⍝ HTTP method (GET, POST, PUT, etc)
        :Field Public Instance Endpoint←''       ⍝ Requested URI
        :Field Public Instance Body←''           ⍝ body of the request
        :Field Public Instance PeerAddr←'unknown'⍝ client IP address
        :Field Public Instance PeerCert←0 0⍴⊂''  ⍝ client certificate
        :Field Public Instance HTTPVersion←''    ⍝ HTTP version of the request
        :Field Public Instance ErrorInfoLevel←1  ⍝ error information level to report (set from HttpServer class)
        :Field Public Instance Response          ⍝ response namespace
        :Field Public Instance Server            ⍝ ref to the server instance
        :Field Public Instance Object            ⍝ Conga object name for this request
        :Field Public Instance QueryParams←0 2⍴0 ⍝ matrix of query parameters [;1] name, [;2] value
        :Field Public Instance UserID←''         ⍝ user ID if using HTTP Basic Authentication
        :Field Public Instance Password←''       ⍝ password if using HTTP Basic Authentication
        :Field Public Instance Sent←0            ⍝ set to 1 if endpoint sends the response (e.g. when doing chunking)
        :Field Public Instance Closed←0          ⍝ set to 1 if endpoint rather than server closed the connection

        :Field Public Shared HttpStatus←↑(200 'OK')(201 'Created')(204 'No Content')(301 'Moved Permanently')(302 'Found')(303 'See Other')(304 'Not Modified')(305 'Use Proxy')(307 'Temporary Redirect')(400 'Bad Request')(401 'Unauthorized')(403 'Forbidden')(404 'Not Found')(405 'Method Not Allowed')(406 'Not Acceptable')(408 'Request Timeout')(409 'Conflict')(410 'Gone')(411 'Length Required')(412 'Precondition Failed')(413 'Request Entity Too Large')(414 'Request-URI Too Long')(415 'Unsupported Media Type')(500 'Internal Server Error')(501 'Not Implemented')(503 'Service Unavailable')

        ⍝ Content types for common file extensions
        :Field Public Shared ContentTypes←18 2⍴'txt' 'text/plain' 'htm' 'text/html' 'html' 'text/html' 'css' 'text/css' 'xml' 'text/xml' 'svg' 'image/svg+xml' 'json' 'application/json' 'zip' 'application/x-zip-compressed' 'csv' 'text/csv' 'pdf' 'application/pdf' 'mp3' 'audio/mpeg' 'pptx' 'application/vnd.openxmlformats-officedocument.presentationml.presentation' 'js' 'application/javascript' 'png' 'image/png' 'jpg' 'image/jpeg' 'bmp' 'image/bmp' 'jpeg' 'image/jpeg' 'woff' 'application/font-woff'

        GetFromTable←{(⍵[;1]⍳⊂,⍺)⊃⍵[;2],⊂''}
        split←{p←(⍺⍷⍵)⍳1 ⋄ ((p-1)↑⍵)(p↓⍵)} ⍝ Split ⍵ on first occurrence of ⍺
        lc←0∘(819⌶)
        deb←{{1↓¯1↓⍵/⍨~'  '⍷⍵}' ',⍵,' '}

        ∇ {r}←{message}Fail status
        ⍝ Set HTTP response status code and message if status≠0
          :Access public
          :If r←0≠1↑status
              :If 0=⎕NC'message'
                  :If 500=status
                      message←ErrorInfo
                  :Else
                      message←'' ⋄ :EndIf
              :EndIf
              message SetStatus status
              Response.Payload←'<h2 style="color:red">',message,'</h2>'
              'content-type'SetHeader'text/html'
          :EndIf
        ∇

        ∇ make
        ⍝ barebones constructor for interactive debugging (use HttpServer.MakeRequest '')
          :Access public
          :Implements constructor
          Response←⎕NS''
          Response.(Status StatusText Payload)←200 'OK' ''
          Response.Headers←0 2⍴'' ''
        ∇

        ∇ make1 args;query;origin;length;param;value;type
        ⍝ args is the result of Conga HTTPHeader event
          :Access public
          :Implements constructor
         
          (Method URL HTTPVersion Headers)←args
          Headers[;1]←lc Headers[;1]  ⍝ header names are case insensitive
          Method←lc Method
         
          (ContentType param)←deb¨2↑(';'(≠⊆⊢)GetHeader'content-type'),⊂''
          ContentType←lc ContentType
          (type value)←2↑⊆deb¨'='(≠⊆⊢)param
          :Select lc type
          :Case '' ⍝ no parameter set
              Charset←(ContentType≡'application/json')/'utf-8'
          :Case 'charset'
              Charset←lc value
          :Case 'boundary'
              Boundary←value
          :EndSelect
         
          Response←⎕NS''
          Response.(Status StatusText Payload)←200 'OK' ''
          Response.Headers←0 2⍴'' ''
         
          (Endpoint query)←'?'split URL
         
          :Trap 11 ⍝ trap domain error on possible bad UTF-8 sequence
              Endpoint←URLDecode Endpoint
              QueryParams←URLDecode¨2↑[2]↑'='(≠⊆⊢)¨'&'(≠⊆⊢)query
              :If 'basic '≡lc 6↑auth←GetHeader'authorization'
                  (UserID Password)←':'split Base64Decode 6↓auth
              :EndIf
          :Else
              Complete←1 ⍝ mark as complete
              Fail 400   ⍝ 400 = bad request
              →0
          :EndTrap
         
          Complete←('get'≡Method)∨(length←GetHeader'content-length')≡,'0' ⍝ we're a GET or 0 content-length
          Complete∨←(0∊⍴length)>∨/'chunked'⍷GetHeader'transfer-encoding' ⍝ or no length supplied and we're not chunked
        ∇

        ∇ ProcessBody args
          :Access public
          Body←args
          Complete←1
        ∇

        ∇ ProcessChunk args
          :Access public
        ⍝ args is [1] chunk content [2] chunk-extension name/value pairs (which we don't expect and won't process)
          Body,←1⊃args
        ∇

        ∇ ProcessTrailer args;inds;mask
          :Access public
          args[;1]←lc args[;1]
          mask←(≢Headers)≥inds←Headers[;1]⍳args[;1]
          Headers[mask/inds;2]←mask/args[;2]
          Headers⍪←(~mask)⌿args
          Complete←1
        ∇

        ∇ r←Hostname;h
          :Access public
          :If ~0∊⍴h←GetHeader'host'
              r←'http',(~Server.Secure)↓'s://',h
          :Else
              r←Server.Hostname
          :EndIf
        ∇

        ∇ r←URLDecode r;rgx;rgxu;i;j;z;t;m;⎕IO;lens;fill
          :Access public shared
        ⍝ Decode a Percent Encoded string https://en.wikipedia.org/wiki/Percent-encoding
          ⎕IO←0
          ((r='+')/r)←' '
          rgx←'[0-9a-fA-F]'
          rgxu←'%[uU]',(4×⍴rgx)⍴rgx ⍝ 4 characters
          r←(rgxu ⎕R{{⎕UCS 16⊥⍉16|'0123456789ABCDEF0123456789abcdef'⍳⍵}2↓⍵.Match})r
          :If 0≠⍴i←(r='%')/⍳⍴r
          :AndIf 0≠⍴i←(i≤¯2+⍴r)/i
              z←r[j←i∘.+1 2]
              t←'UTF-8'⎕UCS 16⊥⍉16|'0123456789ABCDEF0123456789abcdef'⍳z
              lens←⊃∘⍴¨'UTF-8'∘⎕UCS¨t  ⍝ UTF-8 is variable length encoding
              fill←i[¯1↓+\0,lens]
              r[fill]←t
              m←(⍴r)⍴1 ⋄ m[(,j),i~fill]←0
              r←m/r
          :EndIf
        ∇

          base64←{⎕IO ⎕ML←0 1              ⍝ from dfns workspace - Base64 encoding and decoding as used in MIME.
              chars←'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
              bits←{,⍉(⍺⍴2)⊤⍵}             ⍝ encode each element of ⍵ in ⍺ bits, and catenate them all together
              part←{((⍴⍵)⍴⍺↑1)⊂⍵}          ⍝ partition ⍵ into chunks of length ⍺
              0=2|⎕DR ⍵:2∘⊥∘(8∘↑)¨8 part{(-8|⍴⍵)↓⍵}6 bits{(⍵≠64)/⍵}chars⍳⍵  ⍝ decode a string into octets
              four←{                       ⍝ use 4 characters to encode either
                  8=⍴⍵:'=='∇ ⍵,0 0 0 0     ⍝   1,
                  16=⍴⍵:'='∇ ⍵,0 0         ⍝   2
                  chars[2∘⊥¨6 part ⍵],⍺    ⍝   or 3 octets of input
              }
              cats←⊃∘(,/)∘((⊂'')∘,)        ⍝ catenate zero or more strings
              cats''∘four¨24 part 8 bits ⍵
          }

        ∇ r←{cpo}Base64Encode w
        ⍝ Base64 Encode
        ⍝ Optional cpo (code points only) suppresses UTF-8 translation
        ⍝ if w is numeric (single byte integer), skip any conversion
          :Access public shared
          :If 83=⎕DR w ⋄ r←base64 w
          :ElseIf 0=⎕NC'cpo' ⋄ r←base64'UTF-8'⎕UCS w
          :Else ⋄ r←base64 ⎕UCS w
          :EndIf
        ∇

        ∇ r←{cpo}Base64Decode w
        ⍝ Base64 Decode
        ⍝ Optional cpo (code points only) suppresses UTF-8 translation
          :Access public shared
          :If 0=⎕NC'cpo' ⋄ r←'UTF-8'⎕UCS base64 w
          :Else ⋄ r←⎕UCS base64 w
          :EndIf
        ∇

        ∇ r←GetHeader name
          :Access Public Instance
          r←(lc name)GetFromTable Headers
        ∇

        ∇ r←{type}GetQueryParam name
          :Access Public Instance
        ⍝ type - 0 for numeric result (if possible)
          :If 900⌶⍬ ⋄ type←'' ⋄ :EndIf
          r←(lc name)GetFromTable QueryParams
          :If 2|⎕DR type ⋄ r←{∧/⊃t←⎕VFI ⍵:2⊃t ⋄ ⍵}r ⋄ :EndIf
        ∇

        ∇ name DefaultHeader value
          :Access public instance
          :If 0∊⍴Response.Headers GetHeader name
              name SetHeader value
          :EndIf
        ∇

        ∇ r←ErrorInfo
          r←⍕ErrorInfoLevel↑⎕DMX.(EM({⍵↑⍨⍵⍳']'}2⊃DM))
        ∇

        ∇ name SetHeader value
          :Access Public Instance
          Response.Headers⍪←name value
        ∇

        ∇ {statusText}SetStatus status
          :Access public instance
          :If status≠0
              :If 0=⎕NC'statusText'
              :OrIf 0∊⍴statusText
                  statusText←(HttpStatus[;1]⍳status)⊃HttpStatus[;2],⊂''
              :EndIf
              Response.(Status StatusText)←status statusText
          :EndIf
        ∇

        ∇ r←ContentTypeForFile filename;ext
          :Access public instance
          ext←⊂1↓3⊃⎕NPARTS filename
          r←(ContentTypes[;1]⍳ext)⊃ContentTypes[;2],⊂'text/html'
          r,←('text/html'≡r)/'; charset=utf-8'
        ∇

        ∇ {contentType}Respond payload
          :Access public instance
          :If 0≠⎕NC'contentType'
              'content-type'SetHeader contentType
          :EndIf
          Response.Payload←payload
        ∇

    :EndClass

    :Section Utilities

    If←((0∘≠⊃)⊢)⍴⊣
    stripQuotes←{'""'≡2↑¯1⌽⍵:¯1↓1↓⍵ ⋄ ⍵} ⍝ strip leading and ending "
    deb←{{1↓¯1↓⍵/⍨~'  '⍷⍵}' ',⍵,' '} ⍝ delete extraneous blanks
    dlb←{⍵↓⍨+/∧\' '=⍵} ⍝ delete leading blanks
    lc←0∘(819⌶) ⍝ lower case
    nameClass←{⎕NC⊂,'⍵'} ⍝ name class of argument
    nocase←{(lc ⍺)⍺⍺ lc ⍵} ⍝ case insensitive operator
    begins←{⍺≡(⍴⍺)↑⍵} ⍝ does ⍺ begin with ⍵?
    ends←{⍺≡(-≢⍺)↑⍵} ⍝ does ⍺ end with ⍵?
    match←{⍺ (≡nocase) ⍵} ⍝ case insensitive ≡
    sins←{0∊⍴⍺:⍵ ⋄ ⍺} ⍝ set if not set
    isChar←{0 2∊⍨10|⎕DR ⍵}
    stopIf←{1∊⍵:-⎕TRAP←0 'C' '⎕←''Stopped for debugging... (Press Ctrl-Enter)''' ⋄ shy←0} ⍝ faster alternative to setting ⎕STOP

    ∇ r←DyalogRoot
      r←{⍵,('/\'∊⍨⊢/⍵)↓'/'}{0∊⍴t←2 ⎕NQ'.' 'GetEnvironment' 'DYALOG':⊃1 ⎕NPARTS⊃2 ⎕NQ'.' 'GetCommandLineArgs' ⋄ t}''
    ∇

    ∇ r←crlf
      r←⎕UCS 13 10
    ∇

    ∇ r←Now
      :Access public shared
      r←DateToIDNX ⎕TS
    ∇

    ∇ r←fmtTS ts
      :Access public shared
      r←,'G⊂9999/99/99 @ 99:99:99⊃'⎕FMT 100⊥6↑ts
    ∇

    ∇ r←a splitOn w
    ⍝ split a where w occurs (removing w from the result)
      :Access public shared
      r←a{⍺{(¯1+⊃¨⊆⍨⍵)↓¨⍵⊆⍺}(1+≢⍵)*⍵⍷⍺}w
    ∇

    ∇ r←a splitOnFirst w
    ⍝ split a on first occurence of w (removing w from the result)
      :Access public shared
      r←a{⍺{(¯1+⊃¨⊆⍨⍵)↓¨⍵⊆⍺}(1+≢⍵)*<\⍵⍷⍺}w
    ∇

    ∇ r←type ipRanges string;ranges
      :Access public shared
      r←''
      :Select ≢ranges←{('.'∊¨⍵){⊂1↓∊',',¨⍵}⌸⍵}string splitOn','
      :Case 0
          →0
      :Case 1
          r←,⊂((1+'.'∊⊃ranges)⊃'IPV6' 'IPV4')(⊃ranges)
      :Case 2
          r←↓'IPV4' 'IPV6',⍪ranges
      :EndSelect
      r←⊂(('Accept' 'Deny'⍳⊂type)⊃'AllowEndPoints' 'DenyEndPoints')r
    ∇

    ∇ r←leaven w
    ⍝ "leaven" JSON vectors of vectors (of vectors...) into higher rank arrays
      :Access public shared
      r←{
          0 1∊⍨≡⍵:⍵
          1=≢∪≢¨⍵:↑∇¨⍵
          ⍵
      }w
    ∇

    ∇ r←isRelPath w
    ⍝ is path w a relative path?
      r←{{~'/\'∊⍨(⎕IO+2×('Win'≡3↑⊃#.⎕WG'APLVersion')∧':'∊⍵)⊃⍵}3↑⍵}w
    ∇

    ∇ r←isDir path
    ⍝ is path a directory?
      r←{22::0 ⋄ 1=1 ⎕NINFO ⍵}path
    ∇

    ∇ r←SourceFile;class
      :Access public shared
      :If 0∊⍴r←4⊃5179⌶class←⊃∊⎕CLASS ⎕THIS
          r←{6::'' ⋄ ∊1 ⎕NPARTS ⍵⍎'SALT_Data.SourceFile'}class
      :EndIf
    ∇

    ∇ r←makeRegEx w
    ⍝ convert a simple search using ? and * to regex
      :Access public shared
      r←{0∊⍴⍵:⍵
          {'^',(⍵~'^$'),'$'}{¯1=⎕NC('A'@(∊∘'?*'))r←⍵:('/'=⊣/⍵)↓(¯1×'/'=⊢/⍵)↓⍵   ⍝ already regex? (remove leading/trailing '/'
              r←∊(⊂'\.')@('.'=⊢)r  ⍝ escape any periods
              r←'.'@('?'=⊢)r       ⍝ ? → .
              ∊(⊂'.*')@('*'=⊢)r    ⍝ * → .*
          }⍵            ⍝ add start and end of string markers
      }w
    ∇

    ∇ (rc msg)←{root}LoadFromFolder path;type;name;nsName;parts;ns;files;folders;file;folder;ref;r;m;findFiles;pattern
      :Access public
    ⍝ Loads an APL "project" folder
      (rc msg)←0 ''
      root←{6::⍵ ⋄ root}#
      findFiles←{
          (names type hidden)←0 1 6(⎕NINFO⍠1)∊1 ⎕NPARTS path,'/',⍵
          names/⍨(~hidden)∧type=2
      }
      files←''
      :For pattern :In ','(≠⊆⊢)LoadableFiles
          files,←findFiles pattern
      :EndFor
      folders←{
          (names type hidden)←0 1 6(⎕NINFO⍠1)∊1 ⎕NPARTS path,'/*'
          names/⍨(~hidden)∧type=1
      }⍬
      :For file :In files
          :Trap 11
              2 root.⎕FIX'file://',file
          :Else
              msg,←'Unable to ⎕FIX ',file,⎕UCS 13
          :EndTrap
      :EndFor
      :For folder :In folders
          nsName←2⊃1 ⎕NPARTS folder
          ref←0
          :Select root.⎕NC⊂nsName
          :Case 9.1 ⍝ namespace
              ref←root⍎nsName
          :Case 0   ⍝ not defined
              ref←⍎nsName root.⎕NS''
          :Else     ⍝ oops
              msg,←'"',folder,'" cannot be mapped to a valid namespace name',⎕UCS 13
          :EndSelect
          :If ref≢0
              (r m)←ref LoadFromFolder folder
              r←rc⌈r
              msg,←m
          :EndIf
      :EndFor
      msg←¯1↓msg
      rc←4××≢msg
    ∇
    :EndSection

:EndClass
