function k = iround(t,x,sortflag)

% IROUND	Index of the nearest element
%   IROUND(T,X) returns the index of the nearest element in the monotonic
%   increasing table T for each value of X. Call IROUND with a 3rd argument if X
%   is non monotonic.

if nargin < 3
 sortflag = 0;
end
if sortflag
 [x,ksort] = sort(x);
end
k = iflooriroundmex(t,x,1);
if sortflag
 k(ksort) = k;
end
