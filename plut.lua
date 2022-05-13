--
-- Copyright (C) 2022 Masatoshi Fukunaga
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
--- assign to local
local next = next
local type = type
local error = require('error')
local new_error_message = error.message.new
local check = error.check
local check_table = check.table
local check_func = check.func
local find = string.find
local sub = string.sub
local setmetatable = setmetatable
--- symbols
local SYM_VAR = '^'
local SYM_ALL = '*'
local SYM_EOS = '#'
--- lookup tables
local VSEGMENT = {
    [':'] = SYM_VAR,
    ['*'] = SYM_ALL,
}
local RESERVED = {
    [SYM_VAR] = true,
    [SYM_ALL] = true,
    [SYM_EOS] = true,
}
--- @alias error userdata
--- @class plut.error
--- @field new function
local ECATCHALL = 0
local EPATHNAME = error.type.new('plut.EPATHNAME', 1,
                                 'pathname must be absolute path')
local EEMPTY = error.type.new('plut.EEMPTY', 2, 'cannot use empty segment')
local ERESERVED = error.type.new('plut.ERESERVED', 3,
                                 'cannot use reserved segment')
local EUNNAMED = error.type.new('plut.EUNNAMED', 4,
                                'cannot create unnamed variable segment')
local EALREADY = error.type.new('plut.EALREADY', 5, 'segment already defined')
local EVALREADY = error.type.new('plut.EVALREADY', 6,
                                 'variable segment already defined')
local ETOOMANYSEG = error.type.new('plut.ETOOMANYSEG', 7,
                                   'cannot create a segment after a catch-all segment')
local ECOEXIST = error.type.new('plut.ECOEXIST', 8,
                                'catch-all segment cannot coexist with other segments')

--- mkerror
--- @param op string
--- @param errt error.type
--- @return error err
local function mkerror(op, errt)
    return errt:new(new_error_message(nil, op), nil, 3)
end

--- has_child
--- @param node table
--- @return boolean
local function has_child(node)
    local k = next(node)

    while k do
        if k ~= SYM_EOS then
            return true
        end
        k = next(node, k)
    end

    return false
end

--- mknode
--- @param pathname string
--- @param pos integer
--- @param seg string
--- @param node table
--- @param mklist table
--- @return table node
--- @return error err
local function mknode(_, _, seg, node, mklist)
    if #seg == 0 then
        -- cannot use empty segment
        return nil, mkerror('mknode', EEMPTY)
    elseif mklist.is_catchall then
        -- cannot create a segment after a catch-all segment
        return nil, mkerror('mknode', ETOOMANYSEG)
    end

    -- variable segment
    local vseg = VSEGMENT[sub(seg, 1, 1)]
    if vseg then
        -- extract variable name
        local name = sub(seg, 2)

        -- variable-segment name length must be greater than 0
        if #name < 1 then
            return nil, mkerror('mknode', EUNNAMED)
        end

        local vnode = node[vseg]

        mklist.is_catchall = vseg == SYM_ALL

        -- not found
        if not vnode then
            if mklist.is_catchall and has_child(node) then
                -- catch-all segment cannot coexist with other segments
                return nil, mkerror('mknode', ECOEXIST)
            elseif node[SYM_ALL] or node[SYM_VAR] then
                -- variable-segment already defined
                return nil, mkerror('mknode', EVALREADY)
            end

            -- create new variable node
            vnode = {
                name = name,
                node = {},
            }
            mklist[#mklist + 1] = {
                node = node,
                seg = vseg,
            }
        elseif vnode.name ~= name then
            -- variable-segment already defined
            return nil, mkerror('mknode', EVALREADY)
        end

        node[vseg] = vnode

        return vnode.node
    end

    -- catch-all segment exists
    if node[SYM_ALL] then
        -- catch-all segment cannot coexist with other segments
        return nil, mkerror('mknode', ECOEXIST)
    end

    -- found node
    if node[seg] then
        return node[seg]
    end

    -- create new node
    node[seg] = {}
    mklist[#mklist + 1] = {
        node = node,
        seg = seg,
    }

    return node[seg]
end

--- trace
--- @param pathname string
--- @param pos integer
--- @param seg string
--- @param node table
--- @param pathz table
--- @return table node
local function trace(_, _, seg, node, pathz)
    -- variable segment
    local vseg = VSEGMENT[sub(seg, 1, 1)]

    if vseg then
        local vnode = node[vseg]

        if not vnode or vnode.name ~= sub(seg, 2) then
            return nil
        end

        pathz[#pathz + 1] = {
            name = vseg,
            node = vnode.node,
            parent = node,
        }
        return vnode.node
    end

    if node[seg] then
        pathz[#pathz + 1] = {
            name = seg,
            node = node[seg],
            parent = node,
        }
        return node[seg]
    end
end

--- get
--- @param pathname string
--- @param pos integer
--- @param seg string
--- @param node table
--- @return table node
local function get(_, _, seg, node)
    -- variable segment
    local vseg = VSEGMENT[sub(seg, 1, 1)]
    if vseg then
        local vnode = node[vseg]
        if not vnode or vnode.name ~= sub(seg, 2) then
            return nil
        end
        return vnode.node
    end

    return node[seg]
end

