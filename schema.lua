local typedefs = require "kong.db.schema.typedefs"

return {
  name = "custom-jwt-to-header",
  fields = {
    { route = typedefs.no_route },
    { service = typedefs.no_service },
    { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http },
    {
      config = {
        type = "record",
        fields = {
          { header_prefix = { type = "string", required = true, default = "X-Claim-" } },
          { specific_claims = { type = "array", elements = { type = "string" }, default = {} } },
          { strip_claims = { type = "boolean", required = true, default = false } },
          { token_required = { type = "boolean", required = true, default = true } }
        },
      },
    },
  },
}
