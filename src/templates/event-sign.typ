#import "../lib/vars.typ"
#import "../lib/utils.typ"
#import "../lib/elements.typ" as elems

#let _arrow-v = polygon(
  fill: vars.red,
  stroke: none,
  
  (70pt, 0%),
  (70pt, 80%),
  (0pt, 80%),
  (50pt, 100%),
  (100pt, 80%),
  (30pt, 80%),
  (30pt, 0%),
)

#let _arrow-h = polygon(
  fill: vars.red,
  stroke: none,

  (0%, 70pt),
  (85%, 70pt),
  (85%, 0pt),
  (100%, 50pt),
  (85%, 100pt),
  (85%, 30pt),
  (0%, 30pt)
)
  

#let event-sign(
  body,
  arrow: none, // top, bottom, left, right, none
  title: none,
  room: none,
  event: none,
  date: none,
) = {
  set text(font: vars.font, weight: "bold", size: 30pt)
  set align(center + horizon)
  
  if arrow not in (top, bottom, left, right, none) {
    panic("Alignment is not one of 'top', 'bottom', 'left', 'right' or 'none'")
  }

  let content = align(left, {
    if title == none and room != none { title = room; room = none }
    if title != none {
      set text(
        fill: vars.red,
        size: utils.ternary(body != none, 1.5em, 2em),
        weight: "bold"
      )
      
      block(upper(title))

      if room != none {
        v(0.5em, weak: true)
        set text(size: 0.5em, weight: "extrabold")
        block(room)
      }
      v(1em, weak: true)
    }
    body
  })
  
  page(
    flipped: true,
    paper: "a4",
    footer: {
      set align(right)
      set text(size: 10pt, weight: "regular")
      event
      if date != none [ #utils.ternary(event != none, elems.pipe, none) #date.display("[day].[month].[year]")]
    },
    if (arrow == none) {
      content
    } else [
      #grid(
        columns: utils.ternary(arrow in (top, bottom), (auto, 1fr), 1),
        rows: utils.ternary(arrow in (left, right), (auto, 1fr), 1),
        column-gutter: 2em,
        row-gutter: 1em,

        if arrow.axis() == "vertical" {
          align(center + horizon, rotate(
            utils.ternary(arrow == top, 180deg, 0deg),
            _arrow-v)
          )
        } else {
          align(center + horizon, rotate(
            utils.ternary(arrow == left, 180deg, 0deg),
            _arrow-h)
          )
        },
        content,
      )
    ],
  )
}
