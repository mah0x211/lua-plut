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
