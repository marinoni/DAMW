function rifl(cosa)

global D R scarica;

n=get(gcbo,'userdata');
disp('Downloading data...');
tokamak=get(findobj(0,'style','popupmenu','tag','tokamak'),'value');
switch tokamak
   case 1
   
   case 2
      mdsopen('mdsplus.jet.efda.org::');
   case 3
	mdsopen(scarica)
end
switch cosa
    
    case 'riflX'
        
	switch tokamak
	   case 1
           case 2
	      hx=cell2mat(get(findobj(gcbf,'style','checkbox'),'value'));
              kx=get(findobj(gcbf,'style','checkbox'),'string');
	      i=D(n).ncan+1;
              r=D(n).ncan/2+1;
              for k=8:-1:1
                 if and(hx(k),~ismember(kx{k},D(n).srms))
                    a=mdsdata(sprintf('_sig=jet("jpf/DI/G8B-SIG<chn:0%d",%d)',D(n).canali(k),scarica));
                    b=mdsdata(sprintf('_sig=jet("jpf/DI/G8B-SIG<chn:0%d",%d)',D(n).canali(k+8),scarica));
                    D(n).r=[D(n).r a];
                    D(n).r=[D(n).r b];
                    D(n).can=[D(n).can D(n).canali(k) D(n).canali(k+8)];
                    %D(n).ind=[D(n).ind find(D(n).canali==D(n).can(i))];
                    D(n).ncan=D(n).ncan+2;
                    D(n).scan(i)=D(n).scritte(k);
                    D(n).scan(i+1)=D(n).scritte(8+k);
                    D(n).srms(r)=D(n).scrrms(k);
                    D(n).sph(r)=D(n).scrph(k);
                    r=r+1;
                    i=i+2;    
            	end
              end
              if ~exist('D(n).t')
	         D(n).t=mdsdata('dim_of(_sig)');
	      end
	   case 3
	      hx=cell2mat(get(findobj(gcbf,'style','checkbox'),'value'));
              kx=get(findobj(gcbf,'style','checkbox'),'string');
              r=D(n).ncan;
              for k=8:-1:1
                 if and(hx(k),~ismember(kx{k},D(n).srms))
		    a=[];
		    %a=tdi('\base::tr2412_prefl:channel_001');
                    D(n).r=[D(n).r a];
                    D(n).can=[D(n).can D(n).canali(k)];
                    D(n).ncan=D(n).ncan+1;
                    D(n).scan(i)=D(n).scritte(k);
                    D(n).srms(r)=D(n).scrrms(k);    
            	 end
              end
              if ~exist('D(n).t')
	         D(n).t=a.dim{1};
	      end
	   end
            
    case 'riflO'
        
	switch tokamak
	   case 1
	   case 2
	      ho=cell2mat(get(findobj(gcbf,'style','checkbox'),'value'));
	      ko=get(findobj(gcbf,'style','checkbox'),'string');
              i=D(n).can+1;
              r=D(n).ncan/2+1;
	      for k=10:-1:1
                 if and(ho(k),~ismember(ko{k},D(n).srms))
                    a=mdsdata(sprintf('_sig=jet("lpf/cats1/di/g3-cats<cos:001",chn:0%d",%d)',D(n).canali(k),scarica))
                    b=mdsdata(sprintf('_sig=jet("lpf/cats1/di/g3-cats<sin:001",chn:0%d",%d)',D(n).canali(k+10),scarica))
                    %a=mdsdata(sprintf('_sig=jet("lpf/di/g3-cats<cos:001",chn:0%d",%d)',D(n).canali(k),scarica))
                    %b=mdsdata(sprintf('_sig=jet("lpf/di/g3-cats<sin:001",chn:0%d",%d)',D(n).canali(k+10),scarica))
		    D(n).r=[D(n).r a];
                    D(n).r=[D(n).r b];
                    D(n).can=[D(n).can D(n).canali(k) D(n).canali(k+10)];
                    %D(n).ind=[D(n).ind find(D(n).canali==D(n).can(i))];
                    D(n).ncan=D(n).ncan+2;
                    D(n).scan(i)=D(n).scritte(k);
                    D(n).scan(i+1)=D(n).scritte(k+10);
                    D(n).srms(r)=D(n).scrrms(k);
                    D(n).sph(r)=D(n).sph(k);
                    r=r+1;
                    i=i+2;
            	 end
              end
              if ~exist('D(n).t')
	         D(n).t=mdsdata('dim_of(_sig)');
	      end
	   case 3
              %ho=cell2mat(get(findobj(gcbf,'style','checkbox'),'value'));
	      ho=get(findobj(gcbf,'style','checkbox'),'value');
	      if iscell(ho)
                 ho=cell2mat(ho);
	      end
	      ko=get(findobj(gcbf,'style','checkbox'),'string');
	      i=D(n).ncan+1;
              for k=1:-1:1
                 if and(ho(k),~ismember(ko{k},D(n).srms))
                    a=tdi('\base::tr2412_prefl:channel_001');
		    %Test input signal...structure b has to be deleted once finished
		    %a=tdi('\base::tr2412_prefl:channel_002');
                    %D(n).r=[D(n).r a.data b.data];
                    D(n).r=[D(n).r a.data];
       	            D(n).can=[D(n).can D(n).canali(k)];
                    D(n).ncan=D(n).ncan+1;
                    D(n).scan(i)=D(n).scritte(k);
                    D(n).srms(i)=D(n).scrrms(k);
            	 end
              end
              if ~exist('D(n).t')
	         D(n).t=a.dim{1};
	      end
	end
		
	case 'magn'
        
	   switch tokamak
	      case 1
	      case 2
                 ho=cell2mat(get(findobj(gcbf,'style','checkbox'),'value'));
		 ko=get(findobj(gcbf,'style','checkbox'),'string');
        	 r=D(n).ncan+1;
	         for k=4:-1:1
            	   if and(ho(k),~ismember(ko{k},D(n).srms))
                      a=mdsdata(sprintf('_sig=jet("jpf/DI/C3-CATS<C:%d",%d)',D(n).canali(k),scarica))
                      D(n).r=[D(n).r a];
                      D(n).can=[D(n).can D(n).canali(k)];
                      D(n).ncan=D(n).ncan+1;
                      D(n).scan(i)=D(n).scritte(k);
                      D(n).srms(r)=D(n).scrrms(k);
                      D(n).sph(r)=D(n).sph(k);
            	   end
        	 end
        	 if ~exist('D(n).t')
		    D(n).t=mdsdata('dim_of(_sig)');
        	 end
	      case 3
	         ho=cell2mat(get(findobj(gcbf,'style','checkbox'),'value'));
		 ko=get(findobj(gcbf,'style','checkbox'),'string');
        	 r=D(n).ncan+1;
		 for k=4:-1:1
            	   if and(ho(k),~ismember(ko{k},D(n).srms))
                	%a=tdi()
                	a=[];
			D(n).r=[D(n).r a];
                	D(n).can=[D(n).can D(n).canali(k)];
                	D(n).ncan=D(n).ncan+1;
                	D(n).scan(i)=D(n).scritte(k);
                	D(n).srms(r)=D(n).scrrms(k);
                	D(n).sph(r)=D(n).sph(k);
            	   end
        	 end
        	 if ~exist('D(n).t')
			D(n).t=a.dim{1};
        	 end
		end
end
switch tokamak
   case 1
   case 2
	R.a=mdsdata(sprintf('_sig=jet("jpf/DD/S3-AD34",%d)',scarica));
	R.ta=mdsdata('dim_of(_sig)');
   case 3
	b=tdi('\base::pd:pd_002');
	R.a=b.data;
	R.ta=b.dim{1};
end
mdsclose;
disp('Data downloaded')

%elimina punti errore
R.a=R.a(find(~isnan(R.a)));
R.ta=R.ta(find(~isnan(R.a)));
for i=1:length(D)
    for j=1:D(i).ncan
        D(i).r(:,i)=D(i).r(find(~isnan(D(i).r(:,i))),i);
        D(i).t=D(i).t(find(~isnan(D(i).r(:,i))));
    end
end
