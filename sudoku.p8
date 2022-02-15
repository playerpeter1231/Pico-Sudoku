pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--sudoku
--by playerpeter1231

function copy_data(tab)
 local copy={}
 for k,v in pairs(tab) do
  copy[k] = v
 end
 return copy
end

function _init()

 clk = 0
 hr=0
 min=0
 sec=0
 --game data
 g = {
  state = 0,
  ghost = 0,
  level = 1,
 }
 --menu data
 m = {
  state = 1,
  sec = 0,
  index = 1
 }
 --player data
 p = {
  col = 8,
  x = 1,
  y = 1,
  index = 1,
  num = 1,
  mindex = 1,
  menu = false,
  erase = false
 }


--puzzles from puzzleparade and the wpf
--title font is gravity pixel font by john watson
levels={{6,0,0,0,9,0,0,0,7, --level 1
									0,4,0,0,0,7,1,0,0,
								 0,0,2,8,0,0,0,5,0,
								 8,0,0,0,0,0,0,9,0,
								 0,0,0,0,7,0,0,0,0,
								 0,3,0,0,0,0,0,0,8,
								 0,5,0,0,0,2,3,0,0,
								 0,0,4,5,0,0,0,2,0,
								 9,0,0,0,3,0,0,0,4},
        {1,0,0,0,6,0,0,0,9, --level 2
         0,0,2,4,0,0,0,7,0,
         0,3,0,0,0,5,8,0,0,
         4,0,0,0,0,9,0,0,2,
         0,0,6,7,0,0,1,0,0,
         0,5,0,0,8,0,0,3,0,
         0,0,9,0,3,0,0,6,0,
         7,0,0,0,0,1,5,0,0,
         0,8,0,2,0,0,0,0,4},
        {5,0,0,9,0,7,0,0,4, --level 3
         0,1,0,0,6,0,0,3,0,
         0,0,7,0,0,0,2,0,0,
         3,0,0,8,0,1,0,0,6,
         0,6,0,0,9,0,0,2,0,
         9,0,0,2,0,6,0,0,1,
         0,0,6,0,0,0,8,0,0,
         0,5,0,0,8,0,0,9,0,
         1,0,0,3,0,5,0,0,7},
        {0,0,0,5,7,0,2,9,0, --level 4
         6,0,0,2,0,0,8,0,0,
         5,9,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,2,5,
         7,0,0,0,0,0,0,0,6,
         3,8,0,0,0,0,0,0,0,
         0,0,0,0,0,0,0,7,4,
         0,0,6,0,0,4,0,0,8,
         0,1,2,0,8,5,0,0,0},
        {0,0,0,0,0,5,0,0,2, --level 5
         0,1,2,0,0,0,3,4,0,
         6,0,0,3,0,0,0,0,0,
         3,0,0,4,0,0,0,0,0,
         0,2,5,0,0,0,7,1,0,
         0,0,0,0,0,6,0,0,5,
         0,0,0,0,0,3,0,0,8,
         0,4,8,0,0,0,5,7,0,
         2,0,0,9,0,0,0,0,0},
        {0,4,0,0,0,1,9,2,0, --level 6
         2,0,0,0,0,0,0,0,6,
         0,0,1,8,5,0,0,0,3,
         0,2,0,0,0,7,0,0,8,
         7,0,0,0,0,0,6,0,0,
         8,0,0,9,0,0,2,0,0,
         4,0,0,0,0,0,1,0,0,
         0,5,0,0,0,8,0,0,9,
         0,0,2,3,1,0,0,6,0},
        {0,7,0,0,0,0,0,6,0, --level 7
         8,0,0,0,6,0,0,0,3,
         0,0,0,1,0,4,0,0,0,
         0,0,3,0,7,0,2,0,0,
         0,1,0,2,0,3,0,4,0,
         0,0,9,0,8,0,1,0,0,
         0,0,0,3,0,5,0,0,0,
         7,0,0,0,9,0,0,0,4,
         0,2,0,0,0,0,0,8,0},
        {7,0,0,0,2,0,0,3,0, --level 8
         0,0,0,9,0,0,0,0,0,
         0,0,5,0,0,8,6,2,0,
         0,3,0,0,6,0,4,0,0,
         2,0,0,7,0,9,0,0,5,
         0,0,1,0,4,0,0,6,0,
         0,2,6,5,0,0,1,0,0,
         0,0,0,0,0,2,0,0,0,
         0,7,0,0,8,0,0,0,4},
        {2,3,0,0,9,0,0,0,0, --level 9
         1,0,0,0,0,8,0,0,9,
         0,0,5,6,0,0,7,0,0,
         0,0,4,0,0,0,0,6,0,
         9,0,0,0,5,0,0,0,1,
         0,7,0,0,0,0,2,0,0,
         0,0,8,0,0,5,4,0,0,
         3,0,0,2,0,0,0,0,8,
         0,0,0,0,3,0,0,9,6},
        {2,0,0,8,0,6,0,0,4, --level 10
         0,6,0,0,3,0,0,7,0,
         0,0,8,0,0,0,2,0,0,
         4,0,0,3,0,9,0,0,7,
         0,2,0,0,1,0,0,9,0,
         8,0,0,6,0,4,0,0,5,
         0,0,3,0,0,0,7,0,0,
         0,8,0,0,6,0,0,5,0,
         5,0,0,2,0,3,0,0,9},
        {0,0,0,0,1,9,8,0,0, --level 11
         0,4,0,2,0,0,0,0,0,
         9,0,0,8,0,0,0,0,1,
         0,0,1,9,0,0,7,0,0,
         8,0,0,5,0,4,0,0,3,
         0,0,9,0,0,1,4,0,0,
         2,0,0,0,0,7,0,0,5,
         0,0,0,0,0,5,0,9,0,
         0,0,4,6,3,0,0,0,0},
        {9,0,0,5,0,3,0,0,6, --level 12
         0,0,7,0,0,0,5,2,0,
         5,8,0,0,0,0,0,0,0,
         0,0,0,0,0,7,9,5,0,
         0,5,0,1,0,9,0,4,0,
         0,7,9,2,0,0,0,0,0,
         0,0,0,0,0,0,0,6,8,
         0,4,8,0,0,0,7,0,0,
         0,4,8,0,0,0,7,0,0,
         7,0,0,3,0,1,0,0,5},
        {0,0,0,0,7,0,1,9,0, --level 13
         0,0,0,0,1,0,0,0,6,
         0,9,4,0,0,8,0,0,5,
         0,0,0,0,0,0,6,4,7,
         0,0,0,0,2,0,0,0,0,
         7,8,1,0,0,0,0,0,0,
         8,0,0,5,0,0,2,6,0,
         6,0,0,0,3,0,0,0,0,
         0,3,2,0,4,0,0,0,0},
        {0,0,0,0,7,9,0,0,0, --level 14
         0,2,6,0,0,0,0,0,0,
         0,0,0,5,0,0,6,0,0,
         0,0,3,0,0,0,0,0,8,
         4,0,0,7,0,1,2,0,0,
         4,0,0,7,0,1,2,0,0,
         0,0,4,0,9,0,0,5,0,
         9,0,0,0,6,0,8,7,0,
         0,3,7,0,0,8,0,0,0}, 
        {0,0,0,0,7,0,0,1,0, --level 15
         6,0,0,5,0,0,0,3,0,
         0,8,1,0,0,4,0,0,6,
         0,2,0,0,6,0,0,0,0,
         7,5,0,0,9,0,0,6,8,
         0,0,0,0,5,0,0,7,0,
         1,0,0,7,0,0,3,9,0,
         0,9,0,0,0,6,0,0,5,
         0,3,0,0,8,0,0,0,0},
							 {0,0,0,0,0,0,0,0,0, --debug
								 0,0,0,0,0,0,0,0,0,
								 0,0,0,0,0,0,0,0,0,
								 0,0,0,0,0,0,0,0,0,
								 0,0,0,0,0,0,0,0,0,
								 0,0,0,0,0,0,0,0,0,
									0,0,0,0,0,0,0,0,0,
									0,0,0,0,0,0,0,0,0,
									0,0,0,0,0,0,0,0,0}}

 done={}
 for i=0, 14 do
  add(done,false)
 end

	--starting points for grid
	gridx = 7
	gridy = 10
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

 palt(0,false)
 palt(14,true)
