#import "../lib/vars.typ"
#import "../components/logo.typ": logo

#let document(doc, blue-as-black: false, lang: "de") = {
	set text(fill: vars.blue) if blue-as-black

  // Text styles
  set text(font: vars.font, lang: lang)
  set par(leading: 0.75em)

  // Headings
  show heading: it => [ #v(2em, weak: true) #it #v(1em, weak: true) ]

  doc
}
