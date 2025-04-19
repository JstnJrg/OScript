// #+private

package OScriptRect2D


register :: proc(rect2_id : ImportID )
{
	register_method(rect2_id,"abs",abs)
	// register_method(rect2_id,"distance_to",distance_to)
	register_method(rect2_id,"encloses",encloses)
	register_method(rect2_id,"expand",expand)
	register_method(rect2_id,"get_center",get_center)
	register_method(rect2_id,"get_area",get_area)
	register_method(rect2_id,"grow",grow)
	register_method(rect2_id,"grow_individual",grow_individual)
	register_method(rect2_id,"has_point",has_point)
	register_method(rect2_id,"has_no_area",has_no_area)
	register_method(rect2_id,"intersects",intersects)
	register_method(rect2_id,"merge",merge)
	register_method(rect2_id,"clip",clip)
	register_method(rect2_id,"get_support",get_support)
	// register_method(rect2_id,"",)
	// register_method(rect2_id,"",)
	// register_method(rect2_id,"",)
	// register_method(rect2_id,"",)
	// register_method(rect2_id,"",)
	// register_method(rect2_id,"",)
	// register_method(rect2_id,"",)
	// register_method(rect2_id,"",)
	// register_method(rect2_id,"",)
	// register_method(rect2_id,"",)

}