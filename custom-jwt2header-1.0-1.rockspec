package = "custom-jwt2header"
version = "1.0-1"

source = {
  url = "https://github.com/your-github-repo/custom-jwt2header.git"
}

description = {
  summary = "Extracts JWT claims and sets them as headers with configurable prefix and filtering.",
  license = "MIT"
}

dependencies = {
  "lua ~> 5.1"
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.custom-jwt2header.handler"] = "handler.lua",
    ["kong.plugins.custom-jwt2header.schema"] = "schema.lua",
  }
}
