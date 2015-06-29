function somcoelms(cosa)

global D R O tmin tmax valuta;

if nargin==0
	cosa='parametri';
end
eqseg=get(findobj(gcbf,'style','checkbox','tag','EqualSeg'),'value');
switch cosa
	
	case 'parametri'
		
		if get(gcbo,'value')
    		i1=find(R.ta>tmin,1,'first'); %version MAtlab 7.0
			i2=find(R.ta>tmax,1,'first'); %version Matlab 7.0
			%i1=iround(R.ta,tmin); %version MAtlab 6.5
			%i2=iround(R.ta,tmax); %version Matlab 6.5
			figure;
			p.p1=plot(R.ta,R.a,0,0,0,0);
			axis([tmin tmax 0 max(R.a(i1:i2))]);
			set(p.p1,'linewidth',1,'markersize',15);
			p.p2=line([tmin tmax],[0 0],'color','r','linestyle','none');
    		sh.a_t=uicontrol('units','normalized','style','text',...
			'position',[0.01 0.45 0.08 0.05],'string','average');
    		sh.a=uicontrol('units','normalized','style','edit','position',...
			[0.01 0.4 0.08 0.05],'callback','somcoelms scegli','string','0.80','userdata',p);
    		sh.a_t=uicontrol('units','normalized','style','text',...
			'position',[0.01 0.57 0.08 0.05],'string','std deviation');
    		sh.b=uicontrol('units','normalized','style','edit','position',...
			[0.01 0.52 0.08 0.05],'callback','somcoelms scegli','string','0.15','userdata',p);
			sh.c=uicontrol('units','normalized','style','checkbox',...
			'position',[0.4 0.01 0.2 0.05],'string',['Equal',' ','segments'],'tag','EqualSeg');
		else
			return
		end
		
	case 'scegli'

		p=get(gco,'userdata');
		pts=get(findobj(0,'style','edit','tag','puntispetgram'),'string');
		if iscell(pts)
			pts=cell2mat(pts(1));
		end
		pts=str2num(pts);
		ovl=get(findobj(0,'style','edit','tag','spetgramoverlap'),'string');
		if iscell(ovl)
			ovl=cell2mat(ovl(1));
		end
		ovl=str2num(ovl);
		ovl=round(ovl*pts/100);
	        i1=find(R.ta>tmin,1,'first'); %version MAtlab 7.0
		i2=find(R.ta>tmax,1,'first'); %version Matlab 7.0
		%i1=iround(R.ta,tmin); %version MAtlab 6.5
		%i2=iround(R.ta,tmax); %version Matlab 6.5
		med=mean(R.a(i1:i2));
		sig=std(R.a(i1:i2));
		vett=get(findobj(gcbf,'style','edit'),'string');
		fatt=str2num(cell2mat(vett(2)));
		var=str2num(cell2mat(vett(1)));
		h=i1+find(R.a(i1:i2)>med+fatt*sig);
		hd=diff(h);
		mhd=mean(hd);
		shd=std(hd);
		A.m=[];
		mm=[];
		A.m(1)=h(1);
		%This is slower
		%mm(1)=h(1);
		%bqq=find(hd>mhd+var*shd);
		%for i=1:length(bqq)
		%	m2=[m2 h(bqq(i)) h(bqq(i)+1)];
		%end
		%This is faster, at least for normal dataset lengths
		for i=2:(length(h)-1);
    		if and(hd(i)>(mhd+var*shd),h(i)~=h(i-1))
        		A.m=[A.m h(i) h(i+1)];
    		end
		end
		A.m=[A.m h(i+1)];
		A.punti=0;
		if eqseg
			dm=diff(A.m);
			[intsize,intpos]=max(dm(1:2:end));
			for j=1:length(D)
				if and(O(j).analisi_diag,valuta(j))
					iintsize1=iround(D(1).t,R.ta(A.m(2*intpos-1)));
					iintsize2=iround(D(1).t,R.ta(A.m(2*intpos)));
					%Number of windows
					k=((iintsize2-iintsize1+1)-ovl)/(pts-ovl);
					A.punti(j)=ceil(k)*(pts-ovl)+ovl;
				end
			end
			assignin('base','punti',A.punti);
			cippa=find(valuta);
			%The following is just for plotting purposes
			punti_ref=round(A.punti(cippa(1))*min(diff(D(cippa(1)).t(iintsize1:iintsize2)))/min(diff(R.ta(i1:i2))));
			for i=1:2:length(A.m)-1
				mm=[mm A.m(i) A.m(i)+punti_ref];
			end
			set(p.p1(2),'xdata',R.ta(A.m),'ydata',R.a(A.m),'marker','*','color','k','linestyle','none');
			set(p.p1(3),'xdata',R.ta(mm),'ydata',R.a(mm),'marker','*','color','r','linestyle','none');
		else
			set(p.p1(2),'xdata',R.ta(A.m),'ydata',R.a(A.m),'marker','*','color','k','linestyle','none');
			set(p.p1(3),'marker','none');
		end
		set(p.p2,'ydata',[med+fatt*sig med+fatt*sig],'linestyle','-');
		if mod(length(A.m),2)
			disp('Check choice criteria, odd number of selected points');
			delete(findobj(gcbf,'style','pushbutton','string','Ok'));
		else
			sk=uicontrol('units','normalized','style','pushbutton',...
			'position',[0.02 0.02 0.1 0.05],'string','Ok','callback','somcoelms ottieni','userdata',A);
			if iscell(sk)
				sk=sk(1);
			end
		end
		
	case 'ottieni'	
	
		%vettore indici per matrice di densita'
		A=get(gcbo,'userdata');
		m=A.m;
		punti=A.punti;
		for j=1:length(D)
			if and(valuta(j),O(j).analisi_diag)
				D(j).hh=[];
        		D(j).telms=[];
        		if eqseg
					for i=1:2:length(m)-1
						a=iround(D(j).t,R.ta(m(i)));
            			D(j).hh=[D(j).hh a a+punti(j)-1]; % version Matlab 6.5
        			end
        			D(j).trovamin=iround(D(j).t,tmin);%version Matlab 6.5
					for i=1:length(m)/2
            			D(j).telms=[D(j).telms;(D(j).hh(2*i-1):D(j).hh(2*i))'];
            		end
				else
					for i=1:length(m)
            			D(j).hh=[D(j).hh iround(D(j).t,R.ta(m(i)));]; % version Matlab 6.5
        			end
        			D(j).trovamin=iround(D(j).t,tmin);%version Matlab 6.5
					for i=1:length(m)/2
            			D(j).telms=[D(j).telms; (D(j).hh(2*i-1):D(j).hh(2*i))'];
        			end
				end
        		D(j).telms=D(j).telms-D(j).trovamin;
				D(j).hh=D(j).hh-D(j).trovamin;
				assignin('base','D',D);
    		end
		end
		close

end
