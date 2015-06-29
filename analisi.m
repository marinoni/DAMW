function analisi(cosa)

global D A R O valuta scarica;

tokamak=get(findobj(0,'style','popupmenu','tag','tokamak'),'value');
if iscell(tokamak)
	tokamak=cell2mat(tokamak(1));
end
if tokamak==1
	NAME='JET';
else
	NAME='TCV';
end
incrocia=get(findobj(gcbf,'string','Cross diagnostics'),'value');
if iscell(incrocia)
    incrocia=cell2mat(incrocia(1));
end
fin=get(findobj(gcbf,'style','listbox','tag','finestra'),'value');
if iscell(fin)
    fin=cell2mat(fin(1));
end
vel=get(findobj(gcbf,'style','checkbox','tag','velocita'),'value');
if iscell(vel)
    vel=cell2mat(vel(1));
end
ps=get(findobj(gcbf,'style','edit','tag','puntispetgram'),'string');
if iscell(ps)
    ps=cell2mat(ps(1));
end
ps=str2num(ps);
ps=max(256,ps);
ov=get(findobj(gcbf,'style','edit','tag','spetgramoverlap'),'string');
if iscell(ov)
    ov=cell2mat(ov(1));
end
ov=str2num(ov)/100;
if ov<0
    ov=0;
end
ov=round(ov*ps);
psgram=get(findobj(gcbf,'style','edit','tag','gramdt'),'string');
if iscell(psgram)
    psgram=cell2mat(psgram(1));
end
psgram=str2num(psgram);
ovgram=get(findobj(gcbf,'style','edit','tag','gramov'),'string');
if iscell(ovgram)
    ovgram=cell2mat(ovgram(1));
end
ovgram=str2num(ovgram)/100;
if ovgram<0
    ovgram=0;
end
ovgram=round(ovgram*psgram);
a=[];
if vel
	ps=arrotonda(ps);
end
switch fin
	case 1
    	a=rectwin(ps);
    case 2
    	a=hanning(ps);
    case 3
    	a=hamming(ps);
    case 4
    	a=tukeywin(ps);
    case 5
        a=parzenwin(ps);
    case 6
        a=gausswin(ps);
    case 7
         a=chebwin(ps);