end

function game_init()
 --load level info into current dat var
 dat = copy_data(levels[g.level])

 clk = 0
 err={}

 g.state = 1
 p.menu = false
 p.x = 1
 p.y = 1
end

function _update()
 if(g.state == 0) then
  menu_update()
 elseif(g.state == 1) then
  game_update()
 end
end

function menu_update()
 if(m.state == 0) then
  if(btnp(4)) m.state = 1
 elseif(m.state == 1) then
  if(btnp(0) and m.index>1) m.index-=1
  if(btnp(1) and m.index<16) m.index+=1
  if(btnp(2) and m.index>3) m.index-=3
  if(btnp(3)) then
   if (m.index<14) then m.index+=3
   elseif (m.index>13) then m.index=16 end
  end

  if(btnp(4)) then
   g.level = m.index
   game_init()
  end

  if(btnp(5)) then
   clk = 0
   m.state = 0
  end
 end
end

function game_update()
 if(not p.menu) then
 	--index location based on players x+y
 	p.index = p.x+(p.y-1)*9

 	--arrow keys
  if(btnp(0) and p.x>1) p.x-=1
  if(btnp(1) and p.x<9) p.x+=1
  if(btnp(2) and p.y>1) p.y-=1
  if(btnp(3) and p.y<9) p.y+=1 

  --face buttons
  if(btnp(4) and levels[g.level][p.index] == 0) then
   dat[p.index] = p.num

   --erase current element
   if(p.erase) then dat[p.index] = 0
   else check_error(p.index,dat[p.index],true) end

   for e in all(err) do
    if(dat[e] != 0) then 
     check_error(e,dat[e],false)
    else del(err,e) end
   end
  end
  if(btnp(5)) p.menu = true

 --in menu
 else
 	--arrow keys
  if(btnp(0) and p.mindex>1) p.mindex -= 1
  if(btnp(1) and p.mindex<12) p.mindex += 1
  if(btnp(2) and p.mindex>9) p.mindex -= 6
  if(btnp(3) and p.mindex<10) p.mindex = 10

  if(btnp(4))then 
  	if(p.mindex<10)then
  		p.num = p.mindex
    p.erase = false
  		p.menu = false
  	elseif(p.mindex==11)then
  		p.erase = not p.erase
    if(p.erase) p.menu = false
   elseif(p.mindex==12)then
    g.state=0
  	end
  end

  if(btnp(5)) p.menu = false
 end
