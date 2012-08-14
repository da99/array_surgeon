
array\_surgeon
=============

Find a consecutive group of elements in an array and remove or replace them.


Usage
====

    shell> npm install array_surgeon

    surgeon = require 'array_surgeon'

    hay = [ 1, 2, 3, 4 ]
    
    // You can use a regular array
    surgeon.remove hay, [ 2, 3 ]
    # ==> [ 1, 4 ]
   
    surgeon.replace hay, [ 2, 3 ], "missing"
    # ==> [ 1, "missing", 4 ]


You can also use a function for comparision:

    is_2 = (val) ->
      val is 2
      
    is_3 = (val) ->
      val is 3
      
    surgeon.remove hay, [ is_2, is_3 ]
    # ==> [ 1,  4 ]
   
    surgeon.replace hay, [ is_2, is_3 ], "missing"
    # ==> [ 1, "missing", 4 ]


   
