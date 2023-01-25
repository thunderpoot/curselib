' Curselib

' WARNING: this software is very old and probably contains all kinds of glaring errors, but
'          I will not be releasing further updates, so if you notice a problem, you can fix
'          it yourself!  As of version 1.3.5, this project is ABANDONWARE.

' Init

    ' Package Version & Information
        local_n$ = "curselib"
        local_v$ = "1.3.5"
        local_a$ = "underwood"
        local_c$ = "2020 - " + str$( th_localtime(5) + 1900 )

    ' Core
        esc$ = chr$(27) : crlf$ = chr$(13) + chr$(10) : inverse$ = esc$ + "[7m" : regular$ = esc$ + "[27m"
        prog$ = left$( argv$(0), instr( argv$(0), ".bas" ) )
        nheight = height

    ' Arguments
        for i = 1 to argc% :
            if left$( argv$(i), 2 ) = "--" then : argv$(i) = mid$( argv$(i), 3 )
            if left$( argv$(i), 1 ) = "/" or left$( argv$(i), 1 ) = "-" then : argv$(i) = mid$( argv$(i), 2 )
            if ups$( argv$(i) ) = "VERSION" or aups$( rgv$(i) ) = "VER" or ups$( argv$(i) ) = "V" then : goto 200
            if ups$( argv$(i) ) = "HELP" or ups$( argv$(i) ) = "H" or argv$(i) = "?" then : usage = 1 : goto 200
            if ups$( argv$(i) ) = "NOTITLE" or ups$( argv$(i) ) = "NOHEADER" then : titlebardisabled = 1
            if ups$( argv$(i) ) = "CLS" or ups$( argv$(i) ) = "CLEAR" then : cl = 1
            if ups$( argv$(i) ) = "INPUT" or ups$( argv$(i) ) = "INPUTBOX" then : getUserText = 1 : out = 1
            if ups$( argv$(i) ) = "PASS" or ups$( argv$(i) ) = "PASSWORD" or ups$( argv$(i) ) = "PASSWD" then : getUserText = 1 : passwd = 1 : cl = 1
            if ups$( argv$(i) ) = "FORCE" then : force = 1
            if ups$( argv$(i) ) = "DEBUG" then : debug = 1
            if ups$( argv$(i) ) = "NOGFX" then : nogfx = 1
            if ups$( argv$(i) ) = "TRON" then : tron
            if ups$( argv$(i) ) = "YN" or ups$( argv$(i) ) = "YESNO" or ups$( argv$(i) ) = "YORN" then : yesno = 1
            if ups$( left$( argv$(i), 9 ) ) = "PROGRESS=" and len( argv$(i) ) > 9 then : progress = abs( mid$( argv$(i), 10 ) )
            if ups$( left$( argv$(i), 5 ) ) = "LIST=" and len( argv$(i) ) > 5 then : choicesText$ = mid$( argv$(i), 6 ) : isList = 1 : titlebardisabled = 1
            if ups$( left$( argv$(i), 6 ) ) = "WIDTH=" and len( argv$(i) ) > 6 then : boxwidth = abs( mid$( argv$(i), 7 ) )
            if ups$( left$( argv$(i), 6 ) ) = "PNAME=" and len( argv$(i) ) > 6 then : pname$ = mid$(argv$(i), 7 )
            if ups$( left$( argv$(i), 6 ) ) = "TITLE=" and len( argv$(i) ) > 6 then : title$ = mid$(argv$(i), 7 )
            if ups$( left$( argv$(i), 4 ) ) = "MSG=" and len( argv$(i) ) > 4 then : msg$ = mid$( argv$(i), 5 )
            if ups$( left$( argv$(i), 4 ) ) = "BTN=" and len( argv$(i) ) > 4 then : btn$ = mid$( argv$(i), 5 )
            if ups$( left$( argv$(i), 5 ) ) = "FUNC=" and len( argv$(i) ) > 5 then : func$ = mid$( argv$(i), 6 ) : func = 1
            if ups$( left$( argv$(i), 6 ) ) = "DELIM=" and len( argv$(i) ) > 6 then : delim$ = mid$( argv$(i), 7 ) : fg = 1
            if ups$( left$( argv$(i), 6 ) ) = "COLOR=" and len( argv$(i) ) > 6 then : myfg$ = mid$( argv$(i), 7 ) : fg = 1
            if ups$( left$( argv$(i), 7 ) ) = "COLOUR=" and len( argv$(i) ) > 7 then : myfg$ = mid$( argv$(i), 8 ) : fg = 1
            if ups$( left$( argv$(i), 4 ) ) = "OUT=" and len( argv$(i) ) > 4 then : outFile$ = mid$( argv$(i), 5 ) : out = 1
        next i

    ' Defaults
        if outFile$ = "" then outFile$                           = "result.tmp"          : ' Default Output Filename
        minboxwidth                                              = 65                    : ' Minimum Box Width
        boxheight                                                = 7                     : ' Default Box Height
        if boxwidth < minboxwidth then : boxwidth                = minboxwidth           : ' Enforce Minimum Box Width
        if boxwidth > width - 5 then : boxwidth                  = width - 5             : ' Enforce Maximum Box Width
        if title$ = "" and progress then : title$                = " Progress "          : ' Default Progress Bar Title
        if passwd then : title$                                  = " Password "          : ' Default Password Input Box Title
        if title$ = "" and isList then : title$                  = " Choose from List "  : ' Default Text Input Box Title
        if title$ = "" and getUserText then : title$             = " Input "             : ' Default Text Input Box Title
        if title$ = "" then : title$                             = " Info "              : ' Default Box Title
        if msg$ = "" then : msg$                                 = " Continue? "         : ' Default Box Message
        if btn$ = "" then : btn$                                 = "OK"                  : ' Default Button Text
        if delim$ = "" then : delim$                             = ","                   : ' Default List Delimiter
        if progress < 0 then : progress                          = 0                     : ' Enforce Minimum Progress
        if progress > 100 then : progress                        = 100                   : ' Enforce Maximum Progress
        textFieldFormatting$                                     = ""                    : ' Text Field Formatting ( e.g: esc$ + "[7m" )
        if left$( title$, 1 ) <> " " or right$( title$, 1 ) <> " " then title$ = " " + title$ + " "

    ' Safety Checks

        ' Filename length check
        if len( outFile$ ) > 15 then : ? "%invalid filename" : goto 115

        ' Check for illegal chars in filename
        if out then :    for n = 0 to len( outFile$ ) :
        if out then :        c = asc( mid$( outFile$, n, 1 ) )
        if out then :        if ( c < 65 and chr$(c) <> "." and c <> 52 ) or ( c > 90 and c < 97 ) or c > 122 then : ? "%invalid filename char: " chr$(c) : goto 115
        if out then :    next

        ' Clobber check
        if not force and instr( dir$, " " + outFile$ + " " ) > -1 and instr( outFile$, ".tmp" ) = -1 then : ? "%file " ups$( outFile$ ) " already exists, cannot overwrite" : goto 115

    ' Box Elements
        tl$ = chr$(9484) : tr$ = chr$(9488) : bl$ = chr$(9492) : br$ = chr$(9496) : horiz$ = chr$(9472) : vert$ = chr$(9474)
        if nogfx then : tl$ = "," : tr$ = "." : bl$ = "`" : br$ = "'" : horiz$ = "_" : vert$ = "|"

    ' Hide Cursor (REQUIRE CORE)
        ? esc$ "[?25l" ;

    ' Variables (REQUIRE DEFAULTS)
        ynyes$ = "<  Yes  >" + spc$( int( boxwidth / 8 ) ) + inverse$ + "<  No  >" + regular$
        ynno$ = inverse$ + "<  Yes  >" + regular$ + spc$( int( boxwidth / 8 ) ) + "<  No  >"
        bcen$ = esc$ + "[" + str$( width ) + "D" + esc$ + "[" + str$( int( width / 2 ) - int( boxwidth / 2 ) - 1 ) + "C"
        toplinesc$ = esc$ + "[H" + esc$ + "[B" + " " + string$( width - 2, horiz$ ) + " "
        boxtop$ = bcen$ + tl$ + string$( boxwidth - 1, horiz$ ) + tr$ + reset$
        boxmid$ = bcen$ + vert$ + spc$( boxwidth - 1 ) + vert$ + inverse$ + " " + regular$
        boxbottom$ = bcen$ + bl$ + string$( boxwidth - 1, horiz$ ) + br$ + inverse$ + " " + regular$
        boxshadow$ = bcen$ + mclr$ + " " + inverse$ + spc$( boxwidth + 1 ) + regular$
        btl$ = esc$ + "[H" + esc$ + "[" + str$( int( height / 2 ) - int( boxheight / 2 ) ) + "B"
        if titlebardisabled then : btl$ = esc$ + "[H" + esc$ + "[" + str$( int( height / 2 - 2 ) - int( boxheight / 2 ) ) + "B" : nheight = height - 4
        fieldborder$ = btl$ + crlf$ + crlf$ + bcen$ + esc$ + "[2C" + tl$ + string$( boxwidth - 5, horiz$ ) + tr$ + crlf$ + bcen$ + esc$ + "[2C" + vert$ + esc$ + "[" + str$( boxwidth - 5 ) + "C" + vert$ + crlf$ + bcen$ + esc$ + "[2C" + bl$ + string$( boxwidth - 5, horiz$ ) + br$

    ' Functions (REQUIRE VARIABLES)
        def fnchomp$(s$) = left$(s$,len(s$)-2)
        def fnreplace$(s$,f$,r$) = left$(s$,instr(s$,f$)) + r$ + mid$(s$,instr(s$,f$)+len(f$)+1)
        def fnhcen$( s$ ) = esc$ + "[" + str$(width) + "D" + esc$ + "[" + str$( int( width / 2 ) - int( len(s$) / 2 ) ) + "C" + s$
        def fntitlesc$( s$ ) = esc$ + "[" + str$( ( int( width / 2 ) - 1 ) - int( ( len( s$ ) - 2 ) / 2 ) - 1 ) + "C" + s$
        def fnboxtitlesc$( s$ ) = boxcolour$ + fncentresc$( s$ )
        def fntitlebar$( l$, r$ ) = esc$ + "[2J " + l$ + esc$ + "[" + str$( width - ( len(l$) + len(r$) ) - 2 ) + "C" + r$ + toplinesc$
        def fncontent$( s$, e ) = esc$ + "[H" + esc$ + "[" + str$( int( nheight / 2 ) - 1 + e ) + "B" + fnhcen$( s$ )
        def fnprogress$(p) = bcen$ + esc$ + "[2C" + " " + string$( int(p) / 100 * ( boxwidth - 5 ), "#" )
        def fncurses$( t$, m$ ) = btl$ + boxtop$ + chr$(10) + string$( boxheight + 1, boxmid$ + crlf$ ) + boxbottom$ + chr$(10) + boxshadow$ + crlf$ + btl$ + fntitlesc$( t$ ) + fncontent$( m$, 1 )

