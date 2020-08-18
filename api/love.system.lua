---@class love.system
---Provides access to information about the user's system.
local m = {}

---The basic state of the system's power supply.
PowerState = {
	---Cannot determine power status.
	['unknown'] = 1,
	---Not plugged in, running on a battery.
	['battery'] = 2,
	---Plugged in, no battery available.
	['nobattery'] = 3,
	---Plugged in, charging battery.
	['charging'] = 4,
	---Plugged in, battery is fully charged.
	['charged'] = 5,
}
---Gets text from the clipboard.
---@return string
function m.getClipboardText() end

---Gets the current operating system. In general, LÖVE abstracts away the need to know the current operating system, but there are a few cases where it can be useful (especially in combination with os.execute.)
---@return string
function m.getOS() end

---Gets information about the system's power supply.
---@return PowerState, number, number
function m.getPowerInfo() end

---Gets the amount of logical processor in the system.
---@return number
function m.getProcessorCount() end

---Gets whether another application on the system is playing music in the background.
---
---Currently this is implemented on iOS and Android, and will always return false on other operating systems. The t.audio.mixwithsystem flag in love.conf can be used to configure whether background audio / music from other apps should play while LÖVE is open.
---@return boolean
function m.hasBackgroundMusic() end

---Opens a URL with the user's web or file browser.
---@param url string @The URL to open. Must be formatted as a proper URL.
---@return boolean
function m.openURL(url) end

---Puts text in the clipboard.
---@param text string @The new text to hold in the system's clipboard.
function m.setClipboardText(text) end

---Causes the device to vibrate, if possible. Currently this will only work on Android and iOS devices that have a built-in vibration motor.
---@param seconds number @The duration to vibrate for. If called on an iOS device, it will always vibrate for 0.5 seconds due to limitations in the iOS system APIs.
function m.vibrate(seconds) end

return m