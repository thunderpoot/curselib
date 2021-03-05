# curselib
curselib – ncurses-style interface for TeleBASIC

## What?
It's written in BASIC for [Telehack](https://telehack.com).

![thcurses-demo](https://feen.us/1p6zjy.gif)

### Installation
Copy the contents of `curselib.bas` into `ped`, exit and save as `curselib.bas` with `^D`.

### Usage
```
Usage: run curselib.bas <args>
 --version        Show version info and quit
 --help           Show this help
 --notitle        Disable the title bar
 --yn             Yes/No prompt
 --cls            Clear screen on program exit
 --progress=<N>   Show progress bar (N must be between 0 and 100)
 --width=<N>      Box width
 --title=<text>   Box title
 --msg=<text>     Box message
 --btn=<text>     Info-Box button
 --func=<cmd>     Command to execute on prompt confirmation
```

Examples:
```
@run curselib.bas --yn --func='echo foo bar'
```
```
@run curselib.bas --progress=45
```

As with other commands, `--` is interchangeable with `/` and `-`.
Additionally, `curselib` will allow options with no prefix at all:

```
@curselib yn msg="u grok?"
```

BASIC example:
```
@basic
Dartmouth DTSS TeleBASIC (c) 1964,1966,1969,1970,1971,1979
>for i = 0 to 100 : cmd$ = "run curselib.bas progress=" + str$(i) : th_exec cmd$ : next i
```

use with any loop:
```
@basic
Dartmouth DTSS TeleBASIC (c) 1964,1966,1969,1970,1971,1979
>total = 25 : for i = 0 to total : cmd$ = "run curselib.bas progress=" + str$(i/total*100) : th_exec cmd$ : next i
```
