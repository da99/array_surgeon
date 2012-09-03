
path = require "path"
assert = require 'assert'
surgeon = require "array_surgeon"
_ = require "underscore"

is_2 = (val) ->
  val is 2
is_3 = (val) ->
  val is 3
is_7 = (val) ->
  val is 7
is_true = () ->
  true
is_false = () ->
  false

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

      target = {
        start_index: 1
        end_index:   3
        length:      2
        slice:       [2,3]
        indexs:      [1, 2]
      }
      
      target_keys = (k for k, v of target).sort()
      keys        = (k for k, v of results).sort()
      
      assert_obj_equal results, target
      assert.deepEqual keys, target_keys

    it "starts search based on given offset", () ->
      results = surgeon([1,2,3,4,1,2,3,4]).describe_slice [is_2, is_3], 4
      
      assert_obj_equal results, {
        start_index: 5,
        end_index:   7,
        length:      2,
        slice:       [2,3]
        indexs:      [5, 6]
      }
     
    it "passes index in correct correlation to slice <-> sequence", () ->
      i_s = []
      func_true = (v, i) ->
        i_s.push i
        true
      func_false = (v, i) ->
        i_s.push i
        false
        
      surgeon([0,2,4,6]).describe_slice [func_true, func_false]
      assert.deepEqual i_s, [0,1,1,2,2,3,3]

    it "passes index/position of sequence as 3rd argument to finder", () ->
      i_s = []
      func_true = (v, i, j) ->
        i_s.push j
        true
      func_false = (v, i, j ) ->
        i_s.push j
        false
        
      surgeon([0,2,4,6]).describe_slice [func_true, func_false]
      assert.deepEqual i_s, [0,1,0,1,0,1,0]

    it "groups splat items as one array", () ->
      is_4_to_6 = (v) ->
        v in [4, 5, 6]
      is_4_to_6.is_splat = true

      is_8_to_9 = (v) ->
        v in [8,9]
      is_8_to_9.is_splat = true

      is_10 = (v) ->
        v is 10
        
      desc = surgeon(_.range(1,12)).describe_slice [is_3, is_4_to_6, is_7, is_8_to_9, is_10]
      target =
        start_index: 2
        end_index:   10
        length:      8
        slice:       [3, [4, 5, 6], 7, [8,9], 10]
        indexs:      [2,  3, 4, 5,  6,  7,8,  9  ]

      assert.deepEqual desc, target

    it "grabs splat items to the end if no other finder succeeds it", () ->
        
      is_4_or_greater = (v) ->
        v >= 4
      is_4_or_greater.is_splat = true
        
      desc = surgeon([1,2,3,4,5,6,7,8]).describe_slice [is_4_or_greater]
      target =
        start_index: 3
        end_index:   8
        length:      5
        slice:       [[4, 5, 6, 7, 8]]
        indexs:      [ 3, 4, 5, 6, 7 ]

      assert.deepEqual desc, target

  describe ".replace_all", () ->
    
    it "replaces all sequences", () ->
      hay = [ 1, 2, 3, 4, 1, 2, 3, 4 ]
      results = surgeon(hay).replace_all [ is_2, is_3 ], "missing"
      assert.deepEqual results, [ 1, "missing", 4, 1, "missing", 4 ]
    
    it "replaces values in array with new ones: .replace_all( [..], arg2, arg3, arg4 )", () ->
      hay = [ 1, 2, 3, 4, 1, 2, 3, 4 ]
      results = surgeon(hay).replace_all [ is_2, is_3 ], "two", "three"
      assert.deepEqual results, [ 1, "two", "three", 4, 1, "two", "three", 4 ]
    
  describe ".replace", () ->
    
    it "replaces elements", () ->

      results = surgeon([ 1, 2, 3, 4 ]).replace [ 2, 3 ], "missing"
      assert.deepEqual results, [ 1, "missing",  4 ]

    it "replaces only one sequence", () ->
      hay = [ 1, 2, 3, 4, 1, 2, 3, 4 ]
      results = surgeon(hay).replace [ is_2, is_3 ], "missing"
      assert.deepEqual results, [ 1, "missing", 4, 1, 2, 3, 4 ]
    
    it "replaces values in array with new ones: .replace( [..], arg2, arg3, arg4 )", () ->
      hay = [ 1, 2, 3, 4 ]
      results = surgeon(hay).replace [ is_2, is_3 ], "two", "three"
      assert.deepEqual results, [ 1, "two", "three", 4 ]

    it "replaces elements using functions for comparison", () ->

      results = surgeon([ 1, 2, 3, 4 ]).replace [is_2, is_3], "missing"
      assert.deepEqual results, [ 1, "missing",  4 ]

    it "passes index of element to finder function", () ->
      i_s = []
      func = (v, i) ->
        i_s.push i
        false
      surgeon([1,3,5,7]).replace [func], 2
      assert.deepEqual i_s, [0,1,2,3]

    it "returns a new array, not altering the original", () ->
      orig = [ 1, 2, 3, 4 ]
      target = orig.slice(0)
      results = surgeon(orig).replace [ is_2, is_3 ], "new"
        
      assert.deepEqual orig, target
      
  describe ".remove_all", () ->
    
    it "removes all sequences", () ->
      hay = [ 1, 2, 3, 4, 1, 2, 3, 4 ]
      results = surgeon(hay).remove_all [ is_2, is_3 ]
      assert.deepEqual results, [ 1, 4, 1, 4 ]

  describe ".remove", () ->
    
    it "removes elements based on callback", () ->

      results = surgeon([ 1, 2, 3, 4 ]).remove [ is_2, is_3 ]
      assert.deepEqual results, [ 1,  4 ]

    it "removes only one sequence", () ->
      hay = [ 1, 2, 3, 4, 1, 2, 3, 4 ]
      results = surgeon(hay).remove [ is_2, is_3 ]
      assert.deepEqual results, [ 1, 4, 1, 2, 3, 4 ]
     
    it "passes index of element to finder function", () ->
      i_s = []
      func = (v, i) ->
        i_s.push i
        false
      surgeon([2,4,6,8]).remove [func]
      assert.deepEqual i_s, [0,1,2,3]
      
    it "returns a new array, not altering the original", () ->
      orig = [ 1, 2, 3, 4 ]
      target = orig.slice(0)
      results = surgeon(orig).remove [ is_2, is_3 ]
        
      assert.deepEqual orig, target

     
