" openssl.vim version 3.2 2008 Noah Spurrier <noah@noah.org>
"
" == Edit OpenSSL encrypted files and turn Vim into a Password Safe! ==
"
" This plugin enables reading and writing of files encrypted using OpenSSL.
" The file must have the extension of one of the ciphers used by OpenSSL. For
" example:
"
"    .des3 .aes .bf .bfa .idea .cast .rc2 .rc4 .rc5 (.bfa is base64 ASCII
"    encoded blowfish.)
"
" This will turn off the swap file and the .viminfo log. The `openssl` command
" line tool must be in the path.
"
" == Install ==
"
" Put this in your plugin directory and Vim will automatically load it:
"
"    ~/.vim/plugin/openssl.vim
"
" You can start by editing an empty unencrypted file. Give it one of the
" extensions above. When you write the file you will be asked to give it a new
" password.
"
" == Simple Vim Password Safe ==
"
" If you edit any file named '.auth.bfa' (that's the full name, not just the
" extension) then this plugin will add folding features and an automatic quit
" timeout.
"
" Vim will quit automatically after 5 minutes of no typing activity (unless
" the file has been changed).
"
" This plugin will fold on wiki-style headlines in the following format:
"
"     == This is a headline ==
" 
" Any notes under the headline will be inside the fold until the next headline
" is reached. The SPACE key will toggle a fold open and closed. The q key will
" quit Vim. Create the following example file named ~/.auth.bfa:
"
"     == Colo server ==
"
"     username: maryjane password: esydpm
"
"     == Office server ==
"
"     username: peter password: 4m4z1ng
"
" Then create this bash alias:
"
"     alias auth='view ~/.auth.bfa'
"
" Now you can view your password safe by typing 'auth'. When Vim starts all
" the password information will be hidden under the headlines. To view the
" password information put the cursor on the headline and press SPACE. When
" you write an encrypted file a backup will automatically be made.
"
" This plugin can also make a backup of an encrypted file before writing
" changes. This helps guard against the situation where you may edit a file
" and write changes with the wrong password. You can still go back to the
" previous backup version. The backup file will have the same name as the
" original file with .bak before the original extension. For example:
"
"     .auth.bfa  -->  .auth.bak.bfa
"
" To turn on backups put the following global definition in your .vimrc file:
" 
"     let g:openssl_backup = 1
"
" Thanks to Tom Purl for the original des3 tip.
"
" I release all copyright claims. This code is in the public domain.
" Permission is granted to use, copy modify, distribute, and sell this
" software for any purpose. I make no guarantee about the suitability of this
" software for any purpose and I am not liable for any damages resulting from
" its use. Further, I am under no obligation to maintain or extend this
" software. It is provided on an 'as is' basis without any expressed or
" implied warranty.
"
" $Id: openssl.vim 189 2008-01-28 20:44:44Z root $

augroup openssl_encrypted
if exists("openssl_encrypted_loaded")
    finish
endif
let openssl_encrypted_loaded = 1
autocmd!

function! s:OpenSSLReadPre()
    set cmdheight=3
    set viminfo=
    set noswapfile
    set shell=/bin/sh
    set bin
endfunction

function! s:OpenSSLReadPost()
    let l:cipher = expand("%:e")
    if l:cipher == "aes"
        let l:cipher = "aes-256-cbc"
    endif
    if l:cipher == "bfa"
        let l:cipher = "bf"
        let l:expr = "0,$!openssl " . l:cipher . " -d -a -salt"
    else
        let l:expr = "0,$!openssl " . l:cipher . " -d -salt"
    endif

    silent! execute l:expr
    if v:shell_error
        silent! 0,$y
        silent! undo
        echo "COULD NOT DECRYPT USING EXPRESSION: " . expr
        echo "Note that your version of openssl may not have the given cipher engine built-in"
        echo "even though the engine may be documented in the openssl man pages."
        echo "ERROR FROM OPENSSL:"
        echo @"
        echo "COULD NOT DECRYPT"
        return
    endif
    set nobin
    set cmdheight&
    set shell&
    execute ":doautocmd BufReadPost ".expand("%:r")
    redraw!
endfunction

function! s:OpenSSLWritePre()
    set cmdheight=3
    set shell=/bin/sh
    set bin

    if !exists("g:openssl_backup")
        let g:openssl_backup=0
    endif
    if (g:openssl_backup)
        silent! execute '!cp % %:r.bak.%:e'
    endif

    let l:cipher = expand("<afile>:e") 
    if l:cipher == "aes"
        let l:cipher = "aes-256-cbc"
    endif
    if l:cipher == "bfa"
        let l:cipher = "bf"
        let l:expr = "0,$!openssl " . l:cipher . " -e -a -salt"
    else
        let l:expr = "0,$!openssl " . l:cipher . " -e -salt"
    endif

    silent! execute l:expr
    if v:shell_error
        silent! 0,$y
        silent! undo
        echo "COULD NOT ENCRYPT USING EXPRESSION: " . expr
        echo "Note that your version of openssl may not have the given cipher engine built in"
        echo "even though the engine may be documented in the openssl man pages."
        echo "ERROR FROM OPENSSL:"
        echo @"
        echo "COULD NOT ENCRYPT"
        return
    endif
endfunction

function! s:OpenSSLWritePost()
    silent! undo
    set nobin
    set shell&
    set cmdheight&
    redraw!
endfunction

autocmd BufReadPre,FileReadPre     *.des3,*.des,*.bf,*.bfa,*.aes,*.idea,*.cast,*.rc2,*.rc4,*.rc5,*.desx call s:OpenSSLReadPre()
autocmd BufReadPost,FileReadPost   *.des3,*.des,*.bf,*.bfa,*.aes,*.idea,*.cast,*.rc2,*.rc4,*.rc5,*.desx call s:OpenSSLReadPost()
autocmd BufWritePre,FileWritePre   *.des3,*.des,*.bf,*.bfa,*.aes,*.idea,*.cast,*.rc2,*.rc4,*.rc5,*.desx call s:OpenSSLWritePre()
autocmd BufWritePost,FileWritePost *.des3,*.des,*.bf,*.bfa,*.aes,*.idea,*.cast,*.rc2,*.rc4,*.rc5,*.desx call s:OpenSSLWritePost()

" The following implements a simple password safe for any file named
" '.auth.bfa'. The file is encrypted with Blowfish and base64 encoded.
" Folding is supported for == headlines == style lines.

function! HeadlineDelimiterExpression(lnum)
    if a:lnum == 1
        return ">1"
    endif
    return (getline(a:lnum)=~"^\\s*==.*==\\s*$") ? ">1" : "="
endfunction
autocmd BufReadPost,FileReadPost   .auth.bfa set foldexpr=HeadlineDelimiterExpression(v:lnum)
autocmd BufReadPost,FileReadPost   .auth.bfa set foldlevel=0
autocmd BufReadPost,FileReadPost   .auth.bfa set foldcolumn=0
autocmd BufReadPost,FileReadPost   .auth.bfa set foldmethod=expr
autocmd BufReadPost,FileReadPost   .auth.bfa set foldtext=getline(v:foldstart)
autocmd BufReadPost,FileReadPost   .auth.bfa nnoremap <silent><space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<CR>
autocmd BufReadPost,FileReadPost   .auth.bfa nnoremap <silent>q :q<CR>
autocmd BufReadPost,FileReadPost   .auth.bfa highlight Folded ctermbg=red ctermfg=black
autocmd BufReadPost,FileReadPost   .auth.bfa set updatetime=300000
autocmd CursorHold                 .auth.bfa quit

augroup END

