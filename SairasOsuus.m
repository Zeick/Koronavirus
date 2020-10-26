function SairasOsuus(valtiot,startDate,upperBound)
    global C;
    global nl;
    global kaikkiValtiot;
    global paivat;
    global positiiviset;
    global kaikkiTestitTAS
    k=0;
    lstyle = '-';
    fprintf('Positiivisten osuus testatuista|    Today    |  Yesterday  |      Erotus |\n');
    fprintf('--------------------------------------------------------------------------\n');
    for valtio = valtiot
        k = k+1;
        if k == 8
           lstyle = '--';
        end
        t = [];
        rate = [];
        for j=2:nl
            temp = C{j}(kaikkiValtiot);
            if valtio == string(temp{1}) && size(C{j},2) > 23 
                t2 = datetime(string(C{j}(paivat)),'InputFormat','yyyy-MM-dd');
                rate2 = str2double(string(C{j}(positiiviset)));
                if rate2 < 1
                    rate = [rate rate2];
                    t = [t t2];
                end
            end
        end
        rate = 100*rate;
        plot(t,rate,lstyle,'LineWidth',2);
        hold on;
        if isnumeric(rate(end)) && isnumeric(rate(end-1))
            fprintf('%30s | %11g | %11g | %11g |\n',valtio,rate(end),rate(end-1),rate(end)-rate(end-1));
        else
            fprintf('%30s |             |             |             |\n',valtio);
        end
    end
    set(gca,'FontSize',15);
    xlim([datetime(startDate), t(end)]);
    if nargin == 3
        ylim([0 upperBound]);
    end
    title('Sairastuneiden osuus testatuista (%)','FontSize',20);
    legend(valtiot,'Location','NorthEast'); 
    height = 700;
    set(gcf,'position',[0,0,2.4*height,height]);
end