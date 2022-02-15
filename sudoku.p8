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
levels={{0,0,4,0,5,0,0,0,0,
																																9,0,0,7,3,4,6,0,0,
																													0,0,3,0,2,1,0,4,9,
																													0,3,5,0,9,0,4,8,0,
																													0,9,0,0,0,0,0,3,0,
																													0,7,6,0,1,0,9,2,0,
																													3,1,0,9,7,0,2,0,0,
																													0,0,0,1,8,2,0,0,3,
																													0,0,0,0,6,0,1,0,0}}

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
	dat = copy_data(levels[1])

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

	err={}

	palt(0,false)
	palt(14,true)
end

function _update()
	player_update()
end

function player_update()

	if(not p.menu) then
				--index location based on players x+y
				p.index = p.x+(p.y-1)*9

				--arrow keys
		if(btnp(0) and p.x>1) p.x-=1
		if(btnp(1) and p.x<9) p.x+=1
		if(btnp(2) and p.y>1) p.y-=1
		if(btnp(3) and p.y<9) p.y+=1 

		--face buttons
		if(btnp(4) and levels[1][p.index] == 0) then
			dat[p.index] = p.num
			if(p.erase) dat[p.index] = 0
			check_error(p.index,p.num)
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
								p.menu = false
				elseif (p.mindex==11)then
								p.erase = not p.erase
				end
		end

		if(btnp(5)) p.menu = false
	end
end

--error detection. runs after number is placed
--ind is index, dig is the number being placed
function check_error(ind,dig)
	low = ind-((ind-1)%9)
	high = low+8
	count = 0

 for i=low,high do
	 if(dat[i] == dig) then
			add(err,i-1)
			count += 1
		end
	end
	if(count == 1) del(err,ind-1)
					
	for i=ind%9,81,9 do
		if(dat[i] == dig) then
			add(err,i-1)
			count += 1
		end
	end
if(count == 2) del(err,ind-1)
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
		spr(levels[1][i+1],tempx+1,tempy+1)
	end

	--draw errors
	pal(5,8)
	for e in all(err) do
				xmod = e%9
				ymod = flr(e/9)
				tempx = xmod*cmarg+gridx
				tempy = ymod*cmarg+gridy
				spr(dat[e+1],tempx+1,tempy+1)
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
			spr(i+10,i*cmarg*2+33,tempy+24)
		end
		if(p.erase) rect(58,112,68,122,11)
	end



end

__gfx__
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00eee00000eeee000ee000000000000000000000000
eeeeeeeeeeee5eeeeeee55eeeeee55eeeeeee5eeeee5555eeeee555eeee5555eeee555eeeee555eeeeee0000e00eee00ee00000e000000000000000000000000
eeeeeeeeeee55eeeeee5ee5eeee5ee5eeeee55eeeee5eeeeeee5eeeeeeeeee5eee5eee5eee5eee5eeee00000e0e0e0e0e0000000000000000000000000000000
eeeeeeeeee5e5eeeee5eee5eeeeee5eeeee5e5eeeee555eeeee555eeeeeeee5eeee555eeee5eee5eee00000ee0ee0ee0eeeeeeee000000000000000000000000
eeeeeeeeeeee5eeeeeeee5eeeeeeee5eee55555eeeeeee5eee5eee5eeeeee5eeeee5ee5eeee5555eeee000eee0e0e0e0ee00000e000000000000000000000000
eeeeeeeeeeee5eeeeeee5eeeeeeeee5eeeeee5eeee5eee5eee5eee5eeeee5eeeee5eee5eeeeeee5ee0ee0eeee00eee00ee00e00e000000000000000000000000
eeeeeeeeee55555eee55555eeee555eeeeeee5eeeee555eeeee555eeeee5eeeeeee555eeeee555eee00eeeeeee00000eee00e00e000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee000000000000000000000000
