package OScriptVariant
import  mem "core:mem"

buddy_allocator     :: mem.Buddy_Allocator
buddy_initializer   :: mem.buddy_allocator_init//(&ba,bf[:],8)
get_buddy_allocator :: mem.buddy_allocator

Allocator           :: mem.Allocator

Kilobyte            :: mem.Kilobyte
Megabyte            :: mem.Megabyte
Gigabyte            :: mem.Gigabyte


@(private="file") bf                : [16*Megabyte]byte
@(private="file") current_buddy     : buddy_allocator
@(private="file") current_allocator : Allocator

init_alloc :: proc(){ 
	buddy_initializer(&current_buddy,bf[:],8)
	current_allocator = get_buddy_allocator(&current_buddy)
}

memnew        :: #force_inline proc ($T: typeid) -> ^T { ptr := new(T,current_allocator); assert( ptr != nil ,"Value is nullptr, increase the Pool's size"); return ptr }
memfree       :: #force_inline proc (K: ^$T) { free(K,current_allocator) }
get_allocator :: #force_inline proc() -> Allocator { return current_allocator }