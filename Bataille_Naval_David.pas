PROGRAM Bataille_Naval;

Uses crt;

CONST
	board_width = 15;
	board_length = 15;

TYPE
	orientation=(vertical, horizontal);

	coord = RECORD
		x : integer;
		y : integer;
	END;

	boat = RECORD
		top: coord;
		middle : coord;
		bottom : coord;
	END;

	fleet = RECORD
		boat1 : boat;
		boat2 : boat;
		boat3 : boat;
		END;

procedure init_tab(VAR tab:array of coord);
	VAR
		counter : integer;
	Begin
		for counter:=0 to (length(tab)-1) do
			Begin
				tab[counter].x:=-1;
				tab[counter].y:=-1;
			End;
	End;

function is_on_board (tested_coord : coord):boolean;
	Begin
		is_on_board:=((((tested_coord.x)<=board_width)and((tested_coord.x)>=0))and(((tested_coord.y)<=board_width)and((tested_coord.y)>=0)));
	End;

function make_coord (x : integer; y : integer):coord;
	Begin
		make_coord.x:=x;
		make_coord.y:=y;
	End;

function make_boat (origin : coord; b_orientation : orientation): boat;
	VAR
		y_modifier,x_modifier : integer;
	Begin
		if b_orientation=vertical then 
			Begin
				y_modifier:=1;
				x_modifier:=0;
			End
		else
			Begin
				y_modifier:=0;
				x_modifier:=1;
			End;
		make_boat.top:=origin;
		make_boat.middle:=make_coord(origin.x+(1*x_modifier),origin.y+(1*y_modifier));
		make_boat.bottom:=make_coord(origin.x+(2*x_modifier),origin.y+(2*y_modifier));
	End;

function is_same_coords (coord1 : coord; coord2 : coord):boolean;

	Begin
		is_same_coords:=((coord1.x=coord2.x) and (coord1.y=coord2.y))
	End;

function is_on_boat (t_boat : boat; t_coord : coord) : boolean;

	Begin
		is_on_boat:=((is_same_coords(t_boat.top,t_coord)) or (is_same_coords(t_boat.middle,t_coord)) or (is_same_coords(t_boat.bottom,t_coord)));
	End;

function is_on_fleet (t_fleet : fleet; t_coord : coord) : boolean;
	
	Begin
		is_on_fleet:=((is_on_boat(t_fleet.boat1,t_coord)) or (is_on_boat(t_fleet.boat2,t_coord)) or (is_on_boat(t_fleet.boat3,t_coord)));  
	End;

function does_boat_overlap (t_boat : boat; r_boat : boat) : boolean;
	
	Begin
		does_boat_overlap:=((is_on_boat(r_boat,t_boat.top)) or (is_on_boat(r_boat,t_boat.middle)) or (is_on_boat(r_boat,t_boat.bottom)));
	End;

function create_boat () : boat;
	VAR
		x,y : integer;
		l_orientation : orientation;
		counter1: integer;
		bottom_on_board : boolean;

	Begin
		repeat
			repeat
				writeln('Veuillez entrer la coordonee horizontal de l avant du bateau (entre 0 et ',board_width,').');
				readln(x);
			until ((x>=0) and (x<=board_width));
			repeat
				writeln('Veuillez entrer la coordonee vertical de l avant du bateau (entre 0 et ',board_length,').');
				readln(y);
			until ((y>=0) and (y<=board_length));
			writeln('Veuillez entrer l orientation du bateau (Vertical ou Horizontal).');
			readln(l_orientation);
			create_boat:=make_boat(make_coord(x,y),l_orientation);
			bottom_on_board:=(((create_boat.bottom.x>=0) and (create_boat.bottom.x<=board_width)) and ((create_boat.bottom.y>=0) and (create_boat.bottom.y<=board_length)));
			if (not(bottom_on_board)) then writeln('Le bateau ainsi cree serait hors des limites du terrain (Horizontal et Vertical de 0 a ',board_width,').');
		until (((create_boat.bottom.x>=0) and (create_boat.bottom.x<=board_width)) and ((create_boat.bottom.y>=0) and (create_boat.bottom.y<=board_length)));
	End;

function create_fleet() : fleet;
	Begin
		writeln('Veuillez entrer les informations du premier bateau :');
		create_fleet.boat1:=create_boat;
		repeat 
			writeln('Veuillez entrer les informations du deuxieme bateau :');
			create_fleet.boat2:=create_boat;
			if ((does_boat_overlap(create_fleet.boat2,create_fleet.boat1))) then
				Begin
					writeln('Un bateau se trouve deja sur cette position veuillez en choisir une autre.');
				End;
		until (not(does_boat_overlap(create_fleet.boat2,create_fleet.boat1)));
		repeat
		writeln('Veuillez entrer informations du troisieme bateau :');
		create_fleet.boat3:=create_boat;
		if (((does_boat_overlap(create_fleet.boat3,create_fleet.boat1))) or ((does_boat_overlap(create_fleet.boat3,create_fleet.boat2)))) then
			Begin
				writeln('Un bateau se trouve deja sur cette position veuillez en choisir une autre.');
			End;		
		until ((not(does_boat_overlap(create_fleet.boat3,create_fleet.boat1))) and (not(does_boat_overlap(create_fleet.boat3,create_fleet.boat2))));
	End;

