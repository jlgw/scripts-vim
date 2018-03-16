" █▀▄  symbols for reference
let s:width = 75
let s:height = 23
let s:gapheight = 6
let s:tubewidth = 4

let s:pbase = 2
let s:num = 1

let s:birdx = 20
let s:birdold = 0
let s:birdsp = 0
let s:jumpforce = 2

let s:dbg = 0

function! Gen()
    " 'very pseudo'-random number generator
    " 2 generates {1,...,12} mod 13, this needs change for arbitrary height
    let s:num = (s:num*s:pbase)%13+3
    return s:num
endfunction

function! Ddual()
    " draw tube section
    normal R████ 
    normal 4hj
endfunction

function! Dsingle()
    " draw only right tube section for smooth animation
    normal R█    
    normal 4hj
endfunction

function! Draw(column, line)
    " draw tubes w/ right at 'a:column' and gap starting at 'a:line'
    " cursor() may be a better idea than the normal command movements, ideal
    " solution would be replace with coordinates
    if a:column>s:width-2
        return
    endif

    normal gg0
    for i in range(a:column)
        normal l
    endfor
    if a:column>3
        normal 3h
    endif
    for i in range(a:line-1)
        if a:column>3
            call Ddual()
        else
            call Dsingle()
        endif
    endfor
    for i in range(s:gapheight)
        normal j
    endfor
    for i in range(s:height-a:line-s:gapheight+1)
        if a:column>3
            call Ddual()
        else
            call Dsingle()
        endif
    endfor
endfunction

function! Drawbird()
    " 'bird' has coordinates (s:birdx, s:bird)
    " s:bird is determined by s:birdheight/2, and ansi blocks
    " make the movement seem smoother by s:birdheight%2 determining the glyph
    normal gg0
    for i in range(s:bird-1)
        normal j
    endfor
    for i in range(s:birdx-1)
        normal l
    endfor

    if s:birdheight%2==1
        normal r▄
    else
        normal r▀
    endif
    if s:birdold<s:bird
        normal kr j
        let s:birdold=0
    endif
    if s:birdold>s:bird
        normal jr k
        let s:birdold=0
    endif
endfunction

function! Fill()
    " fill screen with blanks
    for i in range(1, s:height)
        for j in range(1, s:width)
            normal i 
        endfor
        normal O
    endfor
    normal dd
endfunction

function! Fail()
    " This function is called when the 'bird' hits a tube
    nmap n <NOP>
    nmap N <NOP>
    if s:dbg
        echo "bird"
        echo s:bird
        echo "birdheight"
        echo s:birdheight
        echo "birdsp"
        echo s:birdsp
        echo "col1"
        echo s:col1
        echo "line1"
        echo s:line1
        echo "col2"
        echo s:col2
        echo "line2"
        echo s:line2
        echo "col3"
        echo s:col3
        echo "line3"
        echo s:line3
        echo "col4"
        echo s:col4
        echo "line4"
        echo s:line4
    endif
    let s:final = (s:score-40)/20
    echo "You lost :( Score: ".s:final " press ctrl to start new game"
    if s:dbg
        sleep 10
    endif
endfunction


function! Animate()
    " This function is called whenever the play key is pressed
    " Changing col/line to arrays or similar would make this look nicer and
    " shave off ~50loc here
    
    let s:col1 = s:col1 - 1
    let s:col2 = s:col2 - 1
    let s:col3 = s:col3 - 1
    let s:col4 = s:col4 - 1
    let s:birdheight = s:birdheight - s:birdsp
    if s:birdsp>-1
        let s:birdsp = s:birdsp - 1
    endif
    let s:birdold = s:bird
    let s:bird = s:birdheight/2
    if s:bird<1 || s:bird>s:height
        call Fail()
    endif
    
    if s:col1 == 0
        let s:col1 = s:width
        let s:line1 = Gen()
    endif
    if s:col2 == 0
        let s:col2 = s:width
        let s:line2 = Gen()
    endif
    if s:col3 == 0
        let s:col3 = s:width
        let s:line3 = Gen()
    endif
    if s:col4 == 0
        let s:col4 = s:width
        let s:line4 = Gen()
    endif

    call Drawbird()
    call Draw(s:col1,s:line1)
    call Draw(s:col2,s:line2)
    call Draw(s:col3,s:line3)
    call Draw(s:col4,s:line4)

    " Collision detection
    if s:col1>s:birdx-1 && s:col1<s:birdx+s:tubewidth
        if s:line1>s:bird || s:line1<=s:bird-s:gapheight
            call Fail()
        endif
    endif
    if s:col2>s:birdx-1 && s:col2<s:birdx+s:tubewidth
        if s:line2>s:bird || s:line2<=s:bird-s:gapheight
            call Fail()
        endif
    endif
    if s:col3>s:birdx-1 && s:col3<s:birdx+s:tubewidth
        if s:line3>s:bird || s:line3<=s:bird-s:gapheight
            call Fail()
        endif
    endif
    if s:col4>s:birdx-1 && s:col4<s:birdx+s:tubewidth
        if s:line4>s:bird || s:line4<=s:bird-s:gapheight
            call Fail()
        endif
    endif

    " Making this variable might make the game more interesting
    sleep 10 m
    let s:score += 1
endfunction

function! Jump()
    " Jump initiates the jump, it 
    let s:birdsp = s:jumpforce
    call Animate()
endfunction

function! Binds()
    let s:score = 0
    " This is the 'play' key, it is held whenever the game is played
    nmap n :call Animate()<CR>
    " Shift is the jump key, pressing shift while the play key is held
    " calls jump()
    nmap N :call Jump()<CR>
endfunction

function! Flap()
    " Initializer
    let s:col1 = 80
    let s:col2 = 100
    let s:col3 = 120 
    let s:col4 = 140
    
    let s:birdheight = 30
    let s:bird = s:birdheight/2
    let s:line1 = Gen()
    let s:line2 = Gen()
    let s:line3 = Gen()
    let s:line4 = Gen()
    set nonumber
    set norelativenumber
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
    call Fill()
    call Binds()
    nmap <silent> D :call Binds()<CR>
    nnoremap <C-n>  ggVGd:call Flap()<CR>
    echo "Hold n to flap and press shift to jump!"
endfunction

call Flap()
