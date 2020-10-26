function kaikki = laskePaivat()
global C;
global nl;
paivat = [];
for j=2:nl
%   t = datetime(string(C{j}(3)),'InputFormat','yyyy-MM-dd');
    t = string(C{j}(3));
    paivat = [paivat t];
end
kaikki = unique(paivat);
end

