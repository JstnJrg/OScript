package OScriptVariant

// import fmt 	  "core:fmt"

DISPACTH_FUNCTION 	 :: #type proc(op: OpCode, type_a, type_b: ValueType)
EVALUATE_FUNCTION	 :: #type proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError)

// Nota(jstn): table usada para guardar as devidas funcoes com base no tipo
dispatch_table       : [OpCode.OP_OPERATOR_COUNT][ValueType][ValueType]EVALUATE_FUNCTION


// Nota(jstn): registra as funcoes a serem chamadas
register_variant_operators :: proc(){

	// Bool
	register_op(.OP_EQUAL,.BOOL_VAL,.BOOL_VAL,evaluate_bool_bool_equal)
	register_op(.OP_NOT_EQUAL,.BOOL_VAL,.BOOL_VAL,evaluate_bool_bool_not_equal)


	// FLOAT
	register_op(.OP_NEGATE,.FLOAT_VAL,.NONE_VAL,evaluate_float_negate)
	// register_op(.OP_POSITIVE,.FLOAT_VAL,.NONE_VAL,evaluate_float_positive)

	register_op(.OP_ADD,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_add)
	register_op(.OP_SUB,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_sub)
	register_op(.OP_MULT,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_mult)
	register_op(.OP_DIV,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_div)

	register_op(.OP_LESS,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_less)
	register_op(.OP_GREATER,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_greater)
	register_op(.OP_EQUAL,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_equal)

	register_op(.OP_LESS_EQUAL,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_less_equal)
	register_op(.OP_GREATER_EQUAL,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_greater_equal)
	register_op(.OP_NOT_EQUAL,.FLOAT_VAL,.FLOAT_VAL,evaluate_float_float_not_equal)



	// INT
	register_op(.OP_NEGATE,.INT_VAL,.NONE_VAL,evaluate_int_negate)

	register_op(.OP_ADD,.INT_VAL,.INT_VAL,evaluate_int_int_add)
	register_op(.OP_SUB,.INT_VAL,.INT_VAL,evaluate_int_int_sub)
	register_op(.OP_MULT,.INT_VAL,.INT_VAL,evaluate_int_int_mult)
	register_op(.OP_DIV,.INT_VAL,.INT_VAL,evaluate_int_int_div)
	register_op(.OP_MOD,.INT_VAL,.INT_VAL,evaluate_int_int_mod)

	register_op(.OP_LESS,.INT_VAL,.INT_VAL,evaluate_int_int_less)
	register_op(.OP_GREATER,.INT_VAL,.INT_VAL,evaluate_int_int_greater)
	register_op(.OP_EQUAL,.INT_VAL,.INT_VAL,evaluate_int_int_equal)


	register_op(.OP_LESS_EQUAL,.INT_VAL,.INT_VAL,evaluate_int_int_less_equal)
	register_op(.OP_GREATER_EQUAL,.INT_VAL,.INT_VAL,evaluate_int_int_greater_equal)
	register_op(.OP_NOT_EQUAL,.INT_VAL,.INT_VAL,evaluate_int_int_not_equal)


	// INT BIT
	register_op(.OP_BIT_NEGATE,.INT_VAL,.NONE_VAL,evaluate_int_bit_negate)
	register_op(.OP_BIT_AND,.INT_VAL,.INT_VAL,evaluate_int_int_bit_and)
	register_op(.OP_BIT_OR,.INT_VAL,.INT_VAL,evaluate_int_int_bit_or)
	register_op(.OP_BIT_XOR,.INT_VAL,.INT_VAL,evaluate_int_int_bit_xor)
	register_op(.OP_SHIFT_LEFT,.INT_VAL,.INT_VAL,evaluate_int_int_bit_shift_left)
	register_op(.OP_SHIFT_RIGHT,.INT_VAL,.INT_VAL,evaluate_int_int_bit_shift_right)


	// INT, FLOAT
	register_op(.OP_ADD,.INT_VAL,.FLOAT_VAL,evaluate_int_float_add)
	register_op(.OP_SUB,.INT_VAL,.FLOAT_VAL,evaluate_int_float_sub)
	register_op(.OP_MULT,.INT_VAL,.FLOAT_VAL,evaluate_int_float_mult)
	register_op(.OP_DIV,.INT_VAL,.FLOAT_VAL,evaluate_int_float_div)

	
	
	register_op(.OP_LESS,.INT_VAL,.FLOAT_VAL,evaluate_int_float_less)
	register_op(.OP_GREATER,.INT_VAL,.FLOAT_VAL,evaluate_int_float_greater)
	register_op(.OP_EQUAL,.INT_VAL,.FLOAT_VAL,evaluate_int_float_equal)


	register_op(.OP_LESS_EQUAL,.INT_VAL,.FLOAT_VAL,evaluate_int_float_less_equal)
	register_op(.OP_GREATER_EQUAL,.INT_VAL,.FLOAT_VAL,evaluate_int_float_greater_equal)
	register_op(.OP_NOT_EQUAL,.INT_VAL,.FLOAT_VAL,evaluate_int_float_not_equal)


	// FLOAT,INT
	register_op(.OP_ADD,.FLOAT_VAL,.INT_VAL,evaluate_float_int_add)
	register_op(.OP_SUB,.FLOAT_VAL,.INT_VAL,evaluate_float_int_sub)
	register_op(.OP_MULT,.FLOAT_VAL,.INT_VAL,evaluate_float_int_mult)
	register_op(.OP_DIV,.FLOAT_VAL,.INT_VAL,evaluate_float_int_div)

	


	register_op(.OP_LESS,.FLOAT_VAL,.INT_VAL,evaluate_float_int_less)
	register_op(.OP_GREATER,.FLOAT_VAL,.INT_VAL,evaluate_float_int_greater)
	register_op(.OP_EQUAL,.FLOAT_VAL,.INT_VAL,evaluate_float_int_equal)


	register_op(.OP_LESS_EQUAL,.FLOAT_VAL,.INT_VAL,evaluate_float_int_less_equal)
	register_op(.OP_GREATER_EQUAL,.FLOAT_VAL,.INT_VAL,evaluate_float_int_greater_equal)
	register_op(.OP_NOT_EQUAL,.FLOAT_VAL,.INT_VAL,evaluate_float_int_not_equal)


	// VECTOR2
	register_op(.OP_NEGATE,.VECTOR2_VAL,.NONE_VAL,evaluate_vec2_negate)
	// register_op(.OP_POSITIVE,.VECTOR2_VAL,.NONE_VAL,evaluate_vec2_positive)


	register_op(.OP_ADD,.VECTOR2_VAL,.VECTOR2_VAL,evaluate_vec2_vec2_add)
	register_op(.OP_SUB,.VECTOR2_VAL,.VECTOR2_VAL,evaluate_vec2_vec2_sub)
	register_op(.OP_MULT,.VECTOR2_VAL,.VECTOR2_VAL,evaluate_vec2_vec2_mult)
	register_op(.OP_DIV,.VECTOR2_VAL,.VECTOR2_VAL,evaluate_vec2_vec2_div)
	register_op(.OP_EQUAL,.VECTOR2_VAL,.VECTOR2_VAL,evaluate_vec2_vec2_equal)

	//  VECTOR2 AND FLOAT
	register_op(.OP_ADD,.VECTOR2_VAL,.FLOAT_VAL,evaluate_vec2_float_add)
	register_op(.OP_ADD,.FLOAT_VAL,.VECTOR2_VAL,evaluate_float_vec2_add)

	register_op(.OP_SUB,.VECTOR2_VAL,.FLOAT_VAL,evaluate_vec2_float_sub)
	register_op(.OP_SUB,.FLOAT_VAL,.VECTOR2_VAL,evaluate_float_vec2_sub)

	register_op(.OP_DIV,.VECTOR2_VAL,.FLOAT_VAL,evaluate_vec2_float_div)
	register_op(.OP_DIV,.FLOAT_VAL,.VECTOR2_VAL,evaluate_float_vec2_div)

	register_op(.OP_MULT,.VECTOR2_VAL,.FLOAT_VAL,evaluate_vec2_float_mult)
	register_op(.OP_MULT,.FLOAT_VAL,.VECTOR2_VAL,evaluate_float_vec2_mult)

	//  VECTOR2 AND INT
	register_op(.OP_ADD,.VECTOR2_VAL,.INT_VAL,evaluate_vec2_int_add)
	register_op(.OP_ADD,.INT_VAL,.VECTOR2_VAL,evaluate_int_vec2_add)

	register_op(.OP_SUB,.VECTOR2_VAL,.INT_VAL,evaluate_vec2_int_sub)
	register_op(.OP_SUB,.INT_VAL,.VECTOR2_VAL,evaluate_int_vec2_sub)

	register_op(.OP_DIV,.VECTOR2_VAL,.INT_VAL,evaluate_vec2_int_div)
	register_op(.OP_DIV,.INT_VAL,.VECTOR2_VAL,evaluate_int_vec2_div)

	register_op(.OP_MULT,.VECTOR2_VAL,.INT_VAL,evaluate_vec2_int_mult)
	register_op(.OP_MULT,.INT_VAL,.VECTOR2_VAL,evaluate_int_vec2_mult)

	// NIL
	register_op(.OP_EQUAL,.NIL_VAL,.NIL_VAL,evaluate_nil_nil_equal)

	// STRING
	register_op(.OP_EQUAL,.OBJ_STRING,.OBJ_STRING,evaluate_string_string_equal)
	register_op(.OP_LESS,.OBJ_STRING,.OBJ_STRING,evaluate_string_string_less)
	register_op(.OP_LESS_EQUAL,.OBJ_STRING,.OBJ_STRING,evaluate_string_string_less_equal)
	register_op(.OP_GREATER,.OBJ_STRING,.OBJ_STRING,evaluate_string_string_greater)
	register_op(.OP_GREATER_EQUAL,.OBJ_STRING,.OBJ_STRING,evaluate_string_string_greater_equal)



	// Array
	register_op(.OP_GET_INDEXING,.OBJ_ARRAY,.INT_VAL,evaluate_array_indexing)




	// 
	register_fallback()
}



