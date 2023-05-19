package = "nvim-java-utils"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/TheKillerAboy/nvim-java-utils.git"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}

dependencies = {
  "lua >= 5.4",
  "xml2lua >= 1.5-2",
  "lualogging >= 1.8.2-1"
}

build = {
   type = "builtin",
   modules = {
      ["nvim-java-utils.init"] = "lua/nvim-java-utils/init.lua",
      ["nvim-java-utils.log"] = "lua/nvim-java-utils/log.lua",
      ["nvim-java-utils.src"] = "lua/nvim-java-utils/src.lua"
   }
}
