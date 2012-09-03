

_ = require "underscore"
humane_list = require "humane_list"


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
    current_i = (offset - 1)
    
    while current_i < arr.length
      current_i += 1
      i = current_i

      slice_start = i
      slice_end   = i
      finders_match = false
      slice       = []
      
      for f, fi in finders
        break if (i + fi) >= arr.length
          
        ele = arr[i + fi]

        # If splat, loop until finder no longer matches element sequence
        if typeof(f) is 'function' and f.is_splat
          
          # We loop and gather each element for the splat.
          ele_arr = []
          orig_i = i
          while (i + fi < arr.length) and f(ele, i + fi, fi)
            ele_arr.push ele
            i += 1
            ele = arr[i + fi]
            
          finders_match = not _.isEmpty( ele_arr )
          if finders_match 
            i = orig_i + ele_arr.length  - 1
            slice_end += ele_arr.length
            slice.push ele_arr
          
        else # match element to finder
          
          finders_match = if typeof(f) is 'function'
            f ele, i + fi, fi
          else
            ele is f
            
          if finders_match
            slice.push(ele)
            slice_end += 1
            
        break if not finders_match
          
      # If slice matches the finders:
      if finders_match
        final.start_index = slice_start
        final.end_index   = slice_end
        final.length      = slice_end - slice_start
        final.slice       = slice
        final.indexs      = _.range( slice_start, slice_end )
        break

    return null if final.length is 0
    final

  alter_all: (meth, args...) ->
    new_arr = @hay
    alter = () ->
      new_arr = module.exports(new_arr)[meth](args...)
      new_arr
    while !_.isEqual(new_arr, alter() )
      new_arr
    new_arr
    
  replace_all: (args...) ->
    @alter_all('replace', args...)
    
  remove_all: (args...) ->
    @alter_all('remove', args...)

  remove: (args...) ->
    @replace args...

  replace: (finders, replaces...) ->
    return @hay if @hay.length < finders.length
    arr = @hay.slice(0)
    i = -1
    l = arr.length
    while i < l
      i += 1
      
      meta = module.exports(arr).describe_slice(finders, i)
      break unless meta
      i = meta.end_index - 1
      splice_args = [ meta.start_index, meta.length ].concat(replaces)
      
      arr.splice splice_args...
      l = arr.length
      break

    arr

    
module.exports = (hay) ->
  new Surgeon(hay)
  
  
  
