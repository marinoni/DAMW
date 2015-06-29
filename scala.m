function scala(cosa)
	
if nargin==0
	disp('Which scale would you like to change ?')
	return
end
if cosa=='x'
	a=get(gca,'xscale');
end
if cosa=='y'
	a=get(gca,'yscale');
end
scale={'linear','log'};
b=find(~ismember(scale,a));
set(gca,strcat(cosa,'scale'),scale{b});
