if exists("b:current_syntax")
  finish
endif

syntax keyword genUsing using
syntax keyword genAs as
syntax keyword genNew new
syntax keyword genDistinct distinct

syntax keyword genStruct struct
syntax keyword genEnum enum
syntax keyword genUnion union

syntax keyword genIf if
syntax keyword genElse else
syntax keyword genFor for
syntax keyword genWhile while
syntax keyword genSwitch switch
syntax keyword genCase case
syntax keyword genContinue continue
syntax keyword genAgain again
syntax keyword genFallthrough fallthrough
syntax keyword genBreak break
syntax keyword genSizeOf size_of
syntax keyword genOffsetOf offset_of
syntax keyword genTypeInfoOf type_info_of
syntax keyword genTypeIdOf typeid_of
syntax keyword genTypeOf type_of
syntax keyword genAlignOf align_of

syntax keyword genInline inline
syntax keyword genNoInline no_inline

syntax match genTodo "TODO"
syntax match genNote "NOTE"
syntax match genXXX "XXX"
syntax match genFixMe "FIXME"
syntax match genNoCheckin "NOCHECKIN"
syntax match genHack "HACK"

syntax keyword genDataType string bool any f32 f64 u8 u16 u32 u64 u128 uint uptr i8 i16 i32 i64 int iptr void float double
syntax keyword genBool true false
syntax keyword genNull nil
syntax keyword genFn fn
syntax keyword genAlias alias
syntax keyword genImport import
syntax keyword genExport export
syntax keyword genForeign foreign
syntax keyword genConst const
syntax keyword genVar var
syntax keyword genInternal internal

syntax match genNoinit "---"
syntax match genPound "#\w\+"

syntax match genTemplate "$\<\w\+\>"

syntax keyword genReturn return
syntax keyword genDefer defer

syntax region genChar start=/\v'/ skip=/\v\\./ end=/\v/
syntax region genString start=/\v"/ skip=/\v\\./ end=/\v"/

syntax match genFunction "fn\s*\<\w\+\>\s*("
syntax match genTagNote "@\<\w\+\>" display
syntax match genConstant "\v<[A-Z0-9,_]+>" display
syntax match genClass "\v<[A-Z]\w+>" display
syntax match genReturnOp "->" display

syntax match genInteger "\-\?\<\d\+\>" display
syntax match genFloat "\-\?\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=" display
syntax match genHex "\<0[xX][0-9A-Fa-f]\+\>" display
syntax match genDoz "\<0[zZ][0-9a-bA-B]\+\>" display
syntax match genOct "\<0[oO][0-7]\+\>" display
syntax match genBin "\<0[bB][01]\+\>" display

syntax match genAddressOf "&" display

syntax match genCommentNote "@\<\w\+\>" contained display
syntax region genLineComment start=/\/\// end=/$/  contains=genLineComment, genCommentNote, genTodo, genNote, genXXX, genFixMe, genNoCheckin, genHack
syntax region genBlockComment start=/\v\/\*/ end=/\v\*\// contains=genBlockComment, genCommentNote, genTodo, genNote, genXXX, genFixMe, genNoCheckin, genHack

highlight link genUsing Keyword
highlight link genTransmute Keyword
highlight link genCast Keyword
highlight link genDistinct Keyword
highlight link genOpaque Keyword
highlight link genReturn Keyword
highlight link genSwitch Keyword
highlight link genCase Keyword
highlight link genFn Keyword
highlight link genAlias Keyword
highlight link genContinue Keyword
highlight link genAgain Keyword
highlight link genFallthrough Keyword
highlight link genBreak Keyword
highlight link genSizeOf Keyword
highlight link genOffsetOf Keyword
highlight link genTypeOf Keyword
highlight link genTypeInfoOf Keyword
highlight link genTypeIdOf Keyword
highlight link genAlignOf Keyword
highlight link genAs Keyword
highlight link genNew Keyword

highlight link genInline Keyword
highlight link genNoInline Keyword

highlight link genImport Keyword
highlight link genExport Keyword
highlight link genForeign Keyword
highlight link genConst Keyword
highlight link genVar Keyword
highlight link genNoinit Keyword
highlight link genInternal Keyword
highlight link genPound Keyword
highlight link genDo Keyword

highlight link genDefer Keyword
highlight link genDynamic Operator
highlight link genAddressOf Operator
highlight link genDeref Operator
highlight link genReturnOp Operator

highlight link genString String
highlight link genChar String

highlight link genStruct Keyword
highlight link genEnum Keyword
highlight link genUnion Keyword

highlight link genFunction Function

highlight link genIf Conditional
highlight link genElse Conditional
highlight link genFor Repeat
highlight link genWhile Repeat

highlight link genLineComment Comment
highlight link genBlockComment Comment
highlight link genCommentNote Todo

highlight link genTodo Todo
highlight link genNote Todo
highlight link genXXX Todo
highlight link genFixMe Todo
highlight link genNoCheckin Todo
highlight link genHack Todo

highlight link genTemplate Constant

highlight link genTagNote Identifier
highlight link genConstant Constant
highlight link genClass Type

highlight link genDataType Type
highlight link genBool Boolean
highlight link genNull Type
highlight link genInteger Number
highlight link genFloat Float
highlight link genHex Number
highlight link genOct Number
highlight link genBin Number
highlight link genDoz Number

let b:current_syntax = "gen"
