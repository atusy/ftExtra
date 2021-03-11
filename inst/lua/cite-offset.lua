function Meta(meta)
  offset = meta.citationNoteNumOffset or 0
end

function Cite(cite)
  cite.citations.note_num = offset + cite.citations.note_num
  return cite
end
