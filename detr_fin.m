function detr_fin

global D A C O tmin tmax valuta;

el=get(findobj(gcbf,'string','Coherent ELMs'),'value');
if iscell(el)
    el=cell2mat(el(1));
end
cont=get(findobj(gcbf,'string','Force C^0','tag','ForceC^0'),'value');
if iscell(cont)
	cont=cell2mat(cont(1));
end
inc=get(findobj(gcbf,'string','Cross diagnostics'),'value');
if iscell(inc)
    inc=cell2mat(inc(1));
end
l=[];
switch el
    
   case 1
      for i=1:length(D)
         if O(i).analisi_diag
            D(i).trovamin=find(D(i).t>tmin,1,'first'); %version Matlab 7.0
            D(i).trovamax=find(D(i).t<tmax,1,'last'); %version Matlab 7.0
            %D(i).trovamin=iround(D(i).t,tmin); %version Matlab 6.5
	    %D(i).trovamax=iround(D(i).t,tmax); %version Matlab 6.5
	    D(i).Mt=D(i).telms;
            D(i).punti=length(D(i).Mt);
            D(i).dt=mean(diff(D(i).t(D(i).trovamin:D(i).trovamax)));
            %D(i).MT=D(i).t(D(i).telms+D(i).trovamin+(N-1)/2);
	    D(i).MT=D(i).t(D(i).telms+D(i).trovamin);%Controlla che sia giusto!!!
         end
      end        
    case 0
       for i=1:length(D)
          if O(i).analisi_diag
             D(i).trovamin=find(D(i).t>tmin,1,'first'); %version Matlab 7.0
             D(i).trovamax=find(D(i).t<tmax,1,'last'); %version Matlab 7.0
             %D(i).trovamin=iround(D(i).t,tmin); %version Matlab 6.5
             %D(i).trovamax=iround(D(i).t,tmax); %version Matlab 6.5
             %D(i).punti=D(i).trovamax-D(i).trovamin+1;
             %D(i).Mt=(D(i).trovamin:D(i).trovamax)';
             %D(i).MT=D(i).t(D(i).trovamin+(N-1)/2:D(i).trovamax-(N-1)/2);
             if O(i).amp
	        D(i).Mt=[1:size(D(i).rms,1)]';
		D(i).punti=size(D(i).rms,1);
	     else if O(i).phase
	        D(i).Mt=[1:size(D(i).ph,1)]';
		D(i).punti=size(D(i).ph,1);
	     end
	  end
	  %D(i).MT=D(i).t(D(i).trovamax-D(i).punti:D(i).trovamax-1);
	  D(i).MT=D(i).t(D(i).trovamin:D(i).trovamax);
          D(i).dt=mean(diff(D(i).t(D(i).trovamin:D(i).trovamax)));
       end
    end
end
h=get(findobj(gcbf,'style','listbox','tag','detrend'),'value');
if iscell(h)
   h=cell2mat(h(1));
end
valuta=zeros(1,length(D));
for i=1:length(D)
   if O(i).analisi_diag
      O(i).hr=[];
      O(i).nr=0;
      O(i).hp=[];
      O(i).np=0;
      if O(i).amp
         O(i).hr=get(findobj(gcbf,'tag',strcat(char(D(i).nome),'rms')),'value');
         %D(i).hr=D(i).hr(1:D(i).ncan/2);
         if nnz(O(i).analizza)>1
            O(i).hr=cell2mat(O(i).hr);
	    O(i).nr=length(O(i).hr);
	 else
	    O(i).nr=1;
         end
      end
      if O(i).phase
         O(i).hp=get(findobj(gcbf,'tag',strcat(char(D(i).nome),'ph')),'value');
         %D(i).hp=D(i).hp(1:D(i).ncan/2);
         if nnz(O(i).analizza)>1
            O(i).hp=cell2mat(O(i).hp);
	    O(i).np=length(O(i).hp);
	 else
            O(i).np=1;
	 end
      end
      valuta(i)=or(nnz(O(i).hp),nnz(O(i).hr));
      D(i).M=[]; 
      A(i).nomi={};

      %detrend data
      switch h       
         case 1
            if and(valuta(i),O(i).analisi_diag)
               for j=1:O(i).nr
                  if O(i).hr(O(i).nr+1-j)
                     D(i).M=[D(i).M (D(i).rms(D(i).Mt,j))];
                     A(i).nomi=cat(1,A(i).nomi,D(i).srms(j));
                  end
               end
               for j=1:O(i).np
                  if O(i).hp(O(i).np+1-j)
	             if and(cont,el)
		        SHIFT=0;
		        TEMP=D(i).ph(:,j);
		        for k=3:2:length(D(i).hh)
		           SHIFT=SHIFT+D(i).ph(D(i).hh(k-1),j)-D(i).ph(D(i).hh(k),j);
		           TEMP(D(i).hh(k):D(i).hh(k+1))=TEMP(D(i).hh(k):D(i).hh(k+1))+SHIFT;
		        end
                        D(i).M=[D(i).M TEMP(D(i).Mt)];
		     else
		        D(i).M=[D(i).M (D(i).ph(D(i).Mt,j))];
		     end
                     A(i).nomi=cat(1,A(i).nomi,D(i).sph(j));
                  end
               end
            end
         otherwise
            %D(i).coeff=[];
            if and(valuta(i),O(i).analisi_diag)
               for j=1:O(i).nr
                  if O(i).hr(O(i).nr+1-j)
                     [D(i).coef,D(i).s,D(i).mu]=polyfit(D(i).Mt,D(i).rms(D(i).Mt,j),h-2);
                     D(i).M=[D(i).M (D(i).rms(D(i).Mt,j)-polyval(D(i).coef,D(i).Mt,D(i).s,D(i).mu))];
                     A(i).nomi=cat(1,A(i).nomi,D(i).srms(j));
                  end
               end
               for j=1:O(i).np
                  if O(i).hp(O(i).np+1-j)
                     if and(el,cont)
   		        SHIFT=0;
	  	        TEMP=D(i).ph(:,j);
		        for k=3:2:length(D(i).hh)
		           SHIFT=SHIFT+D(i).ph(D(i).hh(k-1),j)-D(i).ph(D(i).hh(k),j);
		           TEMP(D(i).hh(k):D(i).hh(k+1))=TEMP(D(i).hh(k):D(i).hh(k+1))+SHIFT;
		        end
		        [D(i).coef,D(i).s,D(i).mu]=polyfit([1:D(i).punti]',TEMP(D(i).Mt),h-1);
		        D(i).M=[D(i).M (TEMP(D(i).Mt)-polyval(D(i).coef,[1:D(i).punti]',D(i).s,D(i).mu))];
		     else
		        [D(i).coef,D(i).s,D(i).mu]=polyfit(D(i).Mt,D(i).ph(D(i).Mt,j),h-2);
                        D(i).M=[D(i).M (D(i).ph(D(i).Mt,j)-polyval(D(i).coef,D(i).Mt,D(i).s,D(i).mu))];
		     end
                     A(i).nomi=cat(1,A(i).nomi,D(i).sph(j));
                  end
               end
            end
      end
      [D(i).n1x,D(i).n2x]=size(D(i).M);
      l=[l D(i).n1x]; 
   end     
end   
ll=find(min(l)==l);   
if inc
   for i=1:length(D)
      if and(i~=ll,O(i).analisi_diag)
         D(i).M=resample(D(i).M,D(ll).n1x,D(i).n1x);
         %D(i).Mt=(D(ll).trovamin:D(ll).trovamax)';
         D(i).punti=D(ll).punti;
         D(i).dt=D(ll).dt;
      end
   end
end
