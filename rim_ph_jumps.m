function rim_ph_jump(j)

%h = uibuttongroup('visible','off','Position',[0 0 .2 1]);
%u0 = uicontrol('Style','Radio','String','Option 1',...
%    'pos',[10 110 100 30],'parent',h);
%u1 = uicontrol('Style','Radio','String','Option 2',...
%    'pos',[10 80 100 30],'parent',h);
%u2 = uicontrol('Style','Radiobutton','String','Option 3',...
%    'position',[10 50 100 30],'parent',h,'handlevisibility','on');
%P=varargin;
%cell2mat(P(1))
%cell2mat(P(2))
%load sumsin; s = sumsin;
%load('turbo_62209.mat');
%i1=find(D(1).t>39,1,'first');
%i2=find(D(1).t<39.3,1,'last');
%t=i1:i2;
%c=D(1).r(i1:i2,1);
%s=D(1).r(i1:i2,2);
%c=c-mean(c);
%s=s-mean(s);
%sig=unwrap(atan2(s,c));
%s=wden(s1,'rigrsure','s','mln',1,'db3');
%der=diff(s);
%m=mean(der);
%v=std(der);
%der=[der(1) der'];
%s=sin(2*pi*t/200).*heaviside(500-t)+cos(2*pi*(t-500)/20).*heaviside(t-500);
%s(500)=1;
x=[1:1000]';
s=0;
for i=1:10
    r1=randn(1);
    r2=randn(1);
    if r1>0
        s=s+2*pi*heaviside(x-80*i);
    else
        s=s-2*pi*heaviside(x-80*i);
    end
    s(80*i)=(s(80*i-2)+s(80*i+2))/2;
    if r2>0
        s(80*i-1)=(s(80*i-2)+s(80*i))/2;
        s(80*i+1)=(s(80*i+2)+s(80*i))/2;
    end
end
s=awgn(s,20);
s1=s;
% Decomposizione del segnale al livello n, utilizzando diverse wavelets.
w1='db1';
w2='db2';
%w3='db4';
n1=wmaxlev(length(x),w1);
n2=wmaxlev(length(x),w2);
%n3=wmaxlev(length(x),w3);
n=[n1,n2];
[h,k]=min(n);
[c1,l1]=wavedec(s,n(k),w1);
[c2,l2]=wavedec(s,n(k),w2);
%[c3,l3]=wavedec(s,n(k),w3);
%Ricostruisci il segnale utilizzando solo i coefficienti di una data scala
d1=zeros(length(x),n(k));
d2=zeros(length(x),n(k));
d3=zeros(length(x),n(k));
for i=1:2
    d1(:,i)=wrcoef('d',c1,l1,w1,i);
    d2(:,i)=wrcoef('d',c2,l2,w2,i);
    d3(:,i)=d1(:,i).*conj(d1(:,i))+d2(:,i).*conj(d2(:,i));
end
m1=mean(d1);
m2=mean(d2);
m3=mean(d3);
v1=std(d1);
v2=std(d2);
v3=std(d3);
%dind=[];
ind=[];
for i=1:2
    ind(i).a=find(d3(:,i)>m3(i)+j*v3(i));
    for h=1:(length(ind(i).a)/2)
        [a,b,c]=polyfit((0:(ind(i).a(2*h)-ind(i).a(2*h-1)))',s1(ind(i).a(2*h-1):ind(i).a(2*h)),1);
        s1(ind(i).a(2*h-1)+1:ind(i).a(2*h)-1)=s1(ind(i).a(2*h-1)+1:ind(i).a(2*h)-1)-polyval(a,(1:(ind(i).a(2*h)-ind(i).a(2*h-1)-1))',b,c)+s1(ind(i).a(2*h-1));
        if h==length(ind(i).a)/2
            s1(ind(i).a(2*h):end)=s1(ind(i).a(2*h):end)-(s1(ind(i).a(2*h))-s1(ind(i).a(2*h-1)));
        else
            %s1(ind(i).a(2*h):ind(i).a(2*h+1))=s1(ind(i).a(2*h):ind(i).a(2*h+1))-(s1(ind(i).a(2*h))-s1(ind(i).a(2*h-1)));
            s1(ind(i).a(2*h):ind(i).a(2*(h+1))-1)=s1(ind(i).a(2*h):ind(i).a(2*(h+1))-1)-(s1(ind(i).a(2*h))-s1(ind(i).a(2*h-1)));
        end
    end
    %dind(i).a=diff(ind(i).a);
    %dind(i).a=find(dind(i).a>1);
end
for i=1:2
% Grafici 
    figure;
    subplot(411),plot(x,s,'r',x,s1); 
    title('Orig. signal'); 
    subplot(412),plot(x,d1(:,i),'g',x,m1(i)+j*v1(i),'*',x,m1(i)-j*v1(i),'*');
    subplot(413),plot(x,d2(:,i),'g',x,m2(i)+j*v2(i),'*',x,m2(i)-j*v2(i),'*');
    subplot(414),plot(x,d3(:,i),'g',x,m3(i)+j*v3(i),'*');
    hold on;
    plot(ind(i).a,d3(ind(i).a,i),'r+');
    %title(strcat('livello ',sprintf(i+1)));
    %title('livello 3');
    %title('livello 4');
end
%for i=1:1
%    a(i,:)=find(d1(i,:)>m(i)+std(i),1,'first');
%end
%length(a)
