function prob_rifl(scarica,t)
	
load(sprintf('turbo_%d.mat',scarica));
i1=iround(D.t,t(1));
i2=iround(D.t,t(2));
y1=D.r(i1:i2,2);
y2=D.r(i1:i2,4);
[c,t]=xcorr(detrend(y1),detrend(y2),'coeff');
a=iround(t,0);
c(a)
[c,f]=cohere(detrend(y1),detrend(y2),4096,5e5,hanning(4096),2048);
[P,f]=csd(detrend(y1),detrend(y2),4096,5e5,hanning(4096),2048);
plot(f,180/pi*unwrap(atan2(imag(P),real(P))));
figure
plot(f,c);
