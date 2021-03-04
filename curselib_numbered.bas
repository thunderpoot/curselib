0 REM Curselib
1 REM Init
2 REM Package Version & Information
3 local_n$ = "curselib"
4 local_v$ = "1.1.0"
5 local_a$ = "underwood@telehack.com"
6 local_c$ = "2020 - " + str$( th_localtime(5) + 1900 )
7 REM Core
8 esc$ = chr$(27) : crlf$ = chr$(13) + chr$(10) : inverse$ = esc$ + "[7m" : regular$ = esc$ + "[27m"
9 prog$ = left$( argv$(0), instr( argv$(0), ".bas" ) )
10 nheight = height
11 REM Arguments
12 for i = 1 to argc% :
13 if left$( argv$(i), 2 ) = "--" then : argv$(i) = mid$( argv$(i), 3 )
14 if left$( argv$(i), 1 ) = "/" or left$( argv$(i), 1 ) = "-" then : argv$(i) = mid$( argv$(i), 2 )
15 if ups$( argv$(i) ) = "VERSION" or aups$( rgv$(i) ) = "VER" or ups$( argv$(i) ) = "V" then : goto undefined
16 if ups$( argv$(i) ) = "HELP" or ups$( argv$(i) ) = "H" or argv$(i) = "?" then : usage = 1 : goto undefined
17 if ups$( argv$(i) ) = "NOTITLE" or ups$( argv$(i) ) = "NOTITLEBAR" or ups$( argv$(i) ) = "NOHEADER" then : titlebardisabled = 1
18 if ups$( argv$(i) ) = "CLS" or ups$( argv$(i) ) = "CLEAR" then : cl = 1
19 if ups$( argv$(i) ) = "YN" or ups$( argv$(i) ) = "YESNO" or ups$( argv$(i) ) = "YORN" then : yesno = 1
20 if ups$( left$( argv$(i), 9 ) ) = "PROGRESS=" and len( argv$(i) ) > 9 then : progress = abs( mid$( argv$(i), 10 ) )
21 if ups$( left$( argv$(i), 6 ) ) = "WIDTH=" and len( argv$(i) ) > 6 then : boxwidth = abs( mid$( argv$(i), 7 ) )
22 if ups$( left$( argv$(i), 6 ) ) = "TITLE=" and len( argv$(i) ) > 6 then : title$ = mid$(argv$(i), 7 )
23 if ups$( left$( argv$(i), 4 ) ) = "MSG=" and len( argv$(i) ) > 4 then : msg$ = mid$( argv$(i), 5 )
24 if ups$( left$( argv$(i), 4 ) ) = "BTN=" and len( argv$(i) ) > 4 then : btn$ = mid$( argv$(i), 5 )
25 if ups$( left$( argv$(i), 5 ) ) = "FUNC=" and len( argv$(i) ) > 5 then : func$ = mid$( argv$(i), 6 )
26 next i
27 REM Defaults
28 minboxwidth                                       = 65                       : REM Minimum Box Width
29 boxheight                                         = 7                        : REM Default Box Height
30 if boxwidth < minboxwidth then : boxwidth         = minboxwidth              : REM Enforce Minimum Box Width
31 if boxwidth > width - 5 then : boxwidth           = width - 5                : REM Enforce Maximum Box Width
32 if title$ = "" and progress <> 0 then : title$    = "Progress"               : REM Default Progress Bar Title
33 if title$ = "" then : title$                      = "Info"                   : REM Default Box Title
34 if msg$ = "" then : msg$                          = "Continue?"              : REM Default Box Message
35 if btn$ = "" then : btn$                          = "OK"                     : REM Default Button Text
36 if progress < 0 then : progress = 0                                          : REM Enforce Minimum Progress
37 if progress > 100 then : progress = 100                                      : REM Enforce Maximum Progress
38 REM Box Elements
39 tl$ = chr$(9484) : tr$ = chr$(9488) : bl$ = chr$(9492) : br$ = chr$(9496) : horiz$ = chr$(9472) : vert$ = chr$(9474)
40 REM Hide Cursor (REQUIRE CORE)
41 ? esc$ "[?25l" ;
42 REM Variables (REQUIRE DEFAULTS)
43 ynyes$ = "<  Yes  >" + spc$( int( boxwidth / 8 ) ) + inverse$ + "<  No  >" + regular$
44 ynno$ = inverse$ + "<  Yes  >" + regular$ + spc$( int( boxwidth / 8 ) ) + "<  No  >"
45 bcen$ = esc$ + "[" + str$( width ) + "D" + esc$ + "[" + str$( int( width / 2 ) - int( boxwidth / 2 ) - 1 ) + "C"
46 toplinesc$ = esc$ + "[H" + esc$ + "[B" + " " + string$( width - 2, horiz$ ) + " "
47 boxtop$ = bcen$ + tl$ + string$( boxwidth - 1, horiz$ ) + tr$ + reset$
48 boxmid$ = bcen$ + vert$ + spc$( boxwidth - 1 ) + vert$ + inverse$ + " " + regular$
49 boxbottom$ = bcen$ + bl$ + string$( boxwidth - 1, horiz$ ) + br$ + inverse$ + " " + regular$
50 boxshadow$ = bcen$ + mclr$ + " " + inverse$ + spc$( boxwidth + 1 ) + regular$
51 btl$ = esc$ + "[H" + esc$ + "[" + str$( int( height / 2 ) - int( boxheight / 2 ) ) + "B"
52 if titlebardisabled then : btl$ = esc$ + "[H" + esc$ + "[" + str$( int( height / 2 - 2 ) - int( boxheight / 2 ) ) + "B" : nheight = height - 4
53 REM Functions (REQUIRE VARIABLES)
54 def fnhcen$( s$ ) = esc$ + "[" + str$(width) + "D" + esc$ + "[" + str$( int( width / 2 ) - int( len( s$ ) / 2 ) ) + "C" + s$
55 def fntitlesc$( s$ ) = esc$ + "[" + str$((int(width/2)-1)-int((len(s$)-2)/2)-1) + "C" + " " + s$ + " "
56 def fnboxtitlesc$( s$ ) = boxcolour$ + fncentresc$(" " + s$ + " ")
57 def fntitlebar$( l$, r$ ) = esc$ + "[2J " + l$ + esc$ + "[" + str$( width - ( len(l$) + len(r$) ) - 2 ) + "C" + r$ + toplinesc$
58 def fncontent$( s$, e ) = esc$ + "[H" + esc$ + "[" + str$( int( nheight / 2 ) - 1 + e ) + "B" + fnhcen$( s$ )
59 def fnprogress$(p) = bcen$ + esc$ + "[2C" + " " + string$(int(p)/100*(boxwidth-5),"#")
60 def fncurses$( t$, m$ ) = btl$ + boxtop$ + chr$(10) + string$( boxheight + h, boxmid$ + crlf$ ) + boxbottom$ + chr$(10) + boxshadow$ + crlf$ + btl$ + fntitlesc$( t$ ) + fncontent$( m$, 1 )
61 REM Start Runtime (REQUIRE FUNCTIONS)
62 cls
63 if not titlebardisabled then : ? fntitlebar$( prog$ + " " + local_v$, th_localtime$ )
64 if yesno then : goto 75
65 if progress then : goto 69
66  REM Simple Box
67 ? fncurses$( title$, msg$ ) inverse$ fncontent$( "< " + btn$ + " >", 3 ) regular$ : c$ = inkey$ : if c$ <> chr$(13) goto 66
68 goto undefined
69 REM Progress Bar
70 boxheight = 6
71 ? fncurses$( title$, "" ) ;
72 ? fnprogress$( progress );
73 ? crlf$ crlf$ fnhcen$( str$( progress ) + " %" )
74 goto undefined
75 REM Yes / No Prompt: Init
76 ? fncurses$( title$, msg$ )
77 ? crlf$ fnhcen$( spc$( int( boxwidth / 8 ) + 17 ) ) esc$ "[" str$( int( boxwidth / 8 ) + 17 ) "D" ynyes$ ;
78 REM Yes / No Prompt: Get User Input
79 key$ = inkey$
80 if asc(key$) = 89 then : ? ynyes$ + esc$ + "[H" ; : ekey$ = "d" : goto <YNBR>         : REM Capital-letter-Y    (Select option and continue)
81 if asc(key$) = 78 then : ? ynno$ + esc$ + "[H" ; : ekey$ = "c" : goto <YNBR>          : REM Capital-letter-N    (Select option and cancel)
82 if asc(key$) = 121 then : ekey$ = "d" : goto <YNBC>                                   : REM Lowercase-letter-y  (Select option, don't continue)
83 if asc(key$) = 110 then : ekey$ = "c" : goto <YNBC>                                   : REM Lowercase-letter-n  (Select option, don't cancel)
84 if asc(key$) = 13 then : goto <YNBR>                                                  : REM Return              (User pressed return, continue)
85 if key$ = esc$ then : key$ = inkey$ : if key$ = "[" then : goto <YNAK>                : REM Arrow Key
86 goto <YNUI>                                                                           : REM Incorrect key       (Go back to prompt, don't redraw)
87 50 <YNAK> REM Yes / No Prompt: Arrow Key Direction (A=up, B=down, C=right, D=left)
88 ekey$ = inkey$
89 60 <YNBC> REM Yes / No Prompt: Draw Button Choices
90 if ekey$ = "c" then ? fncurses$( title$, msg$ ) : ? crlf$ fnhcen$( spc$( int( boxwidth / 8 ) + 17 ) ) esc$ "[" str$( int( boxwidth / 8 ) + 17 ) "D" ynyes$ ;
91 if ekey$ = "d" then ? fncurses$( title$, msg$ ) : ? crlf$ fnhcen$( spc$( int( boxwidth / 8 ) + 17 ) ) esc$ "[" str$( int( boxwidth / 8 ) + 17 ) "D" ynno$ ;
92 goto 78
93  REM Yes / No Prompt: Button Returned
94 if ekey$ = "c" then exitcode = 1 : goto <EXIT> : REM No
95 if ekey$ = "d" then exitcode = 0 : goto <EXIT> : REM Yes
96 100 <EXIT> REM Cleanup and Exit
97 locate height,1
98 ? esc$ "[?25h" esc$ + "[K" ; : REM Show Cursor and Clear from Cursor right
99 if cl then cls
100 if exitcode = 0 then : th_exec func$
101 end
102 200 <PACK> REM Package info
103 ? local_n$ " (" argv$(0) ") v " local_v$
104 if usage then : gosub 300
105 goto undefined
106 300 <INFO> REM Usage info
107 ? "Usage: " argv$(0) " <args>"
108 ? " --version        Show version info and quit"
109 ? " --help           Show this help"
110 ? " --notitle        Disable the title bar"
111 ? " --yn             Yes/No prompt"
112 ? " --cls            Clear screen on program exit"
113 ? " --progress=<N>   Show progress bar (N must be between 0 and 100)"
114 ? " --width=<N>      Box width"
115 ? " --title=<text>   Box title"
116 ? " --msg=<text>     Box message"
117 ? " --btn=<text>     Info-Box button"
118 ? " --func=<cmd>     Command to execute on prompt confirmation"
119 ? crlf$ "Example:" crlf$ "@" argv$(0) " --yn --msg='Hello, World!' --btn=Howdy --func='echo foo bar'"
120 return
