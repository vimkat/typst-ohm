#import "../../src/lib/vars.typ"
#import "../../src/lib/utils.typ"
#import "../../src/components/logo.typ": logo

#let script-size = 7.97224pt
#let footnote-size = 8.50012pt
#let small-size = 9.24994pt
#let normal-size = 10.00002pt
#let large-size = 11.74988pt

// This function gets your whole document as its `body` and formats
// it as an article in the style of Ohm
#let thesis(
  // The article's title.
  title: [Paper title],

  // The document's author. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  author: (),

  // The examinors
  examinors: (first: none, second: none),

  // Your article's abstract. Can be omitted if you don't have one.
  abstract: none,

  type: "Bachelorarbeit",
  organization: "Fakultät Informatik",
  field-of-study: "Informatik",
  version: none,

  // The article's paper size. Also affects the margins.
  // paper-size: "a4",

  // The path to a bibliography file if you want to cite some external
  // works.
  bibliography-file: none,

  // Parameter to enable or disable showing table of chapters
  show_chapters: false,

  // Parameter to enable or disable showing table of tables
  show_tables: false,

  // Parameter to enable or disable showing table of images
  show_images: false,

  // The document's content.
  body,
) = {
  let margin = (x: 3cm, y: 3cm)

  // Set document metadata.
  set document(title: title, author: author.name)

  // Set the body font. AMS uses the LaTeX font.
  set text(size: normal-size, font: "New Computer Modern")

  // Configure the page.
  set page(
    paper: "a4",
    
    // The margins depend on the paper size.
    margin: margin,

    // The page header should show the page number and list of
    // authors, except on the first page. The page number is on
    // the left for even pages and on the right for odd pages.
    //header-ascent: 14pt,
    // header: locate(loc => {
    //   let i = counter(page).at(loc).first()
    //   // if i == 1 { return }
    //   
    //   set text(size: script-size)
    //   // grid(
    //   //   columns: (6em, 1fr, 6em),
    //   //   if calc.even(i) [#i],
    //   //   align(center, upper(
    //   //     if calc.odd(i) { title } else { author.name }
    //   //   )),
    //   //   if calc.odd(i) { align(right)[#i] }
    //   // )

    //   smallcaps(title)
    // }),
	
		footer: context {
			set align(if calc.odd(here().page()) { right } else { left })
			if here().page-numbering() != none {
				counter(page).display(here().page-numbering())
			}
		},
	
    background: if version != none {
      let _version = text(size: 0.75em)[
        Version: #utils.ternary(
          version == true,
          datetime.today().display(),
          version
        )
      ]
      style(styles => {
        let size = measure(_version, styles)
        place(
          bottom,
          dx: -size.width/2 + size.height + 1em,
          dy: -size.width/2 - 1em,
          rotate(-90deg, _version),
        )
      })
    },
  )

  // Configure headings.
	show heading.where(level: 1): set heading(supplement: "Kapitel")
  set heading(numbering: "1.1")
  show heading: it => {
		// Create the heading numbering.
		let number = if it.numbering != none {
			counter(heading).display(it.numbering)
			h(0.5em, weak: true)
		}

		if it.level == 1 and it.numbering != none {
			set text(size: 1.5em)
			pagebreak(to: "odd", weak: true)
			
			v(3em)
			stack(
				spacing: 1em,
				[#it.supplement #number],
				it.body,
			)
			v(2em)
		} else {
			if it.level == 1 { pagebreak(to: "odd", weak: true) }
			block(above: 3em, below: 2em)[#number #it.body]
		}
  }

  //   Configure lists and links.
  set list(indent: 1em, body-indent: 0.5em)
  set enum(indent: 1em, body-indent: 0.5em)
  show link: set text(font: "New Computer Modern Mono")

  // Configure equations.
  show math.equation: set block(below: 8pt, above: 9pt)
  show math.equation: set text(weight: 400)

  show figure: it => {
    show: pad.with(x: 23pt)
    set align(center)

    v(12.5pt, weak: true)

    // Display the figure's body.
    it.body

    // Display the figure's caption.
    if it.has("caption") {
      // Gap defaults to 17pt.
      v(if it.has("gap") { it.gap } else { 17pt }, weak: true)
      smallcaps(it.supplement)
      if it.numbering != none {
        [ ]
        it.counter.display(it.numbering)
      }
      [. ]
      it.caption.body
    }

    v(15pt, weak: true)
  }

//////////////

	set page(numbering: "i")

  // Display the title and authors.
  page(
    // margin: (x: margin.x, y: margin.y), // prevent binding margins
    header: block(),
    footer: block(),
  )[
    #set align(center)
    #logo(height: 2.5cm, safety-zone: false, none)
    #v(1cm)
    #text(size: 1.5em, organization)
    #v(2cm)
    #text(size: 1.75em)[*#title*]
    #v(1cm)
    #text(size: 1.25em)[#type im Studiengang #field-of-study]
    #v(1cm)
    vorgelegt von
    #v(0.25cm)
    #text(size: 1.25em, author.name)
    #v(0.25cm)
    #if author.keys().contains("student-id") {
      text(size: 0.75em)[Matrikelnummer: #author.student-id]
    }
    #v(1fr)
    #if examinors.first != none and examinors.second != none {
      table(
        columns: (auto, auto),
        stroke: none,
        
        align(right)[Erstgutachter:],  align(left, examinors.first),
        align(right)[Zweitgutachter:], align(left, examinors.second),
      )
    }
    #v(1cm)
    © #datetime.today().year()
    #v(1cm)
    #set align(left)
    #set par(justify: true)
    Dieses Werk einschließlich seiner Teile ist urheberrechtlich geschützt. Jede Verwertung außerhalb der engen Grenzen des Urheberrechtgesetzes ist ohne Zustimmung des Autors unzulässig und strafbar. Das gilt insbesondere für Vervielfältigungen, Übersetzungen, Mikroverfilmungen sowie die Einspeicherung und Verarbeitung in elektronischen Systemen.
  ]
  
  // Configure paragraph properties.
  set par(first-line-indent: 0em, justify: true, leading: 1em)
  show par: set block(spacing: 2em)

	//// Pre-content: abstract, TOC etc.
	set page(numbering: "i")
	
  // Display the abstract
  if abstract != none {
		set page(header: block(), footer: block())
		heading(depth: 1, outlined: false, numbering: none, bookmarked: true)[Kurzdarstellung]
		abstract
  }

  // Table of chapters - headings
  if show_chapters {
		heading(numbering: none, outlined: false, bookmarked: true)[Inhaltsverzeichnis]

		show outline.entry.where(level: 1): it => {
			v(2em, weak: true)
			strong(it)
		}

    outline(
      title: none,
      depth: 3,
      target: heading.where(outlined: true),
      indent: auto,
    )
  }

	set page(numbering: "1")
	pagebreak(to: "odd", weak: true)
  counter(page).update(1)

  // Display the article's contents.
  body


  // Table of contents - kind: image
  if show_images {
		heading(numbering: none)[Abbildungsverzeichnis]
    outline(
      title: none,
      target: figure.where(kind: image, outlined: true),
    )
  }

  // Table of contents - kind: table
  if show_tables {
		heading(numbering: none)[Tabellenverzeichnis]
    outline(
      title: none,
      target: figure.where(kind: table, outlined: true),
    )
  }

	// TODO: Listings and bibliography

  // Display the bibliography, if any is given.
  if bibliography-file != none {
    show bibliography: set text(0.85em)
    show bibliography: pad.with(x: 0.5pt)
		show bibliography: set block(spacing: 2em)
    // show bibliography: set par(justify: false)
	
		heading(depth: 1, numbering: none)[Literaturverzeichnis]
    bibliography(bibliography-file, title: none)
  }

  // The thing ends with details about the authors.
  // show: pad.with(x: 11.5pt)
  // set par(first-line-indent: 0pt)
  // set text(7.97224pt)

  // for author in authors {
  //   let keys = ("department", "organization", "location")
// 
  //   let dept-str = keys
  //     .filter(key => key in author)
  //     .map(key => author.at(key))
  //     .join(", ")
// 
  //   smallcaps(dept-str)
  //   linebreak()
// 
  //   if "email" in author [
  //     _Email address:_ #link("mailto:" + author.email) \
  //   ]
// 
  //   if "url" in author [
  //     _URL:_ #link(author.url)
  //   ]
// 
  //   v(12pt, weak: true)
  // }
}

// The ASM template also provides a theorem function.
#let theorem(body, numbered: true) = figure(
  body,
  kind: "theorem",
  supplement: [Theorem],
  numbering: if numbered { "1" },
)

// And a function for a proof.
#let proof(body) = block(spacing: 11.5pt, {
  emph[Proof.]
  [ ] + body
  h(1fr)
  box(scale(160%, origin: bottom + right, sym.square.stroked))
})
