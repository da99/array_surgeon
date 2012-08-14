
array\_surgeon
=============

Find a consecutive group of elements in an array and remove or replace them.


Usage
====

    shell> npm install array_surgeon

    surgeon = require 'array_surgeon'

    hay = [ 1, 2, 3, 4 ]

    finder = ( val, props ) ->
      props.is_first
      props.is_last
      (val is 2) or (val is 3)

    surgeon.remove hay, finder
    # ==> [ 1,  4 ]
   
    surgeon.replace hay, finder, "missing"
    # ==> [ 1, "missing", 4 ]


   
