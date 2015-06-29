function prova(segnale,pt)

ft=fft(segnale,2*pt);
ccf=ifft((conj(ft).*ft)/(2*pt),2*pt);
x=pt./[pt:-1:1];
ccft=ccf(1:pt).*x;
plot([0:pt-1],real(ccft),'r',);
