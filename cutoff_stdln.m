function [shot]=cutoff_stdln(varargin)

%expected reflectometer cut-off positions as a function of sqrt(psi_norm) and R
%by means of EFIT-LIUQE and Thomson scattering
%[shot]=cutoff_stdln(shot,freq,tmin,tmax,tokamak)
%
%Input: 
%shot=shot number;
%freq=reflectometer frequency [GHz]
%tmin=initial instant
%tmax=final istant
%tokamak=JET(1)or TCV(2) 
%
%Output: structure shot with fields
%rhox=cutoff X mode [sqrt(psi/psi_edge)];
%rhoo=cutoff O mode [sqrt(psi/psi_edge)];
%pathx=beam path (in vacuum, not optical beam path!!!) between the rotatable mirror and the plasma X mode cutoff [m]
%patho=beam path (in vacuum, not optical beam path!!!) between the rotatable mirror and the plasma O mode cutoff [m]
%anglex=angle between the X-mode cut-off flux surface and k0 [rad]
%angleo=angle between the O mode cut-off flux surface and k0 [rad]
%curv_fs_x=Radius of curvature of X-mode cut-off flux surface [m]
%curv_fs_o=Radius of curvature of O-mode cut-off flux surface [m]
%kscattx=scattering k in case of X mode [cm-1]
%kscatto=scattering k in case of O mode [cm-1]
%
%AM revised to standalone version 14/02/08
%AM	bug fixed 07/05/08
%AM added cut-off ece for first 2 harmonics 12/09/08

switch nargin
	
	case 0
		disp('Nothing provided, default: shot=33481, freq=70 GHz, tmin=1 s, tmax=1.5 s');
		shot=33481;
		freq=70;
		tmin=1;
		tmax=1.5;
		tokamak=2;
	
	case 1
		disp('No freq, time provided, default: frq=70 GHz, tmin=1s, tmax=1.5,');
		shot=varargin{1};
		freq=70;
		tmin=1;
		tmax=1.5;
		tokamak=2;
	
	case 2
		disp('No time provided, default: tmin=1s, tmax=1.5,');
		tmin=1;
		tmax=1.5;
		shot=varargin{1};
		freq=varargin{2};
		tokamak=2;
		
	case 3
		disp('No tmax provided, default: tmax=min(1.5 s, tmin+0.1 s)');
		tmin=varargin{3};
		tmax=min(1.5,tmin+0.1);
		shot=varargin{1};
		freq=varargin{2};
		tokamak=2;
	case 4
		disp('TCV tokamak assumed');
		shot=varargin{1};
		freq=varargin{2};
		tmin=varargin{3};
		tmax=varargin{4};
		tokamak=2;
		
	otherwise
		disp('Additional parameters ignored');
		shot=varargin{1};
		freq=varargin{2};
		tmin=varargin{3};
		tmax=varargin{4};
		tokamak=varargin{5};
end
C.rne=[];
if iscell(tokamak)
	tokamak=cell2mat(tokamak(1));
