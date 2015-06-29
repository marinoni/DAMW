function canali

global D R O C scarica;

D=[];
R=[];
O=[];
C=[];
scarica=str2num(get(gcbo,'string'));
if scarica<34180
   set(findobj(gcbf,'style','edit','tag','freq'),'string',70);
else
   set(findobj(gcbf,'style','edit','tag','freq'),'string',78);
end	
nome_file=sprintf('turbo_%d.mat',scarica);
if exist(nome_file)
   disp('Loading data file...');
   load(nome_file);
   disp('Loaded diagnostics and channels :');
   a=cell(1,length(D));
   for i=1:length(D)
      O(i).analisi_diag=0;
      %By default no filtering operation on amplitude and phase
      O(i).ampwvl=0;
      O(i).ampfil=0;
      O(i).amp=0;
      if or(D(i).nome=='riflx',D(i).nome=='riflo')
         O(i).phwvl=0;
	 O(i).phfil=0;
         O(i).phase=0;
      end
      disp(D(i).nome);
      disp(D(i).scan(1:D(i).ncan));
      %disp(D(i).srms);
      a(i)=cellstr(D(i).nome);
   end
   %h=findobj(gcbf,'style','listbox','tag','quali');
   %set(h,'string',a);
else 
   D.nome={};
end
