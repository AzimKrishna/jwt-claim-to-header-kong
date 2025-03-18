package = "jwt-claim-to-header-kong"
version = "1.0-1"

source = {
  url = "https://github.com/AzimKrishna/jwt-claim-to-header-kong.git"
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
    ["kong.plugins.jwt-claim-to-header-kong.handler"] = "handler.lua",
    ["kong.plugins.jwt-claim-to-header-kong.schema"] = "schema.lua",
  }
}