end
if ~ismember('neo',fieldnames(C))
	if tokamak==1
		mdsopen('mdsplus.jet.efda.org::');
		C.lidr=0;
    	[C.neo,ny]=mdsdata(sprintf('_sig=jet("ppf/nft2/prof",%d)',shot));
		if C.neo==0
			[C.neo,ny]=mdsdata(sprintf('_sig=jet("ppf/lidr/ne",%d)',shot));
			if C.neo==0
				disp('No density data')
				shot=nan;
				return
			end
			C.lidr=1;
		end
		[C.rne,y]=mdsdata('dim_of(_sig,0)');
    	[C.tne,yy]=mdsdata('dim_of(_sig,1)');
    	[C.b,by]=mdsdata(sprintf('_sig=jet("ppf/efit/btax",%d)',shot));
    	[C.rb,yy]=mdsdata('dim_of(_sig,0)');
    	[C.tb,byyy]=mdsdata('dim_of(_sig,1)');
    	[C.conv,cy]=mdsdata(sprintf('_sig=jet("ppf/efit/rmjo",%d)',shot));
    	[C.rconv,cyy]=mdsdata('dim_of(_sig,0)');
    	[C.tconv,cyyy]=mdsdata('dim_of(_sig,1)');
	else
		mdsopen(shot);
    	if shot>24799
    		a=tdi('\results::thomson.profiles.auto:ne');
    		if or(isempty(a.data),ischar(a.data))
        		disp('No density data!');
        		shot=nan;
				mdsclose;
				return;
    		end
			if strcmp('s',a.dimunits{1})
				i1=find(~isnan(a.data(:,end)));
				a.data=a.data(i1,:);
				C.neo=a.data';
    			C.tne=a.dim{1}(i1);
    			C.rne=a.dim{2};
			else
				i1=find(~isnan(a.data(end,:)));
				a.data=a.data(i1,:);
				C.neo=a.data';
    			C.tne=a.dim{2}(i1);
    			C.rne=a.dim{1};
			end
		else
    		a=tdi('\results::th_prof_ne');
    		if isempty(a.data)
        		disp('No density data');
        		shot=nan;
				mdsclose;
				return;
    		elseif isnan(a.data)
				disp('No density data');
        		shot=nan;
				mdsclose;
				return;
			end
			if strcmp('s',a.dimunits{1})
				i1=find(~isnan(a.data(:,end)));
				a.data=a.data(i1,:);
				C.neo=a.data;
    			C.tne=a.dim{2}(i1);
    			C.rne=a.dim{1};
			else
				i1=find(~isnan(a.data(end,:)));
				a.data=a.data(:,i1);
				C.neo=a.data';
    			C.tne=a.dim{1}(i1);
    			C.rne=a.dim{2};
			end
		end
	disp('dowloading injection angles')
	C.theta=tdi('\ecrh::launchers:theta_l:x2_7');
	if isempty(C.theta.data)
		disp('No poloidal injection angle data');
		shot=nan;
		mdsclose;
		return
	end
	C.phi=tdi('\ecrh::launchers:phi_l:x2_7');
	if isempty(C.phi.data)
		disp('No toroidal injection angle data');
		shot=nan;
		mdsclose;		
		return
	end
	disp('Injection angles information downloaded')
	disp('dowloading equilibrium data')
	C.psi=tdi('\results::psi');
	C.rcont=tdi('\results::r_contour');
	C.zcont=tdi('\results::z_contour');
	C.z_axis=tdi('\results::z_axis');
	C.r_axis=tdi('\results::r_axis');
	C.btor=tdi('\magnetics::rbphi');
	C.ip=tdi('\magnetics::iplasma:trapeze');
	disp('equilibrium data downloaded')
    mdsclose;
	end
	%disp('Saving equilibrium data');
	%if exist(strcat(sprintf('turbo_%d',shot),'.mat'))
		%save(sprintf('turbo_%d',shot),'C','-append');
	%else
		%save(sprintf('turbo_%d',shot),'C');
	%end
	%disp(sprintf('Data saved as turbo_%d',shot));
end
if tmin<C.tne(1)
	disp('tmin<first exp time point, this one will be taken');
	tmin=C.tne(1);
end
if tmax>C.tne(end)
	tmax=C.tne(end);
	disp('tmax>last exp time point, this one will be taken');
	if tmin>tmax
		tmin=tmax-0.5;
		disp('tmin set to tmax-0.5 s');
	end
