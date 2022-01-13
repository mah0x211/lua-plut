-- http://developer.github.com/v3/
local GITHUB_API = {
    -- OAuth Authorizations
    {
        method = "GET",
        pathname = "/authorizations",
    },
    {
        method = "GET",
        pathname = "/authorizations/:id",
    },
    {
        method = "POST",
        pathname = "/authorizations",
    },
    {
        method = "PUT",
        pathname = "/authorizations/clients/:client_id",
    },
    {
        method = "PATCH",
        pathname = "/authorizations/:id",
    },
    {
        method = "DELETE",
        pathname = "/authorizations/:id",
    },
    {
        method = "GET",
        pathname = "/applications/:client_id/tokens/:access_token",
    },
    {
        method = "DELETE",
        pathname = "/applications/:client_id/tokens",
    },
    {
        method = "DELETE",
        pathname = "/applications/:client_id/tokens/:access_token",
    },

    -- Activity
    {
        method = "GET",
        pathname = "/events",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/events",
    },
    {
        method = "GET",
        pathname = "/networks/:owner/:repo/events",
    },
    {
        method = "GET",
        pathname = "/orgs/:org/events",
    },
    {
        method = "GET",
        pathname = "/users/:user/received_events",
    },
    {
        method = "GET",
        pathname = "/users/:user/received_events/public",
    },
    {
        method = "GET",
        pathname = "/users/:user/events",
    },
    {
        method = "GET",
        pathname = "/users/:user/events/public",
    },
    {
        method = "GET",
        pathname = "/users/:user/events/orgs/:org",
    },
    {
        method = "GET",
        pathname = "/feeds",
    },
    {
        method = "GET",
        pathname = "/notifications",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/notifications",
    },
    {
        method = "PUT",
        pathname = "/notifications",
    },
    {
        method = "PUT",
        pathname = "/repos/:owner/:repo/notifications",
    },
    {
        method = "GET",
        pathname = "/notifications/threads/:id",
    },
    {
        method = "PATCH",
        pathname = "/notifications/threads/:id",
    },
    {
        method = "GET",
        pathname = "/notifications/threads/:id/subscription",
    },
    {
        method = "PUT",
        pathname = "/notifications/threads/:id/subscription",
    },
    {
        method = "DELETE",
        pathname = "/notifications/threads/:id/subscription",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/stargazers",
    },
    {
        method = "GET",
        pathname = "/users/:user/starred",
    },
    {
        method = "GET",
        pathname = "/user/starred",
    },
    {
        method = "GET",
        pathname = "/user/starred/:owner/:repo",
    },
    {
        method = "PUT",
        pathname = "/user/starred/:owner/:repo",
    },
    {
        method = "DELETE",
        pathname = "/user/starred/:owner/:repo",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/subscribers",
    },
    {
        method = "GET",
        pathname = "/users/:user/subscriptions",
    },
    {
        method = "GET",
        pathname = "/user/subscriptions",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/subscription",
    },
    {
        method = "PUT",
        pathname = "/repos/:owner/:repo/subscription",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/subscription",
    },
    {
        method = "GET",
        pathname = "/user/subscriptions/:owner/:repo",
    },
    {
        method = "PUT",
        pathname = "/user/subscriptions/:owner/:repo",
    },
    {
        method = "DELETE",
        pathname = "/user/subscriptions/:owner/:repo",
    },

    -- Gists
    {
        method = "GET",
        pathname = "/users/:user/gists",
    },
    {
        method = "GET",
        pathname = "/gists",
    },
    {
        method = "GET",
        pathname = "/gists/public",
    },
    {
        method = "GET",
        pathname = "/gists/starred",
    },
    {
        method = "GET",
        pathname = "/gists/:id",
    },
    {
        method = "POST",
        pathname = "/gists",
    },
    {
        method = "PATCH",
        pathname = "/gists/:id",
    },
    {
        method = "PUT",
        pathname = "/gists/:id/star",
    },
    {
        method = "DELETE",
        pathname = "/gists/:id/star",
    },
    {
        method = "GET",
        pathname = "/gists/:id/star",
    },
    {
        method = "POST",
        pathname = "/gists/:id/forks",
    },
    {
        method = "DELETE",
        pathname = "/gists/:id",
    },

    -- Git Data
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/git/blobs/:sha",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/git/blobs",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/git/commits/:sha",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/git/commits",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/git/refs/*ref",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/git/refs",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/git/refs",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/git/refs/*ref",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/git/refs/*ref",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/git/tags/:sha",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/git/tags",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/git/trees/:sha",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/git/trees",
    },

    -- Issues
    {
        method = "GET",
        pathname = "/issues",
    },
    {
        method = "GET",
        pathname = "/user/issues",
    },
    {
        method = "GET",
        pathname = "/orgs/:org/issues",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/issues",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/issues/:number",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/issues",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/issues/:number",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/assignees",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/assignees/:assignee",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/issues/:number/comments",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/issues/comments",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/issues/comments/:id",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/issues/:number/comments",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/issues/comments/:id",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/issues/comments/:id",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/issues/:number/events",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/issues/events",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/issues/events/:id",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/labels",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/labels/:name",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/labels",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/labels/:name",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/labels/:name",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/issues/:number/labels",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/issues/:number/labels",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/issues/:number/labels/:name",
    },
    {
        method = "PUT",
        pathname = "/repos/:owner/:repo/issues/:number/labels",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/issues/:number/labels",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/milestones/:number/labels",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/milestones",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/milestones/:number",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/milestones",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/milestones/:number",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/milestones/:number",
    },

    -- Miscellaneous
    {
        method = "GET",
        pathname = "/emojis",
    },
    {
        method = "GET",
        pathname = "/gitignore/templates",
    },
    {
        method = "GET",
        pathname = "/gitignore/templates/:name",
    },
    {
        method = "POST",
        pathname = "/markdown",
    },
    {
        method = "POST",
        pathname = "/markdown/raw",
    },
    {
        method = "GET",
        pathname = "/meta",
    },
    {
        method = "GET",
        pathname = "/rate_limit",
    },

    -- Organizations
    {
        method = "GET",
        pathname = "/users/:user/orgs",
    },
    {
        method = "GET",
        pathname = "/user/orgs",
    },
    {
        method = "GET",
        pathname = "/orgs/:org",
    },
    {
        method = "PATCH",
        pathname = "/orgs/:org",
    },
    {
        method = "GET",
        pathname = "/orgs/:org/members",
    },
    {
        method = "GET",
        pathname = "/orgs/:org/members/:user",
    },
    {
        method = "DELETE",
        pathname = "/orgs/:org/members/:user",
    },
    {
        method = "GET",
        pathname = "/orgs/:org/public_members",
    },
    {
        method = "GET",
        pathname = "/orgs/:org/public_members/:user",
    },
    {
        method = "PUT",
        pathname = "/orgs/:org/public_members/:user",
    },
    {
        method = "DELETE",
        pathname = "/orgs/:org/public_members/:user",
    },
    {
        method = "GET",
        pathname = "/orgs/:org/teams",
    },
    {
        method = "GET",
        pathname = "/teams/:id",
    },
    {
        method = "POST",
        pathname = "/orgs/:org/teams",
    },
    {
        method = "PATCH",
        pathname = "/teams/:id",
    },
    {
        method = "DELETE",
        pathname = "/teams/:id",
    },
    {
        method = "GET",
        pathname = "/teams/:id/members",
    },
    {
        method = "GET",
        pathname = "/teams/:id/members/:user",
    },
    {
        method = "PUT",
        pathname = "/teams/:id/members/:user",
    },
    {
        method = "DELETE",
        pathname = "/teams/:id/members/:user",
    },
    {
        method = "GET",
        pathname = "/teams/:id/repos",
    },
    {
        method = "GET",
        pathname = "/teams/:id/repos/:owner/:repo",
    },
    {
        method = "PUT",
        pathname = "/teams/:id/repos/:owner/:repo",
    },
    {
        method = "DELETE",
        pathname = "/teams/:id/repos/:owner/:repo",
    },
    {
        method = "GET",
        pathname = "/user/teams",
    },

    -- Pull Requests
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/pulls",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/pulls/:number",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/pulls",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/pulls/:number",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/pulls/:number/commits",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/pulls/:number/files",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/pulls/:number/merge",
    },
    {
        method = "PUT",
        pathname = "/repos/:owner/:repo/pulls/:number/merge",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/pulls/:number/comments",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/pulls/comments",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/pulls/comments/:number",
    },
    {
        method = "PUT",
        pathname = "/repos/:owner/:repo/pulls/:number/comments",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/pulls/comments/:number",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/pulls/comments/:number",
    },

    -- Repositories
    {
        method = "GET",
        pathname = "/user/repos",
    },
    {
        method = "GET",
        pathname = "/users/:user/repos",
    },
    {
        method = "GET",
        pathname = "/orgs/:org/repos",
    },
    {
        method = "GET",
        pathname = "/repositories",
    },
    {
        method = "POST",
        pathname = "/user/repos",
    },
    {
        method = "POST",
        pathname = "/orgs/:org/repos",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/contributors",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/languages",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/teams",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/tags",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/branches",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/branches/:branch",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/collaborators",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/collaborators/:user",
    },
    {
        method = "PUT",
        pathname = "/repos/:owner/:repo/collaborators/:user",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/collaborators/:user",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/comments",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/commits/:sha/comments",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/commits/:sha/comments",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/comments/:id",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/comments/:id",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/comments/:id",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/commits",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/commits/:sha",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/readme",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/contents/*path",
    },
    {
        method = "PUT",
        pathname = "/repos/:owner/:repo/contents/*path",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/contents/*path",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/:archive_format/:ref",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/keys",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/keys/:id",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/keys",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/keys/:id",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/keys/:id",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/downloads",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/downloads/:id",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/downloads/:id",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/forks",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/forks",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/hooks",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/hooks/:id",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/hooks",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/hooks/:id",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/hooks/:id/tests",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/hooks/:id",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/merges",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/releases",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/releases/:id",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/releases",
    },
    {
        method = "PATCH",
        pathname = "/repos/:owner/:repo/releases/:id",
    },
    {
        method = "DELETE",
        pathname = "/repos/:owner/:repo/releases/:id",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/releases/:id/assets",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/stats/contributors",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/stats/commit_activity",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/stats/code_frequency",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/stats/participation",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/stats/punch_card",
    },
    {
        method = "GET",
        pathname = "/repos/:owner/:repo/statuses/:ref",
    },
    {
        method = "POST",
        pathname = "/repos/:owner/:repo/statuses/:ref",
    },

    -- Search
    {
        method = "GET",
        pathname = "/search/repositories",
    },
    {
        method = "GET",
        pathname = "/search/code",
    },
    {
        method = "GET",
        pathname = "/search/issues",
    },
    {
        method = "GET",
        pathname = "/search/users",
    },
    {
        method = "GET",
        pathname = "/legacy/issues/search/:owner/:repository/:state/:keyword",
    },
    {
        method = "GET",
        pathname = "/legacy/repos/search/:keyword",
    },
    {
        method = "GET",
        pathname = "/legacy/user/search/:keyword",
    },
    {
        method = "GET",
        pathname = "/legacy/user/email/:email",
    },

    -- Users
    {
        method = "GET",
        pathname = "/users/:user",
    },
    {
        method = "GET",
        pathname = "/user",
    },
    {
        method = "PATCH",
        pathname = "/user",
    },
    {
        method = "GET",
        pathname = "/users",
    },
    {
        method = "GET",
        pathname = "/user/emails",
    },
    {
        method = "POST",
        pathname = "/user/emails",
    },
    {
        method = "DELETE",
        pathname = "/user/emails",
    },
    {
        method = "GET",
        pathname = "/users/:user/followers",
    },
    {
        method = "GET",
        pathname = "/user/followers",
    },
    {
        method = "GET",
        pathname = "/users/:user/following",
    },
    {
        method = "GET",
        pathname = "/user/following",
    },
    {
        method = "GET",
        pathname = "/user/following/:user",
    },
    {
        method = "GET",
        pathname = "/users/:user/following/:target_user",
    },
    {
        method = "PUT",
        pathname = "/user/following/:user",
    },
    {
        method = "DELETE",
        pathname = "/user/following/:user",
    },
    {
        method = "GET",
        pathname = "/users/:user/keys",
    },
    {
        method = "GET",
        pathname = "/user/keys",
    },
    {
        method = "GET",
        pathname = "/user/keys/:id",
    },
    {
        method = "POST",
        pathname = "/user/keys",
    },
    {
        method = "PATCH",
        pathname = "/user/keys/:id",
    },
    {
        method = "DELETE",
        pathname = "/user/keys/:id",
    },
}

local testcase = require('testcase')
local nanotime = require('chronos').nanotime
local plut = require('plut')
-- local dump = require('dump')
local handler = function(...)
    -- print(dump {
    --     ...,
    -- })
end

local function printf(fmt, ...)
    print(string.format(fmt, ...))
end

local function setup()
    local router = {}

    for _, v in ipairs(GITHUB_API) do
        local p = router[v.method]
        if not p then
            p = plut.new()
            router[v.method] = p
        end
        local ok, err = p:set(v.pathname, handler)
        assert(ok, tostring(err))
    end

    return router
end

function testcase.memory_usage()
    collectgarbage("collect")

    local usage = collectgarbage("count")
    local _ = setup()
    usage = collectgarbage("count") - usage
    printf('memory usage: %f KB', usage)
end

local function bench_request(r, method, pathname)
    local N = 100000
    local t = nanotime()

    for _ = 0, N, 1 do
        local p = r[method]
        if p then
            local h, _, glob = p:lookup(pathname)
            if h then
                h(glob)
            end
        end
    end

    return N, (nanotime() - t) * 1000
end

function testcase.static()
    local router = setup()
    local N, t = bench_request(router, 'GET', '/user/repos')
    printf('time elapsed %f ms for %d ops | %f us/op', t, N, (t / N) * 1000)
end

function testcase.param()
    local router = setup()
    local N, t = bench_request(router, 'GET',
                               '/repos/julienschmidt/httprouter/stargazers')
    printf('time elapsed %f ms for %d ops | %f us/op', t, N, (t / N) * 1000)
end

local function bench_routes(r, routes)
    local N = 5000
    local t = nanotime()

    for _ = 0, N, 1 do
        for _, v in ipairs(routes) do
            local p = r[v.method]
            if p then
                local h, _, glob = p:lookup(v.pathname)
                if h then
                    h(glob)
                end
            end

        end
    end

    return N, (nanotime() - t) * 1000
end

function testcase.all_routes()
    local router = setup()
    local N, t = bench_routes(router, GITHUB_API)
    printf('time elapsed %f ms for %d ops | %f ms/op', t, N, t / N)
end