register_op :: proc(op: OpCode, type_left,type_right: ValueType, function: EVALUATE_FUNCTION) { 
	dispatch_table[op][type_left][type_right] = function
}

register_fallback :: proc(){
	for op in OpCode(0)..<OpCode.OP_OPERATOR_COUNT do for type_a in ValueType do for type_b in ValueType 
	{			
		if dispatch_table[op][type_a][type_b] == nil {
			if      op == .OP_EQUAL { dispatch_table[op][type_a][type_b]    = evaluate_variant_variant_equal; continue } // comparação
			else if op == .OP_AND   { dispatch_table[op][type_a][.NONE_VAL] = evaluate_variant_variant_and;   continue } //and, vai ser unaria, pois não quero avaliar lhs e rhs
			else if op == .OP_OR    { dispatch_table[op][type_a][.NONE_VAL] = evaluate_variant_variant_or;    continue } //or, mesmo raciocinio
			else if op == .OP_NOT   { dispatch_table[op][type_a][.NONE_VAL] = evaluate_variant_not;           continue } //not
		}	   
	}
}


get_operator_evaluator  :: #force_inline proc(op: OpCode, type_a,type_b: ValueType) -> EVALUATE_FUNCTION {
	return dispatch_table[op][type_a][type_b]
}

// //if {type_a,.NONE_VAL} in dispacth_compatible else default_fallback
get_operator_evaluator_unary  :: #force_inline proc(op: OpCode, type_a: ValueType) -> EVALUATE_FUNCTION {
	return dispatch_table[op][type_a][ValueType.NONE_VAL]
}

