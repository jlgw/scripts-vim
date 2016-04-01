function Smallest_divisor(num)
    " Returns smallest prime divisor
    if type(a:num)!=0
        echoerr("Not an integer")
        return 1
    endif
    if a:num<0
        return -1
    elseif a:num==0
        return 0
    else
        if a:num==1
            return 1
        elseif a:num%2==0
            return 2
        elseif a:num%3==0
            return 3
        elseif a:num%5==0
            return 5
        elseif a:num%7==0
            return 7
        endif
        for i in range(3,float2nr(sqrt(a:num)),2)
            if a:num%i==0
                return i
            endif
        endfor
        return a:num
    endif
endfunction

function Isprime_bool(num)
    " Returns 1 if prime, else 0
    if type(a:num)!=0
        echoerr("Not an integer")
        return -1
    endif
    let d = Smallest_divisor(a:num)
    if d<2
        return 0
    else
        return a:num==d
    endif
endfunction

function Isprime()
    " Wrapper for Isprime_bool function on current word
    let nst = expand("<cword>")
    let num = str2nr(nst)
    if expand(num)!=nst
        echo "Not a number"
        return 
    endif
    if Isprime_bool(num)
        echo "Prime"
    else
        echo "Not prime"
    endif
endfunction

function Factor()
    " Factor out smallest prime divisor on number under cursor
    let nst = expand("<cword>")
    let num = str2nr(nst)

    if expand(num)!=nst
        echo "Not a number"
        return 
    endif

    let div = Smallest_divisor(num)
    if div==num
        echo "Prime"
        return 0
    endif
    let quot = num/div
    let outstr = expand(div)."*".expand(quot)
    if div*quot!=num
        echoerr("Arithmetic error")
        return -1
    else
        " Replace number under cursor with divisor*quotient
        let @a = outstr
        normal diw"ap
    endif
    return 1
endfunction

function Fullfactor()
    " Factor number under cursor completely
    while(Factor())
    endwhile
endfunction
