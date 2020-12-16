function love.conf(t)
	t.console,t.identity=true,"osu!SongExport"
	local M=t.modules
	M.system,M.event,M.math,M.audio,M.sound,M.data,M.timer,M.graphics,M.font,M.image,M.mouse,M.touch,M.keyboard,M.joystick,M.window,M.physics,M.thread,M.video=true
end