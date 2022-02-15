pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

function copy_data(tab)
 local copy={}
 for k,v in pairs(tab) do
  copy[k] = v
 end
 return copy
end


function _init()
poke(0x5f2e,1)

level1={0,0,4,0,5,0,0,0,0,
								9,0,0,7,3,4,6,0,0,
							 0,0,3,0,2,1,0,4,9,
							 0,3,5,0,9,0,4,8,0,
							 0,9,0,0,0,0,0,3,0,
							 0,7,6,0,1,0,9,2,0,
							 3,1,0,9,7,0,2,0,0,
							 0,0,0,1,8,2,0,0,3,
							 0,0,0,0,6,0,1,0,0}

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
 dat = copy_data(level1)

 --player data
 p = {
 	x = 1,
 	y = 1,
  pind = 1,
 	num = 1,
 	menu = true
 }

 palt(0,false)
 palt(14,true)
end

function _update()
	--TODO error detection will be with count(t,"num")

 player_update()
end

function player_update()
 if(not p.menu) then
  if(btnp(0) and p.x>1) p.x-=1
  if(btnp(1) and p.x<9) p.x+=1
  if(btnp(2) and p.y>1) p.y-=1
  if(btnp(3) and p.y<9) p.y+=1 

  --index location based on players x+y
  p.pind = p.x+(p.y-1)*9
  if(btnp(4) and level1[pind] == 0) then
   dat[pind] = p.num
   p.num += 1
  end
 else
  if(btnp(0) and p.num>1) p.num -= 1
  if(btnp(1) and p.num<12) p.num += 1
  if(btnp(2) and p.num>9) p.num -= 6
  if(btnp(3) and p.num<10) p.num = 10
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
  pal(5,133)
 	spr(dat[i+1],tempx+1,tempy+1)
  pal(5,5)

  pal(5,0)
  spr(level1[i+1],tempx+1,tempy+1)
  pal(5,5)
 end

 print(p.pind,50,50,7)
 if(p.menu == true and p.pind < 64) then
  rectfill(0,90,128,128,5)
  for i=0,8 do
   rectfill(i*cmarg+6,98,i*cmarg+16,108,15)
   print(p.num,50,118,7)
  end
  for i=0,2 do
   rectfill(i*cmarg*2+32,112,i*cmarg*2+42,122,15)
  end
 end

end

__gfx__
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee5eeeee55eeeee55555e000000000000000000000000
eeeeeeeeeeee5eeeeeee55eeeeee55eeeeeee5eeeee5555eeeee555eeee5555eeee555eeeee555eeeeee555eee5555eee55eee55000000000000000000000000
eeeeeeeeeee55eeeeee5ee5eeee5ee5eeeee55eeeee5eeeeeee5eeeeeeeeee5eee5eee5eee5eee5eeee55555e555555ee5e5e5e5000000000000000000000000
eeeeeeeeee5e5eeeee5eee5eeeeee5eeeee5e5eeeee555eeeee555eeeeeeee5eeee555eeee5eee5eee55555eeeeeeeeee5ee5ee5000000000000000000000000
eeeeeeeeeeee5eeeeeeee5eeeeeeee5eee55555eeeeeee5eee5eee5eeeeee5eeeee5ee5eeee5555eeee555eeee5555eee5e5e5e5000000000000000000000000
eeeeeeeeeeee5eeeeeee5eeeeeeeee5eeeeee5eeee5eee5eee5eee5eeeee5eeeee5eee5eeeeeee5ee5ee5eeeee55e5eee55eee55000000000000000000000000
eeeeeeeeee55555eee55555eeee555eeeeeee5eeeee555eeeee555eeeee5eeeeeee555eeeee555eee55eeeeeee55e5eeee55555e000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000
