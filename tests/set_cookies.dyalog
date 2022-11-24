:NameSpace set_cookies
    ⎕IO←1
⍝ https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie

    c ← ⎕a,⎕d,⎕c⎕a
    r ← {⍵[8↑?⍨≢⍵]}

    :NameSpace Date

        months ← 'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'
        days   ← 'Tue' 'Wed' 'Thu' 'Fri' 'Sat' 'Sun' 'Mon'

        f ← ¯2↑'0',⍕
        join ← {⊃,/1↓,⍺,⍪⍵}
        fromUnix ← 20 ¯1∘⎕DT
        toUnix   ← 20⎕DT⊆

          New←{
              date←year month day hour minute second millisecond←¯1(⊃⎕DT)'Z'
              year month day hour minute second millisecond←⊃fromUnix ⍵+toUnix date
              month⊃←months
              ' 'join(((7+¯7|day)⊃days),',')(f day)month(⍕year)(':'join f¨hour minute second)'GMT'
          }

    :EndNameSpace

      path←{
          ⍵.Response.Payload←⎕A
          'Set-Cookie'⍵.SetHeader'user=name; Path=/set_cookies/path'
      }

      max_age←{
          ⍵.Response.Payload←⎕A
     
          'Set-Cookie'⍵.SetHeader('key',r c),'=',(r c),'; Max-Age=5; ','; Expires=',Date.New 7
      }

      expires←{
          ⍵.Response.Payload←⎕A
          'Set-Cookie'⍵.SetHeader('key',r c),'=',(r c),'; Expires=',Date.New 3
      }

      ping←{
          ⍵.Response.Payload←⎕A
      }

:EndNameSpace