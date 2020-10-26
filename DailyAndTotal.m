% GET NUMBER OF DAILY/TOTAL INFECTIONS/DEATHS FROM MULTIPLE COUNTRIES
function DailyAndTotal(valtiot,tyyppi,plotLinear,lowerBound,upperBound,useSubPlot)
    global C;
    global nl;
    global kaikkiValtiot;
    global otsikot;
    if nargin < 3
        plotLinear = false;
    elseif nargin < 6
        useSubPlot = false;
    end
    first = true;
    k = 0;
    lstyle = '-';
    maxLKM = 1;
    totLKM = 1;
    for valtio = valtiot
        k = k+1;
        if k == 8
           lstyle = '--';
        end
        total = [];
        daily = [];
        for j=2:nl
            temp = C{j}(kaikkiValtiot);
            if valtio == string(temp{1})
                total2 = str2double(string(C{j}(tyyppi)));
                daily2 = str2double(string(C{j}(tyyppi + 2)));
                total  = [total total2];
                daily  = [daily daily2];
            end
        end
        maxLKM = max(maxLKM,max(daily));
        totLKM = max(totLKM,max(total));
        % Logarithmicity should be called only once.
        if first
            first = false;
            if ~useSubPlot
                figure;
            end
            if plotLinear
                plot(total,daily,'LineWidth',2);
            else
                loglog(total,daily,'LineWidth',2);
            end
            hold on;
        else
            plot(total,daily,lstyle,'LineWidth',2);
        end
        fprintf('Calculating %30s\n',valtio);
    end
    set(gca,'FontSize',15);
    xlim([10, totLKM]);
    if nargin < 5
        lowerBound = 1;
        upperBound = 1.1*maxLKM;
    end
    if lowerBound == -1
        lowerBound = 1;
    end
    if upperBound == -1
        upperBound = 1.1*maxLKM;
    end
    ylim([lowerBound upperBound]);
    legend(valtiot,'Location','NorthWest'); 
    title(otsikot(tyyppi),'FontSize',20);
    xlabel('Kaikki tapaukset','FontSize',15);
    ylabel('Uudet tapaukset','FontSize',15);
    height = 700;
    set(gcf,'position',[0,0,2.4*height,height])
end
