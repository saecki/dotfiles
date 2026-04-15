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
