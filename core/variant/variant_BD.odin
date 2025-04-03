package OScriptVariant


initBD :: proc(allocator : Allocator) 
{
	init_functionBD(allocator)
	init_classBD(allocator)
	init_importBD(allocator)
	init_global_symbol_BD(allocator)
}