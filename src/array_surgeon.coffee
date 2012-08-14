

if Array.prototype.surgeon
  throw new Error("Already defined: Array.prototype.surgeon")

_ = require "underscore"
  
Array.prototype.surgeon = (op, args...) ->
  if !exports[op]
    throw new Error("Unknown surgeon op: #{op}")
  
  exports[op](this, args...)

exports.replace = replace = (arr, func) ->
  []


exports.remove = remove = (arr, finder, yes_or_no) ->
  s = get_first_seq_starting_at(0, arr, finder)
  new_arr = (v for v in arr)
  
  return new_arr if s.length is 0

  do_splice = if yes_or_no
    slice = (new_arr[v] for v in s)
    yes_or_no(slice)
  else
    true
    
  if do_splice
    new_arr.splice( s[0], s.length ) if do_splice
    return remove(new_arr, finder, yes_or_no)
  else




exports.remove_first_seq_starting_at = remove_seq_starting_at = (offset, arr, finder) ->
  s = get_first_seq_starting_at(offset, arr, finder)
  new_arr = (v for v in arr)
  return new_arr if s.length is 0
  new_arr.splice( s[0], s.length ) 
  new_arr


    
exports.get_first_seq_starting_at = get_first_seq_starting_at = (offset, arr, finder) ->
  i = offset
  l = arr.length
  i_in_seq = -1
  current = []
  last_i  = arr.length-1

  while i < l
    v = arr[i]
    i_follows_prev = (current.length is 0) or ((i - _.last(current)) == 1 ) 
    break unless i_follows_prev
    
    i_in_seq += 1
    props =
      index: i
      seq_index: i_in_seq
      is_first: i==0
      is_last:  i==last_i

      
    if finder(v, props)
      current.push(i) 
      
    i = i + 1
    
  current
  

    
    
exports.get_seqs = get_seqs = (arr, finder) ->
  indxs   = [ ]
  current = _.last(indxs)
  last  = arr.length-1
  l = arr.length
  i = 0
  
  while i < l
    i = if indxs.length is 0
      i
    else
      _.last( _.last(indxs) ) + 1
      
    seq = get_first_seq_starting_at(i, arr, finder)
    break if seq.length is 0
    
    indxs.push seq
    i = i + 1
    
  indxs