--- lookup
--- @param pathname string
--- @param pos integer
--- @param seg string
--- @param node table
--- @param glob table
--- @param pickup boolean
--- @return table node
--- @return integer err
local function lookup(pathname, pos, seg, node, glob, pickup)
    if pickup then
        -- pickup the node-value
        if node[SYM_EOS] then
            glob[#glob + 1] = node[SYM_EOS]
        end

        -- pickup the node-value of the trailing-slash node
        if seg ~= '/' and node['/'] then
            glob[#glob + 1] = node['/'][SYM_EOS]
        end
    end

    -- found segment
    if node[seg] then
        return node[seg]
    end

    -- variable-segment
    local vnode = node[SYM_VAR]
    if vnode then
        glob[vnode.name] = seg
        return vnode.node
    end

    -- catch-all-segment
    vnode = node[SYM_ALL]
    if vnode then
        glob[vnode.name] = sub(pathname, pos)
        return vnode.node, ECATCHALL
    end
end

--- traverse
--- @alias getchildfn fun(pathname:string, pos:integer, seg:string, node:table, ...):table,error
--- @param pathname string
--- @param node table
--- @param fn getchildfn
--- @vararg any arguments for fn
--- @return any val
--- @return error err
local function traverse(pathname, node, fn, ...)
    check_table(node, 2)
    check_func(fn, 3)

    -- pathname must be absolute path
    if sub(pathname, 1, 1) ~= '/' then
        return nil, mkerror('traverse', EPATHNAME)
    end

    local pos = 2
    local head, tail = find(pathname, '/', pos, true)
    while head do
        local seg = sub(pathname, pos, head - 1)

        -- there is reserved segment name
        if RESERVED[seg] then
            return nil, mkerror('traverse', ERESERVED)
        end

        -- get child node
        local child, err = fn(pathname, pos, seg, node, ...)
        if not child or err then
            return child, err
        end

        node = child
        pos = tail + 1
        head, tail = find(pathname, '/', pos, true)
    end

    -- check last segment
    if pos <= #pathname then
        local seg = sub(pathname, pos)

        -- there is reserved segment name
        if RESERVED[seg] then
            return nil, mkerror('traverse', ERESERVED)
        end

        -- get child node
        return fn(pathname, pos, seg, node, ...)
    end

    -- trailing-slash
    return fn(pathname, pos, '/', node, ...)
end

--- @class Plut
--- @field symbol string
--- @field tree table
local Plut = {}
Plut.__index = Plut

--- set
--- @param pathname string
--- @param val any
--- @return boolean ok
--- @return error err
function Plut:set(pathname, val)
    if type(pathname) ~= 'string' then
        error('pathname must be string', 2)
    elseif val == nil then
        error('val must not be nil', 2)
    end

    -- create node
    local mklist = {}
    local node, err = traverse(pathname, self.tree, mknode, mklist)

    if not node then
        -- remove created node
        for _, v in ipairs(mklist) do
            v.node[v.seg] = nil
        end
        return false, err
    elseif node[SYM_EOS] then
        return false, mkerror('set', EALREADY)
    end

    -- set value
    node[SYM_EOS] = val

    return true
end

--- del
--- @param pathname string
--- @return any val
--- @return error err
function Plut:del(pathname)
    if type(pathname) ~= 'string' then
        error('pathname must be string', 2)
    end

    local pathz = {}
    local node, err = traverse(pathname, self.tree, trace, pathz)

    -- not found
    if not node or not node[SYM_EOS] then
        return nil, err
    end

    local val = node[SYM_EOS]

    -- remove value
    node[SYM_EOS] = nil
    -- remove empty node
    for i = #pathz, 1, -1 do
        local path = pathz[i]
        if path.node and next(path.node) then
            -- has child nodes
            break
        end
        path.parent[path.name] = nil
    end

    return val
end

--- get
--- @param pathname string
--- @return any val
--- @return error err
function Plut:get(pathname)
    if type(pathname) ~= 'string' then
        error('pathname must be string', 2)
    end

    local node, err = traverse(pathname, self.tree, get)

    if not node then
        return nil, err
    end

    return node[SYM_EOS]
end

--- dumper
--- @param list table
--- @param pathname string
--- @param node table
--- @return table list
local function dumper(list, pathname, node)
    if node['/'] then
        list[pathname .. '/'] = node['/'][SYM_EOS]
    end

    for seg, v in pairs(node) do
        if seg ~= '/' then
            if seg == SYM_EOS then
                list[pathname] = v
            elseif seg == SYM_VAR then
                dumper(list, pathname .. '/:' .. v.name, v.node)
            elseif seg == SYM_ALL then
                dumper(list, pathname .. '/*' .. v.name, v.node)
            else
                dumper(list, pathname .. '/' .. seg, v)
            end
        end
    end

    return list
end

--- dump
--- @return table<string, any> list
function Plut:dump()
    return dumper({}, '', self.tree)
end

--- lookup
--- @param pathname string
--- @param pickup boolean
--- @return any val
--- @return error err
--- @return table glob
function Plut:lookup(pathname, pickup)
    if type(pathname) ~= 'string' then
        error('pathname must be string', 2)
    elseif pickup ~= nil and type(pickup) ~= 'boolean' then
        error('pickup must be boolean', 2)
    end

    local glob = {}
    local node, err = traverse(pathname, self.tree, lookup, glob, pickup)

    if not node then
        return nil, err
    end

    local val = node[SYM_EOS]
    if val then
        return val, nil, glob
    end
end

--- new
--- @return Plut
local function new()
    return setmetatable({
        tree = {},
    }, Plut)
end

return {
    new = new,
    EPATHNAME = EPATHNAME,
    EEMPTY = EEMPTY,
    ERESERVED = ERESERVED,
    EUNNAMED = EUNNAMED,
    EALREADY = EALREADY,
    EVALREADY = EVALREADY,
    ETOOMANYSEG = ETOOMANYSEG,
    ECOEXIST = ECOEXIST,
}
