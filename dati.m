function dati

global D R N C O scarica tmin tmax;

salva=get(findobj(gcbf,'tag','salva','style','checkbox'),'value');
tokamak=get(findobj(gcbf,'style','popupmenu','tag','tokamak'),'value');
if salva
   disp('Saving data file...');
   if tokamak==2
      if exist('C')
         save(sprintf('turbo_%d',scarica),'D','R','C');
      else
         save(sprintf('turbo_%d',scarica),'D','R');
      end
   else
      save(sprintf('turbo_%d',scarica),'D','R');
   end
   disp(sprintf('data saved as turbo_%d',scarica));
end

if tokamak==2
   for i=1:length(D)
      if O(i).analisi_diag==1;
         i1=find(D(i).t>tmin,1,'first');
         i2=find(D(i).t<tmax,1,'last');
         if O(i).all
	    D(i).rm=D(i).r(i1:i2,:)-ones(i2-i1+1,1)*mean(D(i).r(i1:i2,:));
	    if or(D(i).nome=='riflx',D(i).nome=='riflo')
	       O(i).analizza=ones(1,D(i).ncan/2);
	       can=[1:D(i).ncan/2];
	    else
	       O(i).analizza=ones(1,D(i).ncan);
	       can=[1:D(i).ncan];
	    end
	 else
	    can=find(O(i).analizza);
	    cano=[];
	    for j=1:length(can)
	       cano=[cano 2*can(j)-1 2*can(j)];
	    end
	    D(i).rm=D(i).r(i1:i2,cano)-ones(i2-i1+1,1)*mean(D(i).r(i1:i2,cano));
	 end
	 if O(i).amp==1
	    D(i).rms=[];
	    D(i).rms1=[];%Due to the convolution, otherwise it gives error due to different number of lines
	    %The following if is 'cause reflectometer calculates rms^2=sin^2+cos^2 others do not, so they are taken as they are
            if or(D(i).nome=='riflx',D(i).nome=='riflo')
	       for h=1:size(D(i).rm,2)/2;
                  D(i).rms=[D(i).rms D(i).rm(:,2*h-1).^2+D(i).rm(:,2*h).^2];
               end
	    else
	       D(i).rms=D(i).rm;
	    end
            if O(i).ampwvl			
	       switch O(i).wvl2a
    	          case 1
        	     a1='minimaxi';
    		  case 2
        	     a1='heursure';
    		  case 3
        	     a1='sqtwolog';
    		  case 4
        	     a1='rigrsure';
	       end
	       if O(i).wvl4a==1
    	          a2='s';
	       else
    	          a2='h';
	       end
	       switch O(i).wvl3a
    	          case 1
        	     a3='mln';
    		  case 2
        	     a3='sln';
    		  case 3
        	     a3='one';
	       end
	       b5=max(O(i).wvl5a,0);
	       pt=max(i2-i1+1,1);
               nw=wmaxlev(pt,O(i).wvl1a)-b5;
               nw=max(1,nw);
               for k=1:size(D(i).rms,2)
                  D(i).rms(:,k)=wden(D(i).rms(:,k),a1,a2,a3,nw,O(i).wvl1a);            	
               end
	    end
	    if O(i).ampfil
	       [n,wn]=buttord(O(i).fil1a,O(i).fil2a,O(i).fil3a,O(i).fil4a);
	       if length(wn)==1,
	          [b,a]=butter(n,wn);
	       elseif O(i).ampfilhi
	          [b,a]=butter(n,wn,'high');
	       elseif O(i).ampfillow
	          [b,a]=butter(n,wn,'stop');
	       end
	    D(i).rms=filter(b,a,D(i).rms);
	    end
	    %convolving with hanning(or similar) windows should improve spectral estimates by decreasing spectral leakage 
	    if O(i).conva>1
	       for k=1:size(D(i).rms,2)
	          h=conv(hann(O(i).conva),D(i).rms(:,k))/(sum(hann(O(i).conva)));
		  %D(i).rms1=[D(i).rms1 h(O(i).conva:end-O(i).conva+1)];
	          D(i).rms1=[D(i).rms1 h(O(i).conva:end)];
	       end
	       D(i).rms=D(i).rms1;
	       clear D(i).rms1;
	    end
            D(i).rms=sqrt(D(i).rms);
         end
         if O(i).phase==1
            D(i).ph1=[];%Convolution stuff, see above
            D(i).ph=[];
            for h=1:size(D(i).rm,2)/2;
               D(i).ph=[D(i).ph complex(D(i).rm(:,2*h-1),D(i).rm(:,2*h))];
            end
	    D(i).ph=unwrap(angle(D(i).ph));
            if O(i).phwvl			
	       switch O(i).wvl2p
    	          case 1
                     a1='minimaxi';
    	          case 2
                     a1='heursure';
    	          case 3
        	     a1='sqtwolog';
    	          case 4
        	     a1='rigrsure';
	       end
	       if O(i).wvl4p==1
    	          a2='s';
	       else
    	          a2='h';
	       end
	       switch O(i).wvl3p
    	          case 1
                     a3='mln';
    	          case 2
                     a3='sln';
    	          case 3
                     a3='one';
	       end
	       b5=max(O(i).wvl5p,0);
	       pt=max(i2-i1+1,1);
               nw=wmaxlev(pt,O(i).wvl1p)-b5;
               nw=max(1,nw);
               for k=1:size(D(i).ph,2)
                  D(i).ph(:,k)=wden(D(i).ph(:,k),a1,a2,a3,nw,O(i).wvl1p);            	
               end 
	    end
	    if O(i).phfil
	       [n,wn]=buttord(O(i).fil1p,O(i).fil2p,O(i).fil3p,O(i).fil4p);
	       if length(wn)==1
	          [b,a]=butter(n,wn);
	       elseif O(i).phfilhi
	          [b,a]=butter(n,wn,'high');
	       elseif O(i).phfillow
	          [b,a]=butter(n,wn,'stop');
	       end
	       D(i).ph=filter(b,a,D(i).ph);
	    end
	    %convolving with hanning(or similar) windows should improve spectral estimates by decreasing spectral leakage 
            if O(i).convp>1
	       for k=1:size(D(i).ph,2)
	          h=conv(hann(O(i).convp),D(i).ph(:,k))/(sum(hann(O(i).convp)));
                  %D(i).ph1=[D(i).ph1 h(O(i).convp:end-O(i).convp+1)];
	          D(i).ph1=[D(i).ph1 h(O(i).convp:end)];
	       end
	       D(i).ph=D(i).ph1;
               clear D(i).ph1;
            end
         end						
         aaa=findobj(gcbf,'style','checkbox','tag',strcat(char(D(i).nome),'rms'));
         bbb=findobj(gcbf,'style','checkbox','tag',strcat(char(D(i).nome),'ph'));
         delete(aaa,bbb);
         j=0;
         if O(i).amp
            for j=1:length(can)
               uicontrol('units','normalized','style','checkbox','position',...
	          [0.01+0.13*(i-1) 0.72-0.04*j 0.12 0.04],'tag',strcat(char(D(i).nome),'rms'),'string',char(D(i).srms(can(j))));
            end
         end
         if O(i).phase
            for k=1:length(can)
               uicontrol('units','normalized','style','checkbox','position',[0.01+0.13*(i-1) 0.72-0.04*(k+j) 0.12 0.04],...
  		 'tag',strcat(char(D(i).nome),'ph'),'string',char(D(i).sph(can(k))));
            end
         end
      end
   end
