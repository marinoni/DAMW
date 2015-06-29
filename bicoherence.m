function [BC,f1,f2,ncol]=bicoherence(sig1,sig2,ovlap,pt,dt)
%Funzione la cui prima parte e' stata liberamente adattata da specgram.m
%Mathworks
tic;
nx1=length(sig1);
nx2=length(sig2);
window=hanning(pt);
if or(nx1<pt,nx2<pt)    % zero-pad x if it has length less than the window length
    sig1=[sig1;zeros(pt-nx1,1)];  
    nx1=pt;
    sig2=[sig2;zeros(pt-nx2,1)];  
    nx2=pt;
end
%ovlap=ceil(ovlap*pt)
%fai un vettore colonna
if size(sig1,1)==1
    sig1=sig1(:);
end
if size(sig2,1)==1
    sig2=sig2(:);
end
ncol=fix((nx1-ovlap)/(pt-ovlap));
colindex=1+(0:(ncol-1))*(pt-ovlap);
rowindex=(1:pt)';
if length(sig1)<(pt+colindex(ncol)-1)
    sig1(pt+colindex(ncol)-1)=0;   % zero-pad sig1
    sig2(pt+colindex(ncol)-1)=0;   % zero-pad sig2
end
if length(pt)==1
    y1=zeros(pt,ncol);
    y2=zeros(pt,ncol);
    %metti tutto nelle colonne di matrici
    y1(:)=sig1(rowindex(:,ones(1,ncol))+colindex(ones(pt,1),:)-1);
    y2(:)=sig2(rowindex(:,ones(1,ncol))+colindex(ones(pt,1),:)-1);
    %applica la finestra 
    y1=window(:,ones(1,ncol)).*y1;
    y2=window(:,ones(1,ncol)).*y2;
end
%construisci frequenze
ppu=ceil(pt/2);
f1=linspace(1/((pt-1)*dt),1/(2*dt),ppu);
f2=linspace(1/((pt-1)*dt),1/(4*dt),ceil(ppu/2));
%Analisi di bicoerenza
z1=fft(y1)/pt;
z2=fft(y2)/pt;
den1=zeros(ppu,ceil(ppu/2));
den2=zeros(ppu,ceil(ppu/2));
BC=zeros(ppu,ceil(ppu/2));
z1=z1(1:ppu,:);
z2=z2(1:ppu,:);
for h=1:ncol
    P2=z2(:,h).*conj(z2(:,h));
    P1=z1(:,h).*conj(z1(:,h));
    for i=1:ceil(ppu/2)
        for j=i:ppu-i
            BC(j,i)=BC(j,i)+z1(j,h)*z2(i,h)*conj(z1(i+j,h));
            den2(j,i)=den2(j,i)+P1(i+j);
            den1(j,i)=den1(j,i)+P2(i)*P1(j);
        end
    end
end
BC=BC.*conj(BC);
BC=BC./(den1.*den2);
tempo=toc
%figure;
%mesh(f2,f1,BC);
