local sub = string.sub
local type = type
local pairs = pairs
local lower = string.lower

local jwt_decoder = require "kong.plugins.jwt.jwt_parser"

local CustomJWT2Header = {
  PRIORITY = 900,  -- Runs before most plugins
  VERSION = "1.0"
}

-- Function to process JWT and set headers
function CustomJWT2Header:rewrite(conf)
  kong.service.request.set_header("X-Kong-JWT-Kong-Proceed", "no")

  local claims = nil
  local header = nil

  -- Extract JWT from Authorization header
  if kong.request.get_header("Authorization") ~= nil then
    local auth_header = kong.request.get_header("Authorization")

    -- Ensure it's a Bearer token
    if string.match(lower(auth_header), 'bearer') ~= nil then
      local jwt, err = jwt_decoder:new(sub(auth_header, 8))
      if err then
        return kong.response.exit(401, { message = "Invalid JWT: " .. tostring(err) })
      end

      claims = jwt.claims
      header = jwt.header

      -- Mark that we can proceed with JWT claims
      kong.service.request.set_header("X-Kong-JWT-Kong-Proceed", "yes")
    end
  end

  -- If JWT is valid, inject the claims as headers
  if kong.request.get_header("X-Kong-JWT-Kong-Proceed") == "yes" then
    for claim, value in pairs(claims) do
      if type(claim) == "string" and type(value) == "string" then
        -- If claim filtering is enabled, only extract specified claims
        if conf.specific_claims and #conf.specific_claims > 0 then
          for _, allowed_claim in ipairs(conf.specific_claims) do
            if claim == allowed_claim then
              kong.service.request.set_header(conf.header_prefix .. claim, value)
            end
          end
        else
          -- Extract all claims
          kong.service.request.set_header(conf.header_prefix .. claim, value)
        end
      end
    end
  end
end

-- Cleanup (optional: remove JWT headers from request)
function CustomJWT2Header:access(conf)
  if kong.request.get_header("X-Kong-JWT-Kong-Proceed") == "yes" then
    if conf.strip_claims == true then
      for claim, _ in pairs(kong.request.get_headers()) do
        if type(claim) == "string" and string.match(claim, 'x%-kong%-jwt%-claim') ~= nil then
          kong.service.request.clear_header(claim)
        end
      end
      kong.service.request.clear_header("X-Kong-JWT-Kong-Proceed")
    end
  elseif conf.token_required == true then
    kong.response.exit(404, { message = "No valid JWT token found" })
  end
end

return CustomJWT2Header
