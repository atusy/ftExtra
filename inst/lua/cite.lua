cite = {}

function Cite(elem)
  table.insert(cite, elem)
  table.insert(cite, pandoc.Space())
end

function Pandoc(doc)
  table.remove(cite)
  doc.blocks = {pandoc.Para(cite)}
  return doc
end
