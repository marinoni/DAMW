function [co,fo,to]=coergram(x,y,varargin)
%Coherence gram calculated through cohere.m 
%[co,fo,to]=coergram(x,y,Nt,Ov,Nfft,Noverlap,Window,Ft)
%Signals x and y do not need to have the same length, in this case the shorter one is zero-padded.
%Nt is the number of the points over which the coherence is calculated, default=4096
%Ov is the number of their ovelapping points, default=1024
%Nfft is the number of points over which the FFTs are calculatedin each interval, default=1024
%Noverlap is the overlapping number of points for FFTs, default=512
%Window is the anti-leakage window, default=Hanning(nfft)
%Ft is the sampling frequency, default=1 Hz. 
%Default values can be obtained by setting the value to [];

if nargin<2
	disp('Insufficient number of signals')
	return
end
if nargin>2
	nt=cell2mat(varargin(1));
	if isempty(nt)
		nt=4096;
	end
else
	nt=4096;
end
if nargin>3
	ov=cell2mat(varargin(2));
	if isempty(ov)
		ov=1024;
	end
else
	ov=1024;
end
if nargin>4
	nfft=cell2mat(varargin(3));
	if isempty(nfft)
		nfft=1024;
	end
else
	nfft=1024;
end
if nargin>5
	noverlap=cell2mat(varargin(4));
	if isempty(noverlap)
		noverlap=512;
	end
else
	noverlap=512;
end	
if nargin>6
	window=cell2mat(varargin(5));
	if isempty(window)
		window=hanning(1024);
	end
else
	window=hanning(1024);
end
if nargin>7
	ft=cell2mat(varargin(6));
	if isempty(ft)
		ft=1;
	end
else
	ft=1;
end
nx=length(x);
ny=length(y);
if nx<ny
	x(ny)=0;
else
	y(nx)=0;
end
x=x(:); % make a column vector for ease later
y=y(:);
window=window(:); % be consistent with data set
ncol=ceil((nx-ov)/(nt-ov));
colindex=1+(0:(ncol-1))*(nt-ov);
rowindex=(1:nt)';
% zero-pad x if it has length less than the total windowed length
if nx<ncol*nt-(ncol-1)*ov
    x(ncol*nt-(ncol-1)*ov)=0;  
	nx=ncol*nt-(ncol-1)*ov;
	y(ncol*nt-(ncol-1)*ov)=0;  
	ny=ncol*nt-(ncol-1)*ov;
end
% put x into columns of y with the proper offset
% should be able to do this with fancy indexing!
x1=zeros(nt,ncol);
y1=zeros(nt,ncol);
x1(:)=x(rowindex(:,ones(1,ncol))+colindex(ones(nt,1),:)-1);
y1(:)=y(rowindex(:,ones(1,ncol))+colindex(ones(nt,1),:)-1);
Cxy=[];
for i=1:ncol
	[Cxy(:,i),f]=mscohere(x1(:,i),y1(:,i),window,noverlap,nfft,ft);
end
t=(colindex-1)'/ft;
if nargout==0
	imagesc([0 1/f(2)],f,Cxy);
	axis xy; 
	colormap(jet)	
	xlabel('Time')
	ylabel('Frequency')
elseif nargout == 1,
    co=Cxy;
elseif nargout == 2,
    co=Cxy;
    fo=f;
elseif nargout == 3,
    co=Cxy;
    fo=f;
    to=t;
end
