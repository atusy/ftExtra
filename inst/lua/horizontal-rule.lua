function HorizontalRule(el)
	warn(
		"HorizontalRule is unsupported and fallbacks to three hyphens (---) "
			.. "regardless of the input string (e.g., `-------`, `***`, and `_ _ _`)"
	)
	return pandoc.Para({ pandoc.Str("---") })
end
