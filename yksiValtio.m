%% PLOTS from one country
% (C) Timo J. Kärkkäinen
%% GET DATA FROM ONE COUNTRY
function yksiValtio(valtio)
    global C;
    global maanosat;
    global nl;
    global kaikkiValtiot;
    global paivat;
    global kaikkiSairaat;
    global uudetSairaat;
    global uudetSairaatTAS;
    global kaikkiKuolleet;
    global uudetKuolleet;
    global uudetKuolleetTAS;
    t = [];
    sairaat = [];
    pSairaat = [];
    pSairaatTAS = [];
    kuolleet = [];
    pKuolleet = [];
    pKuolleetTAS = [];
    % Implement region correction (rc) parameters
    if ismember(valtio,["World", "Africa", "Asia", "Europe", "North America", "Oceania", "South America"])
        rc = 1;
    else
        rc = 0;
    end
    for j=2:nl
        temp = C{j}(kaikkiValtiot - rc);
        if valtio == string(temp{1})
            t2 = datetime(string(C{j}(paivat - rc)),'InputFormat','yyyy-MM-dd');
            sairaat2   = str2double(string(C{j}(kaikkiSairaat - rc)));
            pSairaat2  = str2double(string(C{j}(uudetSairaat - rc)));
            pSairaatTAS2 =  str2double(string(C{j}(uudetSairaatTAS - rc)));
            kuolleet2  = str2double(string(C{j}(kaikkiKuolleet - rc)));
            pKuolleet2 = str2double(string(C{j}(uudetKuolleet - rc)));
            pKuolleetTAS2 = str2double(string(C{j}(uudetKuolleetTAS - rc)));
            t = [t t2];
            sairaat   = [sairaat   sairaat2];
            pSairaat  = [pSairaat  pSairaat2];
            pSairaatTAS  = [pSairaatTAS  pSairaatTAS2];
            kuolleet  = [kuolleet  kuolleet2];
            pKuolleet = [pKuolleet pKuolleet2];
            pKuolleetTAS = [pKuolleetTAS pKuolleetTAS2];
        end
    end

    %% PLOT THE TOTAL DEATHS AND INFECTIONS IN ONE COUNTRY
    figure;
    semilogy(t,sairaat,'-r','LineWidth',2);
    hold on;
    plot(t,kuolleet,'-k','LineWidth',2);
    title(valtio,'FontSize',20);
    set(gca,'FontSize',15);
    ylim([1 1.1*max(sairaat)]);
    legend('Sairaat','Kuolleet','Location','NorthWest');

    %% AND THEN THE DAILY DEATHS AND INFECTIONS
    figure;
    semilogy(t,pSairaat,'-r','LineWidth',1);
    hold on;
    plot(t,pKuolleet,'-k','LineWidth',1);
    plot(t,pSairaatTAS,'-r','LineWidth',2);
    plot(t,pKuolleetTAS,'-k','LineWidth',2);
    title(valtio,'FontSize',20);
    set(gca,'FontSize',15);
    ylim([1 1.1*max(pSairaat)]);
    legend('Päivittäin sairaat','Päivittäin kuolleet','Location','NorthWest');
    
    %% SITUATION TODAY
   fprintf('---------------------------------------------------\n');
   fprintf('Situation in %11s| %11s | %11s\n',valtio,datestr(t(end)),datestr(t(end-1)));
   fprintf('---------------------------------------------------\n');
   fprintf('Sairaat\t\t\t\t\t| %11d | %11d\n',sairaat(end),sairaat(end-1));
   fprintf('Kuolleet\t\t\t\t| %11d | %11d\n',kuolleet(end),kuolleet(end-1));
   fprintf('Päivittäin sairaat\t\t| %11d | %11d\n',pSairaat(end),pSairaat(end-1));
   fprintf('Päivittäin kuolleet\t\t| %11d | %11d\n',pKuolleet(end),pKuolleet(end-1));
end