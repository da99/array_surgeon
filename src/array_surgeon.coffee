

if Array.prototype.surgeon
  throw new Error("Already defined: Array.prototype.surgeon")

_ = require "underscore"
  
Array.prototype.surgeon = (op, args...) ->
  if !exports[op]
    throw new Error("Unknown surgeon op: #{op}")
  
  exports[op](this, args...)

exports.replace_sequences = replace_sequences = (raw_arr, finders, replace) ->
  return raw_arr if raw_arr.length < finders.length
  arr = (v for v in raw_arr)
  i = -1
  l = arr.length
  while i < l
    i += 1
    slice_end = finders.length + i
    slice = arr.slice(i, slice_end)
    is_seq = false
    break if slice.length < finders.length
    if slice.length == finders.length
      for f, fi in finders
        ele = slice[fi]
        is_seq = f(ele)
        break if !is_seq

    if is_seq
      splice_args = [ i, finders.length ]
      if typeof(replace) is 'function'
        splice_args.push replace(slice) 
      else if typeof(replace) != 'undefined'
        splice_args.push replace
        
      arr.splice splice_args...
      l = arr.length

  arr


exports.remove_sequences = remove_sequences = (args...) ->
  replace_sequences args...

