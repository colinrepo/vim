" |  \/  |_   _  \ \   / /_ _|  \/  |  _ \ / ___|
" | |\/| | | | |  \ \ / / | || |\/| | |_) | |
" | |  | | |_| |   \ V /  | || |  | |  _ <| |___
" |_|  |_|\__, |    \_/  |___|_|  |_|_| \_\\____|
"         |___/

"""
" + 如果以evim启动vim，则不使用该配置
"""
if v:progname =~? "evim"
  finish
endif

" ===
" === 自动装载插件管理器
" ===
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"""
" + 这会按照多数用户的喜好设置Vim。如果你是少数不喜欢的，注释掉这行
"""
source $VIMRUNTIME/defaults.vim

"""
" + 这告诉 Vim 当覆盖一个文件的时候保留一个备份。但 VMS 系统除外，因为 VMS 系统
" 会自动产生备份文件
" + 如果不是VMS系统，则设置 'undofile' 选项，会在一个文件中保存多层撤销信息
" + 效果是，当你改动了文件，退出Vim，然后再次编辑文件时你可以撤销之前做过的改动
" + 这是一个很强大很有用的功能，代价是要保存一个文件
"""
if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

"""
" + 打开 'hlsearch' 选项，告诉 Vim 高亮上次查找模式匹配的地方
"""
if &t_Co > 2 || has("gui_running")
  set hlsearch
endif

"""
" + 这使 Vim 在一行长于 80 个字符的时候自动换行，但仅对纯文本文件中有效
"""
augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END


""" 
" + 在标准 Vim 中，% 键只能用于跳转匹配的括号或符号（如 ()、[]、{}）但在实际编程中，许多语言使用成对关键字来定义代码块，例如 HTML 的 <div> 和 </div>，或 Pascal 的 begin 和 end
" + 原生 Vim 无法直接跳转这些结构，而 matchit.vim 正是为解决这一问题而设计的
" + 该插件广泛支持多种语言，包括 HTML、LaTeX、Pascal、Ada、Python、C++ 等，并允许用户自定义匹配规则极大提升了在大型代码文件中的导航效率
" + 运用场景在函数、条件语句、循环等结构间快速跳转，避免手动查找配对关键字。
" + 使用:help matchit详细学习该插件
"""
if has('syntax') && has('eval')
  packadd! matchit
endif

"""
" 中文输入法全模式智能切换配置
" 适配嵌入式开发场景：命令行模式强制英文，插入模式智能切换
"""
" 退出插入模式（进入命令行/普通/可视模式）：强制切换英文
autocmd InsertLeave * call s:ForceEnglishInput()
autocmd InsertEnter * call s:ForceChineseInput()
function! s:ForceChineseInput()
   " 适配fcitx5输入法（主流推荐）
   " call system('fcitx5-remote -o')
   " 适配ibus输入法（注释上面一行，启用下面一行）
   call system('ibus engine libpinyin')
   " 适配搜狗输入法（注释上面一行，启用下面一行）
   " call system('fcitx-remote -o')
endfunction
function! s:ForceEnglishInput()
   " 适配fcitx5输入法
   " call system('fcitx5-remote -c')
   " 适配ibus输入法
   call system('ibus engine xkb:us::eng')
   " 适配搜狗输入法
   " call system('fcitx-remote -c')
endfunction

" --------------------------
" 基础配置（I.MX6U阿尔法开发板优先）
" --------------------------
filetype off                  " 关闭文件类型检测
set encoding=utf-8            " 编码设置
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,gd2312,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set formatoptions+=r          " 换行时自动延续注释符号
set comments=sO:*\ -,mO:*\ ,exO:*/,s1:/*,mb:*,ex:*/,://,:#
set ambiwidth=double          " 中文字符按双宽度显示解决中文光标错位的问题
set t_Co=256                  " 启用256色
set number                    " 显示行号（调试必备）
"set relativenumber            " 相对行号（快速跳转）
syntax on                     " 自动语法高亮
set cursorline                " 高亮当前行
set tabstop=4                 " Tab宽度（对齐Linux内核代码风格）
set shiftwidth=4              " 缩进宽度
set expandtab                 " Tab转为空格
set softtabstop=4
set autoindent                " 自动缩进
set smartindent               " 智能缩进（C语言大括号对齐）
set hidden                    " 允许隐藏未保存的缓冲区
"set mouse=a                   " 启用鼠标支持
"set clipboard=unnamedplus     " 系统剪贴板集成
set nowrap                    " 禁止换行（寄存器定义一行到底）
set colorcolumn=80            " 80字符标记线（符合Linux内核代码规范）
set timeout 		      "在按下前缀键（如 <Leader>）后等待后续按键，并在超时时间内显示键绑定提示弹窗t
set timeoutlen=500 	      "vim-which-key要求必须设置该时间，否则插件功能失效 
" --------------------------
" 插件管理器（Vim-Plug）
" --------------------------
call plug#begin('~/.vim/plugged')
" 基础插件
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'   " 状态栏主题
Plug 'flazz/vim-colorschemes'
Plug 'ryanoasis/vim-devicons'  " 文件图标
Plug 'liuchengxu/vim-which-key'
Plug 'easymotion/vim-easymotion'
Plug 'voldikss/vim-floaterm'
Plug 'preservim/nerdcommenter'  " 批量注释插件
Plug '907th/vim-auto-save'      " 自动保存插件
" 核心工具
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }  " 模糊搜索
Plug 'lambdalisue/vim-fern', { 'do':  ':call fern#install()'}
Plug 'francoiscabrol/ranger.vim'
Plug 'ludovicchabant/vim-gutentags'                             " 自动生成ctags、gtags
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'                                       " Git集成
Plug 'preservim/tagbar'                                         " 函数/寄存器标签导航
Plug 'majutsushi/tagbar'                                        " 寄存器/宏定义导航
" 正点原子I.MX6U阿尔法专属插件
"Plug 'jeffkreeftmeijer/vim-numbertoggle'                        " 智能行号切换
Plug 'rhysd/vim-clang-format'                                   " C代码格式化
Plug 'bfrg/vim-cpp-modern'                                      " 现代C++语法高亮
Plug 'puremourning/vimspector'                                  " 图形化调试器
"Plug 'xuhdev/SyntaxRange'                                       " 寄存器块高亮
Plug 'pangloss/vim-javascript'                                  " JavaScript支持（设备树脚本）
Plug 'udalov/kotlin-vim'                                        " Kotlin支持（设备树脚本）
call plug#end()
filetype plugin indent on      " 重新开启文件类型检测

