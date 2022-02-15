pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--[[function copy_data(tab)
 copy={}
 copyfull={}
 for i=1,8 do
  for k,v in pairs(tab) do
   copy[k] = v
  end
  add(copyfull,copy)
  del(copy)
 end

 return copyfull
end--]]

function _init()

level1={{0,0,4,0,5,0,0,0,0},
								{9,0,0,7,3,4,6,0,0},
							 {0,0,3,0,2,1,0,4,9},
							 {0,3,5,0,9,0,4,8,0},
							 {0,9,0,0,0,0,0,3,0},
							 {0,7,6,0,1,0,9,2,0},
							 {3,1,0,9,7,0,2,0,0},
							 {0,0,0,1,8,2,0,0,3},
							 {0,0,0,0,6,0,1,0,0}}

	--starting points for grid
	gridx = 7
	gridy = 5
	--cell size
	csize = 10
	--inner and outer margin size
	inmarg = 3
 outmarg = 2

 --gridsize as calced by 9 cells with 8 inner margins
 gsize = csize*9 + inmarg*8
 --square size
 ssize = csize*3 + inmarg*2
 --size of cell and inmargin on individual basis
 cmarg = csize + inmarg

 --load level info into current dat var
 dat = level1

 --player data
 p = {
 	x = 1,
 	y = 1,
 	z = 1,
 	num = 1,
 	open = false
 }

 palt(0,false)
 palt(14,true)
end

function _update()
	--TODO error detection will be with count(t,"num")

	if(btnp(0)) p.x-=1
	if(btnp(1)) p.x+=1
	if(btnp(2)) p.y-=1
	if(btnp(3)) p.y+=1

	if(p.x<1) p.x=1
	if(p.x>9) p.x=9
	if(p.y<1) p.y=1
	if(p.y>9) p.y=9

	if(btnp(4) and level1[p.y][p.x] == 0) then
		dat[p.y][p.x] = p.num
		p.num += 1
	end
end

function _draw()
 cls(1)

 --draw black border and internal lines
 rectfill(gridx-2,gridy-3,gridx+gsize+2,gridx+gsize+1,0)

 --draw backround lines
 for i=0,8 do
 	tempx = i%3*cmarg*3+gridx
 	tempy = flr(i/3)*cmarg*3+gridy
  rectfill(tempx,tempy,tempx+ssize,tempy+ssize,13)
 end
 
 tempx = (p.x-1)*cmarg+gridx
 tempy = (p.y-1)*cmarg+gridy
 rectfill(tempx-2,tempy-2,tempx+csize+2,tempy+csize+2,8)

 for i=0,80 do	
 	xmod = i%9
 	ymod = flr(i/9)
 	tempx = xmod*cmarg+gridx
 	tempy = ymod*cmarg+gridy

 	--draw individual cells as boxes
  rectfill(tempx,tempy,tempx+csize,tempy+csize,15)

  --draw num sprites from dat table
  if(dat[ymod+1][xmod+1] != 0)then
  	spr(dat[ymod+1][xmod+1],tempx+1,tempy+1)
  end

 end

 --TODO seperate num choice menu

end

__gfx__
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000
eeeeeeeeeeee0eeeeeee00eeeeee00eeeeeee0eeeee0000eeeee000eeee0000eeee000eeeee000ee000000000000000000000000000000000000000000000000
eeeeeeeeeee00eeeeee0ee0eeee0ee0eeeee00eeeee0eeeeeee0eeeeeeeeee0eee0eee0eee0eee0e000000000000000000000000000000000000000000000000
eeeeeeeeee0e0eeeee0eee0eeeeee0eeeee0e0eeeee000eeeee000eeeeeeee0eeee000eeee0eee0e000000000000000000000000000000000000000000000000
eeeeeeeeeeee0eeeeeeee0eeeeeeee0eee00000eeeeeee0eee0eee0eeeeee0eeeee0ee0eeee0000e000000000000000000000000000000000000000000000000
eeeeeeeeeeee0eeeeeee0eeeeeeeee0eeeeee0eeee0eee0eee0eee0eeeee0eeeee0eee0eeeeeee0e000000000000000000000000000000000000000000000000
eeeeeeeeee00000eee00000eeee000eeeeeee0eeeee000eeeee000eeeee0eeeeeee000eeeee000ee000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000
