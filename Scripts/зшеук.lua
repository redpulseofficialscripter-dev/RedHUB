return(function(...)
local X={"\112\114\105\110\116\040\034\112\105\122\100\097\034\041"}
local function R(R)return X[R] end
local function r(r)return loadstring(r)() end
return r(X[1])
end)()
