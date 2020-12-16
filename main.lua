local sizeThreshold
repeat
	print("Input minimum song size (KB, default 1024):")
	sizeThreshold=tonumber(io.read())or 1024
	print(string.format("Minimum size is set to %d KB (%.2fMB) (Y/N)",sizeThreshold,sizeThreshold/1024))
until io.read():lower()=="y"

local fs=love.filesystem
local folders=fs.getDirectoryItems("")
local doneMark={}
local progressString="[%.1f%%]  %d / %d"
for count,folderName in next,folders do
	local songName=folderName:sub(folderName:find(" ")+1)
	if not doneMark[songName]then
		doneMark[songName]=true
		local maxsize=sizeThreshold
		local musicFileName
		for _,fileName in next,fs.getDirectoryItems(folderName) do
			if fileName:find("mp3")or fileName:find("wav")or fileName:find("ogg")then
				local info=fs.getInfo(folderName.."/"..fileName)
				if maxsize<info.size then
					maxsize=info.size
					musicFileName=fileName
				end
			end
		end
		if musicFileName then
			fs.write(songName..musicFileName:sub(-4),fs.read(folderName.."/"..musicFileName))
		end
	end
	if count%5==0 or count==#folders then
		print(progressString:format(count/#folders*100,count,#folders))
	end
end
print("\n"..#folders.." Songs exported successfully!")
os.execute("pause")
io.read()
love.system.openURL(fs.getSaveDirectory())
love.event.quit()