end
switch cosa
    
    case 'spetgram'
        
        for i=1:length(D)
            if and(valuta(i),O(i).analisi_diag)
                A(i).mod=[];
                for j=1:size(D(i).M,2)
                    [A(i).mod(j).mod,A(i).fre,A(i).t]=specgram(D(i).M(:,j),ps,1/D(i).dt,a,ov);
                    A(i).t=A(i).t+D(i).MT(1);
					A(i).mod(j).mfreq=abs(A(i).mod(j).mod)'*A(i).fre./sum(abs(A(i).mod(j).mod))';
					A(i).mod(j).sqfreq=abs(A(i).mod(j).mod)'*(A(i).fre.^2)./sum(abs(A(i).mod(j).mod))';
					A(i).mod(j).sqfreq=sqrt(A(i).mod(j).sqfreq-A(i).mod(j).mfreq.^2);
                    %A(i).ncol=fix((A(i).punti-ov)/(ps-ov));
				end
				scr=get(0,'screensize');
				scrsize=0.8;
				f(1)=scr(1)+scr(3)*(1-scrsize)/2;
				f(2)=scr(2)+scr(4)*(1-scrsize)/2;
				f(3)=scr(3)*scrsize;
				f(4)=scr(4)*scrsize;
				figure('position',[f(1) f(2) f(3) f(4)]);
				set(gca,'fontsize',15)
				set(gca,'fontname','times')
                if D(i).n2x>1                   
					uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],...
					'min',0,'max',D(i).n2x-1,'sliderstep',[1/(D(i).n2x-1) 1/(D(i).n2x-1)],'callback','plotb spetgram','userdata',A(i));
                else
                    i1=find(R.ta>D(i).MT(1),1,'first');%version Matlab 7.0
                    i2=find(R.ta<D(i).MT(end),1,'last');%version Matlab 7.0
                    %i1=iround(R.ta,D(i).MT(1));%version Matlab 6.5
                    %i2=iround(R.ta,D(i).MT(end));%version Matlab 6.5
					if i2>i1
						subplot(311),plot(R.ta(i1:i2),R.a(i1:i2));
						set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
                    	title(strcat(sprintf(strcat([NAME,' %d'])',scarica),', D-alpha'));
					else
						disp('The reference signal does not overlap with the selected time window, we do not plot it')
					end
                    subplot(312),imagesc(A(i).t,A(i).fre,20*log10(abs(A(i).mod(1).mod)));axis xy;
                    colorbar('horiz');
                    title(strcat(sprintf(strcat(['Spectrum',' ',NAME,' %d,']),scarica),A(i).nomi));
					subplot(313),plot(A(i).t,A(i).mod(1).mfreq,A(i).t,A(i).mod(1).sqfreq)
					legend('Mean','Std')
					set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
					title('Frequency, center of mass') 
                end    
                disp(sprintf('FFT is computed over %d points',D(i).punti));
            end
        end
                
	case 'coergram'
	
		if incrocia
            nn=0;
            A(1).cc=[];
            A(1).nominc={};
			l=1;
            for k=1:length(D)
                if and(O(k).analisi_diag,valuta(k))
                    for h=1:length(D)
                        if h==k
                            for i=1:D(k).n2x
                                for j=(i+1):D(k).n2x
									[A(1).cc(l).cc,A(k).fre,A(k).t]=coergram(D(k).M(:,i),D(k).M(:,j),psgram,ovgram,ps,ov,a,1/D(k).dt);
                                    A(1).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                                    A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
									l=l+1;
                                end
                            end
                        else if valuta(h)
                                for i=1:D(k).n2x
                                    for j=1:D(h).n2x
                                        [A(1).cc(l).cc,A(1).fre,A(1).t]=coergram(D(k).M(:,i),D(k).M(:,j),psgram,ovgram,ps,ov,a,1/D(k).dt);
										A(1).nomc=strcat(A(k).nomi(i),'&',A(h).nomi(j));
                                        A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
										l=l+1;
                                    end
                                end
                            end
                        end
                    end
                end
                nn=nn+D(k).n2x;
            end
            nn=nn*(nn-1)/2;
            if nn>1
                figure;
				set(gca,'fontsize',15)
				set(gca,'fontname','times')
                uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],...
				'min',0,'max',nn-1,'sliderstep',[1/(nn-1) 1/(nn-1)],'callback','plotb coergram','userdata',A(1));
                disp(sprintf('FFT is computed over %d points',D(k).punti));
            else if nn==1
                    figure;
					set(gca,'fontsize',15)
					set(gca,'fontname','times')
				i1=find(R.ta>D(1).MT(1),1,'first');%version Matlab 7.0
        			i2=find(R.ta<D(1).MT(end),1,'last');%version Matlab 7.0
				%i1=iround(R.ta,D(1).MT(1));%version Matlab 6.5
        			%i2=iround(R.ta,D(1).MT(end));%version Matlab 6.5
					if i2>i1
						subplot(211),plot(R.ta(i1:i2),R.a(i1:i2));
						set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
        				title(strcat(sprintf(strcat([NAME,' %d'])',scarica),', D-alpha'));
					else
						disp('The reference signal does not overlap with the selected time window, we do not plot it')
					end
                    subplot(212),imagesc(A(1).t,A(1).fre,A(1).cc.cc);
					colorbar('horiz')
                    title(strcat(sprintf(strcat(['Coherencegram',' ',NAME,' %d,']),scarica),',',A(1).nomi(1),'&',A(1).nomi(2)));
                    disp(sprintf('FFT is computed over %d points ',D(k).punti));
                else
                    disp('Type coherence, please ');
                end
            end
        else
            for k=1:length(D)
				l=1;
                if and(O(k).analisi_diag,valuta(k))
                    A(k).cc=[];
                    A(k).nominc={};
                    for i=1:D(k).n2x
                        for j=(i+1):D(k).n2x
							[A(k).cc(l).cc,A(k).fre,A(k).t]=coergram(D(k).M(:,i),D(k).M(:,j),psgram,ovgram,ps,ov,a,1/D(k).dt);
							A(k).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                            A(k).nominc=cat(1,A(k).nominc,A(k).nomc);
							l=l+1;
                        end
					end
					A(k).t=A(k).t+D(k).MT(1);
                    D(k).nn=D(k).n2x*(D(k).n2x-1)/2;
                    if D(k).nn>1
                        figure;
						set(gca,'fontsize',15)
						set(gca,'fontname','times')
						uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',D(k).nn-1,'sliderstep',[1/(D(k).nn-1) 1/(D(k).nn-1)],'callback','plotb coergram','userdata',A(k));
                        disp(sprintf('FFT is computed over %d points',D(k).punti));
                    else if D(k).nn==1
                            figure;
							set(gca,'fontsize',15)
							set(gca,'fontname','times')
						i1=iround(R.ta>D(k).MT(1),1,'first');%version Matlab 7.0
        					i2=iround(R.ta,D(k).MT(end),1,'last');%version Matlab 7.0
						%i1=iround(R.ta,D(k).MT(1));%version Matlab 6.5
        					%i2=iround(R.ta,D(k).MT(end));%version Matlab 6.5
							if i2>i1
								subplot(2,1,1),plot(R.ta(i1:i2),R.a(i1:i2));
								set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
        						title(strcat(sprintf(strcat([NAME,' %d'])',scarica),', D-alpha'));
							else
								disp('The reference signal does not overlap with the selected time window, we do not plot it')
							end
        					subplot(2,1,2),imagesc(A(k).t,A(k).fre,A(k).cc.cc);
							colorbar('horiz')
                            title(strcat(sprintf(strcat(['Coherencegram',' ',NAME,' %d,']),scarica),',',A(k).nomi(1),'&',A(k).nomi(2)));
                            disp(sprintf('FFT is computed over %d points ',D(k).punti));
                        else
                            disp('Type coherence, please ');
                        end
                    end
                end
            end                 
        end	
				
    case 'spet'
        
        for i=1:length(D)
            if and(valuta(i),O(i).analisi_diag)
                A(i).mod=[];
                for j=1:size(D(i).M,2)
                    %[sp,A(i).fre]=pwelch(D(i).M(:,j),a(:,i),[],p(i),1/D(i).dt);
					[sp,A(i).fre]=pwelch(D(i).M(:,j),a,ov,ps,1/D(i).dt);    
                    A(i).mod=[A(i).mod sp];
                end
                %grafico spettro
				A(i).N=fix((D(i).punti-ov)/(ps-ov));
                figure;
				set(gca,'fontsize',15)
				set(gca,'fontname','times')
				uicontrol('units','normalized','string','Change x scale','position',[0.25 0.01 0.15 0.05],'callback','scala x');
				uicontrol('units','normalized','string','Change y scale','position',[0.45 0.01 0.15 0.05],'callback','scala y');
				uicontrol('units','normalized','string','Spectral index','position',[0.7 0.93 0.15 0.05],'callback','indice uno','userdata',A(i));
				if D(i).n2x>1
                    uicontrol('units','normalized','style','slider','position',[0.05 0.02 0.2 0.04],'min',0,'max',D(i).n2x-1,'sliderstep',[1/(D(i).n2x-1) 1/(D(i).n2x-1)],'callback','plotb spet','userdata',A(i));
                else
                    loglog(A(i).fre,A(i).mod,A(i).fre,A(i).mod*sqrt(11/9/A(i).N),'r');
                    title(strcat(sprintf(strcat(['Spectrum',' ',NAME,' %d,']),scarica),',',A(i).nomi));
                end    
                disp(sprintf('FFT is computed over %d points divided into %d segments',D(i).punti,A(i).N));
            end
        end
        
    case 'auto'
        for i=1:length(D)
			D(i).n2x=size(D(i).M,2);
			if and(valuta(i),O(i).analisi_diag)
                A(i).ccf=[];
                for h=1:D(i).n2x
					[A(i).ccf(:,h),A(i).x]=xcorr(D(i).M(:,h),D(i).M(:,h),'unbiased');
                end
                figure;
				set(gca,'fontsize',15)
				set(gca,'fontname','times')
                A(i).x=A(i).x*D(i).dt;
                if D(i).n2x>1
                    uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',D(i).n2x-1,'sliderstep',[1/(D(i).n2x-1) 1/(D(i).n2x-1)],'callback','plotb auto','userdata',A(i));
                else
                    plot(A(i).x,A(i).ccf);
                    title(strcat(sprintf(strcat(['Un-biased Autocorrelation',' ',NAME,' %d,'])',scarica),',',A(i).nomi));
                end
                disp(sprintf('FFT is computed over %d points ',D(i).punti));
            end
        end
        
	  case 'cross'

		if size(D(1).r,2)==1
			disp('Type autocorrelation, please')
			return
		end
        if incrocia
            nn=0;
            n=1;
            A(1).cc=[];
            A(1).nominc={};
            for k=1:length(D)
                if and(valuta(k),O(k).analisi_diag)
                    for h=1:length(D)
                        if h==k
                            for i=1:D(k).n2x
                                for j=(i+1):D(k).n2x
                                    [A(1).cc(:,n),A(1).tt]=xcorr(D(k).M(:,i),D(k).M(:,j),'coef');
                                    A(1).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                                    A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
                                    n=n+1;
                                end
                            end
                        else if valuta(h)
                                for i=1:D(k).n2x
                                    for j=1:D(h).n2x
                                        [A(1).cc(:,n),A(1).tt]=xcorr(D(k).M(:,i),D(h).M(:,j),'coef');
                                        A(1).nomc=strcat(A(k).nomi(i),'&',A(h).nomi(j));
                                        A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
                                        n=n+1;
                                    end
                                end
                            end
                        end
                    end
                end
                nn=nn+D(k).n2x;
            end
            A(1).tt=A(1).tt*D(1).dt;
            nn=nn*(nn-1)/2;
            if nn>1
                figure;
                uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',nn-1,'sliderstep',[1/(nn-1) 1/(nn-1)],'callback','plotb cross','userdata',A(1));
                disp(sprintf('FFT is computed over %d points',D(k).punti));
            else if nn==1
                    figure;
                    plot(A(1).tt,A(1).cc);
                    title(strcat(sprintf(strcat(['Cross Correlation coefficient',' ',NAME,' %d,'])',scarica),',',A(i).nomi(1),'&',A(i).nomi(2)));
                    disp(sprintf('FFT is computed over %d points ',D(k).punti));
                else
                    disp('Type autocorrelation, please ');
                end
            end
        else
            for k=1:length(D)
                if and(O(k).analisi_diag,valuta(k))
                    n=1;
                    A(k).cc=[];
                    A(k).nominc={};
                    for i=1:D(k).n2x
                        for j=(i+1):D(k).n2x
                            [A(k).cc(:,n),A(k).tt]=xcorr(D(k).M(:,i),D(k).M(:,j),'coef');
                            A(k).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                            A(k).nominc=cat(1,A(k).nominc,A(k).nomc);
                            n=n+1;
                        end
                    end
                    A(k).tt=A(k).tt*D(k).dt;
                    D(k).nn=D(k).n2x*(D(k).n2x-1)/2;
                    if D(k).nn>1
                        figure;
                        uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',D(k).nn-1,'sliderstep',[1/(D(k).nn-1) 1/(D(k).nn-1)],'callback','plotb cross','userdata',A(k));
                        disp(sprintf('FFT is computed over %d points',D(k).punti));
                    else if D(k).nn==1
                            figure;
                            plot(A(k).tt,A(k).cc);
                            title(strcat(sprintf(strcat(['Cross Correlation coefficient',' ',NAME,' %d,'])',scarica),',',A(k).nomi(1),'&',A(k).nomi(2)));
                            disp(sprintf('FFT is computed over %d points ',D(k).punti));
                        else
                            disp('Type autocorrelation, please ');
                        end
                    end
                end
            end                 
        end

	case 'coer'

        coerelm=get(findobj(gcf,'style','checkbox','tag','Coherelm'),'value');
		if iscell(coerelm)
			coerelm=cell2mat(coerelm(1));
		end
		if incrocia
            nn=0;
            A(1).cc=[];
            A(1).ph=[];
            A(1).nominc={};
            for k=1:length(D)
                if and(O(k).analisi_diag,valuta(k))
                    for h=1:length(D)
                        if h==k
                            for i=1:D(k).n2x
                                for j=(i+1):D(k).n2x
                                    %[co,A(1).fre]=mscohere(D(k).M(:,i),D(k).M(:,j),a(:,k),[],p(k),1/D(k).dt);%Matlab 7.0
                                    if coerelm
										g=diff(D(k).hh);
										hh=1;
										for gig=1:2:length(D(k).hh)-1
											hh=[hh hh(end)+g(gig) hh(end)+g(gig)+1];
										end
										hh=hh(1:end-1);
										[co,A(1).fre,A(1).N]=coerenza(D(k).M(:,i),D(k).M(:,j),hh,ps,1/D(k).dt,a,ov);%Matlab 6.5
									else
										[co,A(1).fre,A(1).N]=coerenza(D(k).M(:,i),D(k).M(:,j),[],ps,1/D(k).dt,a,ov);%Matlab 6.5
									end
									A(1).cc=[A(1).cc co];
                                    A(1).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                                    A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
                                end
                            end
                        else if valuta(h)
                                for i=1:D(k).n2x
                                    for j=1:D(h).n2x
                                        %[co,A(1).fre]=mscohere(D(k).M(:,i),D(h).M(:,j),a(:,k),[],p(k),1/D(k).dt);%Matlab 7.0
                                        if coerelm
											g=diff(D(h).hh);
											hh=1;
											for gig=1:2:length(D(h).hh)-1
												hh=[hh hh(end)+g(gig) hh(end)+g(gig)+1];
											end
											hh=hh(1:end-1);
											[co,A(1).fre,A(1).N]=coerenza(D(k).M(:,i),D(h).M(:,j),hh,ps,1/D(k).dt,a,ov);%Matlab 6.5
										else
											[co,A(1).fre,A(1).N]=coerenza(D(k).M(:,i),D(h).M(:,j),[],ps,1/D(k).dt,a,ov);%Matlab 6.5
										end
										A(1).cc=[A(1).cc co];
                                        A(1).nomc=strcat(A(k).nomi(i),'&',A(h).nomi(j));
                                        A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
                                    end
                                end
                            end
                        end
                    end
                end
                nn=nn+D(k).n2x;
            end
            nn=nn*(nn-1)/2;
            if nn>1
                figure;
                uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',nn-1,'sliderstep',[1/(nn-1) 1/(nn-1)],'callback','plotb coer','userdata',A(1));
                disp(sprintf('FFT is computed over %d points divided into %d intervals',D(k).punti,A(1).N));
            else if nn==1
                    figure;
                    plot(A(1).fre,A(1).cc,A(1).fre,(1-A(1).cc).^2/A(1).N,'r');
                    title(strcat(sprintf(strcat(['Coherence',' ',NAME,' %d,'])',scarica),',',A(i).nomi(1),'&',A(i).nomi(2)));
                    disp(sprintf('FFT is computed over %d points divided into %d intervals',D(k).punti,A(1).N));
                else
                    disp('Type autocorrelation, please ');
                end
            end
        else
            for k=1:length(D)
                if and(O(k).analisi_diag,valuta(k))
                    A(k).cc=[];
                    A(k).ph=[];
                    A(k).nominc={};
                    sp=abs(fftmod(D(k).M,D(k).punti));
                    %sp=sp*(2*(1-1/D(k).punti))/((D(k).punti-1)*D(k).dt);
                    for i=1:D(k).n2x
                        for j=(i+1):D(k).n2x
							%[co,A(1).fre]=mscohere(D(k).M(:,i),D(k).M(:,j),a(:,k),[],p(k),1/D(k).dt);%version Matlab 7.0    
                            if coerelm
								g=diff(D.hh);
								hh=1;
								for gig=1:2:length(D(k).hh)-1
									hh=[hh hh(end)+g(gig) hh(end)+g(gig)+1];
								end
								hh=hh(1:end-1);
								[co,A(1).fre,A(1).N]=coerenza(D(k).M(:,i),D(k).M(:,j),hh,ps,1/D(k).dt,a,ov);%Matlab 6.5
							else
								[co,A(1).fre,A(1).N]=coerenza(D(k).M(:,i),D(k).M(:,j),[],ps,1/D(k).dt,a,ov);%version Matlab 6.5
							end
							A(k).cc=[A(k).cc co];
                            A(k).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                            A(k).nominc=cat(1,A(k).nominc,A(k).nomc);
                        end
                    end
                    D(k).nn=D(k).n2x*(D(k).n2x-1)/2;
                    if D(k).nn>1
                        figure;
                        uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',D(k).nn-1,'sliderstep',[1/(D(k).nn-1) 1/(D(k).nn-1)],'callback','plotb coer','userdata',A(k));
                        disp(sprintf('FFT is computed over %d points divided into %d intervals',D(k).punti,A(1).N));
                    else if D(k).nn==1
                            figure;
                            plot(A(k).fre,A(k).cc,A(k).fre,(1-A(1).cc).^2/A(1).N,'r');
                            title(strcat(sprintf(strcat(['Coherence',' ',NAME,' %d,'])',scarica),',',A(k).nomi(1),'&',A(k).nomi(2)));
                            disp(sprintf('FFT is computed over %d points divided into %d intervals',D(k).punti,A(1).N));
                        else
                            disp('Type autocorrelation, please ');
                        end
                    end
                end
            end                 
        end
        
    case 'hilbert'
        %Estimate if there's a linear relationship between reference and loaded signals 
        rr=get(findobj(gcbf,'style','radiobutton'),'value');
        if length(rr)>1
            rr=cell2mat(rr);
        end
        r=find(rr);
        for i=1:length(D)
            if i~=ll
                D(i).M=resample(D(i).M,R(r).punti,D(i).n1x);
                %D(i).Mt=(D(ll).trovamin:D(ll).trovamax)';
                D(i).punti=R(r).punti;
                D(i).dt=R(r).dt;
            end 
        end
        for i=1:length(D)
            if and(O(i).analisi_diag,valuta(i))
                D(i).u=fftmod(D(i).M,D(i).punti);
                rif=fftmod(R(r).M,R(r).punti);
                D(i).f=rif./D(i).u;
                D(i).h=imag(hilbert(real(D(i).f)));
                oops=D(i).h./imag(D(i).f);
            end
        end
        
    case 'autobi'
        
        if incrocia
            nn=0;
            A(1).cc=[];
            A(1).nominc={};
            A(1).bico=[];
            l=1;
            for k=1:length(D)
                if and(O(k).analisi_diag,valuta(k))
                    for h=1:length(D)
                        if h==k
                            for i=1:D(k).n2x
                                for j=(i+1):D(k).n2x
                                    [A(1).bico(l).co,A(1).fre1,A(1).fre2,A(1).ncol]=bicoherence(D(k).M(:,i),D(k).M(:,j),ov,ps,D(k).dt);
                                    %A(1).bico=[A(1).bico co];
                                    A(1).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                                    A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
                                    l=l+1;
                                end
                            end
                        else if valuta(h)
                                for i=1:D(k).n2x
                                    for j=1:D(h).n2x
                                        [A(1).bico(l).co,A(1).fre1,A(1).fre2,A(1).ncol]=bicoherence(D(k).M(:,i),D(h).M(:,j),ov,ps,D(k).dt);
                                        %A(1).cc=[A(1).cc co];
                                        A(1).nomc=strcat(A(k).nomi(i),'&',A(h).nomi(j));
                                        A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
                                        l=l+1;
                                    end
                                end
                            end
                        end
                    end
                end
                nn=nn+D(k).n2x;
            end
            nn=nn*(nn-1)/2;
            if nn>1
                figure;
                uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',nn-1,'sliderstep',[1/(nn-1) 1/(nn-1)],'callback','plotb bicoer','userdata',A(1));
                disp(sprintf('FFT is computed over %d points',D(k).punti));
            else if nn==1
                    figure;
                    mesh(A(1).fre2,A(1).fre1,A(1).bico(1).co);
                    title(strcat(sprintf(strcat(['Auto Bicoherence',' ',NAME,' %d,'])',scarica),',',A(i).nomi(1),'&',A(i).nomi(2)));
                    disp(sprintf('FFT is computed over %d points divided into %d subsets',D(k).punti,A(1).ncol));
                else
                    disp('Type auto bicoherence, please ');
                end
            end
        else
            for k=1:length(D)
                if and(O(k).analisi_diag,valuta(k))
                    A(k).cc=[];
                    A(k).nominc={};
                    A(k).bico=[];
                    for i=1:D(k).n2x
                        [A(k).bico(i).co,A(k).fre1,A(k).fre2,A(k).ncol]=bicoherence(D(k).M(:,i),D(k).M(:,i),ov,ps,D(k).dt);
                        A(k).nominc=cat(1,A(k).nominc,A(k).nomi(i));
                    end
                    if D(k).n2x>1
                        figure;
                        uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',D(k).n2x-1,'sliderstep',[1/(D(k).n2x-1) 1/(D(k).n2x-1)],'callback','plotb bicoer','userdata',A(k));
                        disp(sprintf('FFT is computed over %d points divided into %d subsets',D(k).punti,A(k).ncol));
                    else if D(k).n2x==1
                            figure;
                            mesh(A(k).fre2,A(k).fre1,A(k).bico(1).co);
                            title(strcat(sprintf(strcat(['Auto Bicoherence',' ',NAME,' %d,'])',scarica),',',A(k).nomi(1)));
                            disp(sprintf('FFT is computed over %d points divided into %d subsets',D(k).punti,A(k).ncol));
                        else
                            disp('Select something, please ');
                        end
                    end
                end
            end                 
        end
        
    case 'crossbi'
        
        if incrocia
            nn=0;
            l=1;
            A(1).nominc={};
            A(1).bico=[];
            for k=1:length(D)
                if and(O(k).analisi_diag,valuta(k))
                    for h=1:length(D)
                        if h==k
                            for i=1:D(k).n2x
                                for j=(i+1):D(k).n2x
                                    [A(1).bico(l).co,A(1).fre1,A(1).fre2,A(1).ncol]=bicoherence(D(k).M(:,i),D(k).M(:,j),ov,ps,D(k).dt);
                                    %A(1).cc=[A(1).cc co];
                                    A(1).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                                    A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
                                    l=l+1;
                                end
                            end
                        else if valuta(h)
                                for i=1:D(k).n2x
                                    for j=1:D(h).n2x
                                        [A(1).bico(l).co,A(1).fre1,A(1).fre2,A(1).ncol]=bicoherence(D(k).M(:,i),D(h).M(:,j),ov,ps,D(k).dt);
                                        %A(1).cc=[A(1).cc co];
                                        A(1).nomc=strcat(A(k).nomi(i),'&',A(h).nomi(j));
                                        A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
                                        l=l+1;
                                    end
                                end
                            end
                        end
                    end
                end
                nn=nn+D(k).n2x;
            end
            nn=nn*(nn-1)/2;
            if nn>1
                figure;
                uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',nn-1,'sliderstep',[1/(nn-1) 1/(nn-1)],'callback','plotb bicoer','userdata',A(1));
                disp(sprintf('FFT is computed over %d points',D(k).punti));
            else if nn==1
                    figure;
                    mesh(A(1).fre2,A(1).fre1,A(1).bico(1).co);
                    title(strcat(sprintf(strcat(['Cross Bicoherence',' ',NAME,' %d,'])',scarica),',',A(i).nomi(1),'&',A(i).nomi(2)));
                    disp(sprintf('FFT is computed over %d points divided into %d subsets',D(k).punti,A(1).ncol));
                else
                    disp('Type auto bicoherence, please ');
                end
            end
        else
            for k=1:length(D)
                if and(O(k).analisi_diag,valuta(k))
                    %A(k).cc=[];
                    l=1;
                    A(k).nominc={};
                    A(k).bico=[];
                    for i=1:D(k).n2x
                        for j=(i+1):D(k).n2x
                            [A(k).bico(l).co,A(1).fre1,A(1).fre2,A(k).ncol]=bicoherence(D(k).M(:,i),D(k).M(:,j),ov,ps,D(k).dt);
                            %A(k).cc=[A(k).cc co];
                            A(k).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                            A(k).nominc=cat(1,A(k).nominc,A(k).nomc);
                            l=l+1;
                        end
                    end
                    D(k).nn=D(k).n2x*(D(k).n2x-1)/2;
                    if D(k).nn>1
                        figure;
                        uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',D(k).nn-1,'sliderstep',[1/(D(k).nn-1) 1/(D(k).nn-1)],'callback','plotb bicoer','userdata',A(k));
                        disp(sprintf('FFT is computed over %d points divided in %d subsets',D(k).punti,A(k).ncol));
                    else if D(k).nn==1
                            figure;
                            mesh(A(k).fre2,A(k).fre1,A(k).bico(1).co);
                            disp(sprintf('FFT is computed over %d points divided in %d subsets',D(k).punti,A(k).ncol));
                        else
                            disp('Type auto bicoherence, please ');
                        end
                    end
                end
            end                 
        end
        
    case 'crossspet'
        if incrocia
            nn=0;
            A(1).cc=[];
            A(1).nominc={};
            A(1).ph=[];          
            %title(strcat(sprintf('Bicoherence JET %d',scarica),',',A(k).nomi(1),'&',A(k).nomi(2)));           
            for k=1:length(D)
                if and(O(k).analisi_diag,valuta(k))
                    for h=1:length(D)
                        if h==k
                            for i=1:D(k).n2x
                                for j=(i+1):D(k).n2x
                                    %[cs,A(1).fre]=cpsd(D(k).M(:,i),D(k).M(:,j),a(:,k),[],p(k),1/D(k).dt);%Matlab 7.0
									[cs,A(1).fre]=csd(D(k).M(:,i),D(k).M(:,j),ps,1/D(k).dt,a,ov);%Matlab 6.5
                                    A(1).cc=[A(1).cc abs(cs)];
                                    A(1).ph=[A(1).ph unwrap(phase(cs))];
                                    A(1).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                                    A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
                                end
                            end
                        else if and(O(h).analisi_diag,valuta(h))
                                for i=1:D(k).n2x
                                    for j=1:D(h).n2x
                                        %[cs,A(1).fre]=cpsd(D(k).M(:,i),D(h).M(:,j),a(:,k),[],p(k),1/D(k).dt);%Matlab 7.0
                                        [cs,A(1).fre]=csd(D(k).M(:,i),D(h).M(:,j),ps,1/D(k).dt,a,ov);%Matlab 6.5
										A(1).cc=[A(1).cc abs(cs)];
                                        A(1).ph=[A(1).ph 180/pi*unwrap(atan2(imag(cs),real(cs)))];
                                        A(1).nomc=strcat(A(k).nomi(i),'&',A(h).nomi(j));
                                        A(1).nominc=cat(1,A(1).nominc,A(1).nomc);
                                    end
                                end
                            end
                        end
                    end
                end
                nn=nn+D(k).n2x;
            end
            nn=nn*(nn-1)/2;
            if nn>1
                figure;
                uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',nn-1,'sliderstep',[1/(nn-1) 1/(nn-1)],'callback','plotb crosspet','userdata',A(1));
                disp(sprintf('FFT is computed over %d points',D(k).punti));
            else if nn==1
                    figure;
                    plot(A(1).fre,A(1).cc,'b',A(1).fre,A(1).ph,'r');
                    %plotyy(log10(A(k).fre),log10(A(k).cc),A(k).fre,A(k).ph*180/pi);
					title(strcat(sprintf(strcat(['Cross Spectrum',' ',NAME,' %d,'])',scarica),',',A(i).nomi(1),'&',A(i).nomi(2)));
                    disp(sprintf('FFT is computed over %d points ',D(k).punti));
                else
                    disp('Type spectrum, please ');
                end
            end
        else
            for k=1:length(D)
                if and(O(k).analisi_diag,valuta(k))
                    A(k).cc=[];
                    A(k).ph=[];
                    A(k).nominc={};
                    for i=1:D(k).n2x
                        for j=(i+1):D(k).n2x
                            %[cs,A(k).fre]=cpsd(D(k).M(:,i),D(k).M(:,j),a(:,k),[],p(k),1/D(k).dt);%Matlab 7.0
							[cs,A(k).fre]=csd(D(k).M(:,i),D(k).M(:,j),ps,1/D(k).dt,a,ov);%Matlab 6.5
                            A(k).cc=[A(k).cc abs(cs)];
                            A(k).ph=[A(k).ph 180/pi*unwrap(atan2(imag(cs),real(cs)))];
                            A(k).nomc=strcat(A(k).nomi(i),'&',A(k).nomi(j));
                            A(k).nominc=cat(1,A(k).nominc,A(k).nomc);
                        end
                    end
                    D(k).nn=D(k).n2x*(D(k).n2x-1)/2;
                    if D(k).nn>1
                        figure;
                        uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',D(k).nn-1,'sliderstep',[1/(D(k).nn-1) 1/(D(k).nn-1)],'callback','plotb crosspet','userdata',A(k));
                        disp(sprintf('FFT is computed over %d points',D(k).punti));
                    else if D(k).nn==1
                            figure;
                            plot(A(k).fre,A(k).cc,'b',A(k).fre,A(k).ph,'r');
							%plotyy(log10(A(k).fre),log10(A(k).cc),A(k).fre,A(k).ph*180/pi);
                            title(strcat(sprintf(strcat(['Cross Spectrum',' ',NAME,' %d,'])',scarica),',',A(k).nomi(1),'&',A(k).nomi(2)));
                            disp(sprintf('FFT is computed over %d points ',D(k).punti));
                        else
                            disp('Type spectrum, please ');
                        end
                    end
                end
            end                 
        end
        
    case 'wavelet'
        
        %b4=get(findobj(gcbf,'style','edit','tag','tipowvt'),'string');
		b4='db3';
        for k=1:length(D)
            if and(O(k).analisi_diag,valuta(k))
                A(k).cwt=[];
                scale=wmaxlev(D(k).punti,b4);
                for i=1:D(k).n2x
                    A(k).cwt(i).cc=cwt(D(k).M(:,i),1:scale,b4);
                end
                A(k).t=linspace(D(k).MT(1),D(k).MT(end),D(k).punti);
                figure;
                if D(k).n2x>1
                    uicontrol('units','normalized','style','slider','position',[0.02 0.02 0.15 0.05],'min',0,'max',D(k).n2x-1,'sliderstep',[1/(D(k).n2x-1) 1/(D(k).n2x-1)],'callback','plotb cwt','userdata',A(k));
                else
                    i1=find(R.ta>D(k).MT(1),1,'first');%version Matlab 7.0
                    i2=find(R.ta<D(k).MT(end),1,'last');%version Matlab 7.0
                    %i1=iround(R.ta,D(k).MT(1));%version Matlab 6.5
                    %i2=iround(R.ta,D(k).MT(end));%version Matlab 6.5
					if i2>i1
						subplot(211),plot(R.ta(i1:i2),R.a(i1:i2));
						set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
                    	title(strcat(sprintf(strcat([NAME,' %d'])',scarica),', D-alpha'));
					else
						disp('The reference signal does not overlap with the selected time window, we do not plot it')
					end
                    subplot(212),imagesc(A(k).t,1:scale,A(k).cwt(1).cc);
					colorbar('horiz');
					if i2>i1
						set(gca,'xlim',[R.ta(i1) R.ta(i2)]);
                    end
					title(strcat(sprintf(strcat(['CWT',' ',NAME,' %d,'])',scarica),',',A(k).nomi));
                end
                disp(sprintf('CWT is computed over %d points ',D(k).punti));
            end
        end
        
end
