%% SECOND DERIVATIVE
% One should insert the first derivative, ie. eg. NewCases or NewDeaths.
%
% For valtio = "World", the function sets temp = C{j}(maanosat) by
% exploiting that kaikkiValtiot - 1 = maanosat.
%
% For "World", the dates are shifted by one column left compared to
% individual countries. We exploit then "paivat - 1" trick.

function SecondDerivative(p,valtio,tyyppi,startDate)
    global C;
    global nl;
    global otsikot;
    global kaikkiValtiot;
    global paivat;
    if nargin < 4
        startDate = '2019-12-01'; 
    end
    calculateWorld = false;
    if valtio == "World"
        calculateWorld = true;
    end
    %tyyppi = uudetSairaat;  % First derivative of AllCases(t)
    %tyyppi = uudetKuolleet; % First derivative of AllDeaths(t)
    lkm = [];
    t = [];
    % Get the data for individual country
    for j=2:nl
        temp = C{j}(kaikkiValtiot - calculateWorld); % Here the difference between World and individual countries
        if valtio == string(temp{1})
            t2 = datetime(string(C{j}(paivat - calculateWorld)),'InputFormat','yyyy-MM-dd'); % Also here
            lkm2 = str2double(string(C{j}(tyyppi)));
            t = [t t2];
            lkm = [lkm lkm2];
        end
    end
    % Calculate the second derivative
    der = zeros(1,length(t)-1);
    for j=2:length(t)
        der(j-1) = lkm(j)-lkm(j-1);
    end
    t = t(1:end-1);

    % Next we calculate the p-day running mean to clean the data.
    % p should be odd.
    runningDer = zeros(1,length(der)-p+1);
    for j=1:(length(der)-p+1)
       runningDer(j) = 1/p*sum(der(j:j+p-1)); 
    end

    % Logarithmicity should be called only once.
    % The time for running mean is cut short from both ends.
    tRunning = t(1+(p-1)/2:end-(p-1)/2);

    figure;
    plot(t,der,'-b','LineWidth',1);
    hold on;
    plot(tRunning,runningDer,'-r','LineWidth',2);
    plot(t,zeros(1,length(t)),'-k','LineWidth',2); % Zero line
    xlim([datetime(startDate), t(end)]);
    title(otsikot(tyyppi),'FontSize',20);
    legend(valtio,'Location','NorthWest','FontSize',15);
    set(gca,'FontSize',15);
    height = 700;
    set(gcf,'position',[0,0,2.4*height,height]);