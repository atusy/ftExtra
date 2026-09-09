local sep = {}

function Meta(meta)
	sep = meta.sep_blocks and (meta.sep_blocks.t and meta.sep_blocks or { pandoc.Str(meta.sep_blocks) })
		or { pandoc.LineBreak(), pandoc.LineBreak() }
end

local function expand_lists(blocks, indent)
	local expanded = {}
	for _, block in ipairs(blocks) do
		if block.t == "BulletList" then
			for _, item in ipairs(block.content) do
				local content = pandoc.utils.blocks_to_inlines(expand_lists(item, indent .. "  "), sep)
				table.insert(content, 1, pandoc.Str(indent .. "• "))
				table.insert(expanded, pandoc.Para(content))
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