" ===
" === 美化配置：colorscheme, devicons,airline
" ===
colorscheme Monokai
let g:airline_theme = 'dark'                                " 状态栏主题
let g:airline_powerline_fonts = 1                              " 启用Powerline字体
let g:devicons_enable = 1                                      " 启用文件图标

" ===
" === ceasymotion: 在vim中跳转到任意位置
" ===
let g:EasyMotion_do_mapping = 0				" Disable default mappings
let g:EasyMotion_smartcase = 1				" Turn on case-insensitive feature

" ===
" === vim-auto-save 
" ===
" let g:auto_save = 1
" let g:auto_save_events = ["InsertLeave", "TextChanged", "TextChangedI", "CursorHold", "CursorHoldI", "CompleteDone"]

" ===
" === nerdcomment: vim批量注释
" ===
let g:NERDSpaceDelims = 1        " 注释符号后添加空格（符合代码规范）
let g:NERDDefaultAlign = 'left'  " 注释左对齐
let g:NERDCommentEmptyLines = 1  " 允许注释空行
let g:NERDTrimTrailingWhitespace = 1  " 注释时自动删除行尾空格
" 嵌入式语言注释风格映射
let g:NERDCustomDelimiters = {
    \ 'c': { 'left': '// ', 'leftAlt': '/* ', 'rightAlt': ' */' },
    \ 'h': { 'left': '// ', 'leftAlt': '/* ', 'rightAlt': ' */' },
    \ 's': { 'left': '@ ' },
    \ 'dts': { 'left': '// ' }
    \ }

" ===
" === cvim-floaterm: 在vim中打开一个终端
" ===
let g:floaterm_wintype = 'float'             "浮动窗口类型。
let g:floaterm_position = 'center'           "在窗口中间显示。

" ===
" === nerdtree
" ===
"let g:NERDTreeShowHidden = 1                   " 显示隐藏文件
"let g:NERDTreeIgnore = ['\.pyc$', '\.git$']    " 忽略文件
"" let g:NERDTreeQuitOnOpen = 1                   " 打开文件后自动关闭
"" 启动Vim时自动打开NERDTree，并聚焦右侧编辑窗口
"autocmd VimEnter * NERDTree | wincmd l
"" 界面优化 
"let g:NERDTreeWinPos = 'left'            " 窗口位置
"let g:NERDTreeWinSize = 35               " 窗口宽度 
"let g:NERDTreeShowLineNumbers = 1        " 显示行号
"let g:NERDTreeHighlightCursorline = 1    " 高亮当前行 
"let g:NERDTreeAutoDeleteBuffer = 1       " 文件删除后自动关闭
"let g:NERDTreeHidden = 0                 " 不显示隐藏文件（.开头的文件）
"let g:NERDTreeShowBookmarks = 1          " 显示书签
"" 文件过滤 (嵌入式专用)
"let g:NERDTreeIgnore = [
"  \ '\.o$', '\.d$', '\.elf$', '\.bin$',
"  \ 'build$', 'dist$', 'node_modules$',
"  \ '\.git$', '\.pyc$', '__pycache__',
"  \ '\.jpg$', '\.pdf$', '\.DS_Store'
"\ ]
"" 智能关闭策略: 关闭仅剩 NERDTree 窗口时自动退出 Vim（避免僵尸窗口）
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()  | quit | endif
"autocmd BufEnter * if (winnr("$") == 1 && &filetype == "nerdtree") | q | endif 
"" 文件类型图标 (需Nerd字体)
"let g:NERDTreeFileExtensionHighlightFullName = 1
"let g:NERDTreeExactMatchHighlightFullName = 1
"let g:NERDTreePatternMatchHighlightFullName = 1 

" ===
" === Fern
" ===

"
" ===
" === Ranger
" ===
" add this line if you use NERDTree 
let g:NERDTreeHijackNetrw = 0 
" open ranger when vim open a directory
let g:ranger_replace_netrw = 1 
" For instance if you want to display the hidden files by default you can write
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'


