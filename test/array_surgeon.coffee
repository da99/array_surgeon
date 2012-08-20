
path = require "path"
assert = require 'assert'
surgeon = require "array_surgeon"

is_2 = (val) ->
  val is 2
is_3 = (val) ->
  val is 3

assert_obj_equal = (a, b) =>
  for k,v of a
    assert.deepEqual v, b[k]

describe "array_surgeon", () ->

  describe ".describe_slice", () ->
    it "returns null if slice is not found", () ->
      results = surgeon([ 1, 3, 3, 4 ]).describe_slice [is_2, is_3]
      assert.equal results, null

    it "returns an object describing the slice", () ->
      results = surgeon([1,2,3,4]).describe_slice [is_2, is_3]

      assert_obj_equal results, {
        slice: [2,3],
        start_index: 1
        end_index: 3
        length: 2
      }

    it "starts search based on given offset", () ->
      results = surgeon([1,2,3,4,1,2,3,4]).describe_slice [is_2, is_3], 4
      
      assert_obj_equal results, {
        start_index: 5,
        end_index:   7,
        length:      2,
        slice:       [2,3]
      }
     
    it "passes index of element to finder function", () ->
      i_s = []
      func = (v, i) ->
        i_s.push i
        false
      surgeon([0,2,4,6]).describe_slice [func]
      assert.deepEqual i_s, [0,1,2,3]
      
  describe ".replace", () ->
    
    it "replaces elements", () ->

      results = surgeon([ 1, 2, 3, 4 ]).replace [ 2, 3 ], "missing"
      assert.deepEqual results, [ 1, "missing",  4 ]
    
    it "replaces elements using functions for comparison", () ->

      results = surgeon([ 1, 2, 3, 4 ]).replace [is_2, is_3], "missing"
      assert.deepEqual results, [ 1, "missing",  4 ]

    it "replaces elements with return of callback", () ->

      results = surgeon([ 1, 2, 3, 4 ]).replace [ is_2, is_3 ], (slice, props) ->
        slice.join(",")
        
      assert.deepEqual results, [ 1, "2,3",  4 ]
      

  describe ".remove", () ->
    
    it "removes elements based on callback", () ->

      results = surgeon([ 1, 2, 3, 4 ]).remove [ is_2, is_3 ]
      assert.deepEqual results, [ 1,  4 ]

    it "removes multiple sequences", () ->
      hay = [ 1, 2, 3, 4, 1, 2, 3, 4 ]
      results = surgeon(hay).remove [ is_2, is_3 ]
      assert.deepEqual results, [ 1,  4, 1, 4 ]
     
      

     