end
cost1=3180.96;    	%e^2/(epsilon0*me) 
cost2=8.8*10^10;  	%e/(2*me)
cost3=1.7588e11;	%e/me
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
	
	%.....frequenze cut-off modo X.....
	omegax=2*pi*1e9*[76;85;96;100];
	OMECE=cost3.*btor;
	OML=sqrt(cost1*ne+(cost2*btor).^2)-cost2*btor;
	OMU=sqrt(cost1*ne+(cost2*btor).^2)+cost2*btor;
	%passx=find(omegax>max(OMU));
	%passx1=find(omegax>max(OML) & omegax<min(OMU));
	XU=interp1(OMU,R,omegax);
	XL=interp1(OML,R,omegax);
	XECE=interp1(OMECE,R,omegax);
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
	
	XECE=interp1(OMECE,R,omegao);
	rhoo=interp1(R,C.rconv,XO);
	rhox=interp1(R,C.rconv,XU);
	rhoece=interp1(R,C.rconv,XECE);
	
	%plot, uncomment the following to plot results in a figure
	%scr=get(0,'screensize');
	%a=0.45;
	%f(1)=scr(1)+scr(3)*(1-a)/2;
	%f(2)=scr(2)+scr(4)*(1-a)/2;
	%f(3)=scr(3)*a;
	%f(4)=scr(4)*a;
	%h=figure('position',[f(1) f(2) f(3) f(4)]);
	%set(h,'name','Reflectometer cut-off positions','numbertitle','off');
	%risp.uno=uicontrol('units','normalized','style','text','position',[0.05 0.94 0.4 0.05],'string',...
	%'X Reflectometer','Fontweight','demi','fontsize',14,'fontname','times');
	%for i=1:4
	%	if ~isnan(XU(i))
	%		uicontrol('units','normalized','style','text','position',[0.05 0.94-i*0.08 0.4 0.05],'string',...
	%		strcat(mat2str(omegax(i)/2/pi*1e-9),' GHz: ',' R=',mat2str(XU(i),3),' m - rho= ',mat2str(rhox(i),3)));
	%	else
	%		uicontrol('units','normalized','style','text','position',[0.05 0.94-i*0.08 0.4 0.05],'string',...
	%		strcat([mat2str(omegax(i)/2/pi*1e-9),' GHz: ','No resonance']));
	%	end
	%end
	%risp.due=uicontrol('units','normalized','style','text','position',[0.55 0.94 0.4 0.05],'string',...
	%'O Reflectometer','Fontweight','demi','fontsize',14,'fontname','times');
	%for i=1:length(XO)
	%	if ~isnan(XO(i))
	%		uicontrol('units','normalized','style','text','position',[0.55 0.94-i*0.08 0.4 0.05],'string',...
	%		strcat(mat2str(omegao(i)/2/pi*1e-9),' GHz: ',' R=',mat2str(XO(i),3),' m - rho= ',mat2str(rhoo(i),3)));
	%	else
	%		uicontrol('units','normalized','style','text','position',[0.55 0.94-i*0.08 0.4 0.05],'string',...
	%		strcat([mat2str(omegao(i)/2/pi*1e-9),' GHz: ','No resonance']));
	%	end
	%end
