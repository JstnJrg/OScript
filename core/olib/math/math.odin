#+private

package OscriptMath

_posmodf :: proc "contextless" (a,b: $T) -> (value: T) where IS_NUMERIC(T) {
	value = linalg.mod(a,b) //resto
	if (value < 0 && b > 0) || (value > 0 && b < 0 ) do value += b
	return 
}

_posmodi :: proc "contextless" (a,b: $T) -> (value: T) where IS_NUMERIC(T) {
	value = a%b //resto
	if (value < 0 && b > 0) || (value > 0 && b < 0 ) do value += b
	return 
}

// retorna a posicao do primeiro decimal diferente de zero
_step_decimal :: proc "contextless" (n: $T ) -> T where IS_NUMERIC(T) #no_bounds_check {
	
	sd := [?]T{
		0.999,
		0.09999,
		0.009999,
		0.0009999,
		0.00009999,
		0.000009999,
		0.0000009999,
		0.00000009999,
		0.000000009999,
		0.0000000009999
	}

	decs : T = #force_inline linalg.abs(n)-T(int(n))
	for i in 0..< len(sd) do if decs >= sd[i] do return T(i)
	return 0
}

// retorna o multiplo de step proximo de value
_stepfy :: proc  "contextless" (value,step : $T) -> T where IS_NUMERIC(T) {
	if step == 0 do return 0
	return step*linalg.floor((value/step)+0.5)
}


_cubic_interpolate :: proc "contextless" ( p_from, p_to, p_pre, p_post, p_weight: $T) -> T where IS_NUMERIC(T) {
		return 0.5 *
				((p_from * 2.0) +
						(-p_pre + p_to) * p_weight +
						(2.0 * p_pre - 5.0 * p_from + 4.0 * p_to - p_post) * (p_weight * p_weight) +
						(-p_pre + 3.0 * p_from - 3.0 * p_to + p_post) * (p_weight * p_weight * p_weight));
}

_cubic_interpolate_angle :: proc "contextless" (p_from, p_to, p_pre, p_post, p_weight: $T) -> T where IS_NUMERIC(T) {
		from_rot 	:= linalg.fmod(p_from, TAU)
		pre_diff 	:= linalg.fmod(p_pre - from_rot, TAU)
		pre_rot 	:= from_rot + linalg.fmod(2.0 * pre_diff, TAU) - pre_diff
		to_diff 	:= linalg.fmod(p_to - from_rot, TAU)
		to_rot 		:= from_rot + linalg.fmod(2.0 * to_diff, TAU) - to_diff
		post_diff 	:= linalg.fmod(p_post - to_rot, TAU)
		post_rot 	:= to_rot + linalg.fmod(2.0 * post_diff, TAU) - post_diff
		return _cubic_interpolate(from_rot, to_rot, pre_rot, post_rot, p_weight)
	}


