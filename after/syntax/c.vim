syntax match hbCType "\v<[A-Z]\w+>" display
syntax match hbCConstant "\v<[A-Z][A-Z0-9_]+>" display

hi link hbCConstant Macro
hi link hbCType		Type

syn keyword	cType		u8 u16 u32 u64
syn keyword	cType		i8 i16 i32 i64
syn keyword	cType		iptr uptr
