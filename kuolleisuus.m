function kuolleisuus(valtiot,startDate)
    global C;
    global nl;
    global kaikkiValtiot;
    global paivat;
    global kaikkiSairaat;
    global kaikkiKuolleet;
    k=0;
    lstyle = '-';
    for valtio = valtiot
        k = k+1;
        if k == 8
           lstyle = '--';
        end
        t = [];
        rate = [];
        for j=2:nl
            temp = C{j}(kaikkiValtiot);
            if valtio == string(temp{1})
                t2 = datetime(string(C{j}(paivat)),'InputFormat','yyyy-MM-dd');
                sairaat = str2double(string(C{j}(kaikkiSairaat)));
                kuolleet = str2double(string(C{j}(kaikkiKuolleet)));
                if sairaat > 0
                    rate2 = kuolleet/sairaat;
                else
                    rate2 = 0;
                end
                rate = [rate rate2];
                t = [t t2];
            end
        end
        plot(t,100*rate,lstyle,'LineWidth',2);
        hold on;
    end
    set(gca,'FontSize',15);
    xlim([datetime(startDate), t(end)]);
    title('Kuolleiden osuus sairastuneista (%)','FontSize',20);
    legend(valtiot,'Location','NorthWest'); 
    height = 700;
    set(gcf,'position',[0,0,2.4*height,height]);
end