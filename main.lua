local sizeThreshold
repeat
	print("Input minimum song size (KB, default 1024):")
	sizeThreshold=tonumber(io.read())or 1024
	print(string.format("Minimum size is set to %d KB (%.2fMB) (Y/N)",sizeThreshold,sizeThreshold/1024))
until io.read():lower()=="y"

local fs=love.filesystem
local items=fs.getDirectoryItems("")
local doneMark={}
local progressString="[%.1f%%]  %d / %d"
local saveDir=fs.getSaveDirectory()
for i=#items,1,-1 do
	if fs.getRealDirectory(items[i])==saveDir then
		fs.remove(items[i])
		table.remove(items,i)
	elseif fs.getInfo(items[i]).type=="file"then
		table.remove(items,i)
	end
end
for count,itemName in next,items do
	local songName=itemName:sub(itemName:find(" ")+1)
	if not doneMark[songName]then
		doneMark[songName]=true
		local maxsize=sizeThreshold
		local musicFileName
		for _,fileName in next,fs.getDirectoryItems(itemName) do
			if fileName:find("mp3")or fileName:find("wav")or fileName:find("ogg")then
				local info=fs.getInfo(itemName.."/"..fileName)
				if maxsize<info.size then
					maxsize=info.size
					musicFileName=fileName
				end
			end
		end
		if musicFileName then
			fs.write(songName..musicFileName:sub(-4),fs.read(itemName.."/"..musicFileName))
		end
	end
	if count%5==0 or count==#items then
		print(progressString:format(count/#items*100,count,#items))
	end
end
print("\n"..#items.." Songs exported successfully!")
os.execute("pause")
io.read()
love.system.openURL(fs.getSaveDirectory())
love.event.quit()