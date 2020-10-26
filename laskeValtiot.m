function kaikki = laskeValtiot()
    global C;
    global nl;
    global kaikkiValtiot;
    global maanosat;
    valtiot = [];
    for j=2:nl
        temp = C{j}(kaikkiValtiot);
        paikka = string(temp{1});
        valtiot = [valtiot paikka];
    end
    kaikki = unique(string(valtiot));
end