--[[
math - Render math based on pandoc -t html

# MIT License

Copyright (c) 2020 Atsushi Yasumoto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://github.com/atusy/lua-filters/blob/master/lua/math.lua
]]
is_pandoc_2_10 = (PANDOC_VERSION[1] >= 2) and (PANDOC_VERSION[2] >= 10)

if pandoc.system.os ~= "mingw32" then
  function math2html(text)
    return pandoc.pipe(cmd, {"-t", "html", "-f", "markdown"}, text)
  end
else
  if is_pandoc_2_10 then
    with_temporary_directory = pandoc.system.with_temporary_directory
  else
    with_temporary_directory = function(ignored, callback)
      return callback(temporary_directory)
    end
  end

  math2html = function(text)
    local function callback(directory)
      local path = directory .. "\\math-rendered-by-lua-filter.html"
      pandoc.pipe(cmd, {"-t", "html", "-f", "markdown", "-o", path}, text)
      return io.open(path):read("a")
    end

    return with_temporary_directory("write_html_math", callback)
  end
end

function Meta(elem)
  cmd = elem["pandoc-path"] and (
    pandoc.utils.stringify(elem["pandoc-path"])
  ) or "pandoc"

  elem = elem["temporary-directory"] and (
    pandoc.utils.stringify(elem["temporary-directory"])
  ) or "."
end

function Math(elem)
  return pandoc.read(
    math2html("$" .. elem.text:gsub("[\n\r]", "") .. "$"), "html"
  ).blocks[1].content[1].content
end

return {
  {Meta = Meta},
  {Math = Math}
}
