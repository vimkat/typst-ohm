#import "../../src/lib/vars.typ"

#let ternary(cond, t, f) = if cond { t } else { f }

#let default(value, default) = if value != none { value } else { default }

// Calculate foreground color based on background
#let contrast(override: none, background: none, if-light: none, if-dark: none) = {
	// Can't calculate if background is not a color
	if type(background) != "color" { panic("background is not a color") }

	// Make sure the text color has enough contrast to the background
	if color.hsl(background).components().at(2) < 75% {
		return if-dark
	} else {
		return if-light
	}
}

#let contrast-colors(background) = {
	if type(background) == "color" {
		contrast(background: background, if-light: vars.red, if-dark: white)
	} else {
		vars.red
	}
}