else
	tn=find(C.tne>tmin & C.tne<tmax);
	if isempty(tn)
		tn=iround(C.tne,(tmin+tmax)/2);
		disp('Datatime may too small for Thomson: only one point taken corresponding to (tmin+tmax)/2');
	end
	%i1=iround(C.theta.dim{1},(tmin+tmax)/2);
	%theta1=C.theta.data(i1);
	%phi1=C.phi.data(i1);
	i1=find(C.theta.dim{1}>tmin & C.theta.dim{1}<tmax);
	if isempty(i1)
		i1=iround(C.theta.dim{1},(tmin+tmax)/2);
		disp('Datatime may too small for mirror angle acq. rate: only one point taken corresponding to (tmin+tmax)/2');
	end
	theta1=nanmean(C.theta.data(i1));
	phi1=nanmean(C.phi.data(i1));
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
	
	%Fewer operations hereafter involving theta1, 'cause always in trigonometric functions
	theta1=pi/2-theta1*pi/180;
	
	tm=find(C.ip.dim{1}>tmin & C.ip.dim{1}<tmax);
	ip=nanmean(C.ip.data(tm));
	
	ne1=mean(C.neo(:,tn),2)';
	dump=find(~isnan(ne1));
	ne1=ne1(dump);
	
	if isempty(ne1)
		disp('A combination of NaN gives no useful data points');
		kscatto=nan;
		kscattx=nan;
		angleo=nan;
		anglex=nan;
		patho=nan;
		pathx=nan;
		curv_fs_o=nan;
		curv_fs_x=nan;
		rhoo=nan;
		rhox=nan;
		return
	end
	
	i1=iround(C.psi.dim{3},tmin);
	i2=iround(C.psi.dim{3},tmax);
	raxis=nanmean(C.r_axis.data(i1:i2));
	zaxis=nanmean(C.z_axis.data(i1:i2));
	if i1~=i2
		rcont=nanmean(C.rcont.data(:,i1:i2)');
		zcont=nanmean(C.zcont.data(:,i1:i2)');
	else 
		rcont=C.rcont.data(:,i1:i2);
		rcont=rcont(:);
		zcont=C.zcont.data(:,i1:i2);
		zcont=zcont(:);
	end
	rcont=rcont(find(~isnan(rcont)));
	zcont=zcont(find(~isnan(zcont)));
	
	r0cont=sum(rcont(2:end).*abs(diff(rcont)).*abs(zcont(2:end)))/sum(abs(diff(rcont)).*abs(zcont(2:end)));
	z0cont=sum(zcont(2:end).*abs(diff(zcont)).*abs(rcont(2:end)))/sum(abs(diff(zcont)).*abs(rcont(2:end)));
		
	psi1=mean(C.psi.data(:,:,i1:i2),3);
	
	%Depending if current was clockwise or counter-clockwise
	if nanmean(C.ip.data)>0
		psi1=max(max(psi1))-psi1;
	else
		psi1=psi1+abs(min(min(psi1)));
	end
	Rmin=max(min(rcont),P4(1)-tan(theta1)*(max(zcont)-P4(2)));
	Zmax=P4(2)+cot(theta1)*(P4(1)-Rmin);
	N=400;
	
	[x,y]=meshgrid(C.psi.dim{2},C.psi.dim{1});
	%Create grid between max min points of LCFS touched by the beam
	ZZ=linspace(P4(2)+cot(theta1)*(P4(1)-C.psi.dim{1}(end)),Zmax,N);
	RR=linspace(Rmin,C.psi.dim{1}(end),N);
	dR=RR(2)-RR(1);
	dZ=ZZ(2)-ZZ(1);
	[x1,y1]=meshgrid(ZZ,RR); 
	psi=interp2(x,y,psi1,x1,y1,'*spline');
	psimax=psi(iround(RR,max(rcont)),iround(ZZ,zaxis));
	psi=psi/psimax;
	psi=psi';
	rhopsi=sqrt(diag(psi));
	btor=abs(nanmean(C.btor.data(tm))./(RR));
	btor=btor(:);
	ne=interp1(C.rne(dump),ne1,rhopsi,'spline');
	ne(find(ne<0))=0;%Extrapolation by intepr in general gives negative densities 	
	
	%.....frequenze cut-off modo O-X.....
	omega=freq*2*pi*1e9;
	k0=omega/(2.9979*1e10); %k0 of the microwave expressed in cm-1
	OML=sqrt(cost1*ne+(cost2*btor).^2)-cost2*abs(btor);
	OMU=sqrt(cost1*ne+(cost2*btor).^2)+cost2*abs(btor);
	OMO=sqrt(cost1*ne);
	
	
	%figure, uncomment the following to plot cut-off
	%plot(rhopsi,OML,rhopsi,OMU,rhopsi,OMO)
	%legend('X-M-Low','X-M-Up','O-M')
	%line([min(rhopsi) rhopsi(end)],[omega omega])
	
	%Searching for indexes before and after cut-off and the linear interpolation
	rhoo=[];
	rhoxu=[];
	rhoxl=[];
	ind=find(OMO>=omega);
	if isempty(ind)
		rhoo=nan;
		indo=nan;
	else
		indo=ind(end);
        if indo==length(OMO)
		   rhoo=rhopsi(end);
		else
		   rhoo=interp1(OMO(indo:indo+1)-omega,rhopsi(indo:indo+1),0);	
		end
	end
	ind=find(OMU>=omega);
	if isempty(ind)
		rhoxu=nan;
		indxu=nan;
	else
		indxu=ind(end);
		if indxu==length(OMU)
		   rhoxu=rhopsi(end);
		else
		   rhoxu=interp1(OMU(indxu:indxu+1)-omega,rhopsi(indxu:indxu+1),0);	
		end
	end
	ind=find(OML>=omega);
	if isempty(ind)
		rhoxl=nan;
		indxl=nan;
	else
		indxl=ind(end);
		if indxl==length(OMU)
		   rhoxl=rhopsi(end);
		else
		   rhoxl=interp1(OMU(indxl:indxl+1)-omega,rhopsi(indxl:indxl+1),0);
		end
	end
	
	for n=1:2
	    OMECE=cost3*btor*n;
		ind=find(OMECE>=omega);
		if isempty(ind)
			rhoece(n)=nan;
			indece(n)=nan;
		else
			indece(n)=ind(end);
			if indece(n)==length(OMECE)
			    rhoece(n)=rhopsi(end);
			else
			    rhoece(n)=interp1(OMECE(indece(n):indece(n)+1)-omega,rhopsi(indece(n):indece(n)+1),0);
			end
		end
	end
	%Choice of the X branch cut-off closer to the antenna
	[rhox,dump]=max([rhoxl rhoxu]);	
	indx=[indxl indxu];
	indx=indx(dump);
	
	%figure
	%if length(RR)>length(psi)
	%	contour(RR(1:end-1),ZZ(1:end-1),sqrt(psi'),50)
	%else
	%	contour(RR,ZZ,sqrt(psi'),50)
	%end
	%axis equal
	%colorbar
	%hold on
	
	if ~isnan(rhox)
	    if indx==length(OMU)
		   dpsidr=(psi(end+1-indx,indx)-psi(end+1-indx,indx-1))/(dR);
    	   dpsidz=(psi(end+1-indx+1,indx)-psi(end+1-indx,indx))/(dZ);
		else
		   dpsidr=(psi(end+1-indx,indx+1)-psi(end+1-indx,indx-1))/(2*dR);
    	   dpsidz=(psi(end+1-indx+1,indx)-psi(end+1-indx-1,indx))/(2*dZ);
		end   
		anglex=-pi+theta1+abs(atan2(-dpsidr,dpsidz));
		kscattx=-2*k0*sin(anglex);
		pathx=norm([RR(indx)-P4(1) ZZ(end+1-indx)-P4(2)]);
		%Linear interpolation for the centre of the flux surface
		r_centre=(1-rhox)*(raxis-r0cont)+r0cont;
		z_centre=z0cont;
		curv_fs_x=norm([RR(indx)-r_centre ZZ(end+1-indx)-z_centre]);
		%line([RR(end) RR(indx)],[ZZ(1) ZZ(end+1-indx)]);
		%plot(RR(indx),ZZ(end+1-indx),'*')
	else 
		kscattx=nan;
		anglex=nan;
		pathx=nan;
		curv_fs_x=nan;
	end
	rhoo_c=max(rhoo);
	if ~isnan(rhoo_c)
		if indo==length(OMU)
		   dpsidr=(psi(end+1-indo,indo)-psi(end+1-indo,indo-1))/(dR);
    	   dpsidz=(psi(end+1-indo+1,indo)-psi(end+1-indo,indo))/(dZ);
		else
		   dpsidr=(psi(end+1-indo,indo+1)-psi(end+1-indo,indo-1))/(2*dR);
		   dpsidz=(psi(end+1-indo+1,indo)-psi(end+1-indo-1,indo))/(2*dZ);
		end
		angleo=-pi*theta1+abs(atan2(-dpsidr,dpsidz));
		kscatto=-2*k0*sin(angleo);
		patho=norm([RR(indo)-P4(1) ZZ(end+1-indo)-P4(2)]);
		%Linear interpolation for the centre of the flux surface
		r_centre=(1-rhox)*(raxis-r0cont)+r0cont;
		z_centre=z0cont;
		curv_fs_o=norm([RR(indo)-r_centre ZZ(end+1-indo)-z_centre]);
		%line([RR(end) RR(indo)],[ZZ(1) ZZ(end+1-indo)]);
		%plot(RR(indo),ZZ(end+1-indo),'r*')
	else 
		kscatto=nan;
		angleo=nan;
		patho=nan;
		curv_fs_o=nan;
	end
	
	dump=find(rhox<rhoece);
	if ~isempty(dump)
	    rhox=nan;
		pathx=nan;
		curv_fs_x=nan;
		kscattx=nan;
		messagex=strcat(['harmonic ECE resonance ',dump]);
	end
	dump=find(rhoo<rhoece);
	if rhoece>rhoo
	    rhoo=nan;
		patho=nan;
		curv_fs_o=nan;
		kscatto=nan;
		messageo=strcat(['harmonic ECE resonance ',dump]);
	end
	
	%Output in a structure
	shot.rhox=rhox;
	shot.rhoo=rhoo;
	shot.rhoece=rhoece;
	shot.pathx=pathx;
	shot.patho=patho;
	shot.anglex=anglex;
	shot.angleo=angleo;
	shot.curv_fs_x=curv_fs_x;
	shot.curv_fs_o=curv_fs_o;
	shot.kscattx=kscattx;
	shot.kscatto=kscatto;
	
	%plot, uncomment the following to plot results in a figure
	%scr=get(0,'screensize');
	%a=0.4;
	%f(1)=scr(1)+scr(3)*(1-a)/2;
	%f(2)=scr(2)+scr(4)*(1-a)/2;
	%f(3)=scr(3)*a;
	%f(4)=scr(4)*a/2;
	%h=figure('position',[f(1) f(2) f(3) f(4)]);
	%set(h,'name','Reflectometer cut-off positions','numbertitle','off');
	%risp.due=uicontrol('units','normalized','style','text','position',[0.1 0.54 0.4 0.4],'string',...
	%'O Reflectometer','Fontweight','demi','fontsize',14,'fontname','times');
	%for i=1:length(rhoo)
	%	if ~isnan(rhoo(i))
	%		uicontrol('units','normalized','style','text','position',[0.1 0.54-i*0.4 0.4 0.4],'string',...
	%		strcat([mat2str(omega(i)/2/pi*1e-9),' GHz: ',' rho= ',mat2str(rhoo(i),3),' ','k = ',num2str(kscatto,2),' ','cm-1']));
	%	else
	%		uicontrol('units','normalized','style','text','position',[0.1 0.54-i*0.4 0.4 0.4],'string',...
	%		strcat([mat2str(omega(i)/2/pi*1e-9),' GHz: ','No cut-off']));
	%	end
	%end
	%risp.due=uicontrol('units','normalized','style','text','position',[0.5 0.54 0.4 0.4],'string',...
	%'X Reflectometer','Fontweight','demi','fontsize',14,'fontname','times');
	%for i=1:length(rhox)
	%	if ~isnan(rhox(i))
	%		uicontrol('units','normalized','style','text','position',[0.5 0.54-i*0.4 0.4 0.4],'string',...
	%		strcat([mat2str(omega/2/pi*1e-9),' GHz: ',' rho= ',mat2str(rhox(i),3),' ','k = ',num2str(kscattx,2),' ','cm-1']));
	%	else
	%		uicontrol('units','normalized','style','text','position',[0.5 0.54-i*0.4 0.4 0.4],'string',...
	%		strcat([mat2str(omega/2/pi*1e-9),' GHz: ','No cut-off']));
	%	end
	%end
end