end

--error detection. runs after number is placed
--ind is index, dig is the number being placed
--log is bool for whether to add or remove
function check_error(ind,dig,log)
	low = ind-((ind-1)%9)
	high = low+8
	count = 0
	
 --rows
	for i=low,high do
		if(dat[i] == dig and i != ind) then
   if(log) add(err,i)
			count += 1
		end
	end

 --cols
	for i=ind%9,81,9 do
		if(dat[i] == dig and i != ind) then
			if(log) add(err,i)
			count += 1
		end
	end

 --cubes
	box = ind-(((ind-1)%3)+(flr(ind/9)%3)*9)
	for i=0,2 do
  cell = box
		for j=0,2 do
			if(dat[cell] == dig and cell != ind) then
				if(log) add(err,cell)
				count += 1
			end
			cell += 1
  end
  box += 9
 end

 if(count > 0) then
  if(log) add(err,ind)
 else
  if(not log) del(err, ind)
 end

 if(count == 0) then
  win = true
  for e in all(dat) do
   if(e == 0) win = false
  end
  if(err != nil) win = false
  if(win) done[m.index] = true
 end
end

function _draw()
 cls(1)
 clk += 1

 if(g.state == 0) then
  menu_draw()
 elseif(g.state == 1) then
  game_draw()
 end
end

