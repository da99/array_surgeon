

_ = require "underscore"
humane_list = require "humane_list"

class Slice
  constructor: () ->
    @vals = []
    @new_sub = true
    @_length = 0

  length: () ->
    @_length

  plus_length: () ->
    @_length += 1
    
  push: (val) ->
    @new_sub = true
    @vals.push val
    @plus_length()
    val

  sub_push: (val) ->
    if @new_sub
      @vals.push([])
      @new_sub = false

    _.last(@vals).push val
    @plus_length()
    val

  values: () ->
    @vals

class Surgeon
  constructor: (hay) ->
    @hay = hay
    
  describe_slice:  (finders, offset) ->
    
    return null if @hay.length is 0 
    
    list = new humane_list(@hay)
    final = 
      start_index: null
      end_index:   null
      length:      0
    
    list.to( (offset || 0 ) + 1 )
    loop
      
      orig_pos      = list.position() 
      finders_match = false
      slice       = new Slice()
      slice_end   = orig_pos - 1
      
      for f, fi in finders
          
        # If splat, loop until finder no longer matches element sequence
        if typeof(f) is 'function' and f.is_splat
          # We loop and gather each element for the splat.
          move_backward = false
          
          while f( list.value(), list.position() - 1, fi)
              finders_match = true
              slice.sub_push list.value()
              break if list.is_at_end()
              list.forward()
              move_backward = true
              
          if move_backward
            list.backward()
          break if not finders_match
          
        else # match element to finder
          
          finders_match = if typeof(f) is 'function'
            f list.value(), list.position() - 1, fi
          else
            list.value() is f
            
          break if not finders_match
          slice.push(list.value())
            
        if list.is_at_end() and (fi isnt finders.length - 1)
          finders_match = false
        break if list.is_at_end()
        list.forward()
          
      # If slice matches the finders:
      if finders_match
        final.start_index = orig_pos - 1
        final.end_index   = final.start_index + slice.length()
        final.length      = slice.length()
        final.slice       = slice.values()
        final.indexs      = _.range( final.start_index, final.end_index )
        break
      else
        list.to( orig_pos )

      break if list.is_at_end()
      list.forward() 

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
  
  
  
