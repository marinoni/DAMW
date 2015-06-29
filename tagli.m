function tagli

%expected reflectometer cut-off positions as a function of sqrt(psi_norm) and R
%by means of EFIT-LIUQE and Thomson scattering



global D C tmin tmax scarica

if isempty(C)
	C.rne=[];
end
tokamak=get(findobj(0,'style','popupmenu','tag','tokamak'),'value');
if iscell(tokamak)
	tokamak=cell2mat(tokamak(1));
end
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
        		disp('No density data!');
        		maxa=nan;
				maxaa=nan;
				mdsclose;
				return;
    		end
			i1=find(~isnan(a.data(:,end)));
			a.data=a.data(i1,:);
			C.neo=a.data';
    		C.tne=a.dim{2}(i1);
    		C.rne=a.dim{1};
		else
    		a=tdi('\results::th_prof_ne');
    		if or(isempty(a.data),isnan(a.data))
        		disp('No density data');
        		maxa=nan;
				maxaa=nan;
				mdsclose;
				return;
    		end
			i1=find(~isnan(a.data(end,:)));
			a.data=a.data(i1,:);
			C.neo=a.data;
    		C.tne=a.dim{1}(i1);
    		C.rne=a.dim{2};
		end
	disp('dowloading injection angles')
	C.theta=tdi('\ecrh::launchers:theta_l:x2_7');
	if isempty(C.theta.data)
		disp('No poloidal injection angle data');
		return
	end
	C.phi=tdi('\ecrh::launchers:phi_l:x2_7');
	if isempty(C.phi.data)
		disp('No toroidal injection angle data');
		return
	end
	disp('Injection angles information downloaded')
	disp('dowloading equilibrium data')
	C.psi=tdi('\results::psi');
	C.rcont=tdi('\results::r_contour');
	C.z_axis=tdi('\results::z_axis');
	C.btor=tdi('\magnetics::rbphi');
	C.ip=tdi('\magnetics::iplasma:trapeze');
	disp('equilibrium data downloaded')
    mdsclose;
	end
	disp('Saving equilibrium data');
	if exist(strcat(sprintf('turbo_%d',scarica),'.mat'))
		%save(sprintf('turbo_%d',scarica),'C','-append');
	else
		%save(sprintf('turbo_%d',scarica),'C');
	end
	disp(sprintf('Data saved as turbo_%d',scarica));
