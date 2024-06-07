#import "@preview/polylux:0.3.1" as plx
#import "../lib/vars.typ"
#import "../lib/utils.typ"
#import "../components/logo.typ": logo, logo-omega
#import "../templates/document.typ": document as ohm-document

#let margin = 32pt
#let ohm-logo-content = state("ohm-logo-content", none)
#let ohm-title = state("ohm-title", none)
#let ohm-author = state("ohm-author", none)
#let ohm-date = state("ohm-date", none)
#let ohm-header = state("ohm-header", none)
#let ohm-footer = state("ohm-footer", none)
#let ohm-meta = state("ohm-meta", none)

#let content-with-context(ctx, body) = {
	if type(body) == "function" {
		body(..ctx)
	} else {
		body
	}
}

#let ohm-theme(
	logo-content: none,
	title: none,
	author: none,
	date: datetime.today(),
	header: none,
	footer: none,
	progress-bar: false,
	body
) = {
	set document(title: title, author: author, date: date)
  set page(
    paper: "presentation-16-9",
		margin: margin,

		// Handled in slide-base b/c state makes this go boom
		header: none,
		footer: none,
  )
	set text(size: 20pt)

	show heading: it => {
		set text(weight: "extrabold")
		set text(fill: vars.red) if it.level == 1
		it
	}

	ohm-logo-content.update(logo-content)
	ohm-header.update(header)
	ohm-footer.update(footer)
	ohm-title.update(title)
	ohm-author.update(author)
	ohm-date.update(date)
	ohm-meta.update((
		progress-bar: progress-bar,
	))

	ohm-document(blue-as-black: true, body)
}

// Base header/footer
#let header(fill: none) = {
	set text(size: 10pt, fill: fill)
	grid(
		rows: 1,
		columns: (auto, 1fr),
		align(left, logo(safety-zone: false, height: 16pt, text-only: true, fill: fill, none)),
		align(right, ohm-header.display()),
	)
}


#let footer(fill: none) = {
	set text(size: 10pt, fill: fill)
	grid(
		rows: 1,
		columns: (1fr, auto),
		align(left, ohm-footer.display()),
		align(right, plx.logic.logical-slide.display()),
	)
	ohm-meta.display(meta => 
		if meta.progress-bar {
			plx.utils.polylux-progress(ratio =>
				place(
					bottom,
					dx: -margin,
					dy: margin,
					rect(
						width: ratio * 100% + margin * 2,
						height: 2.5pt,
						stroke: none,
						fill: fill,
					)
				)
			)
		}
	)
}

// Base slide config (with header/footer support)
#let base-slide(
	header: header,
	header-height: 32pt,
	footer: footer,
	footer-height: 16pt,
	background: none,
	body
) = {
	let _fill = if type(background) == "color" { utils.contrast-colors(background) }
	let _background = if type(background) == "color" {
		rect(fill: background, width: 100%, height: 100%)
	} else {
		background
	}
	let _header = content-with-context((fill: utils.default(_fill, vars.red)), header)
	let _footer = content-with-context((fill: utils.default(_fill, vars.red)), footer)
	let _body = content-with-context((fill: utils.default(_fill, vars.blue)), body)

	// Only override if actually needed (to make inheritance work properly)
	set text(fill: _fill) if _fill != none

	plx.polylux-slide({
		if _background != none {
			place(
				dx: -margin,
				dy: -margin,
				block(width: 100% + margin * 2, height: 100% + margin * 2, _background)
			)
		}
		grid(
			rows: (header-height, 1fr, footer-height),
			columns: (1fr),
			row-gutter: 1em,

			align(top, _header),
			_body,
			align(bottom, _footer),
		)
	})
}

#let background-omega = place(dx: 53%, scale(120%, logo-omega(outline: true)))
#let title-slide(
	title,
	subtitle: none,
	background: background-omega,
	fill: none,
) = {
	let _fill = utils.default(fill, utils.contrast-colors(background))
	// Cut out parts of the omega if it is used as the background
	let _content(body) = {
		if background == background-omega {
			highlight(fill: white, body)
		} else {
			body
		}
	}

  base-slide(
		header: (fill: none) => logo(safety-zone: false, fill: fill, height: 100%, ohm-logo-content.display()),
		header-height: 32pt,
		footer: none,
		background: background,
		{
			set align(horizon)
			set text(fill: _fill, weight: "black")
			set par(leading: 0.25em)

			v(3em) // from header-height
			stack(
				spacing: if subtitle != none { 1.5em } else { none },
				block(
					width: 80%,
					text(size: 4em, _content(title)),
				),
				if subtitle != none {
					block(
						width: 80%,
						text(size: 1.5em, _content(subtitle)),
					)
				},
			)
		}
	)
}

#let section-slide(
	title,
	subtitle: none,
	background: vars.red
) = {
	base-slide(
		background: background,
		{
			set align(center + horizon)
			set text(weight: "extrabold")
			plx.utils.register-section(title)

			block(text(size: 2.5em, title))
			if subtitle != none {
				v(0.5em)
				block(text(size: 1.25em, weight: "bold", subtitle))
			}
		}
	)
}

#let agenda-slide(
	title: [Agenda],
) = {
	base-slide[
		= #title

		#plx.utils.polylux-outline(enum-args: (tight: false))
	]
}

// Nothing fancy, just hiding some arguments :)
#let slide(body) = base-slide(body)

#let allowed-items = ["title", "author", "date", "section"]
#let metadata-line(..items) = {
	items.pos().map(item => {
		if item == "title" { ohm-title.display() }
		if item == "author" { ohm-author.display() }
		if item == "date" { ohm-date.display(date => date.display("[day].[month].[year]")) }
		if item == "section" { plx.utils.current-section }
	})
	.filter(item => item != none)
	.join(" | ")
}
