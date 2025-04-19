package OScriptTransform2D



register :: proc(transform2_id : ImportID )
{

	// 
	register_transform2_operators()


	register_method(transform2_id,"basis_xform_inv",basis_xform_inv)
	register_method(transform2_id,"basis_xform",basis_xform)
	register_method(transform2_id,"xform",xform)
	register_method(transform2_id,"xform_inv",xform_inv)
	register_method(transform2_id,"rotated",rotated)
	register_method(transform2_id,"determinant",determinant)
	register_method(transform2_id,"get_inverse",get_inverse)
	register_method(transform2_id,"orthonormalized",orthonormalized)
	register_method(transform2_id,"scaled",scaled)
	register_method(transform2_id,"translated",translated)
	register_method(transform2_id,"xform_rect",xform_rect)
	register_method(transform2_id,"affine_inverse",affine_inverse)
	// register_method(transform2_id,"",)
	// register_method(transform2_id,"",)
	// register_method(transform2_id,"",)
	// register_method(transform2_id,"",)
	// register_method(transform2_id,"",)
	// register_method(transform2_id,"",)
	// register_method(transform2_id,"",)
	// register_method(transform2_id,"",)
	// register_method(transform2_id,"",)
	// register_method(transform2_id,"",)
	// register_method(transform2_id,"",)


}