else
   for i=1:length(D)
      if O(i).analisi_diag==1;
         i1=find(D(i).t>tmin,1,'first');
         i2=find(D(i).t<tmax,1,'last');
	 if O(i).all
	    D(i).rm=D(i).r(i1:i2,:)-ones(i2-i1+1,1)*mean(D(i).r(i1:i2,:));
	    O(i).analizza=ones(1,D(i).ncan);
	    can=[1:D(i).ncan];
         else
	    can=find(O(i).analizza);
	    cano=[];
	    for j=1:length(can)
	       cano=[cano can(j)];
	    end
	    D(i).rm=D(i).r(i1:i2,cano)-ones(i2-i1+1,1)*mean(D(i).r(i1:i2,cano));
	 end
         if O(i).amp==1
	    D(i).rms=[];
	    D(i).rms1=[];%Due to the convolution, otherwise it gives error due to different number of lines
			%The following if is 'cause reflectometer calculates rms^2=sin^2+cos^2 others do not, so they are taken as they are
            D(i).rms=D(i).rm;
	    if O(i).ampwvl			
	       switch O(i).wvl2a
    	          case 1
        	     a1='minimaxi';
    		  case 2
        	     a1='heursure';
    		  case 3
        	     a1='sqtwolog';
    		  case 4
                     a1='rigrsure';
	       end
	       if O(i).wvl4a==1
    	          a2='s';
	       else
    	          a2='h';
	       end
	       switch O(i).wvl3a
    	          case 1
        	     a3='mln';
    		  case 2
        	     a3='sln';
    		  case 3
        	     a3='one';
	       end
	       b5=max(O(i).wvl5a,0);
	       pt=max(i2-i1+1,1);
               nw=wmaxlev(pt,O(i).wvl1a)-b5;
               nw=max(1,nw);
               for k=1:size(D(i).rms,2)
                  D(i).rms(:,k)=wden(D(i).rms(:,k),a1,a2,a3,nw,O(i).wvl1a);            	
               end
	    end
	    if O(i).ampfil
	       [n,wn]=buttord(O(i).fil1a,O(i).fil2a,O(i).fil3a,O(i).fil4a);
	       if length(wn)==1,
	          [b,a]=butter(n,wn);
	       elseif O(i).ampfilhi
	          [b,a]=butter(n,wn,'high');
	       elseif O(i).ampfillow
	          [b,a]=butter(n,wn,'stop');
	       end
	       D(i).rms=filter(b,a,D(i).rms);
	    end
	%convolving with hanning(or similar) windows should improve spectral estimates by decreasing spectral leakage 
	    if O(i).conva>1
	       for k=1:size(D(i).rms,2)
	          h=conv(hann(O(i).conva),D(i).rms(:,k))/(sum(hann(O(i).conva)));
		%D(i).rms1=[D(i).rms1 h(O(i).conva:end-O(i).conva+1)];
		  D(i).rms1=[D(i).rms1 h(O(i).conva:end)];
	       end
	       D(i).rms=D(i).rms1;
	       clear D(i).rms1;
	    end
    	 end				
	 aaa=findobj(gcbf,'style','checkbox','tag',strcat(char(D(i).nome),'rms'));
         bbb=findobj(gcbf,'style','checkbox','tag',strcat(char(D(i).nome),'ph'));
         delete(aaa,bbb);
	 j=0;
	 if O(i).amp
            for j=1:length(can)
               uicontrol('units','normalized','style','checkbox','position',...
		  [0.01+0.13*(i-1) 0.72-0.04*j 0.12 0.04],'tag',strcat(char(D(i).nome),'rms'),'string',char(D(i).srms(can(j))),'value',1);
	    end
         end
      end
   end
