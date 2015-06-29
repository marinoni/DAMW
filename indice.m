function indice(quanti)

global D;
DATI=get(gcbo,'userdata');
switch quanti
    
    case 'uno'
        f=[DATI.fre(1) DATI.fre(end)];
        g=[2 1];
        while (g(2)<g(1)) 
            [g,gg]=ginput(2);
        end
        fmin=max(f(1),g(1));
        fmax=min(f(2),g(2));
        ff=find((DATI.fre>fmin)&(DATI.fre<fmax));
        [c,s,mu]=polyfit(log(DATI.fre(ff)),log(DATI.mod(ff)),1);
        %[d,ss,mu1]=polyfit(DATI.fre(ff),DATI.mod(ff)',1);
        text(fmin,DATI.mod(ff(1)),num2str(c(1)),'fontsize',18);
        hold on;
        k=polyval(c,log(DATI.fre(ff)),s,mu);
        loglog(DATI.fre(ff),exp(k),'r');
        hold off;
        chi2=sum(((k-log(DATI.mod(ff))).^2)./(-k));
        p=chi2cdf(chi2,length(k)-3);
        disp(strcat('chi-square probability: ',num2str(p)));
        
    case 'multipli'
        si=size(DATI.mod,2);
        f=[DATI.fre(1) DATI.fre(length(DATI.fre))];
        g=[2 1];
        while (g(2)<g(1)) 
            [g,gg]=ginput(2);
        end
        fmin=max(f(1),g(1));
        fmax=min(f(2),g(2));
        ff=find((DATI.fre>fmin)&(DATI.fre<fmax));
        [c,s,mu]=polyfit(log(DATI.fre(ff)),log(DATI.mod(ff,DATI.n)),1);
        %[d,ss,mu1]=polyfit(DATI.fre(ff),DATI.mod(ff,DATI.n)',1);
        text(fmin,DATI.mod(ff(1),DATI.n),num2str(c(1)),'fontsize',18);
        hold on;
        k=polyval(c,log(DATI.fre(ff)),s,mu);
        plot(DATI.fre(ff),exp(k),'r');
        hold off;
        chi2=sum(((k-log(DATI.mod(ff))).^2)./(-k));
        p=chi2cdf(chi2,length(k)-3);
        disp(strcat('chi-square probability: ',num2str(p)));
       
end
