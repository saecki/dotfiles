; inherits rust

(
    (attribute_item
      (attribute
        (scoped_identifier
          path: (identifier) @path (#eq? @path "rustfmt")
          name: (identifier) @name (#eq? @name "skip")
        )
      )
    ) @attr.rustfmt_skip
    (#set! "priority" 999)
)

; FIXME: Increase the priority of captures with the `@string.regexp` label
; ((string_content) @string.regexp (#set! priority 150))
