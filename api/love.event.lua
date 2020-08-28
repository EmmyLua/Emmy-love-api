---@class love.event
---Manages events, like keypresses.
local m = {}

---Arguments to love.event.push() and the like.
---
---Since 0.8.0, event names are no longer abbreviated.
Event = {
	---Window focus gained or lost
	['focus'] = 1,
	---Joystick pressed
	['joystickpressed'] = 2,
	---Joystick released
	['joystickreleased'] = 3,
	---Key pressed
	['keypressed'] = 4,
	---Key released
	['keyreleased'] = 5,
	---Mouse pressed
	['mousepressed'] = 6,
	---Mouse released
	['mousereleased'] = 7,
	---Quit
	['quit'] = 8,
	---Window size changed by the user
	['resize'] = 9,
	---Window is minimized or un-minimized by the user
	['visible'] = 10,
	---Window mouse focus gained or lost
	['mousefocus'] = 11,
	---A Lua error has occurred in a thread
	['threaderror'] = 12,
	---Joystick connected
	['joystickadded'] = 13,
	---Joystick disconnected
	['joystickremoved'] = 14,
	---Joystick axis motion
	['joystickaxis'] = 15,
	---Joystick hat pressed
	['joystickhat'] = 16,
	---Joystick's virtual gamepad button pressed
	['gamepadpressed'] = 17,
	---Joystick's virtual gamepad button released
	['gamepadreleased'] = 18,
	---Joystick's virtual gamepad axis moved
	['gamepadaxis'] = 19,
	---User entered text
	['textinput'] = 20,
	---Mouse position changed
	['mousemoved'] = 21,
	---Running out of memory on mobile devices system
	['lowmemory'] = 22,
	---Candidate text for an IME changed
	['textedited'] = 23,
	---Mouse wheel moved
	['wheelmoved'] = 24,
	---Touch screen touched
	['touchpressed'] = 25,
	---Touch screen stop touching
	['touchreleased'] = 26,
	---Touch press moved inside touch screen
	['touchmoved'] = 27,
	---Directory is dragged and dropped onto the window
	['directorydropped'] = 28,
	---File is dragged and dropped onto the window.
	['filedropped'] = 29,
	---Joystick pressed
	['jp'] = 30,
	---Joystick released
	['jr'] = 31,
	---Key pressed
	['kp'] = 32,
	---Key released
	['kr'] = 33,
	---Mouse pressed
	['mp'] = 34,
	---Mouse released
	['mr'] = 35,
	---Quit
	['q'] = 36,
	---Window focus gained or lost
	['f'] = 37,
}
---Clears the event queue.
function m.clear() end

---Returns an iterator for messages in the event queue.
---@return function
function m.poll() end

---Pump events into the event queue.
---
---This is a low-level function, and is usually not called by the user, but by love.run.
---
---Note that this does need to be called for any OS to think you're still running,
---
---and if you want to handle OS-generated events at all (think callbacks).
function m.pump() end

---Adds an event to the event queue.
---
---From 0.10.0 onwards, you may pass an arbitrary amount of arguments with this function, though the default callbacks don't ever use more than six.
---@param n Event @The name of the event.
---@param a Variant @First event argument.
---@param b Variant @Second event argument.
---@param c Variant @Third event argument.
---@param d Variant @Fourth event argument.
---@param e Variant @Fifth event argument.
---@param f Variant @Sixth event argument.
---@param ... Variant @Further event arguments may follow.
function m.push(n, a, b, c, d, e, f, ...) end

---Adds the quit event to the queue.
---
---The quit event is a signal for the event handler to close LÖVE. It's possible to abort the exit process with the love.quit callback.
---@param exitstatus number @The program exit status to use when closing the application.
---@overload fun('restart':string):void
function m.quit(exitstatus) end

---Like love.event.poll(), but blocks until there is an event in the queue.
---@return Event, Variant, Variant, Variant, Variant, Variant, Variant, Variant
function m.wait() end

return m