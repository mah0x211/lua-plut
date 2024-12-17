local dump = require('dump')
local plut = require('plut')

-- create instance of plut
local p = plut.new()
print(p) -- plut: 0x600001afa6c0

-- set pathname
local ok, err = p:set('/repos', 'repos-value')
print(dump({
    ok = ok,
    err = err,
}))
-- {
--     ok = true
-- }

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
val, err, glob = p:lookup('/repos/foo/bar', true)
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
val, err, glob = p:lookup('/repos/foo/settings', true)
print(dump({
    val = val,
    err = err,
    glob = glob,
}))
-- {
--     glob = {
--         [1] = "repos-value",
--         owner = "foo",
--     },
--     val = "settings-value"
-- }

-- it returns the value of the parameter segment if it does not match any static segment
val, err, glob = p:lookup('/repos/foo/non-static-segment', true)
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
val, err, glob = p:lookup('/repos/foo/bar/contents/my/contents/filename.txt',
                          true)
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

-- dump all pathnames and values in the lookup table
print(dump(p:dump()))
-- {
--     ["/repos"] = "repos-value",
--     ["/repos/:owner/:repo"] = "repo-value",
--     ["/repos/:owner/:repo/contents/*path"] = "contents-path-value",
--     ["/repos/:owner/settings"] = "settings-value"
-- }