' Runtime (REQUIRE FUNCTIONS)

0   if local_n$ = "" or fncurses$(1,1) = "" then : ? "%could not load curselib, please reinstall " argv$(0) : goto 115 ' Assert
    cls

    if fg then : gosub 400
    if pname$ <> "" then : prog$ = pname$ : local_v$ = ""
    if not titlebardisabled then : ? fntitlebar$( prog$ + " " + local_v$, th_localtime$ )
    if yesno then : yn$ = "no" : goto 30
    if progress then : goto 20
    if getUserText then : goto 80
    if isList then : goto 15

10  ' Simple Box
    ? fncurses$( title$, msg$ ) inverse$ fncontent$( "< " + btn$ + " >", 3 ) regular$ : c$ = inkey$ : if c$ <> chr$(13) goto 10
    goto 100

15  ' Choose from List: Init

    pheight = height
    pwidth = width

    if not initialised then for l = 1 to len( choicesText$ ) :
    if not initialised then     if mid$( choicesText$, l, len( delim$ ) ) = delim$ then : nchoices = nchoices + 1 : if right$( choicesText$, len( delim$ ) ) <> delim$ then : next l
    if not initialised then     myChoices$( nchoices ) = myChoices$( nchoices ) + mid$( choicesText$, l, 1 )
    if not initialised then next l
    initialised = 1

    if nchoices > boxheight - 2 then ? "%too many list elements" : goto 115

    boxheight = 6 + nchoices mod(2)
    if nchoices < boxheight then boxheight = nchoices + 2
    limit$ = str$( boxheight - 18 )
    nup = nchoices - 8

