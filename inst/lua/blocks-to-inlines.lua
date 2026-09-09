local sep = {}

function Meta(meta)
	sep = meta.sep_blocks and (meta.sep_blocks.t and meta.sep_blocks or { pandoc.Str(meta.sep_blocks) })
		or { pandoc.LineBreak(), pandoc.LineBreak() }
end

local function expand_lists(blocks, indent)
	local function expand_rows(rows)
		for _, row in ipairs(rows) do
			for _, cell in ipairs(row.cells) do
				cell.contents = expand_lists(cell.contents, indent)
			end
		end
		return rows
	end

	local expanded = {}
	for _, block in ipairs(blocks) do
		if block.t == "BulletList" or block.t == "OrderedList" then
			for i, item in ipairs(block.content) do
				local first = item[1]
				while first and (first.t == "Div" or first.t == "BlockQuote") do
					first = first.content[1]
				end
				local item_blocks = expand_lists(item, indent .. "  ")
				if first and (first.t == "BulletList" or first.t == "OrderedList") then
					-- Keep an empty parent item on its own line before its child list.
					table.insert(item_blocks, 1, pandoc.Plain({}))
				end
				local content = pandoc.utils.blocks_to_inlines(item_blocks, sep)
				local marker = block.t == "BulletList" and "• " or tostring(block.start + i - 1) .. ". "
				table.insert(content, 1, pandoc.Str(indent .. marker))
				table.insert(expanded, pandoc.Para(content))
			end
		elseif block.t == "Table" then
			if block.head then
				block.caption.long = expand_lists(block.caption.long, indent)
				block.head.rows = expand_rows(block.head.rows)
				for _, body in ipairs(block.bodies) do
					body.head = expand_rows(body.head)
					body.body = expand_rows(body.body)
				end
				block.foot.rows = expand_rows(block.foot.rows)
			else
				-- Pandoc < 2.10 uses block lists directly for table cells.
				for i, cell in ipairs(block.headers) do
					block.headers[i] = expand_lists(cell, indent)
				end
				for _, row in ipairs(block.rows) do
					for i, cell in ipairs(row) do
						row[i] = expand_lists(cell, indent)
					end
				end
			end
			table.insert(expanded, block)
		elseif block.t == "Figure" then
			block.content = expand_lists(block.content, indent)
			block.caption.long = expand_lists(block.caption.long, indent)
			table.insert(expanded, block)
		elseif block.t == "DefinitionList" then
			for _, item in ipairs(block.content) do
				for i, definition in ipairs(item[2]) do
					item[2][i] = expand_lists(definition, indent)
				end
			end
			table.insert(expanded, block)
		elseif block.t == "BlockQuote" then
			for _, child in ipairs(expand_lists(block.content, indent)) do
				table.insert(expanded, child)
			end
		elseif block.t == "Div" then
			block.content = { pandoc.Para(pandoc.utils.blocks_to_inlines(expand_lists(block.content, indent), sep)) }
			table.insert(expanded, block)
		else
			table.insert(expanded, block)
		end
	end
	return expanded
end

function Note(note)
	note.content = { pandoc.Para(pandoc.utils.blocks_to_inlines(expand_lists(note.content, ""), sep)) }
	return note
end

function Pandoc(doc)
	-- Start at the cell Divs; bottom-up Div callbacks lose the enclosing list depth.
	for _, block in ipairs(doc.blocks) do
		if block.t == "Div" then
			block.content = { pandoc.Para(pandoc.utils.blocks_to_inlines(expand_lists(block.content, ""), sep)) }
		end
	end
	return doc
end

return { { Meta = Meta }, { Note = Note, Pandoc = Pandoc } }
