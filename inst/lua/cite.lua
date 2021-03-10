para = pandoc.Para({})

function Cite(cite)
  para.c:insert(cite)
  para.c:insert(pandoc.Space())
end

function Pandoc(doc)
  table.remove(para.c)
  doc.blocks = {para}
  return doc
end
