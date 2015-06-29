function plotb(cosa)

global D R A O scarica valuta;

tokamak=get(findobj(0,'style','popupmenu','tag','tokamak'),'value');
if tokamak==1
	NAME='JET';
else
	NAME='TCV';
end
switch cosa
    
    case 'spetgram'
        h=round(get(gcbo,'value'));
		set(gcbo,'value',h);
        DATI=get(gcbo,'userdata');
        h=h+1;
        %i1=find(R.ta>DATI.t(1),1,'first');%version Matlab 7.0
        %i2=find(R.ta<DATI.t(end),1,'last');%version Matlab 7.0
		i1=iround(R.ta,DATI.t(1));%version Matlab 6.5
        i2=iround(R.ta,DATI.t(end));%version Matlab 6.5
		if i2>i1
        	subplot(311),plot(R.ta(i1:i2),R.a(i1:i2));
			set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
        	title(strcat(sprintf(strcat([NAME,' %d'])',scarica),', D-alpha'));
		else
			disp('The reference signal does not overlap with the selected time window, we do not plot it')
		end
        subplot(312),imagesc(DATI.t,DATI.fre,20*log10(abs(DATI.mod(h).mod)));
        title(strcat(sprintf(strcat(['Spectrogram',' ',NAME,' %d,'])',scarica),',',DATI.nomi(h)));
        colorbar('horiz');
		subplot(313),plot(DATI.t,DATI.mod(h).mfreq,DATI.t,DATI.mod(h).sqfreq);
		lelegend('Mean','Std')
		set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
		title('Frequency, center of mass')
		
	case 'coergram'
        h=round(get(gcbo,'value'));
		set(gcbo,'value',h);
        DATI=get(gcbo,'userdata');
        h=h+1;
        %i1=find(R.ta>DATI.t(1),1,'first');%version Matlab 7.0
        %i2=find(R.ta<DATI.t(end),1,'last');%version Matlab 7.0
		i1=iround(R.ta,DATI.t(1));%version Matlab 6.5
        i2=iround(R.ta,DATI.t(end));%version Matlab 6.5
		if i2>i1
        	subplot(2,1,1),plot(R.ta(i1:i2),R.a(i1:i2));
			set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
        	title(strcat(sprintf(strcat([NAME,' %d'])',scarica),', D-alpha'));
		else
			disp('The reference signal does not overlap with the selected time window, we do not plot it')
		end
        subplot(2,1,2),imagesc(DATI.t,DATI.fre,DATI.cc(h).cc);
        title(strcat(sprintf(strcat(['Coherencegram',' ',NAME,' %d,'])',scarica),',',DATI.nominc(h)));
        colorbar('horiz');	
            
    case 'spet'
        h=round(get(gcbo,'value'));
		set(gcbo,'value',h);
        DATI=get(gcbo,'userdata');
        h=h+1;
        DATI.n=h;
        loglog(DATI.fre,DATI.mod(:,h),DATI.fre,DATI.mod(:,h)*sqrt(11/9/DATI.N),'r');
        title(strcat(sprintf(strcat(['Spectrum',' ',NAME,' %d,'])',scarica),',',DATI.nomi(h)));
        kk=uicontrol('string','Spectral index','position',[400 395 90 20],'callback','indice multipli','userdata',DATI);
           
    case 'auto'
        h=round(get(gcbo,'value'));
		set(gcbo,'value',h);
        DATI=get(gcbo,'userdata');
        h=h+1;
        c=length(DATI.x);
        plot(DATI.x,DATI.ccf(1:c,h));
        title(strcat(sprintf(strcat(['Un-biased autocorrelation',' ',NAME,' %d,'])',scarica),',',DATI.nomi(h)));
            
    case 'cross'
        h=round(get(gcbo,'value'));
		set(gcbo,'value',h);
        DATI=get(gcbo,'userdata');
        h=h+1;
        plot(DATI.tt,DATI.cc(:,h));
        title(strcat(sprintf(strcat(['Cross correlation coefficient',' ',NAME,' %d,'])',scarica),',',DATI.nominc(h)));
    
    case 'coer'
        h=round(get(gcbo,'value'));
		set(gcbo,'value',h);
        DATI=get(gcbo,'userdata');
        h=h+1;
       	plot(DATI.fre,DATI.cc(:,h),...
		DATI.fre,(1-DATI.cc(:,h)).^2/DATI.N,'r');
        title(strcat(sprintf(strcat(['Coherence',' ',NAME,' %d,'])',scarica),',',DATI.nominc(h)));
        
    case 'crosspet'
        h=round(get(gcbo,'value'));
		set(gcbo,'value',h);
        DATI=get(gcbo,'userdata');
        h=h+1;
        plot(DATI.fre,DATI.cc(:,h),'b',DATI.fre,DATI.ph(:,h),'r');
        title(strcat(sprintf(strcat(['Cross spectrum',' ',NAME,' %d,'])',scarica),',',DATI.nominc(h)));
            
    case 'plot'
        for h=1:length(D)
            if and(valuta(h),O(h).analisi_diag)
                figure;
                n=size(D(h).M,2);
                %i1=find(R.ta>D(h).MT(1),1,'first');%version Matlab 7.0
                %i2=find(R.ta<D(h).MT(end),1,'last');%version Matlab 7.0
				i1=iround(R.ta,D(h).MT(1));%version Matlab 6.5
                i2=iround(R.ta,D(h).MT(end));%version Matlab 6.5
                if i2>i1
					subplot(n+1,1,1),plot(R.ta(i1:i2),R.a(i1:i2));
					set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
                	title(strcat(sprintf(strcat([NAME,' %d'])',scarica),', D-alpha'));
				else
					disp('The reference signal does not overlap with the selected time window, we do not plot it')
				end
                for i=1:n
                    subplot(n+1,1,i+1),plot(D(h).MT,D(h).M(:,i));
					if i2>i1
						set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
					end
                    title(strcat(sprintf(strcat([NAME,' ','%d']),scarica),',',A(h).nomi(i)));
                end
            end
        end    
        
    case 'bicoer'
        h=round(get(gcbo,'value'));
		set(gcbo,'value',h);
        DATI=get(gcbo,'userdata');
        h=h+1;
        mesh(DATI.fre2,DATI.fre1,DATI.bico(h).co);
        title(strcat(sprintf(strcat(['Bicoherence',' ',NAME,' %d,'])',scarica),',',DATI.nominc(h)));
        
    case 'cwt'
        h=round(get(gcbo,'value'));
		set(gcbo,'value',h);
        DATI=get(gcbo,'userdata');
        h=h+1;
        for i=1:length(D)
            if and(valuta(i),O(i).analisi_diag)
                sc=size(DATI.cwt(h).cc,1);
                %i1=find(R.ta>D(i).MT(1),1,'first');%version Matlab 7.0
                %i2=find(R.ta<D(i).MT(end),1,'last');%version Matlab 7.0
                i1=iround(R.ta,D(i).MT(1));%version Matlab 6.5
                i2=iround(R.ta,D(i).MT(end));%version Matlab 6.5
				if i2>i1
					subplot(2,1,1),plot(R.ta(i1:i2),R.a(i1:i2));
					set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
                	title(strcat(sprintf(strcat([NAME,' %d'])',scarica),', D-alpha'));
				else
					disp('The reference signal does not overlap with the selected time window, we do not plot it')
				end
                subplot(2,1,2),imagesc(DATI.t,1:sc,DATI.cwt(h).cc);
				colorbar('horiz');
                title(strcat(sprintf(strcat(['CWT',' ',NAME,' %d,'])',scarica),',',DATI.nomi(h)));
            end
        end
                        
end        
