--[[
math - Render math based on pandoc -t html

# MIT License

Copyright (c) 2020 Atsushi Yasumoto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://github.com/atusy/lua-filters/blob/master/lua/math.lua
]]
local is_pandoc_2_10 = (PANDOC_VERSION[1] >= 2) and (PANDOC_VERSION[2] >= 10)

-- Pandoc 3.11 defaults to MathML, but the R renderer needs plain HTML inlines.
local math_method_option
if PANDOC_VERSION[1] > 3 or (PANDOC_VERSION[1] == 3 and PANDOC_VERSION[2] >= 11) then
	math_method_option = "--math-method=plain"
end

local L = {}

if pandoc.system.os ~= "mingw32" then
	function L.math2html(cmd, text)
		return pandoc.pipe(cmd, { "-t", "html", "-f", "markdown", math_method_option }, text)
	end
else
	if is_pandoc_2_10 then
		L.with_temporary_directory = pandoc.system.with_temporary_directory
	else
		function L.with_temporary_directory(_, callback)
			return callback(L.temporary_directory)
		end
	end

	function L.math2html(cmd, text)
		local function callback(directory)
			local path = directory .. "\\math-rendered-by-lua-filter.html"
			pandoc.pipe(cmd, { "-t", "html", "-f", "markdown", "-o", path, math_method_option }, text)
			return io.open(path):read("a")
		end

		return L.with_temporary_directory("write_html_math", callback)
	end
end

function Meta(elem)
	L.cmd = elem["pandoc-path"] and (pandoc.utils.stringify(elem["pandoc-path"])) or "pandoc"

	L.temporary_directory = elem["temporary-directory"] and (pandoc.utils.stringify(elem["temporary-directory"])) or "."
end

function Math(elem)
	return pandoc.read(L.math2html(L.cmd, "$" .. elem.text:gsub("[\n\r]", "") .. "$"), "html").blocks[1].content[1].content
end

return {
	{ Meta = Meta },
	{ Math = Math },
}
