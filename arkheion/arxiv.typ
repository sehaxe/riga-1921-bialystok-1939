// Свой шаблон в стиле официального шаблона arXiv («A Template for the arXiv Style»).
// Порог верхнего блока: линейка → заголовок → бейдж → авторы → дата → аннотация → ключевые слова.

#let arxiv(
  title: "",
  authors: (),            // (name, affiliation, address, email)
  date: none,
  abstract: none,
  keywords: (),
  note: none,             // сноска на первой странице
  running-title: none,    // колонтитул нечётных страниц
  body,
) = {
  set document(author: authors.map(a => a.name), title: title)
  set page(
    margin: (left: 25mm, right: 25mm, top: 25mm, bottom: 30mm),
    footer: context {
      let i = counter(page).get().first()
      if i > 1 {
        align(center, text(size: 8.5pt, fill: luma(40%), numbering("1", i)))
      }
    },
    header: context {
      let i = counter(page).get().first()
      if i > 1 {
        set text(size: 7.5pt, fill: luma(40%))
        let ch(s) = s.codepoints().at(0, default: "")
        let short(a) = {
          let p = a.name.split(" ")
          p.at(0) + " " + ch(p.at(1, default: "")) + ". " + ch(p.at(2, default: "")) + "."
        }
        grid(
          columns: (1fr, 1fr),
          gutter: 1em,
          align(left, authors.map(short).join(", ")),
          align(right, running-title),
        )
      }
    },
  )
  set text(font: "New Computer Modern", size: 11pt)
  set par(justify: true)
  set text(hyphenate: false)
  set heading(numbering: "1.1")
  show heading: it => {
    if it.level == 1 {
      pad(bottom: 10pt, it)
    } else if it.level == 2 {
      pad(bottom: 8pt, it)
    } else if it.level > 3 {
      text(11pt, weight: "bold", it.body + " ")
    } else {
      it
    }
  }
  set bibliography(title: [Список источников и литературы])

  // Верхняя линейка (как в оригинале arXiv — над заголовком).
  line(length: 100%, stroke: 1.2pt)
  v(10pt)

  align(center, par(justify: false, text(size: 1.85em, tracking: 0.02em, smallcaps(title))))
  v(6pt)
  line(length: 100%, stroke: 1.2pt)
  v(10pt)
  align(center, text(size: 10pt, tracking: 0.06em, weight: "medium")[РЕФЕРАТ])
  v(14pt)

  // Блок авторов: имя → вуз → адрес → email моноширинным жирным.
  grid(
    columns: (1fr,) * calc.min(3, authors.len()),
    gutter: 2em,
    ..authors.enumerate().map(((i, a)) => align(center)[
      *#a.name* \
      #a.affiliation#if note != none and i == 0 { footnote(note) } \
      #a.address \
      #text(font: "PT Mono", weight: 700, size: 0.92em, a.email)
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
