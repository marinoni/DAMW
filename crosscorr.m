function crosscorr(segn1,segn2,pt)

ft=fft(segn1+i*segn2,2*pt);
a=[2*pt:-1:1];
ftx=(ft+conj(ft(a)))/2;
fty=(ft-conj(ft(a)))/(2*i);
sft=ifft((conj(ftx).*fty),2*pt)/(2*pt);
x=pt./[pt:-1:1];
cc=real(sft(1:pt));
plot(1:pt,cc);
