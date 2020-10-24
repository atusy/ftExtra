--[[
math - Render math based on pandoc -t html

# MIT License

Copyright (c) 2020 Atsushi Yasumoto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://github.com/atusy/lua-filters/blob/master/lua/math.lua
]]
local cmd = "pandoc"

local function math2html(text)
  return pandoc.pipe(cmd, {"-t", "html", "-f", "markdown"}, text)
end

if pandoc.system.os == "mingw32" then
  local function gen_math_writer(text)
    local function callback(directory)
      local path = directory .. "\\math.html"
      pandoc.pipe(cmd, {"-t", "html", "-f", "markdown", "-o", path}, text)
      return io.open(path):read("a")
    end
    return callback
  end
  math2html = function(text)
    return pandoc.system.with_temporary_directory(
      "write_html_math", gen_math_writer(text))
  end
end

local function Meta(elem)
  if elem["pandoc-path"] ~= nil then
    cmd = pandoc.utils.stringify(elem["pandoc-path"])
  end
end

local function Math(elem)
  local text = "$" .. elem.text .. "$"
  if elem.mathtype == "DisplayMath" then
    text = "$" .. text .. "$"
  end
  return pandoc.read(math2html(text), "html").blocks[1].content[1].content
end

return {
  {Meta = Meta},
  {Math = Math}
}
