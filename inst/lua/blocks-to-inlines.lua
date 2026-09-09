local sep = {}

function Meta(meta)
	sep = meta.sep_blocks and (meta.sep_blocks.t and meta.sep_blocks or { pandoc.Str(meta.sep_blocks) })
		or { pandoc.LineBreak(), pandoc.LineBreak() }
end

local function expand_lists(blocks, indent)
	local expanded = {}
	for _, block in ipairs(blocks) do
		if block.t == "BulletList" or block.t == "OrderedList" then
			for i, item in ipairs(block.content) do
				local content = pandoc.utils.blocks_to_inlines(expand_lists(item, indent .. "  "), sep)
				local marker = block.t == "BulletList" and "• " or tostring(block.start + i - 1) .. ". "
				table.insert(content, 1, pandoc.Str(indent .. marker))
				table.insert(expanded, pandoc.Para(content))
			end
		elseif block.t == "BlockQuote" then
			for _, child in ipairs(expand_lists(block.content, indent)) do
				table.insert(expanded, child)
			end
		else
			table.insert(expanded, block)
		end
	end
	return expanded
end

function Div(div)
	div.content = { pandoc.Para(pandoc.utils.blocks_to_inlines(expand_lists(div.content, ""), sep)) }
	return div
end

return { { Meta = Meta }, { Div = Div } }
