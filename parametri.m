function parametri

global tmin tmax D R O

if get(gcbo,'value')
    %i1=find(R.ta>tmin,1,'first'); %version MAtlab 7.0
	%i2=find(R.ta>tmax,1,'first'); %version Matlab 7.0
	i1=iround(R.ta,tmin); %version MAtlab 6.5
	i2=iround(R.ta,tmax); %version Matlab 6.5
	figure;
	p.p1=plot(R.ta,R.a,0,0,0,0);
	axis([tmin tmax 0 max(R.a(i1:i2))]);
	set(p.p1,'linewidth',1,'markersize',15);
	p.p2=line([tmin tmax],[0 0],'color','r','linestyle','none');
    sh.a_t=uicontrol('units','normalized','style','text','position',[0.01 0.45 0.08 0.05],'string','average');
    sh.a=uicontrol('units','normalized','style','edit','position',[0.01 0.4 0.08 0.05],...
	'callback','scegli','string','0.80','userdata',p);
    sh.a_t=uicontrol('units','normalized','style','text','position',[0.01 0.57 0.08 0.05],'string','std deviation');
    sh.b=uicontrol('units','normalized','style','edit','position',[0.01 0.52 0.08 0.05],...
	'callback','scegli','string','0.15','userdata',p);
	sh.c=uicontrol('units','normalized','style','checkbox','position',[0.4 0.01 0.2 0.05],...
	'string',['Equal',' ','segments'],'tag','EqualSeg');
end
