function y=heaviside(x)

%Heaviside step function, 1 for x>=0, o otherwise
y=zeros(size(x));
y(x>=0)=1;
