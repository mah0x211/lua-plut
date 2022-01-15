require('luacov')
local testcase = require('testcase')
local plut = require('plut')

function testcase.set()
    local p = assert(plut.new())

    -- test that set segment values
    local last_equal
    for _, v in ipairs({
        {
            pathname = '/foo',
            value = 'foo-value',
            equal = {
                foo = {
                    ['#'] = 'foo-value',
                },
            },
        },
        {
            pathname = '/foo/bar/',
            value = 'bar-trail-value',
            equal = {
                foo = {
                    ['#'] = 'foo-value',
                    bar = {
                        ['/'] = {
                            ['#'] = 'bar-trail-value',
                        },
                    },
                },
            },
        },
        {
            pathname = '/foo/bar',
            value = 'bar-value',
            equal = {
                foo = {
                    ['#'] = 'foo-value',
                    bar = {
                        ['/'] = {
                            ['#'] = 'bar-trail-value',
                        },
                        ['#'] = 'bar-value',
                    },
                },
            },
        },
        {
            pathname = '/',
            value = 'root-value',
            equal = {
                ['/'] = {
                    ['#'] = 'root-value',
                },
                foo = {
                    ['#'] = 'foo-value',
                    bar = {
                        ['/'] = {
                            ['#'] = 'bar-trail-value',
                        },
                        ['#'] = 'bar-value',
                    },
                },
            },
        },
        {
            pathname = '/foo/:bar',
            value = 'barvar-value',
            equal = {
                ['/'] = {
                    ['#'] = 'root-value',
                },
                foo = {
                    ['#'] = 'foo-value',
                    ['^'] = {
                        name = 'bar',
                        node = {
                            ['#'] = 'barvar-value',
                        },
                    },
                    bar = {
                        ['/'] = {
                            ['#'] = 'bar-trail-value',
                        },
                        ['#'] = 'bar-value',
                    },
                },
            },
        },
        {
            pathname = '/foo/:bar/baz/',
            value = 'baz-value',
            equal = {
                ['/'] = {
                    ['#'] = 'root-value',
                },
                foo = {
                    ['#'] = 'foo-value',
                    ['^'] = {
                        name = 'bar',
                        node = {
                            ['#'] = 'barvar-value',
                            baz = {
                                ['/'] = {
                                    ['#'] = 'baz-value',
                                },
                            },
                        },
                    },
                    bar = {
                        ['/'] = {
                            ['#'] = 'bar-trail-value',
                        },
                        ['#'] = 'bar-value',
                    },
                },
            },
        },
        {
            pathname = '/foo/bar/qux/quux',
            value = 'quux-value',
            equal = {
                ['/'] = {
                    ['#'] = 'root-value',
                },
                foo = {
                    ['#'] = 'foo-value',
                    ['^'] = {
                        name = 'bar',
                        node = {
                            ['#'] = 'barvar-value',
                            baz = {
                                ['/'] = {
                                    ['#'] = 'baz-value',
                                },
                            },
                        },
                    },
                    bar = {
                        ['/'] = {
                            ['#'] = 'bar-trail-value',
                        },
                        ['#'] = 'bar-value',
                        qux = {
                            quux = {
                                ['#'] = 'quux-value',
                            },
                        },
                    },
                },
            },
        },
        {
            pathname = '/hello/*world',
            value = 'world-value',
            equal = {
                ['/'] = {
                    ['#'] = 'root-value',
                },
                foo = {
                    ['#'] = 'foo-value',
                    ['^'] = {
                        name = 'bar',
                        node = {
                            ['#'] = 'barvar-value',
                            baz = {
                                ['/'] = {
                                    ['#'] = 'baz-value',
                                },
                            },
                        },
                    },
                    bar = {
                        ['/'] = {
                            ['#'] = 'bar-trail-value',
                        },
                        ['#'] = 'bar-value',
                        qux = {
                            quux = {
                                ['#'] = 'quux-value',
                            },
                        },
                    },
                },
                hello = {
                    ['*'] = {
                        name = 'world',
                        node = {
                            ['#'] = 'world-value',
                        },
                    },
                },
            },
        },
    }) do
        local ok, err = p:set(v.pathname, v.value)
        assert(ok, tostring(err))
        assert.equal(p.tree, v.equal)
        last_equal = v.equal
    end

    -- test that return EPATHNAME
    local ok, err = p:set('foo', 'new-value')
    assert.is_false(ok)
    local msg = assert(plut.is_error(err))
    assert.equal(msg.code, plut.EPATHNAME)
    assert.equal(p.tree, last_equal)

    -- test that return ERESERVED
    for _, pathname in ipairs({
        '/#',
        '/hello/^/world',
    }) do
        ok, err = p:set(pathname, 'new-value')
        assert.is_false(ok)
        msg = assert(plut.is_error(err))
        assert.equal(msg.code, plut.ERESERVED)
        assert.equal(p.tree, last_equal)
    end

    -- test that return EEMPTY
    ok, err = p:set('//', 'new-value')
    assert.is_false(ok)
    msg = assert(plut.is_error(err))
    assert.equal(msg.code, plut.EEMPTY)
    assert.equal(p.tree, last_equal)

    -- test that return EALREADY
    ok, err = p:set('/foo', 'new-value')
    assert.is_false(ok)
    msg = assert(plut.is_error(err))
    assert.equal(msg.code, plut.EALREADY)
    assert.equal(p.tree, last_equal)

    -- test that return EUNNAMED
    ok, err = p:set('/:/bar', 'new-value')
    assert.is_false(ok)
    msg = assert(plut.is_error(err))
    assert.equal(msg.code, plut.EUNNAMED)
    assert.equal(p.tree, last_equal)

    -- test that return EVALREADY
    for _, v in ipairs({
        '/foo/:baa/baz',
        '/hello/*baa',
    }) do
        ok, err = p:set(v, 'new-value')
        assert.is_false(ok)
        msg = assert(plut.is_error(err))
        assert.equal(msg.code, plut.EVALREADY)
        assert.equal(p.tree, last_equal)
    end

    -- test that return ETOOMANYSEG
    for _, v in ipairs({
        '/hello/*world/baz',
        '/foo/bar/qux/quux/*catchall/nest',
    }) do
        ok, err = p:set(v, 'new-value')
        assert.is_false(ok)
        msg = assert(plut.is_error(err))
        assert.equal(msg.code, plut.ETOOMANYSEG)
        assert.equal(p.tree, last_equal)
    end

    -- test that return ECOEXIST
    for _, v in ipairs({
        '/*catchall',
        '/hello/my-world',
    }) do
        ok, err = p:set(v, 'new-value')
        assert.is_false(ok)
        msg = assert(plut.is_error(err))
        assert.equal(msg.code, plut.ECOEXIST)
        assert.equal(p.tree, last_equal)
    end
