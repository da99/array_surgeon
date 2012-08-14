
array\_surgeon
=============

Find a consecutive group of elements in an array and remove or replace them.


Usage
====

    shell> npm install array_surgeon

    surgeon = require 'array_surgeon'

    hay = [ 1, 2, 3, 4 ]

    finders = []
    finder.push (val, props) ->
      val is 2
    finder.push (val, props) ->
      val is 3

    surgeon.remove hay, finders
    # ==> [ 1,  4 ]
   
    surgeon.replace hay, finders, "missing"
    # ==> [ 1, "missing", 4 ]


   
