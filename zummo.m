%Equalizzatore di zoom per vari subplot, bottone sull'interfaccia richiama un
%file di O.Sauter

addpath /home/sauter/matlab
n=get(gcf,'children');
b=nan*ones(1,length(n));
for i=1:length(n)
	if strcmp(get(n(i),'type'),'axes')
		a=get(n(i),'xlim');
		b(i)=a(2)-a(1);
	end
end
[hh,h]=min(b);
modsubplot([get(n(h),'xlim')]);