// Nota(jstn): função que é chamada em caso de erro
default_fallback	 :: #force_inline proc(variant_left,variant_right, variant_return : ^Value, has_error: ^bool,  call_error_p : ^ObjectCallError){

	if       variant_right == nil do CALL_ERROR_STRING(call_error_p,"invalid unary operand ",GET_TYPE_PTR(variant_left),".")
	else do  CALL_ERROR_STRING(call_error_p,"invalid operands ",GET_TYPE_PTR(variant_left),"and",GET_TYPE_PTR(variant_right),".")
	has_error^ = true
	BOOL_VAL_PTR(variant_return,false)
}




// ============================================= bool
evaluate_bool_bool_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_BOOL_PTR(variant_left) == AS_BOOL_PTR(variant_right))
}

evaluate_bool_bool_not_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_BOOL_PTR(variant_left) != AS_BOOL_PTR(variant_right))
}





// ============================================ float
evaluate_float_negate :: #force_inline proc(variant_left,_,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,-AS_FLOAT_PTR(variant_left))
}

evaluate_float_positive :: #force_inline proc(variant_left,_,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left))
}

evaluate_float_float_add :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left)+AS_FLOAT_PTR(variant_right))
}

evaluate_float_float_sub :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool, call_error: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left)-AS_FLOAT_PTR(variant_right))
}

evaluate_float_float_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left)*AS_FLOAT_PTR(variant_right))
}

