

_ = require "underscore"
humane_list = require "humane_list"


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
      slice       = []
      slice_end   = orig_pos - 1
      length      = 0
      
      for f, fi in finders
          
        # If splat, loop until finder no longer matches element sequence
        if typeof(f) is 'function' and f.is_splat
          # We loop and gather each element for the splat.
          ele_arr       = []
          move_backward = false
          
          while f( list.value(), list.position() - 1, fi)
              ele_arr.push list.value()
              break if list.is_at_end()
              list.forward() 
              move_backward = true
              
          finders_match = not _.isEmpty( ele_arr )
          
          if finders_match
            length += ele_arr.length
            slice.push ele_arr
            
          if move_backward
            list.backward()
          
        else # match element to finder
          
          finders_match = if typeof(f) is 'function'
            f list.value(), list.position() - 1, fi
          else
            list.value() is f
            
          if finders_match
            length += 1
            slice.push(list.value())
            
        break if not finders_match
        break if list.is_at_end()
        list.forward()
          
      # If slice matches the finders:
      
      if finders_match
        final.start_index = orig_pos - 1
        final.end_index   = final.start_index + length
        final.length      = length
        final.slice       = slice
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
  
  
  
