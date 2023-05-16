rockspec_format = "3.0"
package = "nvim-java-utils"
version = "0.1.0-1"
source = {
   url = "git+ssh://git@github.com/TheKillerAboy/nvim-java-utils.git"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
description = {
  "lua >= 5.4",
  "xmlparser 2.2-2"
}
build = {
   type = "builtin",
   modules = {
      ["nvim-java-utils.init"] = "lua/nvim-java-utils/init.lua",
      ["nvim-java-utils.src"] = "lua/nvim-java-utils/src.lua"
   }
}
