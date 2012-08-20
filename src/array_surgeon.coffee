

_ = require "underscore"
  
class Surgeon
  constructor: (hay) ->
    @hay = hay
    
  describe_slice:  (finders, offset) ->
    arr = @hay
    final = 
      start_index: null
      end_index: null
      length: 0
    
    offset ?= 0
    i = (offset - 1)
    while i < arr.length
      i += 1

      # Get a slice and run it through the finders.
      slice_end = finders.length + i
      slice = arr.slice(i, slice_end)
      is_seq = false
      break if slice.length < finders.length
      if slice.length == finders.length
        for f, fi in finders
          ele = slice[fi]
          is_seq = if typeof(f) is 'function'
            f(ele, i)
          else
            ele is f
          break if !is_seq

      # If slice matches the finders:
      if is_seq
        final.start_index = i
        final.end_index   = slice_end
        final.length      = slice.length
        final.slice       = slice
        break

    return null if final.length is 0
    final

  remove: (args...) ->
    @replace args...
    
  replace: (finders, replace) ->
    return @hay if @hay.length < finders.length
    arr = @hay
    i = -1
    l = arr.length
    while i < l
      i += 1
      
      meta = @describe_slice(finders, i)
      break unless meta
      i = meta.end_index - 2
      splice_args = [ meta.start_index, meta.length ]
      
      if typeof(replace) is 'function'
        splice_args.push replace(meta.slice) 
      else if typeof(replace) != 'undefined'
        splice_args.push replace
        
      arr.splice splice_args...
      l = arr.length

    arr

    
module.exports = (hay) ->
  new Surgeon(hay)
  
  
  
