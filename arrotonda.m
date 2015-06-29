function l=arrotonda(n)

switch n
    case 0
        l=0;
    case 1
        l=2;
    otherwise
        l=2^(ceil(log2(n)));
end
