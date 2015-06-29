global D O

cosa=get(gcbo,'tag');
if isempty(cosa)
	disp('Specify the diagnostic, please.');
	return;
end
scr=get(0,'screensize');
a=0.6;
f(1)=scr(1)+scr(3)*(1-a)/2;
f(2)=scr(2)+scr(4)*(1-a)/2;
f(3)=scr(3)*a;
f(4)=scr(4)*a;
h=figure('position',[f(1) f(2) f(3) f(4)]);
tokamak=get(findobj(gcbf,'style','popupmenu','tag','tokamak'),'value');

switch cosa

	case 'RIFLX'

		if tokamak==1
			set(h,'name','X Reflectometer - analysis options','numbertitle','off');
			b='set(ao.selx,''value'',0)';
			ba='set(ao.filalow,''value'',0)';
			bp='set(ao.filplow,''value'',0)';
			ao.allx=uicontrol('units','normalized','position',[0.33 0.94 0.15 0.05],'style','checkbox','string','All',...
			'callback','evalc(b);','tag','allriflx');
			c='set(ao.allx,''value'',0)';
			ca='set(ao.filahi,''value'',0)';
			cp='set(ao.filphi,''value'',0)';
			ao.selx=uicontrol('units','normalized','position',[0.52 0.94 0.15 0.05],'style','checkbox','string','Selected',...
			'callback','eval(c);seleziona1 prima','tag','selriflx');
			%Amplitude column
			ao.amp=uicontrol('units','normalized','position',[0.21 0.88 0.2	0.05],'style','checkbox',...
			'string','Amplitude','tag','amplitude');
			ao.ph=uicontrol('units','normalized','position',[0.6 0.88 0.2 0.05],'style','checkbox',...
			'string','Phase','tag','phase');
			ao.conv1=uicontrol('units','normalized','position',[0.31 0.8 0.1 0.05],...
			'style','edit','string','101','tag','conva');
			ao.conv1_t=uicontrol('units','normalized','position',[0.1 0.8 0.2 0.05],'style','text','string','Average point number');
			ao.fil=uicontrol('units','normalized','position',[0.1 0.72 0.15 0.05],'style','checkbox','string','Fourier Filter',...
			'tag','ampfil');
			ao.filahi=uicontrol('units','normalized','position',[0.255 0.72 0.11 0.05],'style','checkbox','string','Pass',...
			'tag','ampfilhi','callback','evalc(ba);');
			ao.filalow=uicontrol('units','normalized','position',[0.37 0.72 0.11 0.05],'style','checkbox','string','Stop',...
			'tag','ampfillow','callback','evalc(ca);');
			ao.fil1a=uicontrol('units','normalized','position',[0.1 0.66 0.1 0.05],'style','edit','tag','fil1a','string','0.1');
			ao.fil1a_t=uicontrol('units','normalized','position',[0.21 0.66 0.2 0.05],'style','text','string','Left frequency corner');
			ao.fil2a=uicontrol('units','normalized','position',[0.1 0.6 0.1 0.05],'style','edit','tag','fil2a','string','0.9');
			ao.fil2a_t=uicontrol('units','normalized','position',[0.21 0.6 0.2 0.05],'style','text','string','Right frequency corner');
			ao.fil3a=uicontrol('units','normalized','position',[0.1 0.54 0.1 0.05],'style','edit','tag','fil3a','string','1');
			ao.fil3a_t=uicontrol('units','normalized','position',[0.21 0.54 0.2 0.05],'style','text','string','dB lost in pass-band');
			ao.fil4a=uicontrol('units','normalized','position',[0.1 0.48 0.1 0.05],'style','edit','tag','fil4a','string','20');
			ao.fil4a_t=uicontrol('units','normalized','position',[0.21 0.48 0.2 0.05],'style','text','string','dB lost in cut-band');
			%Denoise with wavelets
			ao.wav=uicontrol('units','normalized','position',[0.1 0.4 0.2 0.05],'style','checkbox','string','Wavelet denoising',...
			'tag','ampden');
			ao.wte=uicontrol('units','normalized','style','edit','tag','tipowvta','position',[0.1 0.34 0.1 0.05],'string','db3');
			ao.wte_t=uicontrol('units','normalized','style','text','position',[0.21 0.34 0.2 0.05],'string','Wavelet');
			ao.den=uicontrol('units','normalized','style','popupmenu','tag','metodowva','position',[0.1 0.28 0.12 0.05],'string','minimaxi|heursure|sqtwolog|rigrsure');
			ao.den_t=uicontrol('units','normalized','style','text','position',[0.23 0.28 0.18 0.05],'string','Threshold');
			ao.met=uicontrol('units','normalized','style','popupmenu','tag','wnwa','position',[0.1 0.22 0.1 0.05],'string','mln|sln|one');
			ao.met_t=uicontrol('units','normalized','style','text','position',[0.21 0.22 0.2 0.05],'string','Noise hyp.');
			ao.hhh=uicontrol('units','normalized','style','popupmenu','tag','waya','position',[0.1 0.16 0.1 0.05],'string','soft|hard');
			ao.hhh_t=uicontrol('units','normalized','style','text','position',[0.21 0.16 0.2 0.05],'string','Denoising type');
			ao.liv=uicontrol('units','normalized','style','edit','tag','maxa','position',[0.1 0.1 0.07 0.05],'string','5');
			ao.liv_t=uicontrol('units','normalized','style','text','position',[0.21 0.1 0.2 0.05],'string','Maximum level');
			%Phase column				
			ao.conv2=uicontrol('units','normalized','position',[0.8 0.8 0.1 0.05],...
			'style','edit','string','1','tag','convp');
			ao.conv2_t=uicontrol('units','normalized','position',[0.6 0.8 0.2 0.05],'style','text','string','Average point number');
			ao.fil=uicontrol('units','normalized','position',[0.6 0.72 0.15 0.05],'style','checkbox','string','Fourier Filter',...
			'tag','phfil');
			ao.filphi=uicontrol('units','normalized','position',[0.755 0.72 0.11 0.05],'style','checkbox','string','Pass',...
			'tag','phfilhi','callback','evalc(bp);');
			ao.filplow=uicontrol('units','normalized','position',[0.87 0.72 0.11 0.05],'style','checkbox','string','Stop',...
			'tag','phfillow','callback','evalc(cp);');
			ao.fil1p=uicontrol('units','normalized','position',[0.6 0.66 0.1 0.05],'style','edit','tag','fil1p','string','0.1');
			ao.fil1p_t=uicontrol('units','normalized','position',[0.71 0.66 0.2 0.05],'style','text','string','Left frequency corner');
			ao.fil2p=uicontrol('units','normalized','position',[0.6 0.6 0.1 0.05],'style','edit','tag','fil2p','string','0.9');
			ao.fil2p_t=uicontrol('units','normalized','position',[0.71 0.6 0.2 0.05],'style','text','string','Right frequency corner');
			ao.fil3p=uicontrol('units','normalized','position',[0.6 0.54 0.1 0.05],'style','edit','tag','fil3p','string','1');
			ao.fil3p_t=uicontrol('units','normalized','position',[0.71 0.54 0.2 0.05],'style','text','string','dB lost in pass-band');
			ao.fil4p=uicontrol('units','normalized','position',[0.6 0.48 0.1 0.05],'style','edit','tag','fil4p','string','20');
			ao.fil4p_t=uicontrol('units','normalized','position',[0.71 0.48 0.2 0.05],'style','text','string','dB lost in cut-band');
			%Denoise with wavelets
			ao.wav=uicontrol('units','normalized','position',[0.6 0.4 0.2 0.05],'style','checkbox','string','Wavelet denoising',...
			'tag','phden');
			ao.wte=uicontrol('units','normalized','style','edit','tag','tipowvtp','position',[0.6 0.34 0.1 0.05],'string','db3');
			ao.wte_t=uicontrol('units','normalized','style','text','position',[0.71 0.34 0.2 0.05],'string','Wavelet');
			ao.den=uicontrol('units','normalized','style','popupmenu','tag','metodowvp','position',[0.6 0.28 0.12 0.05],'string','minimaxi|heursure|sqtwolog|rigrsure');
			ao.den_t=uicontrol('units','normalized','style','text','position',[0.73 0.28 0.18 0.05],'string','Threshold');
			ao.met=uicontrol('units','normalized','style','popupmenu','tag','wnwp','position',[0.6 0.22 0.1 0.05],'string','mln|sln|one');
			ao.met_t=uicontrol('units','normalized','style','text','position',[0.71 0.22 0.2 0.05],'string','Noise hyp.');
			ao.hhh=uicontrol('units','normalized','style','popupmenu','tag','wayp','position',[0.6 0.16 0.1 0.05],'string','soft|hard');
			ao.hhh_t=uicontrol('units','normalized','style','text','position',[0.71 0.16 0.2 0.05],'string','Denoising type');
			ao.liv=uicontrol('units','normalized','style','edit','tag','maxp','position',[0.6 0.1 0.07 0.05],'string','5');
			ao.liv_t=uicontrol('units','normalized','style','text','position',[0.71 0.1 0.2 0.05],'string','Maximum level');
		else
			set(h,'name','Electron Cyclotron Emission - analysis options','numbertitle','off');
			b='set(ao.selx,''value'',0)';
			ba='set(ao.filalow,''value'',0)';
			ca='set(ao.filahi,''value'',0)';
			ao.allx=uicontrol('units','normalized','position',[0.33 0.94 0.15 0.05],'style','checkbox','string','All',...
			'callback','evalc(b);','tag','allriflx');
			c='set(ao.allx,''value'',0)';
			ao.selx=uicontrol('units','normalized','position',[0.52 0.94 0.15 0.05],'style','checkbox','string','Selected',...
			'callback','eval(c);seleziona1 prima','tag','selriflx');
			%Amplitude column
			ao.amp=uicontrol('units','normalized','position',[0.21 0.88 0.2	0.05],'style','checkbox',...
			'string','Amplitude','tag','amplitude');
			ao.conv1=uicontrol('units','normalized','position',[0.31 0.8 0.1 0.05],...
			'style','edit','string','1','tag','conva');
			ao.conv1_t=uicontrol('units','normalized','position',[0.1 0.8 0.2 0.05],'style','text','string','Average point number');
			ao.fil=uicontrol('units','normalized','position',[0.1 0.72 0.15 0.05],'style','checkbox','string','Fourier Filter',...
			'tag','ampfil');
			ao.filahi=uicontrol('units','normalized','position',[0.255 0.72 0.11 0.05],'style','checkbox','string','Pass',...
			'tag','ampfilhi','callback','evalc(ba);');
			ao.filalow=uicontrol('units','normalized','position',[0.37 0.72 0.11 0.05],'style','checkbox','string','Stop',...
			'tag','ampfillow','callback','evalc(ca);');
			ao.fil1a=uicontrol('units','normalized','position',[0.1 0.66 0.1 0.05],'style','edit','tag','fil1a','string','0.1');
			ao.fil1a_t=uicontrol('units','normalized','position',[0.21 0.66 0.2 0.05],'style','text','string','Left frequency corner');
			ao.fil2a=uicontrol('units','normalized','position',[0.1 0.6 0.1 0.05],'style','edit','tag','fil2a','string','0.9');
			ao.fil2a_t=uicontrol('units','normalized','position',[0.21 0.6 0.2 0.05],'style','text','string','Right frequency corner');
			ao.fil3a=uicontrol('units','normalized','position',[0.1 0.54 0.1 0.05],'style','edit','tag','fil3a','string','1');
			ao.fil3a_t=uicontrol('units','normalized','position',[0.21 0.54 0.2 0.05],'style','text','string','dB lost in pass-band');
			ao.fil4a=uicontrol('units','normalized','position',[0.1 0.48 0.1 0.05],'style','edit','tag','fil4a','string','20');
			ao.fil4a_t=uicontrol('units','normalized','position',[0.21 0.48 0.2 0.05],'style','text','string','dB lost in cut-band');
			%Denoise with wavelets
			ao.wav=uicontrol('units','normalized','position',[0.1 0.4 0.2 0.05],'style','checkbox','string','Wavelet denoising',...
			'tag','ampden');
			ao.wte=uicontrol('units','normalized','style','edit','tag','tipowvta','position',[0.1 0.34 0.1 0.05],'string','db3');
			ao.wte_t=uicontrol('units','normalized','style','text','position',[0.21 0.34 0.2 0.05],'string','Wavelet');
			ao.den=uicontrol('units','normalized','style','popupmenu','tag','metodowva','position',[0.1 0.28 0.12 0.05],'string','minimaxi|heursure|sqtwolog|rigrsure');
			ao.den_t=uicontrol('units','normalized','style','text','position',[0.23 0.28 0.18 0.05],'string','Threshold');
			ao.met=uicontrol('units','normalized','style','popupmenu','tag','wnwa','position',[0.1 0.22 0.1 0.05],'string','mln|sln|one');
			ao.met_t=uicontrol('units','normalized','style','text','position',[0.21 0.22 0.2 0.05],'string','Noise hyp.');
			ao.hhh=uicontrol('units','normalized','style','popupmenu','tag','waya','position',[0.1 0.16 0.1 0.05],'string','soft|hard');
			ao.hhh_t=uicontrol('units','normalized','style','text','position',[0.21 0.16 0.2 0.05],'string','Denoising type');
			ao.liv=uicontrol('units','normalized','style','edit','tag','maxa','position',[0.1 0.1 0.07 0.05],'string','5');
			ao.liv_t=uicontrol('units','normalized','style','text','position',[0.21 0.1 0.2 0.05],'string','Maximum level');
		end
		
		ao.ok=uicontrol('units','normalized','position',[0.45 0.02 0.1 0.05],'string','Ok','tag','OKRIFLX',...
		'callback','seleziona1 opzioni;close');
		
	case 'RIFLO'
	
		set(h,'name','O Reflectometer - analysis options','numbertitle','off');
		if tokamak==1
			b='set(ao.selo,''value'',0)';
			ba='set(ao.filalow,''value'',0)';
			bp='set(ao.filplow,''value'',0)';
			ao.allo=uicontrol('units','normalized','position',[0.33 0.94 0.15 0.05],'style','checkbox','string','All',...
			'callback','evalc(b);','tag','allriflo');
			c='set(ao.allo,''value'',0)';
			ca='set(ao.filahi,''value'',0)';
			cp='set(ao.filphi,''value'',0)';
			ao.selo=uicontrol('units','normalized','position',[0.52 0.94 0.15 0.05],'style','checkbox','string','Selected',...
			'callback','eval(c);seleziona1 prima','tag','selriflo');
			%Amplitude column
			ao.amp=uicontrol('units','normalized','position',[0.21 0.88 0.2 0.05],'style','checkbox',...
			'string','Amplitude','tag','amplitude');
			ao.ph=uicontrol('units','normalized','position',[0.6 0.88 0.2 0.05],'style','checkbox',...
			'string','Phase','tag','phase');
			ao.conv1=uicontrol('units','normalized','position',[0.31 0.8 0.1 0.05],...
			'style','edit','string','101','tag','conva');
			ao.conv1_t=uicontrol('units','normalized','position',[0.1 0.8 0.2 0.05],'style','text','string','Average point number');
			ao.fil=uicontrol('units','normalized','position',[0.1 0.72 0.15 0.05],'style','checkbox','string','Fourier Filter',...
			'tag','ampfil');
			ao.filahi=uicontrol('units','normalized','position',[0.255 0.72 0.11 0.05],'style','checkbox','string','Pass',...
			'tag','ampfilhi','callback','evalc(ba);');
			ao.filalow=uicontrol('units','normalized','position',[0.37 0.72 0.11 0.05],'style','checkbox','string','Stop',...
			'tag','ampfillow','callback','evalc(ca);');
			ao.fil1a=uicontrol('units','normalized','position',[0.1 0.66 0.1 0.05],'style','edit','tag','fil1a','string','0.1');
			ao.fil1a_t=uicontrol('units','normalized','position',[0.21 0.66 0.2 0.05],'style','text','string','Left frequency corner');
			ao.fil2a=uicontrol('units','normalized','position',[0.1 0.6 0.1 0.05],'style','edit','tag','fil2a','string','0.9');
			ao.fil2a_t=uicontrol('units','normalized','position',[0.21 0.6 0.2 0.05],'style','text','string','Right frequency corner');
			ao.fil3a=uicontrol('units','normalized','position',[0.1 0.54 0.1 0.05],'style','edit','tag','fil3a','string','1');
			ao.fil3a_t=uicontrol('units','normalized','position',[0.21 0.54 0.2 0.05],'style','text','string','dB lost in pass-band');
			ao.fil4a=uicontrol('units','normalized','position',[0.1 0.48 0.1 0.05],'style','edit','tag','fil4a','string','20');
			ao.fil4a_t=uicontrol('units','normalized','position',[0.21 0.48 0.2 0.05],'style','text','string','dB lost in cut-band');
			%Denoise with wavelets
			ao.wav=uicontrol('units','normalized','position',[0.1 0.4 0.2 0.05],'style','checkbox','string','Wavelet denoising',...
			'tag','ampden');
			ao.wte=uicontrol('units','normalized','style','edit','tag','tipowvta','position',[0.1 0.34 0.1 0.05],'string','db3');
			ao.wte_t=uicontrol('units','normalized','style','text','position',[0.21 0.34 0.2 0.05],'string','Wavelet');
			ao.den=uicontrol('units','normalized','style','popupmenu','tag','metodowva','position',[0.1 0.28 0.12 0.05],'string','minimaxi|heursure|sqtwolog|rigrsure');
			ao.den_t=uicontrol('units','normalized','style','text','position',[0.23 0.28 0.18 0.05],'string','Threshold');
			ao.met=uicontrol('units','normalized','style','popupmenu','tag','wnwa','position',[0.1 0.22 0.1 0.05],'string','mln|sln|one');
			ao.met_t=uicontrol('units','normalized','style','text','position',[0.21 0.22 0.2 0.05],'string','Noise hyp.');
			ao.hhh=uicontrol('units','normalized','style','popupmenu','tag','waya','position',[0.1 0.16 0.1 0.05],'string','soft|hard');
			ao.hhh_t=uicontrol('units','normalized','style','text','position',[0.21 0.16 0.2 0.05],'string','Denoising type');
			ao.liv=uicontrol('units','normalized','style','edit','tag','maxa','position',[0.1 0.1 0.07 0.05],'string','5');
			ao.liv_t=uicontrol('units','normalized','style','text','position',[0.21 0.1 0.2 0.05],'string','Maximum level');
			%Phase column				
			ao.conv2=uicontrol('units','normalized','position',[0.8 0.8 0.1 0.05],...
			'style','edit','string','1','tag','convp');
			ao.conv2_t=uicontrol('units','normalized','position',[0.6 0.8 0.2 0.05],'style','text','string','Average point number');
			ao.fil=uicontrol('units','normalized','position',[0.6 0.72 0.15 0.05],'style','checkbox','string','Fourier Filter',...
			'tag','phfil');
			ao.filphi=uicontrol('units','normalized','position',[0.715 0.72 0.11 0.05],'style','checkbox','string','Pass',...
			'tag','phfilhi','callback','evalc(bp);');
			ao.filplow=uicontrol('units','normalized','position',[0.83 0.72 0.11 0.05],'style','checkbox','string','Stop',...
			'tag','phfillow','callback','evalc(cp);');
			ao.fil1p=uicontrol('units','normalized','position',[0.6 0.66 0.1 0.05],'style','edit','tag','fil1p','string','0.1');
			ao.fil1p_t=uicontrol('units','normalized','position',[0.71 0.66 0.2 0.05],'style','text','string','Left frequency corner');
			ao.fil2p=uicontrol('units','normalized','position',[0.6 0.6 0.1 0.05],'style','edit','tag','fil2p','string','0.9');
			ao.fil2p_t=uicontrol('units','normalized','position',[0.71 0.6 0.2 0.05],'style','text','string','Right frequency corner');
			ao.fil3p=uicontrol('units','normalized','position',[0.6 0.54 0.1 0.05],'style','edit','tag','fil3p','string','1');
			ao.fil3p_t=uicontrol('units','normalized','position',[0.71 0.54 0.2 0.05],'style','text','string','dB lost in pass-band');
			ao.fil4p=uicontrol('units','normalized','position',[0.6 0.48 0.1 0.05],'style','edit','tag','fil4p','string','20');
			ao.fil4p_t=uicontrol('units','normalized','position',[0.71 0.48 0.2 0.05],'style','text','string','dB lost in cut-band');
			%Denoise with wavelets
			ao.wav=uicontrol('units','normalized','position',[0.6 0.4 0.2 0.05],'style','checkbox','string','Wavelet denoising',...
			'tag','phden');
			ao.wte=uicontrol('units','normalized','style','edit','tag','tipowvtp','position',[0.6 0.34 0.1 0.05],'string','db3');
			ao.wte_t=uicontrol('units','normalized','style','text','position',[0.71 0.34 0.2 0.05],'string','Wavelet');
			ao.den=uicontrol('units','normalized','style','popupmenu','tag','metodowvp','position',[0.6 0.28 0.12 0.05],'string','minimaxi|heursure|sqtwolog|rigrsure');
			ao.den_t=uicontrol('units','normalized','style','text','position',[0.73 0.28 0.18 0.05],'string','Threshold');
			ao.met=uicontrol('units','normalized','style','popupmenu','tag','wnwp','position',[0.6 0.22 0.1 0.05],'string','mln|sln|one');
			ao.met_t=uicontrol('units','normalized','style','text','position',[0.71 0.22 0.2 0.05],'string','Noise hyp.');
			ao.hhh=uicontrol('units','normalized','style','popupmenu','tag','wayp','position',[0.6 0.16 0.1 0.05],'string','soft|hard');
			ao.hhh_t=uicontrol('units','normalized','style','text','position',[0.71 0.16 0.2 0.05],'string','Denoising type');
			ao.liv=uicontrol('units','normalized','style','edit','tag','maxp','position',[0.6 0.1 0.07 0.05],'string','5');
			ao.liv_t=uicontrol('units','normalized','style','text','position',[0.71 0.1 0.2 0.05],'string','Maximum level');
		else
			b='set(ao.selo,''value'',0)';
			ba='set(ao.filalow,''value'',0)';
			ao.allo=uicontrol('units','normalized','position',[0.33 0.94 0.15 0.05],'style','checkbox','string','All',...
			'callback','evalc(b);','tag','allriflo');
			set(ao.allo,'value',1);
			c='set(ao.allo,''value'',0)';
			ca='set(ao.filahi,''value'',0)';
			ao.selo=uicontrol('units','normalized','position',[0.52 0.94 0.15 0.05],'style','checkbox','string','Selected',...
			'callback','eval(c);seleziona1 prima','tag','selriflo');
			%Amplitude column
			ao.amp=uicontrol('units','normalized','position',[0.21 0.88 0.2 0.05],'style','checkbox',...
			'string','Amplitude','tag','amplitude');
			set(ao.amp,'value',1);
			ao.conv1=uicontrol('units','normalized','position',[0.31 0.8 0.1 0.05],...
			'style','edit','string','1','tag','conva');
			ao.conv1_t=uicontrol('units','normalized','position',[0.1 0.8 0.2 0.05],'style','text','string','Average point number');
			ao.fil=uicontrol('units','normalized','position',[0.1 0.72 0.15 0.05],'style','checkbox','string','Fourier Filter',...
			'tag','ampfil');
			ao.filahi=uicontrol('units','normalized','position',[0.255 0.72 0.11 0.05],'style','checkbox','string','Pass',...
			'tag','ampfilhi','callback','evalc(ba);');
			ao.filalow=uicontrol('units','normalized','position',[0.37 0.72 0.11 0.05],'style','checkbox','string','Stop',...
			'tag','ampfillow','callback','evalc(ca);');
			ao.fil1a=uicontrol('units','normalized','position',[0.1 0.66 0.1 0.05],'style','edit','tag','fil1a','string','0.1');
			ao.fil1a_t=uicontrol('units','normalized','position',[0.21 0.66 0.2 0.05],'style','text','string','Left frequency corner');
			ao.fil2a=uicontrol('units','normalized','position',[0.1 0.6 0.1 0.05],'style','edit','tag','fil2a','string','0.9');
			ao.fil2a_t=uicontrol('units','normalized','position',[0.21 0.6 0.2 0.05],'style','text','string','Right frequency corner');
			ao.fil3a=uicontrol('units','normalized','position',[0.1 0.54 0.1 0.05],'style','edit','tag','fil3a','string','1');
			ao.fil3a_t=uicontrol('units','normalized','position',[0.21 0.54 0.2 0.05],'style','text','string','dB lost in pass-band');
			ao.fil4a=uicontrol('units','normalized','position',[0.1 0.48 0.1 0.05],'style','edit','tag','fil4a','string','20');
			ao.fil4a_t=uicontrol('units','normalized','position',[0.21 0.48 0.2 0.05],'style','text','string','dB lost in cut-band');
			%Denoise with wavelets
			ao.wav=uicontrol('units','normalized','position',[0.1 0.4 0.2 0.05],'style','checkbox','string','Wavelet denoising',...
			'tag','ampden');
			ao.wte=uicontrol('units','normalized','style','edit','tag','tipowvta','position',[0.1 0.34 0.1 0.05],'string','db3');
			ao.wte_t=uicontrol('units','normalized','style','text','position',[0.21 0.34 0.2 0.05],'string','Wavelet');
			ao.den=uicontrol('units','normalized','style','popupmenu','tag','metodowva','position',[0.1 0.28 0.12 0.05],'string','minimaxi|heursure|sqtwolog|rigrsure');
			ao.den_t=uicontrol('units','normalized','style','text','position',[0.23 0.28 0.18 0.05],'string','Threshold');
			ao.met=uicontrol('units','normalized','style','popupmenu','tag','wnwa','position',[0.1 0.22 0.1 0.05],'string','mln|sln|one');
			ao.met_t=uicontrol('units','normalized','style','text','position',[0.21 0.22 0.2 0.05],'string','Noise hyp.');
			ao.hhh=uicontrol('units','normalized','style','popupmenu','tag','waya','position',[0.1 0.16 0.1 0.05],'string','soft|hard');
			ao.hhh_t=uicontrol('units','normalized','style','text','position',[0.21 0.16 0.2 0.05],'string','Denoising type');
			ao.liv=uicontrol('units','normalized','style','edit','tag','maxa','position',[0.1 0.1 0.07 0.05],'string','5');
			ao.liv_t=uicontrol('units','normalized','style','text','position',[0.21 0.1 0.2 0.05],'string','Maximum level');
		end
		
		ao.ok=uicontrol('units','normalized','position',[0.45 0.02 0.1 0.05],'string','Ok','tag','OKRIFLO',...
		'callback','seleziona1 opzioni;close');
	
	case 'MAGN'
	
		set(h,'name','Magnetics - analysis options','numbertitle','off');
		b='set(ao.selm,''value'',0)';
		ba='set(ao.filalow,''value'',0)';
		ao.allm=uicontrol('units','normalized','position',[0.33 0.94 0.15 0.05],'style','checkbox','string','All',...
		'callback','evalc(b);','tag','allmagn');
		c='set(ao.allm,''value'',0)';
		ca='set(ao.filahi,''value'',0)';
		ao.selm=uicontrol('units','normalized','position',[0.52 0.94 0.15 0.05],'style','checkbox','string','Selected',...
		'callback','eval(c);seleziona1 prima','tag','selmagn');
		%Analysis options
		ao.conv2=uicontrol('units','normalized','position',[0.55 0.8 0.1 0.05],...
		'style','edit','string','1','tag','convm');
		ao.conv2_t=uicontrol('units','normalized','position',[0.35 0.8 0.2 0.05],'style','text','string','Average point number');
		ao.fil=uicontrol('units','normalized','position',[0.35 0.72 0.15 0.05],'style','checkbox','string','Fourier Filter',...
		'tag','mfil');
		ao.filahi=uicontrol('units','normalized','position',[0.505 0.72 0.11 0.05],'style','checkbox','string','Pass',...
			'tag','mfilhi','callback','evalc(ba);');
		ao.filalow=uicontrol('units','normalized','position',[0.62 0.72 0.11 0.05],'style','checkbox','string','Stop',...
			'tag','mfillow','callback','evalc(ca);');
		ao.fil1p=uicontrol('units','normalized','position',[0.35 0.66 0.1 0.05],'style','edit','tag','fil1m','string','0.1');
		ao.fil1p_t=uicontrol('units','normalized','position',[0.46 0.66 0.2 0.05],'style','text','string','Left frequency corner');
		ao.fil2p=uicontrol('units','normalized','position',[0.35 0.6 0.1 0.05],'style','edit','tag','fil2m','string','0.9');
		ao.fil2p_t=uicontrol('units','normalized','position',[0.46 0.6 0.2 0.05],'style','text','string','Right frequency corner');
		ao.fil3p=uicontrol('units','normalized','position',[0.35 0.54 0.1 0.05],'style','edit','tag','fil3m','string','1');
		ao.fil3p_t=uicontrol('units','normalized','position',[0.46 0.54 0.2 0.05],'style','text','string','dB lost in pass-band');
		ao.fil4p=uicontrol('units','normalized','position',[0.35 0.48 0.1 0.05],'style','edit','tag','fil4m','string','20');
		ao.fil4p_t=uicontrol('units','normalized','position',[0.46 0.48 0.2 0.05],'style','text','string','dB lost in cut-band');
		%Denoise with wavelets
		ao.wav=uicontrol('units','normalized','position',[0.35 0.4 0.2 0.05],'style','checkbox','string','Wavelet denoising',...
		'tag','mden');
		ao.wte=uicontrol('units','normalized','style','edit','tag','tipowvtm','position',[0.35 0.34 0.1 0.05],'string','db3');
		ao.wte_t=uicontrol('units','normalized','style','text','position',[0.46 0.34 0.2 0.05],'string','Wavelet');
		ao.den=uicontrol('units','normalized','style','popupmenu','tag','metodowvm','position',[0.35 0.28 0.12 0.05],'string','minimaxi|heursure|sqtwolog|rigrsure');
		ao.den_t=uicontrol('units','normalized','style','text','position',[0.48 0.28 0.18 0.05],'string','Threshold');
		ao.met=uicontrol('units','normalized','style','popupmenu','tag','wnwm','position',[0.35 0.22 0.1 0.05],'string','mln|sln|one');
		ao.met_t=uicontrol('units','normalized','style','text','position',[0.46 0.22 0.2 0.05],'string','Noise hyp.');
		ao.hhh=uicontrol('units','normalized','style','popupmenu','tag','waym','position',[0.35 0.16 0.1 0.05],'string','soft|hard');
		ao.hhh_t=uicontrol('units','normalized','style','text','position',[0.46 0.16 0.2 0.05],'string','Denoising type');
		ao.liv=uicontrol('units','normalized','style','edit','tag','maxm','position',[0.35 0.1 0.07 0.05],'string','5');
		ao.liv_t=uicontrol('units','normalized','style','text','position',[0.46 0.1 0.2 0.05],'string','Maximum level');
		
		ao.ok=uicontrol('units','normalized','position',[0.45 0.02 0.1 0.05],'string','Ok','tag','OKMAGN',...
		'callback','seleziona1 opzioni;close');
		
end
