function [xout,yout]=choose_mod(x,y,varargin)

%This function selects parts of an input signal on a modulation basis.
%t1=initial time, 0 by default
%period=period of the modulation, 1 by default
%dc=duty cycle, 0.5 by default
%part='on'=first part of the cycle, off'=second part of the cycle, 'on' by default
%cont: 1 makes the output signal continous in case of possible FFT, 0 leaves it as it is. 1 by default
%
%AM 30/01/2007
	
	if nargin<2
		disp('Insufficient number of signals')
		return
	end
	if nargin>2
		t1=cell2mat(varargin(1));
		if isempty(t1)
			t1=0;
		end
	else
		t1=0;
	end
	if nargin>3
		period=cell2mat(varargin(2));
		if isempty(period)
			period=0.5;
		end
	else
		period=1;
	end
	if nargin>4
		dc=cell2mat(varargin(3));
		if isempty(dc)
			dc=0.5;
		end
	else
		dc=0.5;
	end
	if nargin>5
		part=char(varargin(4));
		if isempty(part)
			part='on';
		end
	else
		part='on';
	end	
	if nargin>6
		cont=cell2mat(varargin(5));
		if isempty(cont)
			cont=1;
		end
	else
		cont=1;
	end	
	N=floor((x(end)-t1)/period);
	h=[t1];
	for i=1:N
		h=[h t1+(i-1)*period+period*dc t1+i*period];
	end
	ind=iround(x,h);
	xout=[];
	yout=[];
	switch(part)
		case 'on'
			for i=1:2:length(h)-1
				xout=[xout;x(ind(i):ind(i+1))];
				if and(i>1,cont)	
					yout=[yout;y(ind(i):ind(i+1))-(y(ind(i))-yout(end))];
				else
					yout=[yout;y(ind(i):ind(i+1))];
				end
			end
		case 'off'
			for i=3:2:length(h)
				xout=[xout;x(ind(i-1):ind(i))];
				if and(i>3,cont)	
					yout=[yout;y(ind(i-1):ind(i))+(yout(end)-y(ind(i-1)))];
				else
					yout=[yout;y(ind(i-1):ind(i))];
				end
			end
	end