16  ' Choose from List: Print Choices
    ? fncurses$( title$, "" )
    home : ? btl$ crlf$
    for p = offset to boxheight - 2 :
        if instr( myChoices$(p), delim$ ) <> -1 then : myChoices$(p) = fnreplace$( myChoices$(p), delim$, "" )
        if len( myChoices$(p) ) > boxwidth - 14 then : displaychoice$ = left$( myChoices$(p), boxwidth - 14 ) + "..." else if len( myChoices$(p) ) <= boxwidth - 14 then : displaychoice$ = myChoices$(p)
        if displaychoice$ <> "" then : ? bcen$ esc$ "[2C [" ;
        if displaychoice$ <> "" then : if p = currentchoice then : ? "X" ;
        if displaychoice$ <> "" then : if p <> currentchoice then : ? " " ;
        if displaychoice$ <> "" then : ? "]  " ;
        if displaychoice$ <> "" then : ? displaychoice$
    next p

18  ' Choose from List: Get User Input
    key$ = inkey$
    if key$ = chr$(13) then goto 19
    if key$ <> esc$ then goto 18
    key$ = inkey$ : if key$ <> "[" then goto 18
    ekey$ = inkey$

    if ekey$ = "a" then : currentchoice = currentchoice - 1
    if ekey$ = "b" then : currentchoice = currentchoice + 1
    if currentchoice < 0 then currentchoice = 0
    if currentchoice > nchoices then currentchoice = nchoices

    goto 16

