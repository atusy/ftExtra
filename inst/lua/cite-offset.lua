function Meta(meta)
  offset = meta.citationNoteNumOffset or 0
end

function Cite(cite)
  cite.citations[1].note_num = math.floor(offset + cite.citations[1].note_num)
  return cite
end

return {{Meta = Meta}, {Cite = Cite}}
