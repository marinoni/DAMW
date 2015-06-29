function scegli

global D R O tmin tmax;

p=get(gco,'userdata');
pts=str2num(get(findobj(0,'style','edit','tag','puntispetgram'),'string'));
ovl=str2num(get(findobj(0,'style','edit','tag','spetgramoverlap'),'string'));
ovl=round(ovl*pts/100);
%i1=find(R.ta>tmin,1,'first'); %version MAtlab 7.0
%i2=find(R.ta>tmax,1,'first'); %version Matlab 7.0
i1=iround(R.ta,tmin); %version MAtlab 6.5
i2=iround(R.ta,tmax); %version Matlab 6.5
med=mean(R.a(i1:i2));
sig=std(R.a(i1:i2));
vett=get(findobj(gcbf,'style','edit'),'string');
fatt=str2num(cell2mat(vett(2)));
var=str2num(cell2mat(vett(1)));
eqseg=get(findobj(gcbf,'style','checkbox','tag','EqualSeg'),'value');
h=i1+find(R.a(i1:i2)>med+fatt*sig);
hd=diff(h);
mhd=mean(hd);
shd=std(hd);
m=[];
mm=[];
m(1)=h(1);
%This is slower
%mm(1)=h(1);
%bqq=find(hd>mhd+var*shd);
%for i=1:length(bqq)
%	m2=[m2 h(bqq(i)) h(bqq(i)+1)];
%end
%This is faster, at least for normal dataset lengths
for i=2:(length(h)-1);
    if and(hd(i)>(mhd+var*shd),h(i)~=h(i-1))
        m=[m h(i) h(i+1)];
    end
end
m=[m h(i+1)];
if eqseg
	dm=diff(m);
	[intsize,intpos]=max(dm(1:2:end));
	iintsize1=iround(D(1).t,R.ta(m(2*intpos-1)));
	iintsize2=iround(D(1).t,R.ta(m(2*intpos)));
	%Number of windows
	k=((iintsize2-iintsize1+1)-ovl)/(pts-ovl);
	punti=ceil(k)*(pts-ovl)+ovl;
	%The following is just for plotting purposes
	punti_ref=round(punti*min(diff(D(1).t(iintsize1:iintsize2)))/min(diff(R.ta(i1:i2))));
	for i=1:2:length(m)-1
		mm=[mm m(i) m(i)+punti_ref];
	end
	set(p.p1(2),'xdata',R.ta(m),'ydata',R.a(m),'marker','*','color','k','linestyle','none');
	set(p.p1(3),'xdata',R.ta(mm),'ydata',R.a(mm),'marker','*','color','r','linestyle','none');
else
	set(p.p1(2),'xdata',R.ta(m),'ydata',R.a(m),'marker','*','color','k','linestyle','none');
	set(p.p1(3),'marker','none');
end
set(p.p2,'ydata',[med+fatt*sig med+fatt*sig],'linestyle','-');
if mod(length(m),2)
	disp('Check choice criteria, odd number of selected points');
	delete(findobj(gcbf,'style','pushbutton','string','Ok'));
else
	sk=uicontrol('units','normalized','style','pushbutton','position',[0.02 0.02 0.1 0.05],...
	'string','Ok','callback','ottieni','userdata',m);
	if iscell(sk)
		sk=sk(1);
	end
end	
