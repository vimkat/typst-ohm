#import "../lib/vars.typ"
#import "../components/logo.typ": logo

#let _typst-title = title;
#let _typst-document = document;

#let document(
  blue-as-black: false,
  lang: "de",
  title: none,
  author: (),
  doctype: none,
  logo-content: [],

  doc,
) = {
  let _author = if author != none and (type(author) == str or type(author) == array and author.len() > 0) {
    if type(author) == array {
      author.join[, ]
    } else {
      author
    }
  } else { none }

  // Text styles
	set text(fill: vars.blue) if blue-as-black
  set text(font: vars.font, lang: lang, size: 10pt)
  set par(leading: 0.75em)

  // Headings
  show heading: it => text(fill: vars.red)[ #v(2em, weak: true) #it #v(1em, weak: true) ]

  // Title
  show _typst-title: it => {
    set text(fill: vars.red, weight: 800)
    set par(leading: 0.5em)

    it
  }

  // Document
  set _typst-document(
    title: title,
    author: author,
  )

  // Page
  set page(
    header: context align(right)[
      #if counter(page).get().at(0) == 1 { logo(height: 0.75cm, logo-content) }
    ],
    footer: context {
      let page-number = counter(page).get().at(0)
      set text(size: 0.75em)
      grid(
        columns: (1fr, 1fr),
        align(left, if page-number > 1 { _author }),
        align(right, counter(page).display()),
      )
    }
  )

  //////////////////////////////////////////////////////////////////////////////// 

  // Render doctype
  stack(
    spacing: 1em,

    if doctype != none {
      set block(below: 0em)
      text(fill: vars.red, weight: 800, tracking: 0.05em, upper(doctype))
    },

    // Render title
    if title != none { _typst-title() }
  )

  // Render authors
  if _author != none { text(size: 0.85em, _author) }

  // Separator
  if title != none or _author != none {
    v(1em)
  }

  doc
}
