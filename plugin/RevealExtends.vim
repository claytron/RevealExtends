function! s:RevealExtends(line1, line2, count, ...)
    let s:config_file = expand("~/.buildout/default.cfg")
    if !filereadable(s:config_file)
        echo "Default buildout config not found: " . s:config_file
        return
    endif
    " save the register to put it back later
    let s:original_reg = @"
    let s:line2 = a:line2
    " If there is no count, just use the current line
    if a:count == 0
        let s:line2 = a:line1
    endif
    " yank the visual selection
    silent execute a:line1 . "," . s:line2 . "yank"
    let s:yanked_text = @"
    " get rid of spaces and newlines
    let s:hash_string = substitute(substitute(s:yanked_text, '\n', '', 'g'), ' ', '', 'g')
    " find the extends cache directory
    let s:dirname = substitute(system("awk '/^extends/ {print $3}' ~/.buildout/default.cfg"), '\n', '', 'g')
    " get the md5 hash of the url string
    let s:filename = substitute(system("md5 -s '" . s:hash_string . "' | awk '{print $4}'"), '\n', '', 'g')
    " set the register back to the previous contents
    let @" = s:original_reg
    let s:file_path = s:dirname . "/" . s:filename
    if filereadable(s:file_path)
        " Create a scractch buffer
        botright new
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap filetype=cfg
        " Read the file into the scratch buffer
        execute "read " . s:file_path
    else
        echo "No file in the cache (" . s:dirname . ") for '" . s:hash_string . "'"
    endif
endfunction

" command to run the reveal function
" TODO: change this to accept arguments
command! -nargs=0 -range=0 RevealExtends call s:RevealExtends(<line1>, <line2>, <count>, <f-args>)