end

function testcase.del()
    local p = assert(plut.new())
    for _, v in ipairs({
        {
            pathname = '/foo',
            value = 'foo-value',
        },
        {
            pathname = '/foo/bar/',
            value = 'bar-trail-value',
        },
        {
            pathname = '/foo/bar',
            value = 'bar-value',
        },
        {
            pathname = '/',
            value = 'root-value',
        },
        {
            pathname = '/foo/:bar',
            value = 'barvar-value',
        },
        {
            pathname = '/foo/:bar/baz/',
            value = 'baz-value',
        },
        {
            pathname = '/foo/bar/qux/quux',
            value = 'quux-value',
        },
        {
            pathname = '/hello/*world',
            value = 'world-value',
        },
    }) do
        assert(p:set(v.pathname, v.value))
    end

    -- test that variable node　cannot be deleted if the variable name does not match
    local val, err = p:del('/foo/:baa')
    assert.is_nil(val)
    assert.is_nil(err)

    -- test that delete segments
    for _, v in ipairs({
        {
            pathname = '/foo',
            value = 'foo-value',
            equal = {
                ['/'] = {
                    ['#'] = 'root-value',
                },
                foo = {
                    ['^'] = {
                        name = 'bar',
                        node = {
                            ['#'] = 'barvar-value',
                            baz = {
                                ['/'] = {
                                    ['#'] = 'baz-value',
                                },
                            },
                        },
                    },
                    bar = {
                        ['/'] = {
                            ['#'] = 'bar-trail-value',
                        },
                        ['#'] = 'bar-value',
                        qux = {
                            quux = {
                                ['#'] = 'quux-value',
                            },
                        },
                    },
                },
                hello = {
                    ['*'] = {
                        name = 'world',
                        node = {
                            ['#'] = 'world-value',
                        },
                    },
                },
            },
        },
        {
            pathname = '/foo/bar/',
            value = 'bar-trail-value',
            equal = {
                ['/'] = {
                    ['#'] = 'root-value',
                },
                foo = {
                    ['^'] = {
                        name = 'bar',
                        node = {
                            ['#'] = 'barvar-value',
                            baz = {
                                ['/'] = {
                                    ['#'] = 'baz-value',
                                },
                            },
                        },
                    },
                    bar = {
                        ['#'] = 'bar-value',
                        qux = {
                            quux = {
                                ['#'] = 'quux-value',
                            },
                        },
                    },
                },
                hello = {
                    ['*'] = {
                        name = 'world',
                        node = {
                            ['#'] = 'world-value',
                        },
                    },
                },
            },
        },
        {
            pathname = '/foo/bar',
            value = 'bar-value',
            equal = {
                ['/'] = {
                    ['#'] = 'root-value',
                },
                foo = {
                    ['^'] = {
                        name = 'bar',
                        node = {
                            ['#'] = 'barvar-value',
                            baz = {
                                ['/'] = {
                                    ['#'] = 'baz-value',
                                },
                            },
                        },
                    },
                    bar = {
                        qux = {
                            quux = {
                                ['#'] = 'quux-value',
                            },
                        },
                    },
                },
                hello = {
                    ['*'] = {
                        name = 'world',
                        node = {
                            ['#'] = 'world-value',
                        },
                    },
                },
            },
        },
        {
            pathname = '/',
            value = 'root-value',
            equal = {
                foo = {
                    ['^'] = {
                        name = 'bar',
                        node = {
                            ['#'] = 'barvar-value',
                            baz = {
                                ['/'] = {
                                    ['#'] = 'baz-value',
                                },
                            },
                        },
                    },
                    bar = {
                        qux = {
                            quux = {
                                ['#'] = 'quux-value',
                            },
                        },
                    },
                },
                hello = {
                    ['*'] = {
                        name = 'world',
                        node = {
                            ['#'] = 'world-value',
                        },
                    },
                },
            },
        },
        {
            pathname = '/foo/:bar',
            value = 'barvar-value',
            equal = {
                foo = {
                    ['^'] = {
                        name = 'bar',
                        node = {
                            baz = {
                                ['/'] = {
                                    ['#'] = 'baz-value',
                                },
                            },
                        },
                    },
                    bar = {
                        qux = {
                            quux = {
                                ['#'] = 'quux-value',
                            },
                        },
                    },
                },
                hello = {
                    ['*'] = {
                        name = 'world',
                        node = {
                            ['#'] = 'world-value',
                        },
                    },
                },
            },
        },
        {
            pathname = '/foo/:bar/baz/',
            value = 'baz-value',
            equal = {
                foo = {
                    bar = {
                        qux = {
                            quux = {
                                ['#'] = 'quux-value',
                            },
                        },
                    },
                },
                hello = {
                    ['*'] = {
                        name = 'world',
                        node = {
                            ['#'] = 'world-value',
                        },
                    },
                },
            },
        },
        {
            pathname = '/hello/*world',
            value = 'world-value',
            equal = {
                foo = {
                    bar = {
                        qux = {
                            quux = {
                                ['#'] = 'quux-value',
                            },
                        },
                    },
                },
            },
        },
        {
            pathname = '/foo/bar/qux/quux',
            value = 'quux-value',
            equal = {},
        },
    }) do
        val, err = p:del(v.pathname)
        assert.equal(val, v.value)
        assert.is_nil(err)
        assert.equal(p.tree, v.equal)
    end
