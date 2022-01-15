# lua-plut

[![test](https://github.com/mah0x211/lua-plut/actions/workflows/test.yml/badge.svg)](https://github.com/mah0x211/lua-plut/actions/workflows/test.yml)
[![Coverage Status](https://coveralls.io/repos/github/mah0x211/lua-plut/badge.svg?branch=master)](https://coveralls.io/github/mah0x211/lua-plut?branch=master)

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


## val, err, glob = p:lookup( pathname )

lookup the values in the specified pathname.

**Parameters**

- `pathname:string`: target pathname.

**Returns**

- `val:any`: the value of the last segment of the specified pathname.
- `err:error`: an error object.
- `glob:table`: holds the value on the route up to the last segment.