function menu_draw()
 wig = 0
 if(clk < 40) then wig = cos(clk/155)*10
 else 
  if(clk%25 == 0) m.sec+=1
  if(m.sec%2 == 1) wig = 0-(clk%25)/25
 end
 
 --splash screen
 if(m.state == 0) then
  for i=0,4 do
   pal(7,10-i)
   sspr(8,8,48,8,16,20-(i*wig),96,16)
  end
  pal(7,7)

  rectfill(0,54,128,56,5)
  rectfill(0,56,128,128,4)

  sspr(56,8,17,18,56,68,34,36)
  sspr(73,8,12,18,41,68,24,36)

  print("press 🅾️ to play",32,58,7+(m.sec%2*3))
  print("game by playerpeter1231",22,112,7)

 --draw level select
 elseif(m.state == 1) then

  if(m.index < 16) then
   tempx = (m.index-1)%3*32+22
   tempy = (flr((m.index-1)/3)+1)*20-14
   rectfill(tempx,tempy,tempx+20,tempy+20,8)
  else
   rectfill(38,110,90,122,8)
  end

  pal(5,7)
  for i=0,14 do
   levcol = 0
   tempx = (i%3*32)+24
   tempy = (flr(i/3)+1)*20-12
   if(done[i+1]) levcol = 11
   rectfill(tempx,tempy,tempx+16,tempy+16,levcol)
   spr(i+1,tempx+4,tempy+4)
  end
  pal(5,5)

  rectfill(40,112,88,120,0)
  print("options",51,114,7)
 end
end

function check_clock(time)
 if(tonum(time) < 0) then time = "00"
 elseif(tonum(time) < 10) then time = "0"..time end
 return time
end

function game_draw()
 --draw black border and internal lines
 rectfill(gridx-2,gridy-2,gridx+gsize+2,gridy+gsize+2,0)

 --draw timer
 if(done[g.level] == false) then
  hr = tostr(flr(clk/108000))
  min = tostr(flr(clk/1800)%60)
  sec = tostr(flr(clk/30)%60)
  hr = check_clock(hr)
  min = check_clock(min)
  sec = check_clock(sec)
 end
 print("time: "..hr..":"..min..":"..sec,68,2,7)

 --draw backround lines
 for i=0,8 do
  tempx = i%3*cmarg*3+gridx
  tempy = flr(i/3)*cmarg*3+gridy
  rectfill(tempx,tempy,tempx+ssize,tempy+ssize,13)
 end
 
 --player box, drawn underneath for thicker box
 tempx = (p.x-1)*cmarg+gridx
 tempy = (p.y-1)*cmarg+gridy
 rectfill(tempx-2,tempy-2,tempx+csize+2,tempy+csize+2,p.col)

 --create all cells
 for i=0,80 do 
  xmod = i%9
  ymod = flr(i/9)
  tempx = xmod*cmarg+gridx
  tempy = ymod*cmarg+gridy

  --draw individual cells as boxes
  rectfill(tempx,tempy,tempx+csize,tempy+csize,15)

  --draw num sprites from dat table
  pal(5,5)
  spr(dat[i+1],tempx+1,tempy+1)

  pal(5,0)
  spr(levels[g.level][i+1],tempx+1,tempy+1)
 end

 --draw errors
 pal(5,8)
 for e in all(err) do
  xmod = (e-1)%9
  ymod = flr((e-1)/9)
  tempx = xmod*cmarg+gridx
  tempy = ymod*cmarg+gridy
  spr(dat[e],tempx+1,tempy+1)

 end
 pal(5,5)

 --display num menu
 --print(p.index,50,50,7)
 --print(p.num,58,50,7)
 if(p.menu == true) then

  --display on top or bottom
  tempy = 90
  if(p.index > 54) then
   tempy = 0
  end

  --border
  rectfill(0,tempy,128,tempy+38,5)

  --player selection
  if(p.mindex < 10) then
   tempx = (p.mindex-1)*cmarg+4
   rectfill(tempx,tempy+6,tempx+14,tempy+20,p.col)
  else
   tempx = (p.mindex-10)*cmarg*2+30
   rectfill(tempx,tempy+20,tempx+14,tempy+34,p.col)
   --print(tempx,20,116,7)
  end

  --num options
  pal(5,0)
  for i=0,8 do
   rectfill(i*cmarg+6,tempy+8,i*cmarg+16,tempy+18,15)
   spr(i+1,i*cmarg+7,tempy+10)
   --print(p.mindex,50,118,7)
  end
  pal(5,5)

  --menu options
  for i=0,2 do
   rectfill(i*cmarg*2+32,tempy+22,i*cmarg*2+42,tempy+32,15)
   spr(i+27,i*cmarg*2+33,tempy+24)
  end
  if(p.erase) rect(58,tempy+22,68,tempy+32,11)
 end

 if (done[g.level] == true) then
  print("nice job!",gridx-1,2,11)
 end
