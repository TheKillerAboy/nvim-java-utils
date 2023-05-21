local M = {}

local execute = function(opts, cmd)
  os.execute('cd ' .. opts.plugin_root_dir .. ';' .. cmd)
end

local luarocks_install = function(opts)
  local rockspec = opts.rockspec

  execute(opts, 'luarocks --tree lua_modules install --only-deps ' .. rockspec)
end

local get_luarocks_deps_root = function(opts)
  opts.luarocks_deps_root = opts.plugin_root_dir .. '/lua_modules/share/lua'
  for name, _ in vim.fs.dir(opts.luarocks_deps_root) do
    opts.luarocks_deps_root = opts.luarocks_deps_root .. '/' .. name
    goto continue
  end

  ::continue::

  return opts
end

local get_deps_files = function(opts)
  local deps = {}

  for name, type in vim.fs.dir(opts.luarocks_deps_root, {depth=math.huge}) do
    table.insert(deps, {name = name, type = type})
  end

  return deps
end

local get_plugin_build_lua_path = function()
  return debug.getinfo(3,"S").source:sub(2);
end

local get_plugin_dir = function(opts)
  opts.plugin_lua_dir = vim.fs.find('lua', {
      path = opts.plugin_build_lua_path,
      upward = true,
      type = 'directory'
    }
  )[1]

  opts.plugin_root_dir = vim.fs.dirname(opts.plugin_lua_dir)

  return opts
end

local has_lockfile = function(opts)
  local lock_files = vim.fs.find('.luarocks_bootstrap.lock',
    {
      path = opts.plugin_lua_dir,
      type = 'file'
    }
  )

  return #lock_files == 1
end

local luarocks_cp = function(opts, deps)
  for _, dep in ipairs(deps) do
    if dep.type == 'file' then
      execute(opts, 'cp ' .. opts.luarocks_deps_root .. '/' .. dep.name .. ' ' .. opts.plugin_lua_dir .. '/' .. dep.name)
    else
      execute(opts, 'mkdir ' .. opts.plugin_lua_dir .. '/' .. dep.name)
    end
  end
end

local create_lockfile_cnt = function(opts, deps)
  local lock_cnt = {}

  for _, dep in ipairs(deps) do
    table.insert(lock_cnt, opts.plugin_lua_dir .. '/' .. dep.name)
  end

  table.insert(lock_cnt, opts.plugin_lua_dir .. '/.luarocks_bootstrap.lock')

  return table.concat(lock_cnt, '\n')
end


local write_lockfile = function(opts, deps)
  local cnt = create_lockfile_cnt(opts, deps)

  local handle = io.open(opts.plugin_lua_dir .. '/.luarocks_bootstrap.lock', 'w')
  io.output(handle)
  io.write(cnt)
  io.close(handle)
end

function M.get_plugin_dir()
  local opts = {}
  opts.plugin_build_lua_path = get_plugin_build_lua_path()
  opts = get_plugin_dir(opts)
  return opts.plugin_root_dir
end

function M.bootstrap(opts)
  opts.plugin_build_lua_path = get_plugin_build_lua_path()
  opts = get_plugin_dir(opts)

  if has_lockfile(opts) then
    return  
  end

  luarocks_install(opts)
  opts = get_luarocks_deps_root(opts)
  deps = get_deps_files(opts)
  luarocks_cp(opts, deps)
  write_lockfile(opts, deps)
end

function M.uninstall(opts)
  opts.plugin_build_lua_path = get_plugin_build_lua_path()
  opts = get_plugin_dir(opts)

  if has_lockfile(opts) then
    execute(opts, 'cat ' .. opts.plugin_lua_dir .. '/.luarocks_bootstrap.lock' .. ' | xargs rm -rf')
  end
end

return M
