function istanti

global D tmin tmax;
for i=1:length(D)
    if ~isempty(D(i).ncan)
        t=[min(D(i).t) max(D(i).t)];
        break
    end
end
g=[2 1];
while (g(2)<g(1)) 
    [g,gg]=ginput(2);
end
tmin=max(t(1),g(1));
tmax=min(t(2),g(2));
close;