end
if or(isempty(tmin),isempty(tmax))
	tmin=C.tne(1);
	tmax=C.tne(end);
	disp('Warning: time interval has not been selected.')
	disp('The hole Thomson diagnostic time interval has been used in the computation');
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
	rho=linspace(-1,1,81);
	tn=find(C.tne>tmin & C.tne<tmax);
	if isempty(tn)
		tn=iround(C.tne,(tmin+tmax)/2)
	end
	%i1=iround(C.theta.dim{1},(tmin+tmax)/2);
	%theta1=C.theta.data(i1);
	%phi1=C.phi.data(i1);
	i1=find(C.theta.dim{1}>tmin & C.theta.dim{1}<tmax);
	if isempty(i1)
		i1=iround(C.theta.dim{1},(tmin+tmax)/2)
	end
	theta1=mean(C.theta.data(i1));
	phi1=mean(C.phi.data(i1));
	if theta1==90
		theta1=eps;
	end
	%Coordinates of pivot points of the two mirrors
	P1=[1.3072 0.0537];
	P2=[1.1906 -0.0695];
	M1=tan(52.013*pi/180);%Angular coefficient of the inping beam on the rotatable mirror.
	BETA=(52.013-theta1)/2*pi/180;%Angle of the rotatable mirror with respect to the horizontal direction
	M2=tan(BETA);%Angular coefficient of the rotatable mirror.
	P3=[P2(1)-0.01*sin(BETA) P2(2)+0.01*cos(BETA)];
	A=[M1 -1;M2 -1];%matrix to solve the intercepted point between mirror surface and inping beam.
	B=[P1(1)*M1-P1(2);P3(1)*M2-P3(2)];
	P4=A\B;%Starting point of the beam on the rotatable mirror.
	
	mr=tdi('\results::psitbx:as');
	if isempty(mr.data)
		amin=0.25;
	else
		i1=iround(-mr.dim{2},theta1*pi/180);%minus sign is due to different conventions in psitbx and ecrh node
		i2=iround(mr.dim{3},(tmin+tmax)/2);
		amin=mr.data(end,i1,i2);
	end
	tm=find(C.ip.dim{1}>tmin & C.ip.dim{1}<tmax);
	ip=mean(C.ip.data(tm));
	ne=mean(C.neo(:,tn),2)';
	ne=[ne(end:-1:2) ne];
	btor=mean(C.btor.data(tm))./(0.88+rho*amin/cos(pi/180*theta1));
	%Extrapolate up to zero density
	if ne(end)
		rho=[rho rho(end)+ne(end)*abs((rho(end)-rho(end-1))/(ne(end)-ne(end-1)))];
		ne=[ne 0];
		btor=[btor 1.44*0.88/(0.88+rho(end)*amin/cos(pi/180*theta1))];
	end
	%.....frequenze cut-off modo O-X.....
	omega=str2num(get(findobj(gcbf,'style','edit','tag','freq'),'string'));
	omega=omega*2*pi*1e9;
	OML=sqrt(cost1*ne+(cost2*btor).^2)-cost2*abs(btor);
	OMU=sqrt(cost1*ne+(cost2*btor).^2)+cost2*abs(btor);
	OMO=sqrt(cost1*ne);
	figure
	plot(rho,OML,rho,OMU,rho,OMO)
	legend('X-M-Low','X-M-Up','O-M')
	line([rho(1) rho(end)],[omega omega])
	%Searching for indexes before and after cut-off and the linear interpolation
	ind=find(OMO>=omega);
	if isempty(ind)
		rhoo=nan;
	else
		ind=ind(end);
		rhoo=interp1(OMO(ind:ind+1)-omega,rho(ind:ind+1),0);	
	end
	%rhoo=interp1(OMO(41:end)-omega,rho(41:end),0);
	ind=find(OMU>=omega);
	if isempty(ind)
		rhox=nan;
	else
		ind=ind(end);
		rhox=interp1(OMU(ind:ind+1)-omega,rho(ind:ind+1),0);	
	end
	ind=find(OML>=omega);
	if isempty(ind)
		rhox=[rhox nan];
	else
		ind=ind(end);
		rhox=interp1(OMU(ind:ind+1)-omega,rho(ind:ind+1),0);
	end
	%rhox=[interp1(OMU-omega,rho,0) interp1(OML-omega,rho,0)];
	i1=iround(C.psi.dim{3},tmin);
	i2=iround(C.psi.dim{3},tmax);
	zaxis=mean(C.z_axis.data(i1:i2));
	rcont=mean(C.rcont.data(:,i1:i2),2);
	psi1=mean(C.psi.data(:,:,i1:i2),3);
	if mean(C.ip.data)>0
		psi1=max(max(psi1))-psi1;
	else
		psi1=psi1+abs(min(min(psi1)));
	end
	N=400;%Number of grid points for psi interpolation
	[x,y]=meshgrid(C.psi.dim{2},C.psi.dim{1});
	ZZ=linspace(C.psi.dim{2}(1),C.psi.dim{2}(end),N);
	RR=linspace(C.psi.dim{1}(1),C.psi.dim{1}(end),N);
	[x1,y1]=meshgrid(ZZ,RR); 
	psi=interp2(x,y,psi1,x1,y1,'*spline');
	psimax=psi(iround(RR,max(rcont)),iround(ZZ,zaxis));
	deltr=0;
	indxx=length(RR);
	%indzx=iround(ZZ,0);
	zinit=P4(2)+tan(theta1*pi/180)*(P4(1)-RR(end));%initial height of the beam at the last point of the calculated equilibrium
	indzx=iround(ZZ,zinit);
	indxo=length(RR);
	%indzo=iround(ZZ,0);
	indzo=indzx;
	psi=psi/psimax;
	psirho=psi(indxx,indzx);
	if ~isnan(max(rhox))
		while(psirho>max(rhox))
			indxx=indxx-1;
			indzx=iround(ZZ,zinit+deltr*tan(theta1*pi/180));
			psirho=psi(indxx,indzx);
			deltr=RR(end)-RR(indxx);
		end
	end
	psirho=psi(indxo,indzo);
	deltr=0;
	if ~isnan(rhoo)
		while(psirho>max(rhoo))
			indxo=indxo-1;
			indzo=iround(ZZ,zinit+deltr*tan(theta1*pi/180));
			psirho=psi(indxo,indzo);
			deltr=RR(end)-RR(indxo);
		end
	end
	figure
	contour(RR,ZZ,psi',50)
	axis equal
	colorbar
	hold on
	k0=2*pi/0.4283; %k0 of the microwave expressed in cm-1
	if ~isnan(max(rhox))
		tanang=-(psi(indxx+1,indzx)-psi(indxx-1,indzx))/(psi(indxx,indzx+1)-psi(indxx,indzx-1));
		tanang=tanang*(ZZ(indzx+1)-ZZ(indzx-1))/(RR(indxx+1)-RR(indxx-1));
		scattang=theta1*pi/180+atan(tanang)-pi/2;
		kscattx=-2*k0*sin(scattang);
		line([RR(end) RR(indxx)],[zinit zinit+tan(theta1*pi/180)*(RR(end)-RR(indxx))]);
		plot(RR(indxx),ZZ(indzx),'*')
		plot(P4(1),P4(2),'+')
	else 
		kscattx=nan;
	end
	if ~isnan(max(rhoo))
		tanang=-(psi(indxo+1,indzo)-psi(indxo-1,indzo))/(psi(indxo,indzo+1)-psi(indxo,indzo-1));
		tanang=tanang*(ZZ(indzo+1)-ZZ(indzo-1))/(RR(indxo+1)-RR(indxo-1));
		scattang=theta1*pi/180+atan(tanang)-pi/2;
		kscatto=-2*k0*sin(scattang);
		line([RR(end) RR(indxo)],[zinit zinit+tan(theta1*pi/180)*(RR(end)-RR(indxo))]);
		plot(RR(indxo),ZZ(indzo),'r*')
		plot(P4(1),P4(2),'+')
	else 
		kscatto=nan;
	end
	%plot
	scr=get(0,'screensize');
	a=0.4;
	f(1)=scr(1)+scr(3)*(1-a)/2;
	f(2)=scr(2)+scr(4)*(1-a)/2;
	f(3)=scr(3)*a;
	f(4)=scr(4)*a/2;
	h=figure('position',[f(1) f(2) f(3) f(4)]);
	set(h,'name','Reflectometer cut-off positions','numbertitle','off');
	risp.due=uicontrol('units','normalized','style','text','position',[0.1 0.54 0.4 0.4],'string',...
	'O Reflectometer','Fontweight','demi','fontsize',14,'fontname','times');
	for i=1:length(rhoo)
		if ~isnan(rhoo(i))
			uicontrol('units','normalized','style','text','position',[0.1 0.54-i*0.4 0.4 0.4],'string',...
			strcat([mat2str(omega(i)/2/pi*1e-9),' GHz: ',' rho= ',mat2str(rhoo(i),3),' ','k = ',num2str(kscatto,2),' ','cm-1']));
		else
			uicontrol('units','normalized','style','text','position',[0.1 0.54-i*0.4 0.4 0.4],'string',...
			strcat([mat2str(omega(i)/2/pi*1e-9),' GHz: ','No cut-off']));
		end
	end
	risp.due=uicontrol('units','normalized','style','text','position',[0.5 0.54 0.4 0.4],'string',...
	'X Reflectometer','Fontweight','demi','fontsize',14,'fontname','times');
	for i=1:length(rhox)
		if ~isnan(rhox(i))
			uicontrol('units','normalized','style','text','position',[0.5 0.54-i*0.4 0.4 0.4],'string',...
			strcat([mat2str(omega/2/pi*1e-9),' GHz: ',' rho= ',mat2str(rhox(i),3),' ','k = ',num2str(kscattx,2),' ','cm-1']));
		else
			uicontrol('units','normalized','style','text','position',[0.5 0.54-i*0.4 0.4 0.4],'string',...
			strcat([mat2str(omega/2/pi*1e-9),' GHz: ','No cut-off']));
		end
	end
end

%introduci parametro di errore ed imponi che se tale parametro e' superiore
%alla differenza fra posizione di taglio dei modi O ed X, allora i due modi
%possono essere confrontati.

%
