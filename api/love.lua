---@class love
local m = {}

--region ByteData
---@class ByteData
---Data object containing arbitrary bytes in an contiguous memory.
---
---There are currently no LÖVE functions provided for manipulating the contents of a ByteData, but Data:getPointer can be used with LuaJIT's FFI to access and write to the contents directly.
local ByteData = {}
--endregion ByteData
--region Data
---@class Data
---The superclass of all data.
local Data = {}
--endregion Data
--region Drawable
---@class Drawable
---Superclass for all things that can be drawn on screen. This is an abstract type that can't be created directly.
local Drawable = {}
--endregion Drawable
--region Object
---@class Object
---The superclass of all LÖVE types.
local Object = {}
--endregion Object
---@type love.audio
m.audio = nil

---@type love.data
m.data = nil

---@type love.event
m.event = nil

---@type love.filesystem
m.filesystem = nil

---@type love.graphics
m.graphics = nil

---@type love.image
m.image = nil

---@type love.joystick
m.joystick = nil

---@type love.keyboard
m.keyboard = nil

---@type love.math
m.math = nil

---@type love.mouse
m.mouse = nil

---@type love.physics
m.physics = nil

---@type love.sound
m.sound = nil

---@type love.system
m.system = nil

---@type love.thread
m.thread = nil

---@type love.timer
m.timer = nil

---@type love.touch
m.touch = nil

---@type love.video
m.video = nil

---@type love.window
m.window = nil

---Gets the current running version of LÖVE.
---@return number, number, number, string
function m.getVersion() end

---Gets whether LÖVE displays warnings when using deprecated functionality. It is disabled by default in fused mode, and enabled by default otherwise.
---
---When deprecation output is enabled, the first use of a formally deprecated LÖVE API will show a message at the bottom of the screen for a short time, and print the message to the console.
---@return boolean
function m.hasDeprecationOutput() end

---Sets whether LÖVE displays warnings when using deprecated functionality. It is disabled by default in fused mode, and enabled by default otherwise.
---
---When deprecation output is enabled, the first use of a formally deprecated LÖVE API will show a message at the bottom of the screen for a short time, and print the message to the console.
---@param enable boolean @Whether to enable or disable deprecation output.
function m.setDeprecationOutput(enable) end

return m