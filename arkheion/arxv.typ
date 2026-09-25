// Свой шаблон в стиле официального шаблона arXiv («A Template for the arXiv Style»).
// Порог верхнего блока: линейка → заголовок → бейдж → авторы → дата → аннотация → ключевые слова.

#let arxv(
  title: "",
  authors: (),            // (name, affiliation, address, email)
  date: none,
  abstract: none,
  keywords: (),
  note: none,             // сноска на первой странице
  running-title: none,    // колонтитул нечётных страниц
  body,
) = {
  set page(
    margin: (x: 25mm, y: 25mm),
    numbering: "1",
    header: context {
      let i = counter(page).get().first()
      if i > 1 {
        set text(size: 8.5pt, fill: luma(40%))
        let ch(s) = s.codepoints().at(0, default: "")
        let short(a) = {
          let p = a.name.split(" ")
          p.at(0) + " " + ch(p.at(1, default: "")) + ". " + ch(p.at(2, default: "")) + "."
        }
        if calc.odd(i) {
          align(right, running-title)
        } else {
          align(left, authors.map(short).join(", "))
        }
      }
    },
  )
  set text(size: 11pt)
  set par(justify: true)
  set heading(numbering: "1.1")
  set bibliography(title: [Список источников и литературы])

  // Верхняя линейка (как в оригинале arXiv — над заголовком).
  line(length: 100%, stroke: 1.2pt)
  v(10pt)

  align(center, text(size: 1.85em, title))
  v(4pt)
  align(center, text(size: 10pt, tracking: 0.06em, weight: "medium")[РЕФЕРАТ])
  v(14pt)

  // Блок авторов: имя → вуз → адрес → email моноширинным жирным.
  grid(
    columns: (1fr,) * calc.min(3, authors.len()),
    gutter: 2em,
    ..authors.enumerate().map(((i, a)) => align(center)[
      *#a.name*#if note != none and i == 0 { footnote(note) } \
      #a.affiliation \
      #a.address \
      #text(font: "New Computer Modern Mono", weight: 700, size: 0.92em, a.email)
    ]),
  )
  v(12pt)

  align(center, date)
  v(10pt)

  if abstract != none {
    align(center, text(tracking: 0.06em)[АННОТАЦИЯ])
    v(4pt)
    abstract
    if keywords.len() > 0 {
      v(6pt)
      [*Ключевые слова:* #keywords.join(" · ")]
    }
    v(12pt)
  }

  body
}
