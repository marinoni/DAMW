% Function for reading the KG8b reflectometer settings for the VME fast data acquisition system
% 
% Input: shot number 
%
% S. Hacquin 01/05/2003

function [time,fs,med1,nplat1,pplat2,freq2]=VME_info(numshot);

mdsopen('mdsplus.jet.efda.org::');

med1=mdsvalue(['jpfraw("DI/G8B-MED>001",',num2str(numshot),')']);
med2=mdsvalue(['jpfraw("DI/G8B-MED<001",',num2str(numshot),')']);
ntrig=mdsvalue(['jpfsca("DI/G8B-NT<001",',num2str(numshot),')']);
disp(' ');
disp(['Number of measurement windows: ',num2str(med1),'   (',num2str(med2),')']);
disp(['Number of received triggers: ',num2str(ntrig)]);

delay1=mdsvalue(['jpfraw("DI/G8B-DELAY>001",',num2str(numshot),')']);
delay1=integer32to16(delay1)*1.e-7;
delay2=mdsvalue(['jpfraw("DI/G8B-DELAY<001",',num2str(numshot),')']);
delay2=delay2*1.e-7;
t0=mdsvalue(['jpfraw("DI/G8B-TRIG>000",',num2str(numshot),')']);
t0=integer32to16(t0)*1.e-7+delay1;
for i=1:ntrig 
   t=mdsvalue(['jpfraw("DI/G8B-TRIG>00',num2str(i),'",',num2str(numshot),')']);
   twin(i)=integer32to16(t)*1.e-7+delay1;
end
disp(' ');
disp(['Start of VME slow acquisition window (s): ',num2str(t0)]);
disp(['Start of VME fast acquisition windows (s): ',num2str(twin(1:med1)),'      (',num2str(twin(ntrig)),')']);

fs=mdsvalue(strcat('jpfsca("DI/G8B-FS>001",',num2str(numshot),')'))*1.e3;
ts=mdsvalue(strcat('jpfsca("DI/G8B-FS<001",',num2str(numshot),')'))*1.e-7;
disp(' ');
disp(['Sampling frequency (kHz): ',num2str(fs/1.e3),'  (',num2str(1.e-3/ts),')']);

nplat1=mdsvalue(strcat('jpfsca("DI/G8B-NPLAT>001",',num2str(numshot),')'));
nplat2=mdsvalue(strcat('jpfsca("DI/G8B-NPLAT<001",',num2str(numshot),')'));
%pplat1=mdsvalue(strcat('jpfraw("DI/G8B-PPLAT>001",',num2str(numshot),')'))
%pplat1=integer32to16(pplat1)
pplat2=mdsvalue(strcat('jpfsca("DI/G8B-PPLAT<001",',num2str(numshot),')'));
pwin=mdsvalue(strcat('jpfsca("DI/G8B-TNS<001",',num2str(numshot),')'));
disp(['Number of plateaux (frequency steps): ',num2str(nplat1),'   (',num2str(nplat2),')']);
disp(['Number of samples by plateau: ',num2str(pplat2)]);
disp(['Number of samples by window: ',num2str(pwin),'   (',num2str(nplat2*pplat2),')']);
time2=mdsvalue(strcat('jpfsca("DI/G8B-TIME<001",',num2str(numshot),')'));
for i=1:med1
  time((i-1)*pwin+1:i*pwin)=time2((i-1)*pwin+1)+(0:pwin-1)*ts;
end
 
freq=zeros(nplat1,4);
for j=1:4
  for i=1:nplat1
    fr=mdsvalue(['jpfraw("DI/G8B-S',num2str(j),'PLT>00',num2str(i),'",',num2str(numshot),')']);
    freq(i,j)=integer32to16(fr);
  end
end 
freq2=zeros(nplat1+1,4);
for j=1:4
  freqtab=[];
  ftab=mdsvalue(['jpfsca("DI/G8B-PTAB<00',num2str(j),'",',num2str(numshot),')']);
  for i=1:length(ftab)
    freqtab=[freqtab,char(mod(ftab(i),256))];
  end
  a=str2num(freqtab);
  if length(a) < nplat1+1
    a=[a;zeros(nplat1+1-length(a),1)];
  end
  freq2(:,j)=a(1:nplat1+1);
end   
freq2(1:nplat1,3)=freq2(1:nplat1,3)-3.e6;
disp(' ');
disp('Frequency differences between fixed and swept channels (in kHz)');
disp(' ');
disp('     System 1    System 2    System 3    System 4');
disp(' ');
disp(freq2);  
disp([]);
disp(freq);  

return;
