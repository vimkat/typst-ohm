#import "/src/lib/vars.typ"

#let logo(
  body,
  height: 1cm,
  text-only: false,
  department-below: false,
  safety-zone: true,
  fill: vars.red,
) = {
  layout(container-size => {
    // Height is a ratio, use wrapping container
    let _height = height
    if type(height) == "ratio" { _height = container-size.height * height }

    // Calculate safety zone
    let _logo-height = _height
    let _inset = 0pt
    if safety-zone {
      _logo-height = _height / 3 // TODO: FIX
      _inset = _logo-height
    }

    set par(leading: 0.35em)
    set text(font: vars.font, weight: 300, fill: fill, size: _logo-height)
    set align(bottom)
    
    let content = image.decode(read("/src/assets/ohm-logo.svg").replace("#000000", fill.to-hex()), height: 1em)
    let text-size  = 0.25em
    let logo-text =  {
      set text(size: text-size)
      set align(left + bottom)
      [Technische \ Hochschule \ Nürnberg]
    }

    // Version A: Department right
    if not text-only and not department-below {

      // Version A.2: With department
      if body != none {
        logo-text = stack(
          dir: ltr,  
          spacing: 1em*vars.frac-half,
          logo-text,
          {
            set text(size: text-size)
            set align(left + top)
            body
          }
        )
      }
      
      // Version A.1: THN only
      content = stack(
        dir: ltr,
        spacing: 0.15em,
        content,
        logo-text,
      )
    }
    
    // Version B: Department below
    if not text-only and department-below and body != none {
      content = grid(
        columns: 2,
        column-gutter: 0.15em,
        row-gutter: 1em*vars.frac-half,
        content,
        logo-text,
        none,
        {
          set text(size: text-size)
          body
        }
      )
    }
    
    
    block(
      inset: _inset,
      content,
    )
  })
}
