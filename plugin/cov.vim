" Coder: lmduean
" Date: 2019/05/03

" Do not load cov.vim if it has already been loaded.
if exists('g:loaded_COV')
  finish
endif
let g:loaded_COV = 1

if !exists('g:COVReportDirectory')
  let g:COVReportDirectory = "build/coveragereport"
endif

if !exists('g:COVRebuildCommand')
  let g:COVRebuildCommand = "!mkdir -p build && cd build &&
  \ cmake3 -DCMAKE_BUILD_TYPE=coverage -DCODE_COVERAGE=on .. &&
  \ make -j && make test && make coverage"
endif

" @Function : ShowCOV (PUBLIC)
" @Purpose  : Opens the corresponding *.gcov.html for current file
"             with w3m. E.g. foo.c <--> !w3m foo.c.gcov.html
func! ShowCOV(...)
  let htmlHome = g:COVReportDirectory . "/index.html"
  let fileExistsCheck = filereadable(htmlHome)
  if (fileExistsCheck == 0)
    !whiptail --title "No index.html Found" --msgbox "Please try
    \ \":COVRBLT\" to rebuild coverage report." 8 48
    return
  endif
  let fileName = expand("%")
  let htmlName = g:COVReportDirectory . "/" . fileName . ".gcov.html"
  let fileExistsCheck = filereadable(htmlName)
  if (fileExistsCheck == 0)
    !whiptail --title "No corresponding *.gcov.html Found" --msgbox "Please make
    \ sure the current file has c/c++ code blocks and you have built
    \ coverage report with \":COVRBLT\"." 10 48
  else
    execute "!w3m " . htmlName
  endif
endfunc

" @Function : ShowCOVHome (PUBLIC)
" @Purpose  : Opens coverage report homepage for current project
func! ShowCOVHome()
  let htmlHome = g:COVReportDirectory . "/index.html"
  let fileExistsCheck = filereadable(htmlHome)
  if (fileExistsCheck == 0)
    !whiptail --title "No index.html Found" --msgbox "Please try
    \ \":COVRBLT\" to rebuild coverage report." 8 48
  else
    execute "!w3m " . htmlHome
  endif
endfunc

" @Function : RebuildCOV (PUBLIC)
" @Purpose  : Rebuild coverage report for current project
func! RebuildCOV()
  execute g:COVRebuildCommand
endfunc

comm! -nargs=? COV call ShowCOV(<f-args>)
comm! -nargs=? COVHOME call ShowCOVHome(<f-args>)
comm! -nargs=? COVRBLT call RebuildCOV(<f-args>)
