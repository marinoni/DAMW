function tagli

%expected reflectometer cut-off positions as a function of sqrt(psi_norm) and R
%by means of EFIT and Thomson scattering

global D C tmin tmax scarica

if isempty(C)
	C.rne=[];
end
tokamak=get(findobj(gcbf,'style','popupmenu','tag','tokamak'),'value');
if ~ismember('neo',fieldnames(C))
    if tokamak==1
		mdsopen('mdsplus.jet.efda.org::');
		C.lidr=0;
    	[C.neo,ny]=mdsdata(sprintf('_sig=jet("ppf/nft2/prof",%d)',scarica));
		if C.neo==0
			[C.neo,ny]=mdsdata(sprintf('_sig=jet("ppf/lidr/ne",%d)',scarica));
			if C.neo==0
				disp('No density data')
				return
			end
			C.lidr=1;
		end
		[C.rne,y]=mdsdata('dim_of(_sig,0)');
    	[C.tne,yy]=mdsdata('dim_of(_sig,1)');
    	[C.b,by]=mdsdata(sprintf('_sig=jet("ppf/efit/btax",%d)',scarica));
    	[C.rb,yy]=mdsdata('dim_of(_sig,0)');
    	[C.tb,byyy]=mdsdata('dim_of(_sig,1)');
    	[C.conv,cy]=mdsdata(sprintf('_sig=jet("ppf/efit/rmjo",%d)',scarica));
    	[C.rconv,cyy]=mdsdata('dim_of(_sig,0)');
    	[C.tconv,cyyy]=mdsdata('dim_of(_sig,1)');
	else
		mdsopen(scarica);
    	if scarica>24799
    		a=tdi('\results::thomson.profiles.auto:ne');
    		if or(isempty(a.data),ischar(a.data))
        		disp('Assenza di dati...riprova con un''altra scarica, forse sarai piu'' fortunato!');
        		maxa=nan;
				maxaa=nan;
				mdsclose;
				return;
    		end
			C.neo=a.data';
    		C.tne=a.dim{2};
    		C.rne=a.dim{1};
		else
    		a=tdi('\results::th_prof_ne');
    		if or(isempty(a.data),isnan(a.data))
        		disp('Assenza di dati...riprova con un''altra scarica, forse sarai piu'' fortunato!');
        		maxa=nan;
				maxaa=nan;
				mdsclose;
				return;
    		end
			C.neo=a.data;
    		C.tne=a.dim{1};
    		C.rne=a.dim{2};
		end
	end
    mdsclose;
	disp('Saving equilibrium data');
	if exist(strcat(sprintf('turbo_%d',scarica),'.mat'))
		save(sprintf('turbo_%d',scarica),'C','-append');
	else
		save(sprintf('turbo_%d',scarica),'C');
	end
	disp(sprintf('Data saved as turbo_%d',scarica));
end
if or(isempty(tmin),isempty(tmax))
	tmin=C.tne(1);
	tmax=C.tne(end);
	disp('Warning: time interval has ot been selected.')
	disp('The hole LIDAR time interval has been used in the computation');