19  ' Confirm Choice and Continue
    out = 1 : userText$ = myChoices$( currentchoice )
    goto 100

20  ' Progress Bar
    boxheight = 6
    ? fncurses$( title$, "" ) ;
    ? fnprogress$( progress );
    ? crlf$ crlf$ fnhcen$( str$( progress ) + " %" )
    goto 100

30  ' Yes / No Prompt: Init
    ? fncurses$( title$, msg$ )
    ? crlf$ fnhcen$( spc$( int( boxwidth / 8 ) + 17 ) ) esc$ "[" str$( int( boxwidth / 8 ) + 17 ) "D" ynyes$ ;

40  ' Yes / No Prompt: Get User Input
    key$ = inkey$
    if asc(key$) = 89 then : ? ynyes$ + esc$ + "[H" ; : ekey$ = "d" : goto 70  : ' Capital-letter-Y    (Select option and continue)
    if asc(key$) = 78 then : ? ynno$ + esc$ + "[H" ; : ekey$ = "c" : goto 70   : ' Capital-letter-N    (Select option and cancel)
    if asc(key$) = 121 then : ekey$ = "d" : goto 60                            : ' Lowercase-letter-y  (Select option, don't continue)
    if asc(key$) = 110 then : ekey$ = "c" : goto 60                            : ' Lowercase-letter-n  (Select option, don't cancel)
    if asc(key$) = 13 then : goto 70                                           : ' Return              (User pressed return, continue)
    if key$ = esc$ then : key$ = inkey$ : if key$ = "[" then : goto 50         : ' Arrow Key
    goto 40                                                                    : ' Incorrect key       (Go back to prompt, don't redraw)

