%% GET NUMBER OF DAILY/TOTAL INFECTIONS/DEATHS FROM MULTIPLE COUNTRIES
% Example: vector of length 15 and 5-day average, requires int(15 - 5/2) =
% 11 of averages. P should be odd in P-day average. If the length of vector
% is L, P = 2k+1, then there is L-2k = L-P+1 averages.
% 
% |XXXXX|XXXXXXXXXX v(1:5)
% X|XXXXX|XXXXXXXXX v(2:6)
% XX|XXXXX|XXXXXXXX v(3:7)
% XXX|XXXXX|XXXXXXX v(4:8)
% ...
% XXXXXXXXX|XXXXX|X v(10:14)
% XXXXXXXXXX|XXXXX| v(11:15)
function moniValtioJuokseva(p,valtiot,tyyppi,startDate,plotLinear,upperBound,useSubPlot)
    global C;
    global nl;
    global otsikot;
    global kaikkiValtiot;
    global paivat;
    if nargin < 4
        startDate = '2019-12-01'; 
        plotLinear = false;
        useSubPlot = false;
    elseif nargin < 7
        useSubPlot = false;
    end
    if plotLinear
       lowerBound = 0;
    else
       lowerBound = 1;
    end
    if mod(p,2) == 0
       fprintf('ERROR: The running mean period must be and odd integer!\n');
       return;
    end
    lstyle = '-';
    maxLKM = 1;
    for k=1:length(valtiot)
        if k == 8
           lstyle = '--';
        end
        valtio = valtiot(k);
        t = [];
        lkm = [];
        for j=2:nl
            temp = C{j}(kaikkiValtiot);
            if valtio == string(temp{1}) && length(C{j}) >= tyyppi
                t2 = datetime(string(C{j}(paivat)),'InputFormat','yyyy-MM-dd');
                lkm2  = str2double(string(C{j}(tyyppi)));
                t = [t t2];
                lkm = [lkm lkm2];
            end
        end

        % Next we calculate the p-day running mean.
        runningLKM = zeros(1,length(lkm)-p+1);
        for j=1:(length(lkm)-p+1)
           runningLKM(j) = 1/p*sum(lkm(j:j+p-1)); 
        end

        % Logarithmicity should be called only once.
        % The time for running mean is cut short from both ends.
        tRunning = t(1+(p-1)/2:end-(p-1)/2);
        maxLKM = max(maxLKM,max(runningLKM));
        if k == 1
            if ~useSubPlot
                figure;
            end
            if plotLinear
                plot(tRunning,runningLKM,lstyle,'LineWidth',2);
            else
                semilogy(tRunning,runningLKM,lstyle,'LineWidth',2);
            end
            hold on;
            fprintf('--------------------------------------------------------------------------\n');
            fprintf('%31s | %11s | %11s |      Erotus |\n',otsikot(tyyppi),datestr(t(end)),datestr(t(end-1)));
            fprintf('--------------------------------------------------------------------------\n');
        else
            plot(tRunning,runningLKM,lstyle,'LineWidth',2);
        end
        fprintf('%31s | %11d | %11d | %11d |\n',valtio,lkm(end),lkm(end-1),lkm(end)-lkm(end-1));
    end
    set(gca,'FontSize',15);
    xlim([datetime(startDate), t(end)]);
    if nargin < 6 || upperBound == -1
        upperBound = 1.1*maxLKM;
    end
    ylim([lowerBound, upperBound]);
    % otsikot(tyyppi) 
    title(['Juokseva ', num2str(p), ' päivän keskiarvo'],'FontSize',20);
    xLimits = get(gca,'XLim');
    yLimits = get(gca,'YLim');
    x0 = xLimits(1); x1 = xLimits(2); y0 = log10(yLimits(1)); y1 = log10(yLimits(2));
    %title(['Juokseva ', num2str(p), ' päivän keskiarvo', otsikot(tyyppi)],'FontSize',20);
    leg = legend(valtiot,'Location','NorthWest');
    title(leg,otsikot(tyyppi));
    height = 700;
    set(gcf,'position',[0,0,2.4*height,height])
end

