# lua-plut

[![test](https://github.com/mah0x211/lua-plut/actions/workflows/test.yml/badge.svg)](https://github.com/mah0x211/lua-plut/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/mah0x211/lua-plut/branch/master/graph/badge.svg)](https://codecov.io/gh/mah0x211/lua-plut)

lua-plut is the path segmented lookup table module.  
this module is used as a URL router.

## Installation

```
luarocks install plut
```

## Usage

```lua
local dump = require('dump')
local plut = require('plut')

-- create instance of plut
local p = plut.new()

-- set pathname
p:set('/repos', 'repos-value')
local val, err, glob = p:lookup('/repos')
print(dump({
    val = val,
    err = err,
    glob = glob,
}))
-- {
--     glob = {},
--     val = "repos-value"
-- }

-- set pathname with parameter segments
p:set('/repos/:owner/:repo', 'repo-value')
val, err, glob = p:lookup('/repos/foo/bar')
print(dump({
    val = val,
    err = err,
    glob = glob,
}))
-- {
--     glob = {
--         [1] = "repos-value",
--         owner = "foo",
--         repo = "bar"
--     },
--     val = "repo-value"
-- }

-- set static segment on same level of parameter segments
p:set('/repos/:owner/settings', 'settings-value')
val, err, glob = p:lookup('/repos/foo/settings')
print(dump({
    val = val,
    err = err,
    glob = glob,
}))
-- {
--     glob = {
--         [1] = "repos-value",
--         owner = "foo"
--     },
--     val = "settings-value"
-- }

-- it returns the value of the parameter segment if it does not match any static segment
val, err, glob = p:lookup('/repos/foo/non-static-segment')
print(dump({
    val = val,
    err = err,
    glob = glob,
}))
-- {
--     glob = {
--         [1] = "repos-value",
--         owner = "foo",
--         repo = "non-static-segment"
--     },
--     val = "repo-value"
-- }

-- set pathname with catch-all segment
p:set('/repos/:owner/:repo/contents/*path', 'contents-path-value')
val, err, glob = p:lookup('/repos/foo/bar/contents/my/contents/filename.txt')
print(dump({
    val = val,
    err = err,
    glob = glob,
}))
-- {
--     glob = {
--         [1] = "repos-value",
--         [2] = "repo-value",
--         owner = "foo",
--         path = "my/contents/filename.txt",
--         repo = "bar"
--     },
--     val = "contents-path-value"
-- }
```

## Error Handling

some functions/methods return the error object that created by https://github.com/mah0x211/lua-error module.

### msg = plut.is_error(err)

this function to extract the error message. if type of `err` is not the `plut.error`, it returns `nil`.

**Parameters**

- `err:error`: an error object.

**Returns**

- `msg:table`: an error message or `nil`.


the value of the `code` field in the error message will be one of the following values;

- `plut.EPATHNAME`: pathname must be absolute path.
- `plut.EEMPTY`: cannot use empty segment.
- `plut.ERESERVED`: cannot use reserved segment.
- `plut.EUNNAMED`: cannot create unnamed variable segment.
- `plut.EALREADY`: segment already defined.
- `plut.EVALREADY`: variable segment already defined.
- `plut.ETOOMANYSEG`: cannot create a segment after a catch-all segment.
- `plut.ECOEXIST`: catch-all segment cannot coexist with other segments.


## p = plut.new()

creates a new plut object.

**Returns**

- `p:plut`: new plut object.


## ok, err = p:set( pathname, val )

set the value to the last segment of the specified pathname.

**Parameters**

- `pathname:string`: target pathname.
- `val:any`: any value except `nil`.

**Returns**

- `ok:boolean`: `true` on success.
- `err:error`: an error object.


**Note**

the pathname can contain parameter segments and catch-all segments.

the parameter segment must started with a `:` mark, and the catch-all segment must started with a `*` mark as shown below. 

```
/foo/:param/bar/*catchall
```

**Constraints:**

- A parameter segment and a catch-all segment can be defined only once in the same hierarchy.

```
/foo/:bar/quux
/foo/:baa/quux  <-- NG :bar already defined
/foo/*qux/quux  <-- NG :bar already defined
/foo/baz/quux   <-- OK static segment can be mixed with parameter segment
```

- A catch-all segment cannot be mixed with other segments.

```
/hello/*world
/hello/*world/quux  <-- NG cannot add any segment under the catch-all segment
/hello/*baa/quux    <-- NG *world already defined
/hello/:bar/quux    <-- NG *world already defined
/hello/baz/quux     <-- NG *world already defined
```

- If a static segment and a parameter segment exist in the same hierarchy, the static segment will be used first.

```
/foo/baz/quux   <-- 'baz' segment priorty is higher than parameter segment
/foo/:bar/quux 

lookup '/foo/baz/quux' will matche '/foo/baz/quux'
lookup '/foo/baa/quux' will matche '/foo/:bar/quux'
```


## val, err = p:del( pathname )

delete the specified pathname.

**Parameters**

- `pathname:string`: target pathname.

**Returns**

- `val:any`: the value of the last segment of the specified pathname, or `nil` if it does not exist.
- `err:error`: an error object.


## val, err = p:get( pathname )

get the value of the specified pathname.

**Parameters**

- `pathname:string`: target pathname.

**Returns**

- `val:any`: the value of the last segment of the specified pathname, or `nil` if it does not exist.
- `err:error`: an error object.


## list = p:dump()

get the list of registered pathname/value pairs.

**Returns**

- `list:table`: the list of registered pathname/value pairs.


## val, err, glob = p:lookup( pathname [, pickup] )

lookup the values in the specified pathname.

**Parameters**

- `pathname:string`: target pathname.
- `pickup:boolean`: picking up the node values on the route up to the last segment.

**Returns**

- `val:any`: the value of the last segment of the specified pathname.
- `err:error`: an error object.
- `glob:table`: holds the node values on the route up to the last segment, and the values of variable segment.


