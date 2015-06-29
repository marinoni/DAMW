function ottieni

global D R O tot tmin valuta;
%vettore indici per matrice di densita'
m=get(gcbo,'userdata');
vett=[];
for j=1:length(D)
	if and(valuta(j),O(j).analisi_diag)
		D(j).hh=[];
        D(j).telms=[];
        for i=1:length(m)
            D(j).hh=[D(j).hh iround(D(j).t,R.ta(m(i)));]; % version Matlab 6.5
        end
        tot=0;
        D(j).trovamin=iround(D(j).t,tmin);%version Matlab 6.5
		for i=1:length(m)/2
            D(j).telms=[D(j).telms; (D(j).hh(2*i-1):D(j).hh(2*i))'];
            tot=tot+R.ta(m(2*i))-R.ta(m(2*i-1));
        end
        D(j).telms=D(j).telms-D(j).trovamin;
		D(j).hh=D(j).hh-D(j).trovamin;
    end
end
close
