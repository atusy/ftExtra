function Meta(meta)
  offset = meta.citationNoteNumOffset or 0
end

function add(x)
  return math.floor(tonumber(x) + offset)
end

function Cite(cite)
  cite.citations[1].note_num = math.floor(offset + cite.citations[1].note_num)
  cite.content[1].text = cite.content[1].text:gsub("%d+", add)
  return cite
end

return {{Meta = Meta}, {Cite = Cite}}
