function Meta(meta)
  sep = meta.sep_blocks and (
      meta.sep_blocks.t and meta.sep_blocks or {pandoc.Str(meta.sep_blocks)}
    ) or {pandoc.LineBreak(), pandoc.LineBreak()}
end

function Div(div)
  div.content = {pandoc.Para(pandoc.utils.blocks_to_inlines(div.content, sep))}
  return div
end

return {{Meta = Meta}, {Div = Div}}
