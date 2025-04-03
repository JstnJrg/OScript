
package OScriptVariant

GlobalSymbol       :: struct { str : string ,hash: u32 }
SymbolsMap         :: map[string]GlobalSymbol
SymbolMemory       ::[dynamic]GlobalSymbol

// Nota(jstn): é um id para um 
GlobalSymbolID     :: Uint

SymbolTable        :: struct  
{
	gsid          : GlobalSymbol, 
	symbol_memory : SymbolMemory          
	// symbols_map  : SymbolsMap,
}


@(private="file") variant_global_symbols  : ^SymbolTable
@(private="file") current_symbl_allocator :  Allocator

@private
init_global_symbol_BD :: proc(alloc : Allocator) 
{
	current_symbl_allocator = alloc
	vgs                    := new(SymbolTable,alloc)

	assert(vgs != nil, "SymbolTable is nullptr.")
	vgs.symbol_memory      = make(SymbolMemory,alloc)
	variant_global_symbols = vgs
}


// register_symbol_BD :: proc(symbol : string) -> (has_symbol: bool, hash : u32) {
// 	hash, has_symbol := variant_global_symbols[symbol]
// 	if has_symbol do return

// 	sym := str_clone(symbol,current_symbl_allocator)
// 	variant_global_symbols[sym] = GlobalSymbol{hash = hash_string(sym)}
// 	return 
// }

register_symbol_BD :: proc(symbol : string) -> GlobalSymbolID {

	for &gs,indx in variant_global_symbols.symbol_memory do if gs.str == symbol do return GlobalSymbolID(indx)

	vgssm := &variant_global_symbols.symbol_memory
	sym   := str_clone(symbol,current_symbl_allocator)
	gsym  := GlobalSymbol{sym,hash_string(sym)}

	append(vgssm,gsym)
	return GlobalSymbolID(len(vgssm)-1)
}


// Nota(jstn): não há validação, pois presume-se que  ID está correcto
get_symbol_str_BD   :: #force_inline proc "contextless" (id: GlobalSymbolID ) -> string { return variant_global_symbols.symbol_memory[id].str  }
get_symbol_hash_BD  :: #force_inline proc "contextless" (id: GlobalSymbolID ) -> u32    { return variant_global_symbols.symbol_memory[id].hash }

get_symbol_gsid_BD :: proc "contextless" (str : string ) -> (bool,GlobalSymbolID) 
{ 
	for &gs,indx in variant_global_symbols.symbol_memory do if gs.str == str do return true,GlobalSymbolID(indx)
	return false,GlobalSymbolID(0)
}
