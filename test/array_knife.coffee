
path = require "path"
assert = require 'assert'
knife = require "array_knife"


describe "array_knife", () ->

  describe ".replace", () ->
    it "replaces elements", () ->

      knife = require 'array_knife'

      hay = [ 1, 2, 3, 4 ]

      finder = ( val, props ) ->
        (val is 2) or (val is 3)

      results = hay.knife 'replace', finder, "missing"
      assert.deepEqual results, [ 1, "missing",  4 ]

    it "replaces elements with return of callback", () ->

      knife = require 'array_knife'

      hay = [ 1, 2, 3, 4 ]

      finder = ( val, props ) ->
        (val is 2) or (val is 3)

      results = hay.knife 'replace', finder, (slice, props) ->
        slice.join(",")
        
      assert.deepEqual results, [ 1, "2,3",  4 ]
      

  describe ".remove", () ->
    it "removes elements based on callback", () ->

      knife = require 'array_knife'

      hay = [ 1, 2, 3, 4 ]

      finder = ( val, props ) ->
        (val is 2) or (val is 3)

      results = hay.knife 'remove', finder
      assert.deepEqual results, [ 1,  4 ]

    it "removes multiple sequences", () ->

      knife = require 'array_knife'

      hay = [ 1, 2, 3, 4, 1, 2, 3, 4 ]

      finder = ( val, props ) ->
        (val is 2) or (val is 3)

      results = hay.knife 'remove', finder
      assert.deepEqual results, [ 1,  4, 1, 4 ]
     
  describe '.get_seqs', () ->
    it 'returns a sequence of array indexes of elements that match callback', () ->
      knife = require 'array_knife'

      hay = [ 1, 2, 3, 4, 1, 2, 3, 4 ]

      finder = ( val, props ) ->
        (val is 2) or (val is 3)

      results = hay.knife 'get_seqs', finder
      assert.deepEqual results, [ [1,2], [5, 6] ]

     