evaluate_float_float_div :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	b := AS_FLOAT_PTR(variant_right)
	if b == 0.0 { CALL_ERROR_STRING(call_error_p,"division by zero error in operator '/'."); has_error^ = true; return}
	FLOAT_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left)/b)
}



evaluate_float_float_less :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) < AS_FLOAT_PTR(variant_right))
}

evaluate_float_float_greater :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) > AS_FLOAT_PTR(variant_right))
}

evaluate_float_float_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) == AS_FLOAT_PTR(variant_right))
}


evaluate_float_float_less_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) <= AS_FLOAT_PTR(variant_right))
}

evaluate_float_float_greater_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) >= AS_FLOAT_PTR(variant_right))
}

evaluate_float_float_not_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) != AS_FLOAT_PTR(variant_right))
}




// ============================================ Int
evaluate_int_negate :: #force_inline proc(variant_left,_,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	INT_VAL_PTR(variant_return,-AS_INT_PTR(variant_left))
}

evaluate_int_positive :: #force_inline proc(variant_left,_,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	INT_VAL_PTR(variant_return,AS_INT_PTR(variant_left))
}

evaluate_int_int_add :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	variant_return^ = INT_VAL(AS_INT_PTR(variant_left)+AS_INT_PTR(variant_right))
}

evaluate_int_int_sub :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool, call_error: ^ObjectCallError){
	INT_VAL_PTR(variant_return,AS_INT_PTR(variant_left)-AS_INT_PTR(variant_right))
}

evaluate_int_int_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	INT_VAL_PTR(variant_return,AS_INT_PTR(variant_left)*AS_INT_PTR(variant_right))
}

evaluate_int_int_div :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	b := AS_INT_PTR(variant_right)
	if b == 0 { CALL_ERROR_STRING(call_error_p,"division by zero error in operator '/'."); has_error^ = true; return}
	INT_VAL_PTR(variant_return,AS_INT_PTR(variant_left)/b)
}

evaluate_int_int_mod :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	
	a 	  := AS_INT_PTR(variant_left)
	b 	  := AS_INT_PTR(variant_right)
	if b == 0  { CALL_ERROR_STRING(call_error_p,"modulo by zero error in operator '%'."); has_error^ = true; return}
	INT_VAL_PTR(variant_return,a%b)
}


evaluate_int_int_bit_and :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	INT_VAL_PTR(variant_return,AS_INT_PTR(variant_left) & AS_INT_PTR(variant_right))
}

evaluate_int_int_bit_or :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	INT_VAL_PTR(variant_return,AS_INT_PTR(variant_left) | AS_INT_PTR(variant_right))
}

evaluate_int_int_bit_xor :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	INT_VAL_PTR(variant_return,AS_INT_PTR(variant_left) ~ AS_INT_PTR(variant_right))
}

evaluate_int_bit_negate :: #force_inline proc(variant_left,_,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	INT_VAL_PTR(variant_return,~AS_INT_PTR(variant_left))
}

evaluate_int_int_bit_shift_left :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	a := AS_INT_PTR(variant_left)
	b := AS_INT_PTR(variant_right)

	if a < 0 || b < 0 { CALL_ERROR_STRING(call_error_p,"Invalid operands for bit shifting. Only positive operands are supported."); has_error^ = true; return}
	INT_VAL_PTR(variant_return, Int(Uint(a) << Uint(b)))
}

evaluate_int_int_bit_shift_right :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	a := AS_INT_PTR(variant_left)
	b := AS_INT_PTR(variant_right)

	if a < 0 || b < 0 { CALL_ERROR_STRING(call_error_p,"Invalid operands for bit shifting. Only positive operands are supported."); has_error^ = true; return}
	INT_VAL_PTR(variant_return,Int(Uint(a) >> Uint(b)))
}


evaluate_int_int_less :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_INT_PTR(variant_left) < AS_INT_PTR(variant_right))
}

evaluate_int_int_greater :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_INT_PTR(variant_left) > AS_INT_PTR(variant_right))
}

evaluate_int_int_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_INT_PTR(variant_left) == AS_INT_PTR(variant_right))
}

evaluate_int_int_less_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_INT_PTR(variant_left) <= AS_INT_PTR(variant_right))
}

evaluate_int_int_greater_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_INT_PTR(variant_left) >= AS_INT_PTR(variant_right))
}

evaluate_int_int_not_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_INT_PTR(variant_left) != AS_INT_PTR(variant_right))
}






