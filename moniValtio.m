% GET NUMBER OF DAILY/TOTAL INFECTIONS/DEATHS FROM MULTIPLE COUNTRIES
function moniValtio(valtiot,tyyppi,startDate,plotLinear,upperBound,useSubPlot)
    global C;
    global nl;
    global otsikot;
    global kaikkiValtiot;
    global paivat;
    if nargin == 2
        startDate = '2019-12-01';
        plotLinear = false;
        useSubPlot = false;
    elseif nargin == 3
        plotLinear = false;
        useSubPlot = false;
    elseif nargin == 4
        useSubPlot = false;
    end
    first = true;
    k = 0;
    lstyle = '-';
    maxLKM = 1;
    for valtio = valtiot
        k = k+1;
        if k == 8
           lstyle = '--';
        end
        t = [];
        lkm = [];
        for j=2:nl
            temp = C{j}(kaikkiValtiot);
            if valtio == string(temp{1})
                t2 = datetime(string(C{j}(paivat)),'InputFormat','yyyy-MM-dd');
                lkm2   = str2double(string(C{j}(tyyppi)));
                t = [t t2];
                lkm = [lkm lkm2];
            end
        end
        maxLKM = max(maxLKM,max(lkm));
        % Logarithmicity should be called only once.
        if first
            first = false;
            if ~useSubPlot
                figure;
            end
            if plotLinear
                plot(t,lkm,'LineWidth',2);
            else
                semilogy(t,lkm,'LineWidth',2);
            end
            hold on;
            fprintf('--------------------------------------------------------------------------\n');
            fprintf('%30s | %11s | %11s |      Erotus |\n',otsikot(tyyppi),datestr(t(end)),datestr(t(end-1)));
            fprintf('--------------------------------------------------------------------------\n');
        else
            plot(t,lkm,lstyle,'LineWidth',2);
        end
        fprintf('%30s | %11g | %11g | %11g |\n',valtio,lkm(end),lkm(end-1),lkm(end)-lkm(end-1));
    end
    set(gca,'FontSize',15);
    xlim([datetime(startDate), t(end)]);
    if nargin < 5
       upperBound = 1.1*maxLKM; 
    end
    if plotLinear
        lowerBound = 0.1;
    else
        lowerBound = 1;
    end
    ylim([lowerBound upperBound]);
    title(otsikot(tyyppi),'FontSize',20);
    legend(valtiot,'Location','NorthWest'); 
    height = 700;
    set(gcf,'position',[0,0,2.4*height,height])
end