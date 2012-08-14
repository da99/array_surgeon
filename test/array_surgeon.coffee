
path = require "path"
assert = require 'assert'
surgeon = require "array_surgeon"


describe "array_surgeon", () ->

  describe ".replace_sequences", () ->
    it "replaces elements", () ->

      surgeon = require 'array_surgeon'

      hay = [ 1, 2, 3, 4 ]

      finders = []
      finders.push ( val, props ) ->
        (val is 2)
        
      finders.push (val, props) ->
        val is 3

      results = hay.surgeon 'replace_sequences', finders, "missing"
      assert.deepEqual results, [ 1, "missing",  4 ]

    it "replaces elements with return of callback", () ->

      surgeon = require 'array_surgeon'

      hay = [ 1, 2, 3, 4 ]

      finders = []
      finders.push ( val, props ) ->
        (val is 2) 
      finders.push (val, props) ->
        (val is 3)

      results = hay.surgeon 'replace_sequences', finders, (slice, props) ->
        slice.join(",")
        
      assert.deepEqual results, [ 1, "2,3",  4 ]
      

  describe ".remove_sequences", () ->
    it "removes elements based on callback", () ->

      surgeon = require 'array_surgeon'

      hay = [ 1, 2, 3, 4 ]

      finders = []
      finders.push ( val, props ) ->
        (val is 2) 
      finders.push (val, props) ->
        (val is 3)

      results = hay.surgeon 'remove_sequences', finders
      assert.deepEqual results, [ 1,  4 ]

    it "removes multiple sequences", () ->

      surgeon = require 'array_surgeon'

      hay = [ 1, 2, 3, 4, 1, 2, 3, 4 ]

      finders = []
      finders.push ( val, props ) ->
        (val is 2) 
      finders.push (val, props ) ->
        (val is 3)

      results = hay.surgeon 'remove_sequences', finders
      assert.deepEqual results, [ 1,  4, 1, 4 ]
     
      

     
