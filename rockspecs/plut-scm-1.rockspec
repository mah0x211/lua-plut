package = 'plut'
version = 'scm-1'
source = {
    url = 'git+https://github.com/mah0x211/lua-mux.git'
}
description = {
    summary = 'path segmented lookup table',
    homepage = 'https://github.com/mah0x211/lua-mux',
    license = 'MIT/X11',
    maintainer = 'Masatoshi Fukunaga'
}
dependencies = {
    'lua >= 5.1',
    'error >= 0.6.1',
    'stringex >= 0.2.1',
}
build = {
    type = 'builtin',
    modules = {
        plut = 'plut.lua'
    }
}
