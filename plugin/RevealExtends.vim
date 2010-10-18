function! s:openExtendedURL(line1, line2, count, ...)
    " save the register to put it back later
    let s:original_reg = @@
    " XXX: a better way to handle this?
    " yank the visual selection
    normal! gvy
    " get rid of spaces and newlines
    let @@ = substitute(@@, '\n', '', 'g')
    let @@ = substitute(@@, ' ', '', 'g')
    " find the extends cache directory
    let s:dirname = substitute(system("awk '/^extends/ {print $3}' ~/.buildout/default.cfg"), '\n', '', 'g')
    " get the md5 hash of the url string
    let s:filename = system("md5 -s '" . @@ . "' | awk '{print $4}'")
    " set the register back to the previous contents
    let @@ = s:original_reg
    let s:file_path = s:dirname . "/" . s:filename
    " open up the file and set the syntax to CFG
    exe "edit +set\\ filetype=cfg " . s:file_path
endfunction

command! -nargs=0 -range=0 OpenExtendedURL call s:openExtendedURL(<line1>, <line2>, <count>, <f-args>)<CR>
