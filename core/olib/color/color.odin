#+private

package OscriptColor

_get_remap        :: proc "contextless" (f : Float, $T : typeid ) -> T { return T(math.remap(f,0,1,0,255)) }

_get_luminance    :: proc "contextless" (color: ^Color) -> u8 { return color.r*_get_remap(0.2126,u8)+color.g*_get_remap(0.7152,u8)+color.b*_get_remap(0.0722,u8) }

_darkened         :: proc "contextless" (color: ^Color, amount: ^Float) -> Color {
	return Color{ color.r*(255-_get_remap(amount^,u8)),color.g*(255-_get_remap(amount^,u8)),color.b*(255-_get_remap(amount^,u8)),color.a}
} 

_lightened         :: proc "contextless" (color: ^Color, amount: ^Float) -> Color {
	return Color{ color.r+(255-_get_remap(amount^,u8)),color.g+(255-_get_remap(amount^,u8)),color.b+(255-_get_remap(amount^,u8)),color.a}
} 