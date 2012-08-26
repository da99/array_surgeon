
array\_surgeon
=============

Find a consecutive group of elements in an array and remove or replace them.

Similar, but different to: array\_pinch
===============================

The npm package, [array\_pinch](https://npmjs.org/package/array_pinch), 
lets you define only the start and end points of the sequence:

    pinch = require "pinch"
    arr = [1,2,3,4,5,6]
    pinch(arr).remove [2,5]
    # ===> [ 1, 6 ]

Installation & Usage
====

    shell> npm install array_surgeon

    surgeon = require 'array_surgeon'

    hay = [ 1, 2, 3, 4, 5, 6 ]
    
    // You can use a regular array
    surgeon(hay).remove [ 2, 5 ]
    # ==> [ 1, 6 ]
   
    surgeon(hay).replace [ 2, 5 ], "two", "->", "five"
    # ==> [ 1, "two", "->", "five", 6 ]

You also get `remove_all` and `replace_all`:

    hay = [ 1, 2, 3, 4, 1, 2, 3, 4 ]
    
    surgeon(hay).remove_all [ 2, 3 ]
    # ==> [ 1, 4, 1, 4 ]
   
    surgeon(hay).replace_all [ 2, 3 ], "missing"
    # ==> [ 1, "missing", 4, 1, "missing", 4 ]
    


Using Functions for Comparison
==============================

You can also use a function for comparision:

    is_2 = (val) ->
      val is 2
      
    is_3 = (val) ->
      val is 3
      
    surgeon(hay).remove [ is_2, is_3 ]
    # ==> [ 1,  4 ]
   
    surgeon(hay).replace [ is_2, is_3 ], "missing"
    # ==> [ 1, "missing", 4 ]

The comparison function also accepts two other arguments:

  * arr\_i: the position of the value within the array.
  * finder\_i: the position of the comparison function within the array of finders.

Example:

    is_2 = (val, arr_i, finder_i) ->
      console.log "Checking #{val} at position #{arr_i} with finder at #{finder_i}"
      val is 2


Get Info on a Slice
================
You can also get info on the first slice that matches your slice:

    surgeon(hay).describe_slice [ is_2, is_3 ]
    
    # ==> 
    { 
      start_index: 1, 
      end_index:   3, 
      length:      2,
      slice:       [2, 3]
      indexs:      [1, 2]
    }
   
  
