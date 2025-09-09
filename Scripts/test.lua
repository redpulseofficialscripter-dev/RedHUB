--[[
  Obfuscated with RedPulseHUD Obfuscator
  GitHub: https://github.com/yourusername/redpulsehud
  Date: 2025-09-09 14:27:41
--]]

local encoded = 'bG9jYWwgX19McnZzZWlKQiA9IDY5MjcNCmxvY2FsIF9fYUxZc3pRWlEgPSA1MzA1DQpsb2NhbCBfX2ZMekNCaGlXID0gNzI0MA0KbG9jYWwgX19KdVBtTE9KZSA9IDc5NDYNCmxvY2FsIF9fS05WSnNMS3ggPSAzMTU3DQoNCi0tW1sgSnVuayBjb2RlIHN0YXJ0IF1dDQppZiBmYWxzZSB0aGVuDQogICAgcHJpbnQoNjQ1OSkNCiAgICB3aGlsZSBmYWxzZSBkbyBlbmQNCmVuZA0KLS1bWyBKdW5rIGNvZGUgZW5kIF1dDQoNCnByaW50KCJIVEE1T1RvQ09pYzVNUT09Iik='
local decoded = (function(s)
    local result = ''
    for i = 1, #s do
        result = result .. string.char(string.byte(s, i) ~ 0x55)
    end
    return result
end)(encoded)

loadstring(decoded)()