// ============================================ Int and float

evaluate_int_float_add :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,Float(AS_INT_PTR(variant_left))+AS_FLOAT_PTR(variant_right))
}

evaluate_int_float_sub :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool, call_error: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,Float(AS_INT_PTR(variant_left))-AS_FLOAT_PTR(variant_right))
}

evaluate_int_float_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,Float(AS_INT_PTR(variant_left))*AS_FLOAT_PTR(variant_right))
}

evaluate_int_float_div :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	b := AS_FLOAT_PTR(variant_right)
	if b == 0.0 { CALL_ERROR_STRING(call_error_p,"division by zero error in operator '/'."); has_error^ = true; return}
	FLOAT_VAL_PTR(variant_return,Float(AS_INT_PTR(variant_left))/b)
}


evaluate_int_float_less :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,Float(AS_INT_PTR(variant_left)) < AS_FLOAT_PTR(variant_right))
}

evaluate_int_float_greater :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,Float(AS_INT_PTR(variant_left)) > AS_FLOAT_PTR(variant_right))
}

evaluate_int_float_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,Float(AS_INT_PTR(variant_left)) == AS_FLOAT_PTR(variant_right))
}


evaluate_int_float_less_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,Float(AS_INT_PTR(variant_left)) <= AS_FLOAT_PTR(variant_right))
}

evaluate_int_float_greater_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,Float(AS_INT_PTR(variant_left)) >= AS_FLOAT_PTR(variant_right))
}

evaluate_int_float_not_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,Float(AS_INT_PTR(variant_left)) != AS_FLOAT_PTR(variant_right))
}








// ============================================ float and Int

evaluate_float_int_add :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left)+Float(AS_INT_PTR(variant_right)))
}

evaluate_float_int_sub :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool, call_error: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left)-Float(AS_INT_PTR(variant_right)))
}

evaluate_float_int_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	FLOAT_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left)*Float(AS_INT_PTR(variant_right)))
}

evaluate_float_int_div :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	b := AS_INT_PTR(variant_right)
	if b == 0 { CALL_ERROR_STRING(call_error_p,"division by zero error in operator '/'."); has_error^ = true; return}
	FLOAT_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left)/Float(b))
}


evaluate_float_int_less :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) < Float(AS_INT_PTR(variant_right)))
}

evaluate_float_int_greater :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) > Float(AS_INT_PTR(variant_right)))
}

evaluate_float_int_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) == Float(AS_INT_PTR(variant_right)))
}


evaluate_float_int_less_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) <= Float(AS_INT_PTR(variant_right)))
}

evaluate_float_int_greater_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) >= Float(AS_INT_PTR(variant_right)))
}

evaluate_float_int_not_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_FLOAT_PTR(variant_left) != Float(AS_INT_PTR(variant_right)))
}






// =================================================== Vector2D

evaluate_vec2_negate     :: #force_inline proc(variant_left,_,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,-AS_VECTOR2_PTRV(variant_left))
} 

evaluate_vec2_positive   :: #force_inline proc(variant_left,_,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left))
}



evaluate_vec2_vec2_add :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)+AS_VECTOR2_PTRV(variant_right))
}

evaluate_vec2_vec2_sub :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)-AS_VECTOR2_PTRV(variant_right))
}

evaluate_vec2_vec2_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)*AS_VECTOR2_PTRV(variant_right))
}

evaluate_vec2_vec2_div :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)/AS_VECTOR2_PTRV(variant_right))
}

evaluate_vec2_vec2_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,AS_VECTOR2_PTRV(variant_left)== AS_VECTOR2_PTRV(variant_right))
}


// =================================================== Vector2D and float

evaluate_vec2_float_add :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)+AS_FLOAT_PTR(variant_right))
}

evaluate_vec2_float_sub :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)-AS_FLOAT_PTR(variant_right))
}

evaluate_vec2_float_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)*AS_FLOAT_PTR(variant_right))
}

evaluate_vec2_float_div :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)/AS_FLOAT_PTR(variant_right))
}




evaluate_float_vec2_add :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_FLOAT_PTR(variant_left)+AS_VECTOR2_PTRV(variant_right))
}

evaluate_float_vec2_sub :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_FLOAT_PTR(variant_left)-AS_VECTOR2_PTRV(variant_right))
}

evaluate_float_vec2_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_FLOAT_PTR(variant_left)*AS_VECTOR2_PTRV(variant_right))
}

