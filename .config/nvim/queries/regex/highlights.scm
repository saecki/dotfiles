;; extends

((class_character) @constant (#set! "priority" 155))

((decimal_digits) @number (#set! "priority" 155))


([
  "*"
  "+"
  "?"
  "|"
  "="
  "!"
  "-"
  "\\k"
  (lazy)
] @operator (#set! "priority" 155))

