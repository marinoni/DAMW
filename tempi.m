function tempi

global D R C scarica tokamak;
figure;
for i=1:length(D)
   if ~isempty(D(i).ncan)
      plot(D(i).t,D(i).r(:,1)/((1+i)*max(D(i).r(:,1))),'g');
      hold on;
   end
end
plot(R.ta,R.a/max(R.a));
t.scelta=uicontrol('units','normalized','string','Choose','position',...
[0.01 0.01 0.1 0.05],'callback','istanti');
%Porcata per evitare di far 2 volte le istruzioni nell'if sotto
%cioe' controllare che C esistea e che sia un struttura e che ci siano dentro i parametri dei plateaux
tokamak=get(findobj(0,'style','popupmenu','tag','tokamak'),'value');

if iscell(tokamak)
   tokamak=cell2mat(tokamak(1));
end

if tokamak==2
   if isempty(C)
      C.ts=[];
   end
   if ~ismember('twin',fieldnames(C))
      mdsopen('mdsplus.jet.efda.org::');
      ntrig=mdsvalue(['jpfsca("DI/G8B-NT<001",',num2str(scarica),')']);
      %delay1=mdsvalue(['jpfraw("DI/G8B-DELAY>001",',num2str(scarica),')']);
      %delay1=integer32to16(delay1)*1.e-7;
      delay2=mdsvalue(['jpfraw("DI/G8B-DELAY<001",',num2str(scarica),')']);
      delay2=delay2*1.e-7;
      for i=1:ntrig 
         C.t=mdsvalue(['jpfraw("DI/G8B-TRIG>00',num2str(i),'",',num2str(scarica),')']);
	 C.twin(i)=integer32to16(C.t)*1.e-7+delay2;
      end
      C.ts=mdsvalue(strcat('jpfsca("DI/G8B-FS<001",',num2str(scarica),')'))*1.e-7;
      C.nplat1=mdsvalue(strcat('jpfsca("DI/G8B-NPLAT>001",',num2str(scarica),')'));
      C.pplat2=mdsvalue(strcat('jpfsca("DI/G8B-PPLAT<001",',num2str(scarica),')'));
      mdsclose;
      save(sprintf('turbo_%d',scarica),'C','-append');
      disp(sprintf('data saved as turbo_%d',scarica));
   end
   for i=1:length(C.twin)
      for j=1:C.nplat1
         line([C.twin(i)+(j-1)*C.ts*C.pplat2 C.twin(i)+(j-1)*C.ts*C.pplat2],[0 1],'color','k','linestyle','--');
      end
   end
end
