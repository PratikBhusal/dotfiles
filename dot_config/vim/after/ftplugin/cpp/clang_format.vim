vnoremap <buffer> <Leader>cf :ClangFormat<CR>
nnoremap <buffer> <Leader>cf :ClangFormat<CR>

let g:clang_format#code_style = 'llvm'
let g:clang_format#style_options = {
    \ 'AccessModifierOffset': -4,
    \ 'ColumnLimit': 80,
    \ 'AlignConsecutiveAssignments': 'true',
    \ 'AlignConsecutiveDeclarations': 'true',
    \ 'AlignTrailingComments': 'true',
    \ 'AllowShortIfStatementsOnASingleLine': 'true',
    \ 'AllowShortLoopsOnASingleLine': 'true',
    \ 'AlwaysBreakTemplateDeclarations': 'true',
    \ 'BraceWrapping': {
        \ 'AfterClass': 'false',
        \ 'AfterControlStatement': 'false',
        \ 'AfterEnum': 'true',
        \ 'AfterFunction': 'true',
        \ 'AfterNamespace': 'true',
        \ 'AfterStruct': 'true',
        \ 'AfterUnion': 'true',
        \ 'BeforeCatch': 'true',
        \ 'BeforeElse': 'true'},
    \ 'BreakBeforeBinaryOperators': 'All',
    \ 'BreakBeforeBraces': 'Custom',
    \ 'BreakBeforeTernaryOperators': 'true',
    \ 'BreakStringLiterals': 'false',
    \ 'PointerAlignment': 'Left',
    \ 'SortIncludes': 'true',
    \ 'SpaceBeforeAssignmentOperators': 'true',
    \ 'SpaceBeforeParens': 'ControlStatements',
    \ 'Standard': 'Cpp11',
    \ 'UseTab': 'Never'}
