function Code(elem)
  if elem.attributes['font.family'] == nil then
    elem.attributes['font.family'] = 'monospace'
  end
  if elem.attributes['shading.color'] == nil then
    elem.attributes['shading.color'] = '#f8f8f8'
  end
  local span = pandoc.Span(elem.text)
  span.attr = elem.attr
  return span
end