evaluate_float_vec2_div :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_FLOAT_PTR(variant_left)/AS_VECTOR2_PTRV(variant_right))
}



// =================================================== Vector2D and int

evaluate_vec2_int_add :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)+Float(AS_INT_PTR(variant_right)))
}

evaluate_vec2_int_sub :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)-Float(AS_INT_PTR(variant_right)))
}

evaluate_vec2_int_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)*Float(AS_INT_PTR(variant_right)))
}

evaluate_vec2_int_div :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)/Float(AS_INT_PTR(variant_right)))
}



evaluate_int_vec2_add :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,Float(AS_INT_PTR(variant_left))+AS_VECTOR2_PTRV(variant_right))
}

evaluate_int_vec2_sub :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,Float(AS_INT_PTR(variant_left))-AS_VECTOR2_PTRV(variant_right))
}

evaluate_int_vec2_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,Float(AS_INT_PTR(variant_left))*AS_VECTOR2_PTRV(variant_right))
}

evaluate_int_vec2_div :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,Float(AS_INT_PTR(variant_left))/AS_VECTOR2_PTRV(variant_right))
}


// =================================================== nil
evaluate_nil_nil_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError) {
	BOOL_VAL_PTR(variant_return,true)
}




// =================================================== string
evaluate_string_string_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError) {
	BOOL_VAL_PTR(variant_return,VAL_AS_OBJ_STRING_PTR(variant_left).hash == VAL_AS_OBJ_STRING_PTR(variant_right).hash )
}

evaluate_string_string_less :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError) {
	BOOL_VAL_PTR(variant_return,VAL_STRING_DATA_PTR(variant_left) < VAL_STRING_DATA_PTR(variant_right) )
}

evaluate_string_string_less_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError) {
	BOOL_VAL_PTR(variant_return,VAL_STRING_DATA_PTR(variant_left) <= VAL_STRING_DATA_PTR(variant_right) )
}

evaluate_string_string_greater :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError) {
	BOOL_VAL_PTR(variant_return,VAL_STRING_DATA_PTR(variant_left) > VAL_STRING_DATA_PTR(variant_right) )
}

evaluate_string_string_greater_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError) {
	BOOL_VAL_PTR(variant_return,VAL_STRING_DATA_PTR(variant_left) <= VAL_STRING_DATA_PTR(variant_right) )
}


// =================================================== Transfomr2D
evaluate_transform2d_vec2_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)*Float(AS_INT_PTR(variant_right)))
}

evaluate_vec2_transform2d_mult :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError){
	VECTOR2_VAL_PTRV(variant_return,AS_VECTOR2_PTRV(variant_left)*Float(AS_INT_PTR(variant_right)))
}









// Compara diferentes tipos
evaluate_variant_variant_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,_: ^ObjectCallError) {
	BOOL_VAL_PTR(variant_return,value_hash_compare(variant_left,variant_right,0))
}


// Genericos para AND e OR
evaluate_variant_variant_and :: #force_inline proc(variant_left,_,variant_return: ^Value, _: ^bool,_: ^ObjectCallError) {
	BOOL_VAL_PTR(variant_return,BOOLEANIZE(variant_left))
}

evaluate_variant_variant_or :: #force_inline proc(variant_left,_,variant_return: ^Value, _: ^bool,_: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,BOOLEANIZE(variant_left))
}


evaluate_variant_not        :: #force_inline proc(variant_left,_,variant_return: ^Value, has_error: ^bool,_: ^ObjectCallError){
	BOOL_VAL_PTR(variant_return,!BOOLEANIZE(variant_left))
}


evaluate_array_indexing       :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, has_error: ^bool,call_error_p: ^ObjectCallError) {
	
	arr  := VAL_AS_OBJ_ARRAY_PTR(variant_left)
	indx := AS_INT_PTR(variant_right)
	len  := len(arr.data)-1

	if indx < 0 || indx > len { CALL_ERROR_STRING(call_error_p,"out of bounds get index."); has_error^ = true; return}

	variant_return^ = arr.data[indx]
}






// STRING

// evaluate_string_string_equal :: #force_inline proc(variant_left,variant_right,variant_return: ^Value, _: ^bool,_: ^ObjectCallError){
// 	BOOL_VAL_PTR(variant_return,VAL_STRING_DATA_PTR(variant_left) < VAL_STRING_DATA_PTR(variant_right))
// }

