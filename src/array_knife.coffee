

if Array.prototype.knife
  throw new Error("Already defined: Array.prototype.knife")

_ = require "underscore"
  
Array.prototype.knife = (op, args...) ->
  if !exports[op]
    throw new Error("Unknown knife op: #{op}")
  
  exports[op](this, args...)

exports.replace = replace = (arr, func) ->
  []


exports.remove = remove = (arr, finder) ->
  seqs = get_seqs(arr, finder)

  for s in seqs
  start = null
  end   = null
  indxs   = []
  last  = arr.length-1
  
  for v, i in arr
    i_follows_prev = (indxs.length is 0) or (i - _.last(indxs) == -1 ) 
    break unless i_follows_prev

    props =
      index: i
      is_first: i==0
      is_last:  i==last
    indxs.push(i) if finder(v, props)
    
  return arr if indxs.length is 0
  
  first = indxs[0]
  conseq_arr = ( (i + first) for v, i in indxs )

  is_conseq = conseq_arr.join(',') is indxs.join(',')

  return arr unless is_conseq

  new_arr = (v for v in arr)
  new_arr.splice( indxs[0], indxs.length )
  remove(new_arr, finder)
    
    
exports.get_seqs = get_seqs = (arr, finder) ->
  start = null
  end   = null
  indxs   = [ [] ]
  current = _.last(indxs)
  last  = arr.length-1
  
  for v, i in arr

    i_follows_prev = (current.length is 0) or ((i - _.last(current)) == 1 ) 
    
    props =
      index: i
      is_first: i==0
      is_last:  i==last
      
    if finder(v, props)
      if !i_follows_prev
        current = []
        indxs.push current
      current.push(i) 
    
  indxs.shift if indxs[0].length is 0 
  return [] if indxs.length is 0
  
  indxs

    
    
