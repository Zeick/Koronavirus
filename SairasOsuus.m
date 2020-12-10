function SairasOsuus(valtiot,startDate,upperBound)
    global C;
    global nl;
    global kaikkiValtiot;
    global paivat;
    global positiiviset;
    global uudetSairaat;
    global uudetTestit;
    k=0;
    lstyle = '-';
    maxDate = '1900-01-01';
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
            if valtio == string(temp{1}) && size(C{j},2) >= uudetTestit
                t2 = datetime(string(C{j}(paivat)),'InputFormat','yyyy-MM-dd');
                sair = str2double(string(C{j}(uudetSairaat)));
                test = str2double(string(C{j}(uudetTestit)));
                rate2 = sair/test;
                if rate2 < 1
                    rate = [rate rate2];
                    t = [t t2];
                end
            end
        end
        rate = 100*rate;
        
        % The data is very fluctuating, and we need to have a running
        % average to clear it up.
        % Next we calculate the p-day running mean.
        p = 7;
        runningLKM = zeros(1,length(rate)-p+1);
        for j=1:(length(rate)-p+1)
           runningLKM(j) = 1/p*sum(rate(j:j+p-1)); 
        end
        % The time for running mean is cut short from both ends.
        tRunning = t(1+(p-1)/2:end-(p-1)/2);
        rate = runningLKM;
        maxDate = max(datetime(maxDate),max(tRunning));
        plot(tRunning,rate,lstyle,'LineWidth',2);
        hold on;
        if isnumeric(rate(end)) && isnumeric(rate(end-1))
            fprintf('%31s | %11g | %11g | %10g |\n',valtio,rate(end),rate(end-1),rate(end)-rate(end-1));
        else
            fprintf('%31s |             |             |             |\n',valtio);
        end
    end
    set(gca,'FontSize',15);
    xlim([datetime(startDate), maxDate]);
    ylim([0 40]);
    if nargin == 3
        ylim([0 upperBound]);
    end
    title('Sairastuneiden osuus testatuista (%)','FontSize',20);
    legend(valtiot,'Location','NorthWest'); 
    height = 700;
    set(gcf,'position',[0,0,2.4*height,height]);
end