50  ' Yes / No Prompt: Arrow Key Direction (A=up, B=down, C=right, D=left)
    ekey$ = inkey$

60  ' Yes / No Prompt: Draw Button Choices
    if ekey$ = "c" then : ? fncurses$( title$, msg$ ) : ? crlf$ fnhcen$( spc$( int( boxwidth / 8 ) + 17 ) ) esc$ "[" str$( int( boxwidth / 8 ) + 17 ) "D" ynyes$ ; : yn$ = "no"
    if ekey$ = "d" then : ? fncurses$( title$, msg$ ) : ? crlf$ fnhcen$( spc$( int( boxwidth / 8 ) + 17 ) ) esc$ "[" str$( int( boxwidth / 8 ) + 17 ) "D" ynno$ ; : yn$ = "yes"
    goto 40

70  ' Yes / No Prompt: Button Returned
    if yn$ = "no" then : exitcode = 1 : goto 100 : ' No
    if yn$ = "yes" then : exitcode = 0 : goto 100 : ' Yes

80  ' Text input prompt: Init
    ? esc$ "[?25h" ;
    boxheight = 6
    ? fncurses$( title$, "" ) inverse$ fncontent$( "< " + btn$ + " >", 3 ) regular$
    ? fieldBorder$

85  ' Text input prompt: Get User Input
    if len( userText$ ) > boxwidth-9 then : displayText$ = right$( userText$, boxwidth - 6 ) : else if len( userText$ ) <= boxwidth - 6 then : displayText$ = userText$
    if len( userText$ ) > boxwidth-9 and passwd then : displayText$ = string$( boxwidth - 6, "*" ) : else if len( userText$ ) <= boxwidth - 6 and passwd then : displayText$ = string$( len( userText$ ), "*" )
    displayText$ = displayText$ + spc$( boxwidth - 5 - len( displayText$ ) )
    ? textFieldFormatting$ btl$ crlf$ crlf$ crlf$ bcen$ esc$ "[3C" displayText$ regular$
    ? btl$ crlf$ crlf$ crlf$ bcen$ esc$ "[" + str$( 3 + len( userText$ ) ) + "C" ; : ' Put cursor at end of string
    if len( userText$ ) > boxwidth - 5 then : ? btl$ crlf$ crlf$ crlf$ bcen$ esc$ "[" + str$( boxwidth - 3 ) + "C" ; : ' Put cursor at right edge of field
    ? esc$ "[?25h" ; : ' Show Cursor
    userKey$ = inkey$
    ? esc$ "[?25l" ; : ' Hide Cursor
    if userKey$ = esc$ then : goto 85
    if userKey$ = chr$(127) then : userText$ = left$( userText$, len( userText$ ) - 1 ) : goto 85
    if userKey$ = chr$(13) then : goto 100
    if asc( userKey$ ) < 32 or asc( userKey$ ) > 127 then : goto 85
    userText$ = userText$ + userKey$
    goto 85

90  ' Debug
    ? "Debug"
    ' debug statements here
    return

100 ' Cleanup
    ? esc$ "[m" ; : ' Reset Character Attributes
    ? esc$ "[?25h" ; : ' Show Cursor
    if usage then goto 115
    locate height,1
    if debug then : gosub 90
    ? esc$ "[?25h" esc$ + "[K" ; : ' Show Cursor and Clear from Cursor right
    if cl then : cls
105 ' Output to file
    if not out then goto 110
    cmd$ = "\rm " + outFile$ : th_exec cmd$ ; devnull$
    if isList or getUserText then : open outFile$, as #1 : print# 1, userText$ : close #1
110 ' Execute
    if not exitcode and func then : th_exec func$
115 ' Exit
    end

