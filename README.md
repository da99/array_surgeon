
array\_surgeon
=============

Find a consecutive group of elements in an array and remove or replace them.


Usage
====

    shell> npm install array_surgeon

    surgeon = require 'array_surgeon'

    hay = [ 1, 2, 3, 4 ]
    
    // You can use a regular array
    surgeon(hay).remove [ 2, 3 ]
    # ==> [ 1, 4 ]
   
    surgeon(hay).replace [ 2, 3 ], "missing"
    # ==> [ 1, "missing", 4 ]


You can also use a function for comparision:

    is_2 = (val) ->
      val is 2
      
    is_3 = (val) ->
      val is 3
      
    surgeon(hay).remove [ is_2, is_3 ]
    # ==> [ 1,  4 ]
   
    surgeon(hay).replace [ is_2, is_3 ], "missing"
    # ==> [ 1, "missing", 4 ]

You can also can info on the first slice that matches your slice:

    surgeon(hay).describe_slice [ is_2, is_3 ]
    
    # ==> 
    { 
      start_index: 1, 
      end_index:   3, 
      length:      2,
      slice:       [2, 3]
    }
   
  