end
cost1=3180.96;      %e^2/(epsilon0*me) 
cost2=8.8*10^10;  %e/(2*me)
if tokamak==1
	tn=find(C.tne>tmin & C.tne<tmax);
	if isempty(tn)
		tn=iround(C.tne,(tmin+tmax)/2);
	end
	tc=find(C.tb>tmin & C.tb<tmax);
	if isempty(tc)
		tc=iround(C.tb,(tmin+tmax)/2);
	end
	tr=find(C.tconv>tmin & C.tconv<tmax);
	if isempty(tr)
		tr=iround(C.tconv,(tmin+tmax)/2);
	end
	nem=mean(C.neo(:,tn),2);
	R=mean(C.conv(:,tr),2);
	btor=abs(mean(C.b(:,tc),2));
	if C.lidr
		ne=interp1(C.rne,nem,R,'spline');
	else
		ne=interp1(C.rne,nem,C.rconv,'spline');
	end
		
	%Extrapolate up to zero density
	if ne(end)
		R=[R;R(end)+ne(end)*abs((R(end)-R(end-1))/(ne(end)-ne(end-1)))];
		ne=[ne;0];
		%btor=[btor;btor(1)*R(1)/R(end)]; This gives btor(end)>btor(end-1)???!!!
		btor=[btor;btor(end)-abs((btor(end)-btor(end-1))/(R(end-2)-R(end-1))*(R(end)-R(end-1)))];
		C.rconv=[C.rconv;C.rconv(end)+abs((C.rconv(end)-C.rconv(end-1))/(R(end-2)-R(end-1))*(R(end)-R(end-1)))];
	end
	btor=btor;
	%.....frequenze cut-off modo X.....
	omegax=2*pi*1e9*[76;85;96;100];
	OML=sqrt(cost1*ne+(cost2*btor).^2)-cost2*btor;
	OMU=sqrt(cost1*ne+(cost2*btor).^2)+cost2*btor;
	%passx=find(omegax>max(OMU));
	%passx1=find(omegax>max(OML) & omegax<min(OMU));
	XU=interp1(OMU,R,omegax);
	XL=interp1(OML,R,omegax);
	ooops=find(isnan(XU));
	XU(ooops)=XL(ooops);%takes the second resonance if the first one is missed

	%.....frequenze cut-off modo O.....
	omegao=2*pi*1e9*[18.6 24.3 29.1 34.1 39.6 45.2 50.5 57.7 63.8 69.6]';
	%pass=find(omegao.^2/cost1>max(ne))
	%if pass(1)>1
		%XO=interp1(ne,R,omegao(1:pass(1)-1).^2/cost1);
	%end
	XO=interp1(ne,R,omegao.^2/cost1);
	rhoo=interp1(R,C.rconv,XO);
	rhox=interp1(R,C.rconv,XU);
	%plot
	scr=get(0,'screensize');
	a=0.45;
	f(1)=scr(1)+scr(3)*(1-a)/2;
	f(2)=scr(2)+scr(4)*(1-a)/2;
	f(3)=scr(3)*a;
	f(4)=scr(4)*a;
	h=figure('position',[f(1) f(2) f(3) f(4)]);
	set(h,'name','Reflectometer cut-off positions','numbertitle','off');
	risp.uno=uicontrol('units','normalized','style','text','position',[0.05 0.94 0.4 0.05],'string',...
	'X Reflectometer','Fontweight','demi','fontsize',14,'fontname','times');
	for i=1:4
		if ~isnan(XU(i))
			uicontrol('units','normalized','style','text','position',[0.05 0.94-i*0.08 0.4 0.05],'string',...
			strcat(mat2str(omegax(i)/2/pi*1e-9),' GHz: ',' R=',mat2str(XU(i),3),' m - rho= ',mat2str(rhox(i),3)));
		else
			uicontrol('units','normalized','style','text','position',[0.05 0.94-i*0.08 0.4 0.05],'string',...
			strcat([mat2str(omegax(i)/2/pi*1e-9),' GHz: ','No resonance']));
		end
	end
	risp.due=uicontrol('units','normalized','style','text','position',[0.55 0.94 0.4 0.05],'string',...
	'O Reflectometer','Fontweight','demi','fontsize',14,'fontname','times');
	for i=1:length(XO)
		if ~isnan(XO(i))
			uicontrol('units','normalized','style','text','position',[0.55 0.94-i*0.08 0.4 0.05],'string',...
			strcat(mat2str(omegao(i)/2/pi*1e-9),' GHz: ',' R=',mat2str(XO(i),3),' m - rho= ',mat2str(rhoo(i),3)));
		else
			uicontrol('units','normalized','style','text','position',[0.55 0.94-i*0.08 0.4 0.05],'string',...
			strcat([mat2str(omegao(i)/2/pi*1e-9),' GHz: ','No resonance']));
		end
	end
else
	tn=find(C.tne>tmin & C.tne<tmax);
	if isempty(tn)
		tn=iround(C.tne,(tmin+tmax)/2)
	end
	ne=mean(C.neo(:,tn),2);
	
	%Extrapolate up to zero density
	if ne(end)
		C.rne=[C.rne;C.rne(end)+ne(end)*abs((C.rne(end)-C.rne(end-1))/(ne(end)-ne(end-1)))];
		ne=[ne;0];
	end
	
	%.....frequenze cut-off modo O.....
	omegao=2*pi*1e9*[50]';
	%pass=find(omegao.^2/cost1>max(ne))
	%if pass(1)>1
		%XO=interp1(ne,R,omegao(1:pass(1)-1).^2/cost1);
	%end
	rhoo=interp1(ne,C.rne,omegao.^2/cost1);
		
	%plot
	scr=get(0,'screensize');
	a=0.25;
	f(1)=scr(1)+scr(3)*(1-a)/2;
	f(2)=scr(2)+scr(4)*(1-a)/2;
	f(3)=scr(3)*a;
	f(4)=scr(4)*a/4;
	h=figure('position',[f(1) f(2) f(3) f(4)]);
	set(h,'name','O Reflectometer cut-off positions','numbertitle','off');
	risp.due=uicontrol('units','normalized','style','text','position',[0.1 0.54 0.8 0.4],'string',...
	'O Reflectometer','Fontweight','demi','fontsize',14,'fontname','times');
	for i=1:length(rhoo)
		if ~isnan(rhoo(i))
			uicontrol('units','normalized','style','text','position',[0.1 0.54-i*0.4 0.8 0.4],'string',...
			strcat(mat2str(omegao(i)/2/pi*1e-9),' GHz: ',' rho= ',mat2str(rhoo(i),3)));
		else
			uicontrol('units','normalized','style','text','position',[0.1 0.54-i*0.4 0.8 0.4],'string',...
			strcat([mat2str(omegao(i)/2/pi*1e-9),' GHz: ','No resonance']));
		end
	end
end

%introduci parametro di errore ed imponi che se tale parametro e' superiore
%alla differenza fra posizione di taglio dei modi O ed X, allora i due modi
%possono essere confrontati.
