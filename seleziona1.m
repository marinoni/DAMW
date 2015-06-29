function seleziona1(cosa)
	
global D O

tokamak=get(findobj(0,'style','popupmenu','tag','tokamak'),'value');
if iscell(tokamak)
	tokamak=cell2mat(tokamak(1));
end
switch cosa
	
	case 'prima'
		
		if ~get(gcbo,'value')
			return
		end
		scr=get(0,'screensize');
		a=0.5;
		f(1)=scr(1)+scr(3)*(1-a)/2;
		f(2)=scr(2)+scr(4)*(1-a)/2;
		f(3)=scr(3)*a;
		f(4)=scr(4)*a;
		h=figure('position',[f(1) f(2) f(3) f(4)]);
		a=get(gcbo,'tag');

		switch a

			case 'selriflx'

				if tokamak==1
					set(h,'name','X Reflectometer: channel choice','numbertitle','off');
					for i=1:length(D)
						if D(i).nome=='riflx';
							break
						end		
					end
					if D(i).nome~='riflx'
						disp('Diagnostic not loaded');
						return
					end
					for h=1:D(i).ncan/2
						uicontrol('units','normalized','position',[0.1 1-0.07*h 0.8	0.05],...
						'string',strcat([D(i).srms{h},' & ',D(i).sph{h}]),'style','checkbox');
					end
				else
					set(h,'name','Electron Cyclotron Emission: channel choice','numbertitle','off');
					for i=1:length(D)
						if D(i).nome=='ece';
							break
						end		
					end
					if D(i).nome~='ece'
						disp('Diagnostic not loaded');
						return
					end
					for h=1:D(i).ncan
						uicontrol('units','normalized','position',[0.1 1-0.07*h 0.8	0.05],...
						'string',D(i).srms{h},'style','checkbox');
					end
				end
				uicontrol('units','normalized','string','Ok','callback','seleziona1 dopo','userdata',i);


			case 'selriflo'

				set(h,'name','O Reflectometer: channel choice','numbertitle','off');
				for i=1:length(D)
					if D(i).nome=='riflo';
						break
					end		
				end
				if D(i).nome~='riflo'
					disp('Diagnostic not loaded');
					return
				end
				if tokamak==1
					for h=1:D(i).ncan/2
						uicontrol('units','normalized','position',[0.1 1-0.07*h 0.8	0.05],...
						'string',strcat([D(i).srms{h},' & ',D(i).sph{h}]),'style','checkbox');
					end
				else
					for h=1:D(i).ncan
						uicontrol('units','normalized','position',[0.1 1-0.07*h 0.8	0.05],...
						'string',D(i).srms{h},'style','checkbox');
					end
				end
				uicontrol('units','normalized','string','Ok','callback','seleziona1 dopo','userdata',i);
					

			case 'selmagn'
			
				set(h,'name','Magnetics: channel choice','numbertitle','off');
				for i=1:length(D)
					if D(i).nome=='magn';
						break
					end		
				end
				if D(i).nome~='magn'
					disp('Diagnostic not loaded');
					return
				end
				for h=1:D(i).ncan
					uicontrol('units','normalized','position',[0.1 1-0.07*h 0.8	0.05],...
					'string',D(i).srms{h},'style','checkbox');
				end
				uicontrol('units','normalized','string','Ok','callback','seleziona1 dopo','userdata',i)
			
		end
	
	case 'dopo'

		i=get(gcbo,'userdata');
		aa=findobj(gcbf,'style','checkbox');
		aa=aa(end:-1:1);
		O(i).analizza=cell2mat(get(aa,'value'));
		O(i).all=0;
		O(i).sel=1;
		close;
		
	case 'opzioni'
	
		quale=get(gcbo,'tag');
		switch quale
		
			case 'OKRIFLX'
			
				if tokamak==1
					for i=1:length(D)
						if D(i).nome=='riflx';
							break
						end		
					end
					if D(i).nome~='riflx'
						disp('Diagnostic not loaded');
						return
					end	
					O(i).phase=get(findobj(gcbf,'tag','phase','string','Phase'),'value');
					if O(i).phase
						O(i).convp=str2num(get(findobj(gcbf,'tag','convp','style','edit'),'string'));
						O(i).phfil=get(findobj(gcbf,'tag','phfil','string','Fourier Filter'),'value');
						if O(i).phfil
							O(i).phfilhi=get(findobj(gcbf,'tag','phfilhi','style','checkbox'),'value');
							O(i).phfillow=get(findobj(gcbf,'tag','phfillow','style','checkbox'),'value');
							O(i).fil1p=str2num(get(findobj(gcbf,'tag','fil1p','style','edit'),'string'));
							O(i).fil2p=str2num(get(findobj(gcbf,'tag','fil2p','style','edit'),'string'));
							O(i).fil3p=str2num(get(findobj(gcbf,'tag','fil3p','style','edit'),'string'));
							O(i).fil4p=str2num(get(findobj(gcbf,'tag','fil4p','style','edit'),'string'));
						end
						O(i).phwvl=get(findobj(gcbf,'tag','phden','string','Wavelet denoising'),'value');
						if O(i).phwvl
							O(i).wvl1p=get(findobj(gcbf,'tag','tipowvtp','style','edit'),'string');
							O(i).wvl2p=get(findobj(gcbf,'tag','metodowvp','style','popupmenu'),'value');
							O(i).wvl3p=get(findobj(gcbf,'tag','wnwp','style','popupmenu'),'value');
							O(i).wvl4p=get(findobj(gcbf,'tag','wayp','style','popupmenu'),'value');
							O(i).wvl5p=str2num(get(findobj(gcbf,'tag','maxp','style','edit'),'string'));
						end
					end
				else
					for i=1:length(D)
						if D(i).nome=='ece';
							break
						end		
					end
					if D(i).nome~='ece'
						disp('Diagnostic not loaded');
						return
					end
					O(i).phase=0;	
				end
				O(i).sel=get(findobj(gcbf,'tag','selriflx'),'value');
				O(i).all=get(findobj(gcbf,'tag','allriflx'),'value');
				if or(O(i).sel,O(i).all)
					O(i).analisi_diag=1;
				end
				O(i).amp=get(findobj(gcbf,'tag','amplitude','string','Amplitude'),'value');
				if O(i).amp
					O(i).conva=str2num(get(findobj(gcbf,'tag','conva','style','edit'),'string'));
					O(i).ampfil=get(findobj(gcbf,'tag','ampfil','string','Fourier Filter'),'value');
					if O(i).ampfil
						O(i).ampfilhi=get(findobj(gcbf,'tag','ampfilhi','style','checkbox'),'value');
						O(i).ampfillow=get(findobj(gcbf,'tag','ampfillow','style','checkbox'),'value');
						O(i).fil1a=str2num(get(findobj(gcbf,'tag','fil1a','style','edit'),'string'));
						O(i).fil2a=str2num(get(findobj(gcbf,'tag','fil2a','style','edit'),'string'));
						O(i).fil3a=str2num(get(findobj(gcbf,'tag','fil3a','style','edit'),'string'));
						O(i).fil4a=str2num(get(findobj(gcbf,'tag','fil4a','style','edit'),'string'));
					end
					O(i).ampwvl=get(findobj(gcbf,'tag','ampden','string','Wavelet denoising'),'value');
					if O(i).ampwvl
						O(i).wvl1a=get(findobj(gcbf,'tag','tipowvta','style','edit'),'string');
						O(i).wvl2a=get(findobj(gcbf,'tag','metodowva','style','popupmenu'),'value');
						O(i).wvl3a=get(findobj(gcbf,'tag','wnwa','style','popupmenu'),'value');
						O(i).wvl4a=get(findobj(gcbf,'tag','waya','style','popupmenu'),'value');
						O(i).wvl5a=str2num(get(findobj(gcbf,'tag','maxa','style','edit'),'string'));
					end
				end

			case 'OKRIFLO'
			
				for i=1:length(D)
					if D(i).nome=='riflo';
						break
					end		
				end
				if D(i).nome~='riflo'
					disp('Diagnostic not loaded');
					return
				end	
				O(i).sel=get(findobj(gcbf,'tag','selriflo'),'value');
				O(i).all=get(findobj(gcbf,'tag','allriflo'),'value');
				if or(O(i).all,O(i).sel)
					O(i).analisi_diag=1;
				end
				O(i).amp=get(findobj(gcbf,'tag','amplitude','string','Amplitude'),'value');
				if O(i).amp
					O(i).conva=str2num(get(findobj(gcbf,'tag','conva','style','edit'),'string'));
					O(i).ampfil=get(findobj(gcbf,'tag','ampfil','string','Fourier Filter'),'value');
					if O(i).ampfil
						O(i).ampfilhi=get(findobj(gcbf,'tag','ampfilhi','style','checkbox'),'value');
						O(i).ampfillow=get(findobj(gcbf,'tag','ampfillow','style','checkbox'),'value');
						O(i).fil1a=str2num(get(findobj(gcbf,'tag','fil1a','style','edit'),'string'));
						O(i).fil2a=str2num(get(findobj(gcbf,'tag','fil2a','style','edit'),'string'));
						O(i).fil3a=str2num(get(findobj(gcbf,'tag','fil3a','style','edit'),'string'));
						O(i).fil4a=str2num(get(findobj(gcbf,'tag','fil4a','style','edit'),'string'));
					end
					O(i).ampwvl=get(findobj(gcbf,'tag','ampden','string','Wavelet denoising'),'value');
					if O(i).ampwvl
						O(i).wvl1a=get(findobj(gcbf,'tag','tipowvta','style','edit'),'string');
						O(i).wvl2a=get(findobj(gcbf,'tag','metodowva','style','popupmenu'),'value');
						O(i).wvl3a=get(findobj(gcbf,'tag','wnwa','style','popupmenu'),'value');
						O(i).wvl4a=get(findobj(gcbf,'tag','waya','style','popupmenu'),'value');
						O(i).wvl5a=str2num(get(findobj(gcbf,'tag','maxa','style','edit'),'string'));
					end
				end
				if tokamak==1
					O(i).phase=get(findobj(gcbf,'tag','phase','string','Phase'),'value');
					if O(i).phase
						O(i).convp=str2num(get(findobj(gcbf,'tag','convp','style','edit'),'string'));
						O(i).phfil=get(findobj(gcbf,'tag','phfil','string','Fourier Filter'),'value');
						if O(i).phfil
							O(i).phfilhi=get(findobj(gcbf,'tag','phfilhi','style','checkbox'),'value');
							O(i).phfillow=get(findobj(gcbf,'tag','phfillow','style','checkbox'),'value');
							O(i).fil1p=str2num(get(findobj(gcbf,'tag','fil1p','style','edit'),'string'));
							O(i).fil2p=str2num(get(findobj(gcbf,'tag','fil2p','style','edit'),'string'));
							O(i).fil3p=str2num(get(findobj(gcbf,'tag','fil3p','style','edit'),'string'));
							O(i).fil4p=str2num(get(findobj(gcbf,'tag','fil4p','style','edit'),'string'));
						end
						O(i).phwvl=get(findobj(gcbf,'tag','phden','string','Wavelet denoising'),'value');
						if O(i).phwvl
							O(i).wvl1p=get(findobj(gcbf,'tag','tipowvtp','style','edit'),'string');
							O(i).wvl2p=get(findobj(gcbf,'tag','metodowvp','style','popupmenu'),'value');
							O(i).wvl3p=get(findobj(gcbf,'tag','wnwp','style','popupmenu'),'value');
							O(i).wvl4p=get(findobj(gcbf,'tag','wayp','style','popupmenu'),'value');
							O(i).wvl5p=str2num(get(findobj(gcbf,'tag','maxp','style','edit'),'string'));
						end
					end
				else
					O(i).phase=0;
				end	
			
			case 'OKMAGN'
			
				for i=1:length(D)
					if D(i).nome=='magn';
						break
					end		
				end
				if D(i).nome~='magn'
					disp('Diagnostic not loaded');
					return
				end	
				O(i).phase=0;%Magnetics do not have a phase as the reflectometer (used in dati.m)
				O(i).sel=get(findobj(gcbf,'tag','selmagn'),'value');
				O(i).all=get(findobj(gcbf,'tag','allmagn'),'value');
				if or(O(i).sel,O(i).all)
					O(i).analisi_diag=1;
				end
				O(i).amp=get(findobj(gcbf,'tag','amplitude','string','Amplitude'),'value');
				if O(i).amp
					O(i).conva=str2num(get(findobj(gcbf,'tag','convm','style','edit'),'string'));
					O(i).ampfil=get(findobj(gcbf,'tag','ampfil','string','Fourier Filter'),'value');
					if O(i).ampfil
						O(i).ampfilhi=get(findobj(gcbf,'tag','ampfilhi','style','checkbox'),'value');
						O(i).ampfillow=get(findobj(gcbf,'tag','ampfillow','style','checkbox'),'value');
						O(i).fil1a=str2num(get(findobj(gcbf,'tag','fil1a','style','edit'),'string'));
						O(i).fil2a=str2num(get(findobj(gcbf,'tag','fil2a','style','edit'),'string'));
						O(i).fil3a=str2num(get(findobj(gcbf,'tag','fil3a','style','edit'),'string'));
						O(i).fil4a=str2num(get(findobj(gcbf,'tag','fil4a','style','edit'),'string'));
					end
					O(i).ampwvl=get(findobj(gcbf,'tag','ampden','string','Wavelet denoising'),'value');
					if O(i).ampwvl
						O(i).wvl1a=str2num(get(findobj(gcbf,'tag','tipowvta','style','edit'),'string'));
						O(i).wvl2a=get(findobj(gcbf,'tag','metodowva','style','popupmenu'),'value');
						O(i).wvl3a=get(findobj(gcbf,'tag','wnwa','style','popupmenu'),'value');
						O(i).wvl4a=get(findobj(gcbf,'tag','waya','style','popupmenu'),'value');
						O(i).wvl5a=str2num(get(findobj(gcbf,'tag','maxa','style','edit'),'string'));
					end
				end
				O(i).phase=0;
			end
end
