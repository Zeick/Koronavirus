% GET NUMBER OF TOTAL INFECTIONS/DEATHS FROM MULTIPLE COUNTRIES AFTER N
% CASES (default 100)
%
% (C) Timo J. Kärkkäinen 2020
function afterNcases(valtiot,tyyppi,minimumCases,plotLinear,upperBound,afterN)
    global C;
    global nl;
    global otsikot;
    global kaikkiValtiot;
    if nargin < 3
        minimumCases = 100;
    end
    if nargin < 6
        afterN = 1;
    end
    % Set LineWidth
    if length(valtiot) > 14
        lw = 1;
    else
        lw = 2;
    end
    first = true;
    k = 0;
    lstyle = '-';
    maxLKM = 0;
    for valtio = valtiot
        k = k+1;
        if k == 8
           lstyle = '--';
        end
        lkm = [];
        for j=2:nl
            temp = C{j}(kaikkiValtiot);
            if valtio == string(temp{1})
                lkm2   = str2double(string(C{j}(tyyppi)));
                if lkm2 >= minimumCases
                    lkm = [lkm lkm2];
                end
            end
        end
        if length(lkm) > maxLKM
            maxLKM = length(lkm);
        end
        if length(lkm) > 1
            % Logarithmicity should be called only once.
            t = 1:length(lkm); % Get rid of dates
            if first
                first = false;
                figure;
                if plotLinear
                    plot(t,lkm,'LineWidth',lw);
                else
                    semilogy(t,lkm,'LineWidth',lw);
                end
                hold on;
            else
                plot(t,lkm,lstyle,'LineWidth',lw);
            end
        end
    end
    set(gca,'FontSize',15);
    title(otsikot(tyyppi),'FontSize',20);
    % Limit about of legends to 14
    if length(valtiot) <= 14
        legend(valtiot,'Location','NorthWest'); 
    end
    xlabel(['Päivää ', num2str(minimumCases), ' tapauksen jälkeen']);
    xlim([afterN maxLKM]);
    if nargin == 5
        ylim([minimumCases upperBound]);
    else
        yLimits = get(gca,'YLim');
        ylim([minimumCases yLimits(2)]);
    end
    height = 700;
    set(gcf,'position',[0,0,2.4*height,height])
end