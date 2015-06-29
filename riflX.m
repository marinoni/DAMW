function riflX(cosa)

global D R;

n=length(D);
if n==0
   disp('Insert shot number first, please')
   return
end
nomi=cell(1,n);
if ~isempty(D(n).nome)
   for i=1:length(D)
      nomi(i)=cellstr(D(i).nome);
   end
   n=n+1;
end
tokamak=get(findobj(gcbf,'style','popupmenu','tag','tokamak'),'value');
switch cosa
    
    case 'riflx'
                
        h=figure('position',[100 100 320 200]);
	switch tokamak
	   case 1
	   case 2
	      set(h,'name','X Reflectometer: download','numbertitle','off');
              if ~ismember('riflx',nomi)
                 D(n).scritte={'vcos4';'fcos4';'vcos3';'fcos3';'vcos2';'fcos2';'vcos1';'fcos1';...
	            'vsin4';'fsin4';'vsin3';'fsin3';'vsin2';'fsin2';'vsin1';'fsin1'};
                 D(n).canali=[12,11,10,9,4,3,2,1,16,15,14,13,8,7,6,5];
                 D(n).scrrms={'av100','af100','av96','af96','av85','af85','av76','af76'};
                 D(n).scrph={'pv100','pf100','pv96','pf96','pv85','pf85','pv76','pf76'};
                 D(n).nome='riflx';
                 D(n).can=[];
                 D(n).r=[];
                 D(n).ncan=0;
                 %D(n).ind=[];
                 D(n).rms=[];
                 D(n).ph=[];
                 D(n).srms=cell(1,8);
                 D(n).sph=cell(1,8);
                 D(n).scan=cell(1,16);
                 a=findobj(gcbf,'tag','quali','style','listbox');
                 if iscell(a)
                    a=a(1);
                 end
                 aa=get(a,'string');
                 b=cell(1,length(aa)+1);
                 for i=1:length(aa)
                    b(i)=cellstr(aa(i));
                 end
                 b(i+1)=cellstr(D(n).nome);
                 set(a,'string',b);
               else
                  n=find(ismember(nomi,'riflx'));
               end
               a=ismember(D(n).scrrms,D(n).srms(1:max(1,D(n).ncan/2)));%puoi fare find(ismember(..)) e togliere l'istruzione if ed accorciare il for.
	       k=1;
               for j=8:-1:1
                  uicontrol('units','normalized','style','checkbox','position',[0.02 0.95-0.11*k 0.3 0.1],'string',D(n).scrrms(j));
                  if a(j);
	             uicontrol('units','normalized','style','text','position',[0.33 0.95-0.11*k 0.4 0.085],'string','Already downloaded');	
	          end
	          k=k+1;
               end
	   case 3
	      set(h,'name','ECE: download','numbertitle','off');
              if ~ismember('ece',nomi)
                 D(n).scritte={''};
            	 D(n).canali=[];
            	 D(n).scrrms={};
            	 D(n).scrph={};
		 D(n).nome='ece';
            	 D(n).can=[];
            	 D(n).r=[];
            	 D(n).ncan=0;
            	 D(n).rms=[];
            	 D(n).srms=cell(1,8);
            	 D(n).scan=cell(1,16);
            	 a=findobj(gcbf,'tag','quali','style','listbox');
            	 if iscell(a)
                    a=a(1);
            	 end
            	 aa=get(a,'string');
            	 b=cell(1,length(aa)+1);
            	 for i=1:length(aa)
                    b(i)=cellstr(aa(i));
            	 end
            	 b(i+1)=cellstr(D(n).nome);
            	 set(a,'string',b);
               else
                  n=find(ismember(nomi,'ece'));
               end
               a=ismember(D(n).scrrms,D(n).srms(1:max(1,D(n).ncan/2)));%puoi fare find(ismember(..)) e togliere l'istruzione if ed accorciare il for.
	       k=1;
               for j=8:-1:1
                  uicontrol('units','normalized','style','checkbox','position',[0.02 0.95-0.11*k 0.3 0.1],'string',D(n).scrrms(j));
            	  if a(j);
		     uicontrol('units','normalized','style','text','position',[0.33 0.95-0.11*k 0.4 0.085],'string','Already downloaded');	
		  end
		  k=k+1;
               end
	     end
             riflx.g=uicontrol('units','normalized','position',[0.75 0.8 0.2 0.1],'string','Get data',...
		'callback','rifl riflX','userdata',n);
    	     riflx.gg=uicontrol('units','normalized','position',[0.75 0.6 0.2 0.1],'string','Finish',...
		'callback','delete(gcf)');
		
    case 'riflo'   
        
        h=figure('position',[100 100 320 250]);
	set(h,'name','O Reflectometer: download','numbertitle','off');
        switch tokamak
	   case 1
	   case 2
	      if ~ismember('riflo',nomi);
                 D(n).scritte={'cos 10';'cos9';'cos8';'cos7';'cos6';'cos5';'cos4';...
		   'cos3';'cos2';'cos1';'sin10';'sin9';'sin8';'sin7';'sin6';'sin5';'sin4';'sin3';'sin2';'sin1'};
                 D(n).canali=[10:-1:1];
                 D(n).nome='riflo';
                 D(n).scrrms={'a10','a9','a8','a7','a6','a5','a4','a3','a2','a1'};
                 D(n).scrph={'p10','p9','p8','p7','p6','p5','p4','p3','p2','p1'};
                 D(n).can=[];
                 D(n).r=[];
                 D(n).ncan=0;
                 D(n).rms=[];
                 D(n).ph=[];
                 D(n).srms=cell(1,10);
                 D(n).sph=cell(1,10);
                 D(n).scan=cell(1,20);
                 a=findobj(gcbf,'tag','quali','style','listbox');
                 if iscell(a)
                    a=a(1);
                 end
	         aa=get(a,'string');
                 b=cell(1,length(aa)+1);
                 for i=1:length(aa)
                    b(i)=cellstr(aa(i));
                 end
                 b(i+1)=cellstr(D(n).nome);
                 set(a,'string',b);
              else 
                 n=find(ismember(nomi,'riflo'));
              end
              a=ismember(D(n).scrrms,D(n).srms(1:D(n).ncan/2));
              k=1;
              for j=10:-1:1;
                 uicontrol('units','normalized','style','checkbox','position',[0.02 0.95-0.09*k 0.3 0.08],'string',D(n).scrrms(j));
                 if a(j);
                    uicontrol('units','normalized','style','text','position',[0.33 0.96-0.09*k 0.4 0.07],'string','Already downloaded');	
                 end
                 k=k+1;
              end
	   case 3
		if ~ismember('riflo',nomi);
            	   D(n).scritte={'cos 1'};
            	   D(n).canali=[1];
            	   D(n).nome='riflo';mdsopen('mdsplus.jet.efda.org::');
            	   D(n).scrrms={'a1'};
            	   D(n).can=[];
            	   D(n).r=[];
            	   D(n).ncan=0;
            	   D(n).rms=[];
            	   D(n).srms=cell(1,1);
            	   D(n).scan=cell(1,1);
            	   a=findobj(gcbf,'tag','quali','style','listbox');
            	   if iscell(a)
                      a=a(1);
            	   end
	           aa=get(a,'string');
            	   b=cell(1,length(aa)+1);
            	   for i=1:length(aa)
                      b(i)=cellstr(aa(i));
            	   end
            	   b(i+1)=cellstr(D(n).nome);
            	   set(a,'string',b);
        	else 
            	   n=find(ismember(nomi,'riflo'));
        	end
        	a=ismember(D(n).scrrms,D(n).srms(1:D(n).ncan/2));
        	k=1;
        	for j=1:-1:1;
            	   uicontrol('units','normalized','style','checkbox','position',[0.02 0.95-0.09*k 0.3 0.08],'string',D(n).scrrms(j),'value',1);
            	   if a(j);
		      uicontrol('units','normalized','style','text','position',[0.33 0.96-0.09*k 0.4 0.07],'string','Already downloaded');	
	           end
	           k=k+1;
        	end
	end
	riflo.g=uicontrol('units','normalized','position',[0.75 0.8 0.2 0.08],'string',...
		'Get data','callback','rifl riflO','userdata',n);
        riflx.gg=uicontrol('units','normalized','position',[0.75 0.6 0.2 0.08],'string','Finish','callback','delete(gcf)');
		
    case 'magn'
        
        h=figure('position',[100 100 320 300]);
	set(h,'name','Magnetics: download','numbertitle','off');
        switch tokamak
	   case 1
	      if ~ismember('magn',nomi);
                 D(n).scritte={'ch1';'ch2';'ch3';'ch4'};
                 D(n).canali=[4:-1:1];
                 D(n).nome='magn';
                 D(n).scrrms={''};
                 D(n).scrph={''};
                 D(n).can=[];
                 D(n).r=[];
                 D(n).ncan=0;
                 %D(n).ind=[];
                 D(n).rms=[];
                 D(n).ph=[];
                 D(n).srms=cell(1,4);
                 D(n).sph=cell(1,4);
                 D(n).scan=cell(1,4);
                 a=findobj(gcbf,'tag','quali','style','listbox');
                 if iscell(a)
                   a=a(1);
                 end
	         aa=get(a,'string');
                 b=cell(1,length(aa)+1);
                 for i=1:length(aa)
                    b(i)=cellstr(aa(i));
                 end
                 b(i+1)=cellstr(D(n).nome);
                 set(a,'string',b);
              else 
                 n=find(ismember(nomi,'magn'));
              end
              a=ismember(D(n).scrrms,D(n).srms(1:D(n).ncan/2));
              k=1;
              for j=10:-1:1;
                 uicontrol('units','normalized','style','checkbox','position',[0.02 0.9-0.06*k 0.3 0.1],'string',D(n).scrrms(j));
                 if a(j);
                    uicontrol('units','normalized','style','text','position',[0.33 0.95-0.09*k 0.3 0.08],'string','Already downloaded');	
	         end
                 k=k+1;
              end
           case 3
	      if ~ismember('magn',nomi);
                 D(n).scritte={'ch1';'ch2';'ch3';'ch4'};
            	 D(n).canali=[4:-1:1];
            	 D(n).nome='magn';
            	 D(n).scrrms={''};
            	 D(n).scrph={''};
            	 D(n).can=[];
            	 D(n).r=[];
            	 D(n).ncan=0;
            	 %D(n).ind=[];
            	 D(n).rms=[];
            	 D(n).ph=[];
            	 D(n).srms=cell(1,4);
            	 D(n).sph=cell(1,4);
            	 D(n).scan=cell(1,4);
            	 a=findobj(gcbf,'tag','quali','style','listbox');
            	 if iscell(a)
                    a=a(1);
            	 end
                 aa=get(a,'string');
            	 b=cell(1,length(aa)+1);
            	 for i=1:length(aa)
                    b(i)=cellstr(aa(i));
            	 end
            	 b(i+1)=cellstr(D(n).nome);
            	 set(a,'string',b);
              else 
                 n=find(ismember(nomi,'magn'));
              end
              a=ismember(D(n).scrrms,D(n).srms(1:D(n).ncan/2));
              k=1;
              for j=10:-1:1;
                 uicontrol('units','normalized','style','checkbox','position',[0.02 0.9-0.06*k 0.3 0.1],'string',D(n).scrrms(j));
            	 if a(j);
		    uicontrol('units','normalized','style','text','position',[0.33 0.95-0.09*k 0.3 0.08],'string','Already downloaded');	
		 end
                 k=k+1;
              end
	end
	magn.g=uicontrol('units','normalized','position',[0.8 0.8 0.1 0.05],'string',...
	   'Get data','callback','rifl riflo','userdata',n);
	magn.gg=uicontrol('units','normalized','position',[0.65 0.6 0.2 0.1],'string','Finish','callback','delete(gcf)');
		
     case 'ref'
        
        h=figure('position',[100 100 320 100]);
	set(h,'name','Reference signal: download','numbertitle','off');
        if ~ismember('ref',nomi);
           R(n).scritte={''};
           R(n).canali=[];
           R(n).nome='ref';
           R(n).scrrms={''};
           R(n).can=[];
           R(n).r=[];
           R(n).ncan=0;
           R(n).srms=cell(1,10);
           R(n).scan=cell(1,20);
           a=findobj(gcbf,'tag','qualiref','style','listbox');
           if iscell(a)
              a=a(1);
           end
	   aa=get(a,'string');
           b=cell(1,length(aa)+1);
           for i=1:length(aa)
              b(i)=cellstr(aa(i));
           end
           b(i+1)=cellstr(D(n).nome);
           set(a,'string',b);
        else 
           n=find(ismember(nomi,''));
        end
        a=ismember(D(n).scrrms,D(n).srms(1:D(n).ncan/2));
        k=1;
        for j=3:-1:1;
           uicontrol('units','normalized','style','checkbox','position',[0.02 0.9-0.06*k 0.3 0.1],'string',D(n).scrrms(j));
           if a(j);
              uicontrol('units','normalized','style','text','position',[0.33 0.95-0.09*k 0.3 0.08],'string','Already downloaded');	
           end
           k=k+1;
        end
        ref.g=uicontrol('units','normalized','position',[0.8 0.8 0.1 0.05],'string','Get data',...
		'callback','rifl ref','userdata',n);
	ref.gg=uicontrol('units','normalized','position',[0.65 0.6 0.2 0.1],'string','Finish','callback','delete(gcf)');
		
end