end

function testcase.get()
    local pathvalues = {
        {
            pathname = '/foo',
            value = 'foo-value',
        },
        {
            pathname = '/foo/bar/',
            value = 'bar-trail-value',
        },
        {
            pathname = '/foo/bar',
            value = 'bar-value',
        },
        {
            pathname = '/',
            value = 'root-value',
        },
        {
            pathname = '/foo/:bar',
            value = 'barvar-value',
        },
        {
            pathname = '/foo/:bar/baz/',
            value = 'baz-value',
        },
        {
            pathname = '/foo/bar/qux/quux',
            value = 'quux-value',
        },
        {
            pathname = '/hello/*world',
            value = 'world-value',
        },
    }
    local p = assert(plut.new())
    for _, v in ipairs(pathvalues) do
        assert(p:set(v.pathname, v.value))
    end

    -- test that returns the value of pathname
    for _, v in ipairs(pathvalues) do
        local val = assert(p:get(v.pathname))
        assert.equal(val, v.value)
    end

    -- test that return nil
    local val, err = p:get('/foo/:baa')
    assert.is_nil(val)
    assert.is_nil(err)
end

function testcase.lookup()
    local p = assert(plut.new())
    for _, v in ipairs({
        {
            pathname = '/foo',
            value = 'foo-value',
        },
        {
            pathname = '/foo/bar/',
            value = 'bar-trail-value',
        },
        {
            pathname = '/foo/bar',
            value = 'bar-value',
        },
        {
            pathname = '/',
            value = 'root-value',
        },
        {
            pathname = '/foo/:bar',
            value = 'barvar-value',
        },
        {
            pathname = '/foo/:bar/baz/',
            value = 'baz-value',
        },
        {
            pathname = '/foo/:bar/baz/:var/qux',
            value = 'qux-value',
        },
        {
            pathname = '/foo/bar/qux/quux',
            value = 'quux-value',
        },
        {
            pathname = '/hello/*world',
            value = 'world-value',
        },
    }) do
        assert(p:set(v.pathname, v.value))
    end

    -- test that find the values of path segments
    for _, v in ipairs({
        {
            pathname = '/foo',
            value = 'foo-value',
            glob = {
                'root-value',
            },
        },
        {
            pathname = '/foo/bar/',
            value = 'bar-trail-value',
            glob = {
                'root-value',
                'foo-value',
                'bar-value',
            },
        },
        {
            pathname = '/foo/bar',
            value = 'bar-value',
            glob = {
                'root-value',
                'foo-value',
            },
        },
        {
            pathname = '/',
            value = 'root-value',
            glob = {},
        },
        {
            pathname = '/foo/hello',
            value = 'barvar-value',
            glob = {
                'root-value',
                'foo-value',
                bar = 'hello',
            },
        },
        {
            pathname = '/foo/hello/baz/',
            value = 'baz-value',
            glob = {
                'root-value',
                'foo-value',
                'barvar-value',
                bar = 'hello',
            },
        },
        {
            pathname = '/foo/hello/baz/world/qux',
            value = 'qux-value',
            glob = {
                'root-value',
                'foo-value',
                'barvar-value',
                'baz-value',
                bar = 'hello',
                var = 'world',
            },
        },
        {
            pathname = '/foo/bar/qux/quux',
            value = 'quux-value',
            glob = {
                'root-value',
                'foo-value',
                'bar-value',
                'bar-trail-value',
            },
        },
        {
            pathname = '/hello/*world',
            value = 'world-value',
            glob = {
                'root-value',
                world = '*world',
            },
        },
    }) do
        local val, err, glob = p:lookup(v.pathname)
        assert(val, tostring(err))
        assert.equal(val, v.value)
        assert.is_nil(err)
        assert.equal(glob, v.glob)
    end