end

__gfx__
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
eeeeeeeeeeee5eeeeeee55eeeeee55eeeeeee5eeeee5555eeeee555eeee5555eeee555eeeee555eeee5ee55eee5ee5eeee5ee55eee5ee55eee5eee5eee5e5555
eeeeeeeeeee55eeeeee5ee5eeee5ee5eeeee55eeeee5eeeeeee5eeeeeeeeee5eee5eee5eee5eee5eee5e5ee5ee5ee5eeee5e5ee5ee5e5ee5ee5ee55eee5e5eee
eeeeeeeeee5e5eeeee5eee5eeeeee5eeeee5e5eeeee555eeeee555eeeeeeee5eeee555eeee5eee5eee5e5ee5ee5ee5eeee5eeee5ee5eee5eee5e5e5eee5e555e
eeeeeeeeeeee5eeeeeeee5eeeeeeee5eee55555eeeeeee5eee5eee5eeeeee5eeeee5ee5eeee5555eee5e5ee5ee5ee5eeee5eee5eee5eeee5ee5e5555ee5eeee5
eeeeeeeeeeee5eeeeeee5eeeeeeeee5eeeeee5eeee5eee5eee5eee5eeeee5eeeee5eee5eeeeeee5eee5e5ee5ee5ee5eeee5ee5eeee5e5ee5ee5eee5eee5e5ee5
eeeeeeeeee55555eee55555eeee555eeeeeee5eeeee555eeeee555eeeee5eeeeeee555eeeee555eeee5ee55eee5ee5eeee5e5555ee5ee55eee5eee5eee5ee55e
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000eeeee7777e77ee77e7777eeee777777ee77ee77e77ee77eeeeeeeeeeeeeeeeeeeeeeee5eeeeee000eeeee00eee00000eeee000ee0000000000000000
00000000eeee77777e77ee77e77777ee77777777e77ee77e77ee77eeeeeeeeeeeeeeeeeeeeeee5ee5eeee000eeee0000e00eee00ee00000e0000000000000000
00000000eee77eeeee77ee77e77e777e77eeee77e77ee77e77ee77eeeeeeeeee77799eeeeeeee5eee5eee000eee00000e0e0e0e0e00000000000000000000000
00000000eee777777e77ee77e77ee77e77eeee77e77777ee77ee77eeeeeee777774499eeeeeeee5e5eeee000ee00000ee0ee0ee0eeeeeeee0000000000000000
00000000eee777777e77ee77e77ee77e77eeee77e77777ee77ee77eeee7777777999497eeeeeeeeeeeeee000eee000eee0e0e0e0ee00000e0000000000000000
00000000eeeeeee77e77ee77e77ee77e77eeee77e77ee77e77ee77eee77777774499477eeeee7776666ee000e0ee0eeee00eee00ee00e00e0000000000000000
00000000eee77777ee77777ee777777e77777777e77ee77e77777eeee777d77999497777ee7744444446e000e00eeeeeee00000eee00e00e0000000000000000
00000000eee7777eee7777eee777777ee777777ee77ee77e7777eeeee777dd7ff9477777e644444445556000eeeeeeeeeeeeeeeeeeeeeeee0000000000000000
00000000000000000000000000000000000000000000000000000000e7777775f9777777e6544445555560000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ee7777d7777dd777e7655555555660000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ee7777dd77dd777777766666666760000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ee77777dddd77d7777777777777760000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ee7777777777dd7777767777777760000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000eee77d777777777777677777777760000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000eee77d7d77777777e7676777776650000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000eee7777777777eeeee677676665550000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000eee7777777eeeeeeee5665555555e0000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000eeee777eeeeeeeeeeee55555555ee0000000000000000000000000000000000000000000