" ===
" === leaderF
" === 
" 核心知识：
" + ctags,用于支持函数、标签查找（:Leader function/tag）--->  sudo apt-get install exuberant-ctags
" + ripgrep(rg)，用于实现高速文本搜索（:Leaderf rg --->  sudo apt-get install ripgrep
" + python 2/3，编译 C 扩展所需头文件 ---> sudo apt-get install python3-dev
" + gtags,用于生成标签 ---> sudo apt-get install global
" + 需要在项目目录下面添加.vimexclude文件，并给出LeaderF无需搜索的文件和目录
" + 需要在项目目录下添加.project标记文件,或者.git，让LeaderF能自动识别搜索根目录
" + 在文件内搜索就使用LeaderF line
" + 多使用LeaderF self，里面包含了几乎所有该插件常用的命令函数
" + 多使用LeaderFhelp，他能检索vim的全部帮助文档，遇到不会的问题一定要去看插件的文档
" === 
" 搜索结果导航窗口内快捷键：
" + Ctrl-j/k: 上下选择，浏览搜索结果
" + Enter: 打开选中项（当前窗口）
" + Ctrl-]: 垂直分屏打开，左右对比文件
" + Ctrl-x: 水平分屏打开，上下对比文件
" + Ctrl-\: 让你自己选择对指定搜索结果的处理方式
" + Ctrl-t: 在一个新窗口中打开
" + Ctrl-s: 在结果窗口中选中一个文件
" + Ctrl-a: 在结果窗口中选中所有文件
" + Ctrl-l: 在结果窗口中清除选中
" + F5: 刷新搜索cache
" + ESC： 退出LeaderF窗口，放弃当前搜索
" + Ctrl-r: 切换大小写敏感（默认不敏感）,区分 Abc 和 abc
" + Ctrl+f: 向前翻页,结果太多时快速定位
" + Ctrl+b: 向后翻页, 结果太多时快速定位
" + Ctrl+d: 删除当前选中文件（需确认）,清理无用文件
" ===
" 基础配置
let g:Lf_WindowPosition = 'bottom'	" LeaderF窗口位置（top/bottom/left/right/popup）
let g:Lf_WindowHeight = 0.3         " LeaderF窗口占VIM窗口的百分比
let g:Lf_DefaultMode = 'NameOnly'   " 设置搜索文件是只匹配文件名不匹配文件路径,通过ctrl-r和ctrl-f切换
let g:Lf_DelimiterChar = ';'        " 在NameOnly模式下，搜索到了指定文件名的文件，但是该文件名的文件可能在多个目录下，此时输入;继续在结果中匹配目录
let g:Lf_HighlightIndividual = 0    " 在结果中高亮显示输入的单个字符设置为1，将值设为0以高亮显示连续字符。 默认值为1
let g:Lf_NumberOfHighlight = 120    " 指定结果中高亮行的数目。 默认值为100。
let g:Lf_RgHighlightInPreview = 1   " 指定是否在预览窗口中高亮显示搜索到的单词
let g:Lf_MruMaxFiles = 100          " 指定您希望 LeaderF 记录的最近使用文件的数量。 默认值为 100。
let g:Lf_AutoResize = 0             " 自动调整 LeaderF 窗口高度
let g:Lf_JumpToExistingWindow = 1   " 如果所选文件已在某个窗口中打开，则跳转到该现有窗口
let g:Lf_EnableCircularScroll = 1   " 在结果窗口中启用循环滚动。
let g:Lf_PreviewCode = 1            " 使用此选项指定在导航标签时，是否显示标签所定位代码的预览
let g:Lf_DefaultExternalTool = 'rg' " 使用此选项可指定用于索引文件的默认外部工具。默认情况下，如果可用，将按 'rg'、'pt'、'ag'、'find' 的顺序使用外部工具。如果所有工具均不可用，则回退到内置的 Python 实现，该实现速度稍慢
let g:Lf_RememberLastSearch = 0     " 此选项用于指定是否记住上次搜索。如果值为 1，您在上次搜索时输入的搜索字符串将在下次启动LeaderF时仍然保留
let g:Lf_ReverseOrder = 0           " 按自下而上还是自上而下的顺序显示结果, 默认值为0（自上而下顺序）0。
let g:Lf_UseCache = 1 			    " 使用缓存,如果值为1， LeaderF 在重新打开 Vim 时将不会重新索引文件
let g:Lf_CacheDirectory = '$HOME/.cache' " 更改缓存路径，默认$HOME/.cache
let g:Lf_IndexTimeLimit = 30        " 指定您能容忍等待的文件索引最长时间。 默认值为120秒。
let g:Lf_FollowLinks = 0            " 在索引时是否访问符号链接所指向的目录
let g:Lf_MaxCount = 0               " 指定源条目的数量限制。如果达到该限制，LeaderF 将停止生成源条目。如果值小于 1（≤0），则无限制。 默认值为 2000000。
" 此选项指定是否启用空查询，即如果未输入任何模式，则根据当前缓冲区名称的最佳匹配对结果进行排序
" let g:Lf_EmptyQuery = 1
" 此选项指定是否从结果列表中移除当前缓冲区名称。
" g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_ShowHidden = 1             " 用于指定是否搜索隐藏文件和目录。 默认值为0。（不搜索隐藏文件和目录）
" 设置工作目录：A选项指定工作目录为当前文件最近的祖先目录，该祖先目录下需要包含g:Lf_rootMarkers下面的特殊文件，若找不到则c生效及当前文件所在的目录为工作目录
let g:Lf_WorkingDirectoryMode = 'Ac'
" 自动识别项目根目录，在该配置中给出的，leaderF会认为是项目根目录，能提高搜索效率
let g:Lf_RootMarkers = ['.git', '.root', '.project', '.vimexclude', '.svn']  
" 在项目根目录创建.vimexclude 文件，添加如下所示的项目专属的忽略规则
"  Here uses the Unix shell-style wildcards: *,?,[seq],[!seq], which are not the same as regular expressions
"let g:Lf_WildIgnore = {
"    \ 'dir' : [
"    \   '.git',
"    \   '.svn',
"    \   '.cache', 
"    \   'arch/arm/boot/dts/.tmp_versions',
"    \   'drivers/gpio/.cache',
"    \   'include/config/auto.conf.d',
"    \ ],
"    \ 'file' : [
"    \   '*.swp',
"    \   '*~',
"    \   '*.dtb',
"    \   '*.imx',
"    \   'div2.c',
"    \ ],
"    \}
"""let g:Lf_MruFileExclude = ['*.so']
" 此选项表示不显示文件名与其中定义的模式匹配的MRU文件
"let g:Lf_MruWildIgnore = {
"            \ 'dir': [],
"            \ 'file': []
"            \}
" 添加以下配置，自动加载项目本地配置.vimexclude
if filereadable(".vimexclude")
    source .vimexclude
endif
" 指定 tags 路径,强制生成详细 tags, 
" -R 递归调用
" --fields=+l 在标签文件中添加语言字段
" --excmd=pattern 定位标签在文件中的位置,用pattern的方式速度稍慢但稳健，可以用number的方式，跳转速度快但文件修改行号变动后会导致跳转不准
" --exclude=node_modules 大型项目生成tags慢，排除无关文件
let g:Lf_Ctags = "ctags -R --fields=+l --excmd=pattern --exclude=node_modules" "默认为ctags
" 指定 ctags 的选项字典，以生成函数的标签，其中，键为编程语言名称（如 'c'、'rust'），值为传递给 ctags 的命令行选项，用于指定该语言中需要生成的函数相关标签种类（kinds)
" --c-kinds：ctags 的内置选项，用于指定 C 语言中要生成的标签种类（kinds）
"   + f：function（函数定义，如 int add(int a, int b) { ... }）
"   + p：prototype（函数原型声明，如 int add(int a, int b);）
"   + m: member (类成员函数)
let g:Lf_CtagsFuncOpts = {
            \ 'c': '--c-kinds=fp',
            \ 'cpp': '--c++-kinds=fm',
            \ }
" 使用此选项可指定您使用的rg可执行文件。如果rg不在您的$PATH环境变量所包含的目录中，您应自行设置
" let g:Lf_Rg = 'C:\Windows\System32\rg.exe'
let g:Lf_Rg = 'rg'
" 指定 ripgrep 配置的列表,默认为空
"let g:Lf_RgConfig = [
"        \ "--max-columns=150",
"        \ '--type-add "web:*.{html,css,js}*"',
"        \ "--glob=!git/*",
"        \ "--hidden"
"        \ ]
" 使用此选项可自定义要使用的全局可执行文件
" let g:Lf_Global = "/bin/global"
let g:Lf_Global = "global"
" 使用此选项可自定义要使用的gtags可执行文件
" let g:Lf_Gtags = "/bin/gtags"
let g:Lf_Gtags = "gtags"
" 如果值为1，并且项目根目录下定义了由g:Lf_RootMarkers指定的根标记，
" 则在首次打开新缓冲区并读取文件到缓冲区后，将自动生成gtags文件。
" 否则，应使用Leaderf gtags --update手动生成gtags文件。 默认值为0。
let g:Lf_GtagsAutoGenerate = 0
" 如果您使用 https://github.com/ludovicchabant/vim-gutentags 生成 gtags，
" 首先应将 g:Lf_GtagsAutoGenerate 设置为 0，并将 g:Lf_GtagsGutentags 设置为 1。 
" 然后，您需要按如下方式配置 gutentags
let g:Lf_CacheDirectory = expand('~/.cache')
let g:gutentags_cache_dir = expand(g:Lf_CacheDirectory.'/LeaderF/gtags')
let g:Lf_GtagsGutentags = 1
" 如果值为1且gtags数据库已存在，则在保存缓冲区后，gtags数据库将自动更新。 默认值为1。
let g:Lf_GtagsAutoUpdate = 1
" Gtags 接受一个文件列表作为目标文件。此选项指明了目标文件的来源。
" 它有 3 个取值：0、1、2。 
" + 0 - gtags 自行搜索目标文件。 
" + 1 - 目标文件来自 FileExplorer。 
" + 2 - 目标文件来自 g:Lf_GtagsfilesCmd。
" 默认值为 0。
let g:Lf_GtagsSource = 0
" 如果 g:Lf_GtagsSource 为 2，则使用此选项定义的命令来生成目标文件
" Default value is: >
"let g:Lf_GtagsfilesCmd = {
"        \ '.git': 'git ls-files --recurse-submodules',
"        \ '.hg': 'hg files',
"        \ 'default': 'rg --no-messages --files'
"        \}
" 如果该选项的值为1，此选项会指示gtags接受文件名或目录名以点开头的文件和目录。 默认值为0。
let g:Lf_GtagsAcceptDotfiles = 1
" 如果该选项的值为1，此选项会指示gtags跳过不可读的文件。 默认值为0。
let g:Lf_GtagsSkipUnreadable = 1
" 此选项指示 gtags 跳过符号链接。
" 如果值为 'f'，则仅跳过文件的符号链接；
" 如果值为 'd'，则仅跳过目录的符号链接；
" 如果值为 'a'，则跳过所有符号链接。
" 默认值为“a”
let g:Lf_GtagsSkipSymlink = 'a'

" 此选项用于指定 gtags 配置文件（'gtags.conf' 或 '.globalrc'）的路径。 
" 通常情况下，您无需使用此选项，因为 gtags 自身已具备默认值。
" 如果您将该文件命名为 '/etc/gtags.conf' 或 "$HOME/.globalrc", gtags 将用文件中的值覆盖默认值。
" let g:Lf_Gtagsconf = "$HOME/.globalrc"

" 此选项指定配置文件的标签。 默认情况下，gtags 支持 C、C++、Yacc、Java、PHP 和汇编编程语言。
" 如果您希望支持其他编程语言，可以使用命令 pip install pygments 安装 pygments 包，并将此选项设置为“native-pygments”。 
" 默认值为“default”。
"let g:Lf_Gtagslabel = "default"

" 此选项指定是否将gtags数据库文件存储在项目的根目录中
" let g:Lf_GtagsStoreInProject = 1

" 此选项指定是否将gtags数据库文件存储在项目的根标记中
" let g:Lf_GtagsStoreInRootMarker = 1

" 如果出现“gtag 错误！未识别的选项 --skip-symlink”，请将该值设置为 0。 默认值为 1。
" let g:Lf_GtagsHigherThan6_6_2 = 0


"需求:
"+ 可视模式下选中文本后，按 <Leader>lf 搜索文件（file）
"+ 可视模式下选中文本后，按 <Leader>lc 搜索函数（function）
"+ 可视模式下选中文本后，按 <Leader>lr 搜索内容（ripgrep
" 获取可视模式选中的文本（支持字符/行/块可视）
function! s:GetVisualSelection() abort
    let [lnum1, col1] = getpos("'<")[1:2]  " 选区起始位置
    let [lnum2, col2] = getpos("'>")[1:2]  " 选区结束位置
    let lines = getline(lnum1, lnum2)       " 获取选区行内容
    if len(lines) == 0
        return ''
    endif
    " 截取选区内的文本（处理列范围）
    let lines[-1] = lines[-1][: col2 - (mode() =~# '[vV]' ? 1 : 2)]  " 行尾截断
    let lines[0] = lines[0][col1 - 1:]                               " 行首截断
    return join(lines, "\n")                                         " 拼接多行文本
endfunction

" 一键搜索选中文本（文件搜索示例，可替换为其他 LeaderF 命令）
function! LeaderfSearchSelected(type) abort
    let selected = s:GetVisualSelection()
    if empty(selected)
        echo "❌ No text selected (use visual mode first)"
        return
    endif
    " 转义特殊字符（空格、引号等），避免命令行解析错误
    let safe_input = shellescape(selected, 1)  " 1 表示用单引号包裹（更安全）
    " 根据 type 执行不同 LeaderF 命令（可扩展）
    if a:type ==# 'line'
        execute 'Leaderf line --input=' . safe_input
    elseif a:type ==# 'function'
        execute 'Leaderf function --input=' . safe_input
    elseif a:type ==# 'rg'
        execute 'Leaderf rg --input=' . safe_input
    elseif a:type ==# 'tag'
        execute 'Leaderf tag --input=' . safe_input
    elseif a:type ==# 'gtags'
        execute 'Leaderf gtags --input=' . safe_input
    else
        echo "⚠️ Unknown search type: " . a:type
    endif
endfunction

" leaderF 与主流插件协同配置
" + 需求：在 NERDTree 中选中目录后，用 leaderF 快速搜索该目录下的文件
" 确保已安装 NERDTree 和 LeaderF 插件
" 定义函数：在 NERDTree 中获取选中目录路径并用 LeaderF 搜索
function! g:NERDTreeLeaderFSearch()
    " 获取当前 NERDTree 选中的节点
    let l:node = g:NERDTreeFileNode.GetSelected()
    " 如果上述方法失败，尝试使用标准方法
    if empty(l:node)
        let l:node = NERDTreeGetSelectedNode()
    endif
    " 检查是否选中有效节点
    if empty(l:node) || !has_key(l:node, 'path')
        echo "No valid node selected in NERDTree"
        return
    endif
    " 获取节点路径（兼容不同 NERDTree 版本）
    let l:path = ''
    if has_key(l:node.path, 'abpath')
        " 新版本 NERDTree 使用 abpath 属性
        let l:path = l:node.path.abpath
    elseif has_key(l:node.path, 'str')
        " 旧版本使用 str() 方法
        try
            let l:path = l:node.path.str({'format': 'UI'})
        catch
            " 如果格式化失败，使用基本路径
            let l:path = l:node.path.str()
        endtry
    else
        " 回退方案
        let l:path = expand('%:p:h')
    endif
    " 转换为绝对路径
    let l:path = fnamemodify(l:path, ':p')
    " 如果是文件则取其所在目录
    if get(l:node, 'isDirectory', 0) != 1
        let l:path = fnamemodify(l:path, ':h')
    endif
    " 确保路径以 / 结尾（表示目录）
    if l:path !~# '/$'
        let l:path .= '/'
    endif
    " 调用 LeaderF 搜索该目录
    execute 'Leaderf file ' . fnameescape(l:path)
endfunction
"
"" + 需求：在 Tagbar 中选中标签后，用 leaderF 快速定位到定义位置
"" Tagbar 中按 <Leader>f 触发 leaderF 搜索标签
"" autocmd FileType tagbar nnoremap <buffer> <Leader>f :call LeaderfTagbar()<CR>
"function! LeaderfTagbar()
"  let l:tag = b:tagbar_current_tag
"  if !empty(l:tag)
"    execute 'Leaderf tag -name ' . shellescape(l:tag)
"  endif
"endfunction
"

" ===
" === gutentags
" ===
"在常规的使用ctags生成tag标签文件实现跳转的方式下，每次需要更新tags文件时都需要手工运行 ctags -R 生成当前项目所有源文件对应的tag标签文件
"当工程文件多、文件更新频繁时，上述生成tags文件的方法显得笨拙、低效
"vim-gutentags能够自动异步生成 tags 文件，当检测到同一个工程下面的文件有修改时，gutentags能自动增量更新对应工程的 tags 文件，而不用全部重新生成tags文件
"变量 gutentags_project_root是vim-gutentags提供的用于搜索工程目录的标志，gutentags插件启动后，会从文件当前路径递归往上查找
"gutentags_project_root中指定的文件或目录名，直到第一次找到对应目标文件或目录名停止。若没有找到
"gutentags_project_root 变量指定的文件或目录名，则gutentags不会生成tag文件
"sudo apt-get install exuberant-ctags 
"应当在工程的顶层目录touch
".project，以便在~/.cache/tags下面生成.tags，leaderF按tag搜索时会使用到
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']
" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'
" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
	silent! call mkdir(s:vim_tags, 'p')
endif
" 允许 gutentags 打开一些高级命令和选项,便于出错时追踪
" 运行 “:GutentagsToggleTrace”命令打开日志
" 保存一下当前出错的文件，触发ctags数据库更新，将会看到错误日志，方便定位
let g:gutentags_define_advanced_commands = 1
" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

"--------------------------------- 
" coc.nvim: 补全插件
" --------------------------------
" 部署步骤
"一. Ubuntu 自带的 Vim 版本通常较低（如 8.1 或 8.2），而许多现代插件（如 YouCompleteMe，coc.nvim）要求 Vim 9.0 以上版本才能运行 
" 1. 添加 PPA 源: sudo add-apt-repository ppa:jonathonf/vim -y
" 2. sudo apt update
" 3. sudo apt install vim
" 4. vim --version
"
"二. 安装 Node.js （必需依赖）
" 1. curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
" 2. sudo apt install -y nodejs   安装后 node -v  # 验证版本 ≥16.18.0 
" 
"三. 安装编译工具链
" 1. sudo apt install build-essential cmake clang gdb # 基础编译工具 
" 2. sudo apt install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf # 如果你需要交叉编译，还需要安装相应的交叉编译器
" 3. sudo apt install bear  # 用于生成 compile_commands.json 
"
"四. 安装clangd语言支持（clangd 是目前最流行、性能最好的 C/C++ LSP 服务器之一，由 LLVM 项目维护）
" 1. sudo apt install clangd-15  # Ubuntu 22.04+ 直接安装 
" 2. sudo ln -sf /usr/bin/clangd-15 /usr/bin/clangd # 通常创建一个符号链接，让coc 能找到 clangd，或者在 CocConfig 中指定路径
" 
"五. 为项目生成 compile_commands.json （关键！）
" clangd 需要知道你的项目如何编译（包含哪些头文件，定义了哪些宏）。对于简单的项目，它可能能自动推断。
" 对于复杂的嵌入式项目，你需要创建一个 compile_commands.json 文件，这是标准的 JSON 编译数据库格式
" 你可以通过以下方式生成：
" 1. CMake项目： 
" 在 cmake 配置时加上 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON 选项，它会在构建目录下生成 compile_commands.json
" 然后将其复制到项目根目录或 coc-settings.json 指定的位置
" + mkdir build && cd build 
" + cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
" + ln -s $PWD/compile_commands.json  ../
" 2. Makefile项目：
" + bear -- make clean all # 自动生成 compile_commands.json  
" 3. 手动编写 compile_flags.txt: 如果没有 compile_commands.json，clangd 会尝试读取项目根目录下的 compile_flags.txt 文件，每行一个编译标志（如 -I/path/to/include, -DDEFINE_NAME）
" 
"六. 在vim中部署coc.nvim
" 1. Plug 'neoclide/coc.nvim', {'branch': 'release'}
" 2. 对coc.nvim插件进行各种配置包括快捷键映射等
"
"六. 为 coc.nvim 添加 C/C++ 扩展，配置 C/C++ 语言支持 (针对嵌入式)
" 1. :CocInstall coc-clangd coc-cmake  # 核心扩展 
" 2. :CocInstall coc-snippets  # 代码片段支持
" 3. 创建 coc-settings.json
" (1) 在你的项目根目录（或 ～/.config/nvim/ 作为全局配置）创建 .vim/coc-settings.json 文件。这个文件允许你为 coc.nvim 及其扩展进行项目级或全局的配置。
" {
"  // coc-clangd 配置
"  "clangd.path": "/usr/bin/clangd", // 指定 clangd 可执行文件路径 (如果需要)
"  "clangd.fallbackFlags": [
"    "-std=c11",
"    "-Wall",
"    "-Wextra",
"    "-I/usr/include",
"    // 添加你的嵌入式系统头文件路径
"    // "-I/path/to/your/embedded/toolchain/sysroot/usr/include",
"    // "-I/path/to/your/project/include",
"    // 定义必要的宏
"    // "-D__EMBEDDED_TARGET__",
"    // "-D_GNU_SOURCE"
"  ],
"  // clangd 会优先查找 compile_commands.json，如果找不到再用 fallbackFlags
"  "clangd.arguments": [
"    "--header-insertion=never", // 阻止 clangd 自动插入头文件
"    "--clang-tidy",             // 启用 clang-tidy (需要安装 clang-tidy)
"    "--completion-style=detailed" // 补全详情
"  ]
"} 
"其中：
"- fallbackFlags: 当 compile_commands.json 不存在时，clangd 会使用这里的标志。务必根据你的嵌入式项目添加正确的 -I 头文件路径和 -D 宏定义
"- compile_commands.json: 这是处理复杂项目的首选方法，确保它位于项目根目录。
"或在 coc-settings.json 中通过 clangd.arguments 指定其位置（例如 --compile-commands-dir=/path/to/build/dir）
"- 如果你使用交叉编译器，确保 fallbackFlags 中包含了正确的 sysroot (--sysroot=/path/to/target/sysroot) 和目标架构相关的标志。
"
"(2)安装 coc-clangd 扩展 (可选，但推荐):
"+ 如果你没有在 g:coc_global_extensions 中列出 coc-clangd，或者想手动管理，可以在 Vim/Neovim 中运行：:CocInstall coc-clangd
"+ 这个扩展会增强 clangd 与 coc.nvim 的集成
"
"(3)测试：
"- 打开一个 .c 或 .cpp 文件。
"- 尝试输入一些代码，看看是否有补全提示 (<Tab> 导航)。
"- 将光标放在一个函数名上，按 gd 尝试跳转到定义
"- 检查状态栏或运行 :CocList diagnostics 查看是否有语法或语义错误报告
"
"七. 后续优化建议
"+ .gitignore: 将 .vim/coc-settings.json 加入 .gitignore，因为它是环境相关的
"+ 探索更多 coc.nvim 扩展: :h coc-extension 了解如何查找和安装其他语言支持或工具
"
" --- coc.nvim 基础配置 ---
" 键位映射 (示例，可根据喜好调整)
" 使用 <Tab> 和 <S-Tab> 在补全菜单中导航
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ CheckBackspace() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"function! CheckBackspace() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =～# '\s'
"endfunction
"" 回车键确认补全项，并退出插入模式 (可选)
"inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
"" 自动补全设置
"set completeopt=menuone,noinsert,noselect
"" 更多补全选项 (可选)
"set shortmess+=c
"" 开启虚拟文本显示诊断信息 (LSP 诊断信息会显示在代码右侧)
"" coc-clangd 会自动尝试启动 clangd，如果 clangd 已安装且在 PATH 中
"" 如果 clangd 不在 PATH 或有特定需求，可在 coc-settings.json 中指定
"let g:coc_global_extensions = ['coc-clangd', 'coc-lists'] " 自动安装这些扩展
"" 显示错误或警告信息 (K)
"function! ShowDocumentation()
"  if CocAction('hasProvider', 'hover')
"    call CocActionAsync('doHover')
"  else
"    call feedkeys('K', 'in')
"  endif
"endfunction
"" 高亮当前光标下的符号 (默认开启)
"autocmd CursorHold * silent call CocActionAsync('highlight')
"" --- coc.nvim 配置优化 ---
"" 1. 优化补全行为，减少实时触发
"" 延迟补全触发，避免输入每个字符都触发
"set updatetime=300 " 默认 4000ms, 减少到 300ms 可以更快响应，但也可能增加后台负载
"" 关键：只在输入特定字符时触发补全，而不是任何字母数字
"" 手动触发补全的快捷键
"" inoremap <silent><expr> <c-space> coc#refresh() 
"" 或者，更精细地控制触发时机（例如只在 . -> :: 后触发）
"" inoremap <silent><expr> . coc#on_input_key('coc#refresh()', '.')
"" inoremap <silent><expr> > coc#on_input_key('coc#refresh()', '>')
"" noremap <silent><expr> : coc#on_input_key('coc#refresh()', ':')
"" 2. 限制补全菜单的长度和刷新频率
"" 在补全菜单打开时，减少按键响应延迟
"set ttimeoutlen=0
"" 但这可能导致 <Esc> 延迟，可以试试 set timeoutlen=1000, ttimeoutlen=0
" 3. 控制 CocList 的行为（如果使用频繁）
" 减少 CocList 搜索结果的数量（如果适用）
" 限制预览高度，减少渲染压力
" let g:coc_preferences_maxPreviewHeight = 5 
" 4. 禁用不必要的高亮/功能
" 如果不需要悬停信息，可以禁用
" autocmd CursorHoldI * silent! call CocActionAsync('doHover')
" autocmd CursorHold * silent! call CocActionAsync('doHover')
" 5. 调整 Node.js 后台进程
" coc.nvim 会启动一个 Node.js 服务，有时可能需要清理
" 你可以定期运行 :CocRestart 来重启服务，但这只是临时措施
" 6. 配置语言服务器参数（针对 clangd）
" 在你的 .vim/coc-settings.json 中添加或修改:
" {
"   "clangd.arguments": [
"     "--background-index",  // 后台索引，可能耗资源，对于超大项目可以考虑关闭
"     "--limit-results=50",  // 限制补全结果数量
"     "--malloc-trim",       // 尝试减少内存使用
"     "--pch-storage=memory", // 使用内存存储预编译头 (如果内存充足)
"     "--header-insertion=never" // 禁用自动头文件插入
"   ],
"   // 控制诊断信息的延迟
"   "diagnostic.refreshOnInsertMode": false,
"   "diagnostic.virtualTextDelay": 1000, // 虚拟文本延迟显示
"   // 控制补全排序
"   "suggest.enablePreselect": false, // 不预先选择补全项
"   "suggest.snippetIndicator": "",   // 移除 snippet 指示符
"   "suggest.triggerAfterInsertEnter": false, // 光标进入插入模式时不触发补全
"   "suggest.detailMaxLength": 50, // 限制补全详情的最大长度
"   "suggest.maxCompleteItemCount": 50 // 限制最大补全项数量
" }

"--------------------------------- 
" vim-which-key核心配置
" --------------------------------

" ===
" === vim-which-key
" ===
let g:mapleader = "\<Space>"		" 使用SPC作为leader key来触发vim-which-key
let g:maplocalleader = ','	      	" 使用,作为localleader key来触发vim-which-key
let g:which_key_use_floating_win = 0  	" 关闭浮动窗口显示提示
let g:which_key_position = 'bottom'   	" 提示窗口位置
let g:which_key_ignore_outside_mappings = 1	" 隐藏描述字典元素之外的所有映射
" 快捷键提示延迟（毫秒） 类似于‘ timeoutlen ’，但特别针对vim-which键。默认是与选项‘ timeoutlen ’相同
let g:which_key_timeout = 300
" 当key被触发时退出which-key。例如，使用‘ <C-G> ’退出,默认ESC
" let g:which_key_exit = "\<C-G>"
" :<c-u>在命令行模式下执行命令前，先清除命令行区域可能存在的数字范围（如 :'<,'>），确保命令干净执行
" WhichKey '<Space>'调用 which-key 插件的 WhichKey 函数，并告诉它当前配置的全局 <leader> 键是 <Space>。
" 当你按下 <Space>（即你的全局 <leader> 键）时，which-key 会弹出一个浮动窗口（或底部窗口），列出所有以 <Space> 开头的后续按键组合及其对应的功能描述。
" 当你按下 ,（即你的 <localleader> 键）时，which-key 会弹出一个窗口，列出所有以 , 开头的后续按键组合及其对应的功能描述
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey ','<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ','<CR>
"""""""""""""""""""""" SPC前导键 """"""""""""""""""""""""
"顶层菜单
let g:which_key_space_map = {} " 顶层菜单字典
let g:which_key_space_map['name'] = 'SPC Leader Key' " 顶层菜单名称
let g:which_key_space_map['q'] = [':q!', '退出当前窗口']
let g:which_key_space_map['m'] = [':FloatermNew', '创建终端']
let g:which_key_space_map['j'] = ['<Plug>(easymotion-overwin-f)', '跳转']
" 系统菜单
let g:which_key_space_map['o'] = {}
let g:which_key_space_map['o']['name'] = '系统操作'
let g:which_key_space_map['o']['p'] = [':e $MYVIMRC', '打开vimrc']
let g:which_key_space_map['o']['r'] = [':source $MYVIMRC', '更新vimrc']
let g:which_key_space_map['o']['I'] = [':PlugInstall', '插件安装']
let g:which_key_space_map['o']['U'] = [':PlugUpdate', '插件更新']
let g:which_key_space_map['o']['C'] = [':PlugClean', '插件清理']
let g:which_key_space_map['o']['t'] = [':Leaderf colorscheme', '更换主题']
let g:which_key_space_map['o']['q'] = [':qa!', '退出vim']
" 窗口菜单
let g:which_key_space_map['w'] = {}
let g:which_key_space_map['w']['name'] = '窗口操作'
let g:which_key_space_map['w']['v'] = [':vsplit', '垂直分割']
let g:which_key_space_map['w']['h'] = [':split', '水平分割']
let g:which_key_space_map['w']['<Left>'] = ['<C-w>h', '左边窗口']
let g:which_key_space_map['w']['<Right>'] = ['<C-w>l', '右边窗口']
let g:which_key_space_map['w']['<Up>'] = ['<C-w>k', '上面窗口']
let g:which_key_space_map['w']['<Down>'] = ['<C-w>j', '下面窗口']
let g:which_key_space_map['w']['o'] = ['<C-w>o', '关闭其余窗口']
let g:which_key_space_map['w']['j'] = [':res +10<CR>', '水平扩大窗口']
let g:which_key_space_map['w']['k'] = [':res -10<CR>', '水平缩小窗口']
let g:which_key_space_map['w']['l'] = [':vertical resize+10<CR>', '垂直方向扩大窗口']
let g:which_key_space_map['w']['h'] = [':vertical resize-10<CR>', '垂直方向缩小窗口']
let g:which_key_space_map['w']['w'] = [':w!', '保存窗口']
let g:which_key_space_map['w']['q'] = [':wq!', '保存并退出窗口']
" 目录操作
let g:which_key_space_map['d'] = {}
let g:which_key_space_map['d']['name'] = '目录操作'
let g:which_key_space_map['d']['t'] = [':Fern -drawer . -reveal=% -toggle', '触发Fern目录']
let g:which_key_space_map['d']['r'] = [':Ranger', '触发Ranger目录']

" 补全与跳转菜单(coc.nvim)
let g:which_key_space_map['c'] = {}
let g:which_key_space_map['c']['name'] = '补全操作'
let g:which_key_space_map['c']['r'] = [':Leaderf rg', '当前工程内搜索内容']
let g:which_key_space_map['c']['r'] = [':Leaderf rg', '当前工程内搜索内容']
let g:which_key_space_map['c']['r'] = [':Leaderf rg', '当前工程内搜索内容']
let g:which_key_space_map['c']['r'] = [':Leaderf rg', '当前工程内搜索内容']
let g:which_key_space_map['c']['r'] = [':Leaderf rg', '当前工程内搜索内容']
let g:which_key_space_map['c']['r'] = [':Leaderf rg', '当前工程内搜索内容']
" 跳转菜单(coc.nvim)
let g:which_key_space_map['g'] = {}
let g:which_key_space_map['g']['name'] = '跳转操作'
let g:which_key_space_map['g']['d'] = ['<Plug>(coc-definition)', '跳转到定义']
let g:which_key_space_map['g']['D'] = ['<Plug>(coc-declaration)', '跳转到声明']
let g:which_key_space_map['g']['r'] = ['<Plug>(coc-references)', '查找引用']
let g:which_key_space_map['g']['y'] = ['<Plug>(coc-type-definition)', '显示代码结构大纲']
let g:which_key_space_map['g']['n'] = ['<Plug>(coc-rename)', '重命名符号']
let g:which_key_space_map['g']['m'] = ['<Plug>(coc-format-selected)', '格式化当前行']

" 目录树菜单
let g:which_key_space_map['t'] = {}
let g:which_key_space_map['t']['name'] = '目录树'
let g:which_key_space_map['t']['t'] = [':NERDTreeToggle<CR>', '目录树触发']
" 搜索菜单
let g:which_key_space_map['s'] = {}
let g:which_key_space_map['s']['name'] = '搜索'
let g:which_key_space_map['s']['r'] = [':Leaderf rg', '当前工程内搜索内容']
let g:which_key_space_map['s']['R'] = [':Leaderf rg --cword', '当前工程内搜索光标所在内容']
let g:which_key_space_map['s']['l'] = [':Leaderf line', '当前文件内搜索内容']
let g:which_key_space_map['s']['L'] = [':Leaderf line --cword', '当前文件内搜索光标所在内容']
let g:which_key_space_map['s']['f'] = [':Leaderf file --nameOnly', '当前工程内搜索文件']
let g:which_key_space_map['s']['F'] = [':call NERDTreeLeaderFSearch()', 'NERDTree当前目录下搜索文件']
let g:which_key_space_map['s']['s'] = [':Leaderf self', '查找命令工具箱']
let g:which_key_space_map['s']['c'] = [':Leaderf command', 'vim命令工具箱']
let g:which_key_space_map['s']['h'] = [':Leaderf help', 'vim帮助文档工具箱']
let g:which_key_space_map['s']['n'] = [':Leaderf function', '查找函数']
let g:which_key_space_map['s']['N'] = [':Leaderf function --cword', '查找光标所在函数']
let g:which_key_space_map['s']['m'] = [':Leaderf mru', '最近文件']
let g:which_key_space_map['s']['b'] = [':Leaderf buffer', 'vim buffer切换']
let g:which_key_space_map['s']['B'] = [':Leaderf bufTag', '缓冲Tag查找']
let g:which_key_space_map['s']['w'] = [':Leaderf window', 'vim窗口切换']
let g:which_key_space_map['s']['t'] = [':Leaderf tag', '标签查找(ctags)']
let g:which_key_space_map['s']['T'] = [':Leaderf tag --cword', '当前光标标签查找(ctags)']
let g:which_key_space_map['s']['g'] = [':Leaderf gtags', '标签查找(gtags)']
let g:which_key_space_map['s']['G'] = [':Leaderf gtags --cword', '当前光标标签查找(gtags)']
let g:which_key_space_map['s']['y'] = [':Leaderf cmdHistory', '历史命令查找']
let g:which_key_space_map['s']['Y'] = [':Leaderf searchHistory', '搜索历史查找']
let g:which_key_space_map['s']['e'] = [':Leaderf filetype', '文件类型查找']
let g:which_key_space_map['s']['E'] = [':Leaderf colorscheme', '搜索主题']
let g:which_key_space_map['s']['q'] = [':Leaderf quickfix', 'fix查找']
let g:which_key_space_map['s']['i'] = [':Leaderf loclist', '位置列表查找']
" Git菜单
let g:which_key_space_map['g'] = {}
let g:which_key_space_map['g']['name'] = 'Git操作'
let g:which_key_space_map['g']['s'] = [':w<CR>', '文件搜索']
let g:which_key_space_map['g']['d'] = [':e $MYVIMRC<CR>', '文件目录']
let g:which_key_space_map['g']['d'] = [':e $MYVIMRC<CR>', '文件目录']
" 注册字典到 which-key
call which_key#register('<Space>', g:which_key_space_map, 'n')

"""""""""""""""""""""" Dot前导键 """"""""""""""""""""""""
" 顶层菜单
let g:which_key_dot_map = {}
let g:which_key_dot_map['name'] = 'Dot Leader Key' " 顶层菜单名称
let g:which_key_dot_map['q'] = [':qa!', '退出vim']
let g:which_key_dot_map[','] = [':qa!', '注释']
call which_key#register(',', g:which_key_dot_map, 'n')

"""""""""""""""""""""" Visual模式下,SPC前导键和Dot前导键 """"""""""""""""""""""""
let g:which_key_visual_map = {}
let g:which_key_visual_map['name'] = 'Visual Leader Key' " 顶层菜单名称
let g:which_key_visual_map['q'] = [':qa!', '退出vim']
let g:which_key_visual_map['s'] = {}
let g:which_key_visual_map['s']['name'] = '搜索'
let g:which_key_visual_map['s']['r'] = [':call LeaderfSearchSelected(''rg'')<CR>', '当前工程内搜索内容']
let g:which_key_visual_map['s']['l'] = [':call LeaderfSearchSelected(''line'')<CR>', '当前文件内搜索内容']
let g:which_key_visual_map['s']['g'] = [':call LeaderfSearchSelected(''function'')<CR>', '查找函数']
let g:which_key_visual_map['s']['t'] = [':call LeaderfSearchSelected(''tag'')<CR>', '标签查找(ctags)']
let g:which_key_visual_map['s']['a'] = [':call LeaderfSearchSelected(''gtags'')<CR>', '标签查找(gtags)']

let g:which_key_visual_map[','] = ['<plug>NERDCommenterToggle', '注释']
let g:which_key_visual_map['-'] = [':qa!', '折叠']
let g:which_key_visual_map['='] = [':qa!', '展开']
let g:which_key_visual_map['；'] = [':qa!', '缩进']
call which_key#register('<Space>', g:which_key_visual_map, 'v')
call which_key#register(',', g:which_key_visual_map, 'v')



" ... 你之前的键位映射等配置 ...
"
"" 跳转到定义 (gd)
"nmap <silent> gd <Plug>(coc-definition)
"" 跳转到声明 (gD)
"nmap <silent> gD <Plug>(coc-declaration)
"" 查找引用 (gr)
"nmap <silent> gr <Plug>(clc-references)
"" 显示代码结构大纲 (gy)
"nmap <silent> gy <Plug>(coc-type-definition)
"" 重命名符号 (rn)
"nmap <silent> rn <Plug>(coc-rename)
"" 格式化当前行或选中区域 (空格键触发)
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
"" 如果没有设置 leader 键，默认是 `\`。可以设置为空格:
"" let mapleader=' '
"" 或者设置为逗号:
"let mapleader = ','
"" 获取代码动作 (如快速修复) (ca)
"nmap <leader>ac <Plug>(coc-codeaction-cursor)
"" 对整个文档应用代码动作
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-line)
"" 显示错误或警告信息 (K)
"nmap <silent> K :call ShowDocumentation()<CR>
"" coc-lists 相关 (用于显示诊断、符号列表等)
"" 搜索项目中的符号 (空格 o t)
"nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
"" 搜索工作区符号 (空格 o s)
"nnoremap <silent> <space>os :<C-u>CocList -I symbols<cr>
"" 搜索文件 (空格 f f)
"nnoremap <silent> <space>ff :<C-u>CocList files<cr>
"" 搜索历史打开的文件 (space f r)
"nnoremap <silent> <space>fr :<C-u>CocList history<cr>
"" 搜索诊断问题 (空格 d d)
"nnoremap <silent> <space>dd :<C-u>CocList diagnostics<cr>
"
"
"
"
"
"
"