procedure fleets_creation(VAR fleet_J1 : fleet; VAR fleet_J2 : fleet);
	Begin
		clrscr;
		writeln('Joueur 1 a votre tour :');
		fleet_J1:=create_fleet();
		clrscr;
		writeln('Joueur 2 a votre tour :');
		fleet_J2:=create_fleet();
	End;

function allready_shooted (shooted : integer; coords_shooted : array of coord; shoot : coord) : boolean;

	VAR
	counter : integer;

	Begin
		counter:=0;
		while (not(is_same_coords(coords_shooted[counter],shoot)) and (counter<>shooted)) do
			Begin
				counter:=counter+1;
			End;
		allready_shooted:=is_same_coords(coords_shooted[counter],shoot);
	End;

function create_shoot (shooted : integer;coords_shooted: array of coord) : coord;

	VAR
	x_shoot,y_shoot : integer;

	Begin
		repeat 
			if ((allready_shooted(shooted,coords_shooted,create_shoot))) then writeln('Vous avez deja tire sur cette coordonee.');
			writeln('Veuillez entrer les coordonees ou vous souhaitez tirer :');
			repeat 
				writeln('Veuillez entrer la coordonee horizontal (entre 0 et ',board_width,').');
				readln(x_shoot);
			until ((x_shoot>=0) and (x_shoot<=board_width));
			repeat
				writeln('Veuillez entrer la coordonee vertical (entre 0 et ',board_length,').');
				readln(y_shoot);
				create_shoot:=make_coord(x_shoot,y_shoot);
			until ((y_shoot>=0) and (y_shoot<=board_length));
		until (not(allready_shooted(shooted,coords_shooted,create_shoot)));
	End;

procedure draw_battlefield(touched : integer; shooted : integer; coords_touched : array of coord;coords_shooted : array of coord);

	VAR
		x,y : integer;
	Begin
		for y:=0 to board_length do
			Begin
				for x:=0 to board_width do
					Begin
					 	if allready_shooted(touched,coords_touched,make_coord(x,y)) then write('[O]') else
					 		Begin
					 			if allready_shooted(shooted,coords_shooted,make_coord(x,y)) then write('[X]') else write('[ ]');
					 		End;
					End;
				writeln('');
			End;
	End;

procedure shooting_phase(fleet_J1 : fleet; fleet_J2 : fleet);

	VAR
		coords_shooted_P1: array[0..224] of coord; //J'utilise un tableau pour retenir les coordonnées où le joueur à tiré et ainsi l'empécher de tirer à nouveau dessus
		coords_shooted_P2: array[0..224] of coord;
		coords_touched_P1: array[0..9] of coord;
		coords_touched_P2: array[0..9] of coord;
		shooted_P1,shooted_P2,touched_P1, touched_P2 : integer;
		shoot : coord;
	Begin
		init_tab(coords_shooted_P1);
		init_tab(coords_shooted_P2);
		shoot:=make_coord(-1,-1);
		touched_P1:=0;
		touched_P2:=0;
		shooted_P1:=0;
		shooted_P2:=0;
		repeat
			clrscr;
			writeln('Tour du joueur 1');
			draw_battlefield(touched_P1,shooted_P1,coords_touched_P1,coords_shooted_P1);
			shoot:=create_shoot(shooted_P1,coords_shooted_P1);
			coords_shooted_P1[shooted_P1]:=shoot;
			shooted_P1:=shooted_P1+1;
			if is_on_fleet(fleet_J2,shoot) then
				Begin
					coords_touched_P1[touched_P1]:=shoot;
					writeln('Vous avez toucher un bateau !');
					touched_P1:=touched_P1+1;
				End
			else
				Begin
					writeln('Vous n avez rien touche.')
				End;
			readln;
			if not(touched_P1>=9) then
				Begin
					clrscr;
					writeln('Tour du joueur 2');
					draw_battlefield(touched_P2,shooted_P2,coords_touched_P2,coords_shooted_P2);
					shoot:=create_shoot(shooted_P2,coords_shooted_P2);
					coords_shooted_P2[shooted_P2]:=shoot;
					shooted_P2:=shooted_P2+1;
					if is_on_fleet(fleet_J1,shoot) then
						Begin
							coords_touched_P2[touched_P2]:=shoot;
							writeln('Vous avez toucher un bateau !');
							touched_P2:=touched_P2+1;
						End
					else
						Begin
							writeln('Vous n avez rien touche.')

						End;
					readln;
				End;
		until ((touched_P1>=9) or (touched_P2>=9));
		if touched_P1>=9 then writeln('Tout les bateaux du joueur 2 ont coule, le joueur 1 gagne !') else writeln('Tout les bateaux du joueur 1 ont coule, le joueur 2 gagne !');
		readln;
	End;


VAR
	fleet_J1, fleet_J2 : fleet;


Begin
	fleets_creation(fleet_J1, fleet_J2);
	shooting_phase(fleet_J1, fleet_J2);
END.