200 ' Package info
    pagertmpfile$ = left$( th_md5hex$( rnd(1e6) ), 5 ) + ".tmp" : open pagertmpfile$, as #1
    if asc( argv$(i) ) = 118 then close #1 : ? str$( local_v$ ) : goto 115 : ' Lowercase 'v' argument
    ?# 1, local_n$ + " (" + argv$(0) + ") v " + local_v$
    ?# 1, " "
    ?# 1, "This file was written by UNDERWOOD <" + local_a$ + "> for Telehack (telehack.com)."
    ?# 1, " "
    ?# 1, "The GNU Public Licenses in https://github.com/thunderpoot/curselib/blob/main/LICENSE were taken from ftp.gnu.org and are copyrighted by the Free Software Foundation, Inc."
    ?# 1, " "
    ?# 1, left$( argv$(0), instr( argv$(0), ".bas" ) ) + " copyright (C) " + local_c$ + " Telehack."
    ?# 1, " "
    ?# 1, "This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version."
    ?# 1, "This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details."
    ?# 1, " "
    ?# 1, "[https://github.com/thunderpoot/curselib/]"
    ?# 1, "[https://youtu.be/s4iR668Ki3I?t=162]"
    gosub 300
    goto 100

300 ' Usage info
    ?# 1, " "
    ?# 1, "Usage: " + argv$(0) + " <args>"
    ?# 1, " /version        Show version info and quit"
    ?# 1, " /help           Show this help"
    ?# 1, " /notitle        Disable the title bar"
    ?# 1, " /yn             Yes/No prompt"
    ?# 1, " /input          Prompt for user input, output to file (see: DEFAULTS)"
    ?# 1, " /pass           Prompt for password, output to file (see: DEFAULTS)"
    ?# 1, " /force          Force overwrite of output file"
    ?# 1, " /cls            Clear screen on program exit"
    ?# 1, " /progress=<N>   Show progress bar (N must be between 0 and 100)"
    ?# 1, " /colour=<text>  Foreground colour ('color' is also supported)"
    ?# 1, " /width=<N>      Box width"
    ?# 1, " /pname=<text>   Header title"
    ?# 1, " /title=<text>   Box title"
    ?# 1, " /msg=<text>     Box message"
    ?# 1, " /btn=<text>     Info-Box button label"
    ?# 1, " /list=<text>    Display a list (max 6 elements)"
    ?# 1, " /delim=<text>   Custom list delimiter (defaults to comma)"
    ?# 1, " /out=<text>     Output filename (for use with input option)"
    ?# 1, " /func=<cmd>     Command to execute on prompt confirmation"
    ?# 1, " "
    ?# 1, " Prepending options with / is optional, and interchangeable with - (hyphen) and -- (double hyphen)."
    ?# 1, " "
    ?# 1, "Examples:" "@run " + argv$(0) + " -yn --func='echo foo bar'"
    ?# 1, "@run " + argv$(0) + " /progress=50"
    ?# 1, "@run " + argv$(0) + " list=hello,world,foo,bar"
    ?# 1, "@run " + argv$(0) + " input title='What is the airspeed velocity of an unladen swallow?' btn='Continue'"
    close #1
    cmd$ = "\less " + pagertmpfile$ : th_exec cmd$
    cmd$ = "\rm " + pagertmpfile$ : th_exec cmd$ ; devnull$
    return

400 ' Colours
    if ups$( myfg$ ) = "CYAN" then : ? esc$ "[36m" ;
    if ups$( myfg$ ) = "MAGENTA" then : ? esc$ "[35m" ;
    if ups$( myfg$ ) = "YELLOW" then : ? esc$ "[33m" ;
    if ups$( myfg$ ) = "BLACK" then : ? esc$ "[30m" ;
    if ups$( myfg$ ) = "RED" then : ? esc$ "[31m" ;
    if ups$( myfg$ ) = "GREEN" then : ? esc$ "[32m" ;
    if ups$( myfg$ ) = "BLUE" then : ? esc$ "[34m" ;
    if ups$( myfg$ ) = "WHITE" then : ? esc$ "[37m" ;
    return
