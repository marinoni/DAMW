if isempty(gcbo)
	scr=get(0,'screensize');
	a=0.7;
	f(1)=scr(1)+scr(3)*(1-a)/2;
	f(2)=scr(2)+scr(4)*(1-a)/2;
	f(3)=scr(3)*a;
	f(4)=scr(4)*a;
	h=figure('position',[f(1) f(2) f(3) f(4)]);
	set(h,'name','Data Analysis','numbertitle','off');
	fin.tokamak=uicontrol('units','normalized','style','popupmenu','tag','tokamak','position',[0.01 0.9 0.09 0.05],'string','JET|TCV',...
	'callback','mdaw');
	fin.tokamak_t=uicontrol('units','normalized','style','text','position',[0.01 0.95 0.09 0.05],'string','Tokamak');
	fin.scarica_t=uicontrol('units','normalized','style','text','position',[0.11 0.95 0.12 0.05],'string','Pulse number');
	fin.scarica=uicontrol('units','normalized','style','edit','tag','scarica','position',[0.11 0.9 0.12 0.05],'callback','canali');
	fin.canali_t=uicontrol('units','normalized','style','text','position',[0.5 0.95 0.15 0.05],'string','Diagnostics');
	fin.dia1=uicontrol('units','normalized','position',[0.24 0.9 0.15 0.05],'string','X Reflectometer','callback','riflX riflx');
	fin.dia11=uicontrol('units','normalized','tag','RIFLX','position',[0.24 0.85 0.15 0.05],'string','Analysis options','callback','A_opzioni');
	fin.dia2=uicontrol('units','normalized','position',[0.4 0.9 0.15 0.05],'string','O Reflectometer','callback','riflX riflo');
	fin.dia22=uicontrol('units','normalized','tag','RIFLO','position',[0.4 0.85 0.15 0.05],'string','Analysis options','callback','A_opzioni');
	fin.dia3=uicontrol('units','normalized','position',[0.56 0.9 0.15 0.05],'string','Magnetics','callback','riflX magn');
	fin.dia33=uicontrol('units','normalized','tag','MAGN','position',[0.56 0.85 0.15 0.05],'string','Analysis options','callback','A_opzioni');
	fin.dia4=uicontrol('units','normalized','position',[0.72 0.9 0.15 0.05],'string','Reference','callback','riflX ref');

	fin.t=uicontrol('units','normalized','position',[0.01 0.79 0.1 0.05],'string','tmin&tmax','callback','tempi');
	fin.sp=uicontrol('units','normalized','position',[0.36 0.79 0.1 0.05],'string','Analysis','callback','dati');
	fin.sav=uicontrol('units','normalized','style','checkbox','tag','salva','position',[0.12 0.79 0.1 0.05],'string','Save data');
	%fin.qua=uicontrol('units','normalized','style','listbox','tag','quali','position',[0.01 0.84 0.1 0.05],'string','','max',2);
	fin.tag=uicontrol('units','normalized','tag','tagli','position',[0.24 0.79 0.1 0.05],'callback','tagli','string','Positions');
else
	tokamak=get(gcbo,'value');
	switch tokamak
		
		case 1
			
			set(fin.dia1,'string','X Reflectometer');
			set(fin.dia2,'string','O Reflectometer');	
		case 2
		
			set(fin.dia1,'string','ECE');
			set(fin.dia2,'string','Reflectometer');
	end	
end