end
dat.fin_t=uicontrol('units','normalized','style','text','position',[0.5 0.73 0.2 0.05],...
'string','Anti-leackage window');
dat.fin=uicontrol('units','normalized','style','listbox','tag','finestra','position',...
[0.5 0.64 0.2 0.1],'string','None|Tuckey-Hanning|Tuckey-Hamming|General Tukey|Parzen|Gaussian|Chebytcheff'); 
set(dat.fin,'value',2);
dat.dati_t=uicontrol('units','normalized','style','text','position',...
[0.2 0.74 0.2 0.04],'string','Loaded channels');
dat.dt_t=uicontrol('units','normalized','style','text','position',[0.5 0.57 0.2 0.06],...
'string','Polynomial degree for data detrend');
dat.dt=uicontrol('units','normalized','style','listbox','tag','detrend','position',...
[0.55 0.49 0.1 0.08],'string','none|0|1|2|3|4');
set(dat.dt,'value',3);
dat.spg=uicontrol('units','normalized','position',[0.75 0.7 0.2 0.05],...
'string','Spectrogram','callback','analisi spetgram');
dat.sp=uicontrol('units','normalized','position',[0.75 0.64 0.2 0.05],...
'string','Spectrum','callback','analisi spet');
dat.ac=uicontrol('units','normalized','position',[0.75 0.58 0.2 0.05],...
'string','Auto correlation','callback','analisi auto');
dat.cc=uicontrol('units','normalized','position',[0.75 0.52 0.2 0.05],...
'string','Cross correlation','callback','analisi cross');
dat.co=uicontrol('units','normalized','position',[0.75 0.46 0.2 0.05],...
'string','Coherence','callback','analisi coer');
dat.co=uicontrol('units','normalized','position',[0.75 0.4 0.2 0.05],...
'string','Coherencegram','callback','analisi coergram');
dat.wl=uicontrol('units','normalized','position',[0.75 0.34 0.2 0.05],...
'string','Wavelet','callback','analisi wavelet');
dat.hi=uicontrol('units','normalized','position',[0.75 0.28 0.2 0.05],...
'string','Hilbert');
dat.cs=uicontrol('units','normalized','position',[0.75 0.22 0.2 0.05],...
'string','Cross spectrum','callback','analisi crossspet');
dat.pl=uicontrol('units','normalized','position',[0.75 0.16 0.2 0.05],...
'string','Plot','callback','plotb plot');
dat.abc=uicontrol('units','normalized','position',[0.75 0.1 0.2 0.05],...
'string','Auto Bicoherence','callback','analisi autobi');
dat.cbc=uicontrol('units','normalized','position',[0.75 0.04 0.2 0.05],...
'string','Cross Bicoherence','callback','analisi crossbi');
dat.sc=uicontrol('units','normalized','style','checkbox','position',[0.5 0.19 0.2 0.05],...
'string','Coherent ELMs','callback','somcoelms');
dat.sc=uicontrol('units','normalized','style','checkbox','position',...
[0.5 0.24 0.1 0.05],'string','Force C^0','tag','ForceC^0');
dat.coerelm=uicontrol('units','normalized','style','checkbox','position',...
[0.6 0.24 0.1 0.05],'string','Coherelm','tag','Coherelm');
dat.inc=uicontrol('units','normalized','style','checkbox','position',...
[0.5 0.14 0.2 0.05],'string','Cross diagnostics');
dat.ok=uicontrol('units','normalized','string','Manipulate','position',...
[0.5 0.02 0.2 0.05],'callback','detr_fin');
dat.vel=uicontrol('units','normalized','style','checkbox','tag','velocita','position',...
[0.5 0.09 0.2 0.05],'string','Speed up FFT');
dat.ps=uicontrol('units','normalized','style','edit','tag','puntispetgram','position',...
[0.5 0.40 0.09 0.05],'string','2048');
dat.os=uicontrol('units','normalized','style','edit','tag','spetgramoverlap','position',...
[0.6 0.40 0.1 0.05],'string','50');
dat.ps_t=uicontrol('units','normalized','style','text','string','FFT points','position',...
[0.5 0.45 0.09 0.03]);
dat.os_t=uicontrol('units','normalized','style','text','string','FFT Overlap %',...
'position',[0.6 0.45 0.1 0.03]);
dat.gram=uicontrol('units','normalized','style','edit','tag','gramdt','position',...
[0.5 0.29 0.09 0.05],'string','4096');
dat.gram_t=uicontrol('units','normalized','style','text','string','Coherencegram pts.',...
'position',[0.5 0.34 0.09 0.05]);
dat.gram1=uicontrol('units','normalized','style','edit','tag','gramov','position',...
[0.6 0.29 0.1 0.05],'string','50');
dat.gram1_t=uicontrol('units','normalized','style','text','string','Gram overlap %',...
'position',[0.6 0.34 0.1 0.05]);

%dat.h=uibuttongroup('visible','on','position',[0 0 .2 1]);
%dat.h_t=uicontrol('style','text','position',[180 110 90 20],'string','Reference signal');
%for i=1:length(R)
%    uicontrol('style','radiobutton','string',char(R(i).nome),'position',[200 110-20*i 50 20],'parent',h);
%end
