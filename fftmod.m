function fftm=fftmod(segnale,num)

fftm=fftshift(fft(segnale,num))./(num/2);