end

function testcase.lookup_catchall()
    local p = assert(plut.new())

    -- test that catch-all parameter
    assert(p:set('/hello/:world', 'hello-world'))
    assert(p:set('/hello/:world/foo/*catchall', 'catch-the-world'))
    local val, err, glob = p:lookup('/hello/my/foo/world/segment')
    assert.equal(val, 'catch-the-world')
    assert.is_nil(err)
    assert.equal(glob, {
        'hello-world',
        world = 'my',
        catchall = 'world/segment',
    })
end

function testcase.dump()
    local p = assert(plut.new())
    local list = {}
    for _, v in ipairs({
        {
            pathname = '/foo',
            value = 'foo-value',
        },
        {
            pathname = '/foo/bar/',
            value = 'bar-trail-value',
        },
        {
            pathname = '/foo/bar',
            value = 'bar-value',
        },
        {
            pathname = '/',
            value = 'root-value',
        },
        {
            pathname = '/foo/:bar',
            value = 'barvar-value',
        },
        {
            pathname = '/foo/:bar/baz/',
            value = 'baz-value',
        },
        {
            pathname = '/foo/:bar/baz/:var/qux',
            value = 'qux-value',
        },
        {
            pathname = '/foo/bar/qux/quux',
            value = 'quux-value',
        },
        {
            pathname = '/hello/*world',
            value = 'world-value',
        },
    }) do
        assert(p:set(v.pathname, v.value))
        list[v.pathname] = v.value
    end

    -- test that list the registered pathname and value pairs
    assert.equal(p:dump(), list)
end
