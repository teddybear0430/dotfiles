" grepをラップした関数
" 拡張子を判定して、拡張子ごとに除外ディレクトリを変更できたら
" 検索精度上がるかも
command! -nargs=1 GrepWrap call GrepWrap(<f-args>)
function! GrepWrap(name)
  execute("grep -r ".a:name." * | cw")
endfunction

" 行末の半角スペースを一括削除
command! DeleteSpace call DeleteSpace()
function! DeleteSpace()
  execute("%s/ *$//g")
endfunction

" アロー関数のテンプレ
command! ArrowFunction call ArrowFunction()
function! ArrowFunction()
  :r ~/.vim/templates/javascript/arrow-function.js
endfunction

" markdownのテンプレ
command! MarkdownTemplate call MarkdownTemplate()
function! MarkdownTemplate()
  :r ~/.vim/templates/markdown/template.md
endfunction

" ポップアップウィンドウの中にターミナルを生成
command! TerminalOpen call popup_create(term_start([&shell], #{ hidden: 1, term_finish: 'close'}), #{ border: [], minwidth: winwidth(1), minheight: &lines/2 })

" カーソル上のsyntax情報を取得する
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction

function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction

command! SyntaxInfo call s:get_syn_info()
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
