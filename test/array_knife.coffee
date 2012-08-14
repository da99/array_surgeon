
path = require "path"
knife = require path.resolve("lib/array_knife.js")
assert = require 'assert'


describe "array_knife", () ->

  describe ".replace", () ->
    it "replaces elements", () ->

      arr_knife = require 'array_knife'

      hay = [ 1, 2, 3, 4 ]

      finder = ( val, props ) ->
        (val is 2) or (val is 3)

      results = arr_knife.replace arr, finder, "missing"
      assert.deepEqual results, [ 1, "missing",  4 ]

    it "replaces elements with return of callback", () ->

      arr_knife = require 'array_knife'

      hay = [ 1, 2, 3, 4 ]

      finder = ( val, props ) ->
        (val is 2) or (val is 3)

      results = arr_knife.replace arr, finder, (slice, props) ->
        slice.join(",")
        
      assert.deepEqual results, [ 1, "2,3",  4 ]
      

  describe ".remove", () ->
    it "removes elements based on callback", () ->

      arr_knife = require 'array_knife'

      hay = [ 1, 2, 3, 4 ]

      finder = ( val, props ) ->
        (val is 2) or (val is 3)

      results = arr_knife.remove arr, finder
      assert.deepEqual results, [ 1,  4 ]
     
      arr_knife.replace arr, finder, "missing"
      # ==> [ 1, "missing", 4 ]


     
