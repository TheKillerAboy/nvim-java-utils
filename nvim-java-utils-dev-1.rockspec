package = "nvim-java-utils"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/TheKillerAboy/nvim-java-utils.git"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {
      ["nvim-java-utils.init"] = "lua/nvim-java-utils/init.lua",
      ["nvim-java-utils.src"] = "lua/nvim-java-utils/src.lua"
   }
}
