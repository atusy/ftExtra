function Meta(meta)
  sep = meta.sep_blocks and (
      meta.sep_blocks.t and meta.sep_blocks or {pandoc.Str(meta.sep_blocks)}
    ) or {pandoc.LineBreak(), pandoc.LineBreak()}
end

function Pandoc(doc)
  doc.blocks = {pandoc.Para(pandoc.utils.blocks_to_inlines(doc.blocks, sep))}
  return doc
end
