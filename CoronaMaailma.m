%% KORONAVIRUS MAAILMALLA
% https://github.com/owid/covid-19-data/tree/master/public/data
% (C) Timo Kärkkäinen 2020
clear;
t0 = cputime;
CSVfile = websave('FullData.csv','https://covid.ourworldindata.org/data/owid-covid-data.csv');
%XLSfile = websave('FullData.xlsx','https://covid.ourworldindata.org/data/owid-covid-data.xlsx');

fprintf('Loading data set...');
% DEFINE GLOBAL VARIABLES
global C;  % The data set
global nl; % Number of lines in data set
global maanosat;
global kaikkiValtiot;
global paivat;
global kaikkiSairaat;
global uudetSairaat;
global uudetSairaatTAS;
global kaikkiKuolleet;
global uudetKuolleet;
global uudetKuolleetTAS;
global kaikkiSairaatPPM;
global uudetSairaatPPM;
global kaikkiKuolleetPPM;
global uudetKuolleetPPM;
global kaikkiTestit;
global uudetTestit;
global uudetTestitTAS;
global kaikkiTestitPPT;
global otsikot;
global positiiviset;

%D = csvread(CSVfile,2,1);
%[num, txt, raw] = xlsread(XLSfile);
fid = fopen('FullData.csv');
myline = fgetl(fid);
i=1;

C = {};
while ischar(myline)
    C{i} = strsplit(myline,',');
    % C now contains a cell array for each line
    myline = fgetl(fid);
    i=i+1;
end
fclose(fid);
nl = length(C); % Number of lines in the file
fprintf(' ready. (%.2f s)\n', cputime-t0);
% COLUMN SYSTEM
% 1     iso_code
maanosat         = 2; % 2     continent
kaikkiValtiot    = 3; % 3     location
paivat           = 4; % 4     date
kaikkiSairaat    = 5; % 5     total_cases
uudetSairaat     = 6; % 6     new_cases
uudetSairaatTAS  = 7; % 7     new_cases_smoothed
kaikkiKuolleet   = 8; % 8     total_deaths
uudetKuolleet    = 9; % 9     new_deaths
uudetKuolleetTAS = 10; % 10    new_deaths_smoothed
kaikkiSairaatPPM  = 11; % 11    total_cases_per_million
uudetSairaatPPM   = 12; % 12    new_cases_per_million
% 13    new_cases_smoothed_per_million
kaikkiKuolleetPPM = 14; % 14    total_deaths_per_million
uudetKuolleetPPM  = 15; % 15    new_deaths_per_million
% 16    new_deaths_smoothed_per_million
% 17    icu_patients
% 18    icu_patients_per_million
% 19    hosp_patients
% 20    hosp_patients_per_million
% 21    weekly_icu_admissions
% 22    weekly_icu_admissions_per_million
% 23    weekly_hosp_admissions
% 24    weekly_hosp_admissions_per_million
kaikkiTestit      = 25; % 25    total_tests
uudetTestit       = 26; % 26    new_tests
uudetTestitTAS    = 27; % 27    new_tests_smoothed
kaikkiTestitPPT   = 28; % 28    total_tests_per_thousand
% 29    new_tests_per_thousand
% 30    new_tests_smoothed_per_thousand
% 31    tests_per_case
positiiviset      = 24; % 24    positive_rate
% 33    tests_units
% 34    stringency_index
% 35    population
% 36    population_density
% 37    median_age
% 38    aged_65_older
% 39    aged_70_older
% 40    gdp_per_capita
% 41    extreme_poverty
% 42    cardiovasc_death_rate
% 43    diabetes_prevalence
% 44    female_smokers
% 45    male_smokers
% 46    handwashing_facilities
% 47    hospital_beds_per_thousand
% 48    life_expectancy
% 49    human_development_index
otsikot = ["ISO","Maanosa","Valtio","Päiväys",...
    "Kaikki sairastuneet","Päivittäin sairastuneet","Päivittäinen sairastuneet (tasoitettu)",...
    "Kaikki kuolleet","Päivittäin kuolleet","Päivittäin kuolleet (tasoitettu)",...
    "Kaikki sairastuneet PPM","Päivittäin sairastuneet PPM","Päivittäin sairastuneet PPM (tasoitettu)",...
    "Kaikki kuolleet PPM","Päivittäin kuolleet PPM","Päivittäin kuolleet PPM (tasoitettu)",...
    "All ICU patients","ICU patients PPM","Hospitalized","Hospitalized PPM",...
    "Weekly new ICU patients","Weekly new ICU patients PPM","Weekly hospitalized","Postiivisten testien osuus",...
    "Kaikki testatut","Päivittäin testatut","Kaikki testatut (tasoitettu)",...
    "Kaikki testatut PPT","Uudet testatut PPT", "Uudet testatut PPT (tasoitettu)",...
    "Testejä tapausta kohti","Positiivisten testien osuus","Testiyksikkö"];
plotLinear = true;
plotExp = false;

%% LIST OF LOCATIONS
%fprintf('Generating list of locations...');
%t0 = cputime;
%kaikkiMaat = laskeValtiot();
%fprintf(' ready. (%.2f s)\n', cputime-t0);

%% GET DATA FROM ONE COUNTRY
% TODO: Valitse kaikki plotattavat tyypit graafiin, looppaa tyyppien yli
yksiValtio("World");
%yksiValtio("Finland");
yksiValtio("United States");
%yksiValtio("Sweden");
%yksiValtio("Hungary");

%% ONE COUNTRY SUMMARY, PART 1
valtiot = ["Finland"];
startDate = '2020-02-20';
plotType = plotLinear;
tyyppi = uudetSairaat;
p = 7;
upperBound = -1; % Tarkoittaa että otetaan oletus 1.1*maxLKM käyttöön
useSubPlot = true;
subplot(2,1,1);
moniValtioJuokseva(p,valtiot,tyyppi,startDate,plotType,upperBound,useSubPlot);
subplot(2,1,2);
startDate = '2020-03-16';
tyyppi = uudetKuolleet;
upperBound = 14;
moniValtioJuokseva(p,valtiot,tyyppi,startDate,plotType,upperBound,useSubPlot);

%% PART 2
valtiot = ["Finland"];
startDate = '2020-03-17';
plotType = plotLinear;
tyyppi = kaikkiSairaat;
useSubPlot = true;
subplot(2,1,1);
lowerX = -1;
lowerY = -1;
upperY = -1;
DailyAndTotal(startDate,valtiot,tyyppi,plotType,lowerX,lowerY,upperY,useSubPlot);
tyyppi = kaikkiKuolleet;
subplot(2,1,2);
lowerX = 1;
lowerY = -1;
upperY = 20;
DailyAndTotal(startDate,valtiot,tyyppi,plotType,lowerX,lowerY,upperY,useSubPlot);


%% GET NUMBER OF DAILY/TOTAL INFECTIONS/DEATHS FROM MULTIPLE COUNTRIES
% MAHDOLLISET TYYPIT: kaikkiSairaat/uudetSairaat/kaikkiKuolleet/uudetKuolleet (+PPM)

% Bad data (16.9.2020): South Africa, Argentia, Peru.
%valtiot = ["Finland","Sweden","Denmark","Iceland","Norway","Estonia","Latvia","Hungary","Netherlands","Belgium","Switzerland","Japan","Singapore","South Korea"];
valtiot = ["United States","Brazil","Russia","India","United Kingdom","Chile","Spain","Italy","Iran","Mexico","Pakistan","France","Saudi Arabia","Colombia"];
%valtiot = "World";
%valtiot = kaikkiMaat;
%valtiot = ["Luxembourg","Qatar","Spain","Iceland","Ireland","Belgium","United States","Italy","Switzerland","Singapore"];
startDate = '2020-02-20';
plotType = plotExp;
tyyppi = kaikkiSairaat;
moniValtio(valtiot,tyyppi,startDate,plotType);
tyyppi = kaikkiKuolleet;
moniValtio(valtiot,tyyppi,startDate,plotType);

%% RUNNING P-DAY MEAN
%valtiot = ["Finland","Sweden","Denmark","Iceland","Norway","Estonia","Latvia","Hungary","Netherlands","Belgium","Switzerland","Japan","Singapore","South Korea"];
valtiot = ["United States","Brazil","Russia","India","United Kingdom","Chile","Spain","Italy","Iran","Mexico","Pakistan","France","Saudi Arabia","Colombia"];
startDate = '2020-02-18';
p = 7; % P-day running mean. Must be odd integer!
plotType = plotExp;
tyyppi = uudetSairaat;
moniValtioJuokseva(p,valtiot,tyyppi,startDate,plotType);
%valtiot = ["Finland","Sweden","Denmark","Norway","Estonia","Hungary","Netherlands","Belgium","Switzerland","Japan","South Korea"];
tyyppi = uudetKuolleet;
moniValtioJuokseva(p,valtiot,tyyppi,startDate,plotType,3000);

%% AMOUNT OF DAILY/TOTAL CASES/DEATHS AFTER N CASES/DEATHS
% This allows a better comparison, since then every country starts at the
% same day.
%valtiot = ["Finland","Sweden","Denmark","Iceland","Norway","Estonia","Latvia","Hungary","Netherlands","Belgium","Switzerland","Japan","Singapore","South Korea"];
plotType = plotExp;
%valtiot = ["United States","Brazil"];
valtiot = ["United States","Brazil","Russia","India","United Kingdom","Chile","Spain","Italy","Iran","Mexico","Pakistan","France","Saudi Arabia","Colombia"];
tyyppi = kaikkiSairaat;
minimumCases = 100;
afterNcases(valtiot,tyyppi,minimumCases,plotType);
minimumCases = 10;
tyyppi = kaikkiKuolleet;
afterNcases(valtiot,tyyppi,minimumCases,plotType,300000,6);

%% TAPAUKSET JA KUOLLEET VÄKILUKUA KOHDEN
%valtiot = ["United States","Brazil","Russia","India","United Kingdom","Chile","Spain","Italy","Iran","Mexico","Pakistan","France","Saudi Arabia","Colombia"];
%valtiot = ["Sweden","Denmark","Iceland","Norway","Estonia","Netherlands","Belgium","Switzerland","Japan","Singapore","South Korea","Ireland","Canada"];
valtiot = ["Spain", "Qatar", "Bahrain", "Israel", "United States", "Brazil", "Panama", "Andorra", "Peru", "Chile", "Kuwait", "India", "Oman","Maldives"];
plotType = plotLinear;
minimumCases = 1;
tyyppi = kaikkiSairaatPPM;
afterNcases(valtiot,tyyppi,minimumCases,plotType,50000,18);
% Bad data: Netherlands, Ireland, Iran, Iraq, Ecuador, Brazil
tyyppi = kaikkiKuolleetPPM;
valtiot = ["Peru", "Belgium", "United States", "Italy", "France", "Bolivia", "Spain", "Panama", "Colombia","Moldova","Sweden","Chile","India"];
minimumCases = 1;
afterNcases(valtiot,tyyppi,minimumCases,plotType,1100,37);

%% PÄIVITTÄISET TAPAUKSET KOKONAISTAPAUSTEN FUNKTIONA, TASOITETTUNA
valtiot = ["Finland","Brazil","Estonia","South Korea","Hungary","United States","Germany","Sweden","Russia","Spain","Italy","France","Chile","Japan"];
startDate = '2020-01-01';
plotType = plotExp;
tyyppi = kaikkiSairaat;
DailyAndTotal(startDate,valtiot,tyyppi,plotType,10,1,2e5);
tyyppi = kaikkiKuolleet;
DailyAndTotal(startDate,valtiot,tyyppi,plotType,10,1,3000);

%% SAMA, VÄKILUKUA KOHDEN
valtiot = ["Finland","Brazil","Estonia","South Korea","Hungary","United States","Germany","Sweden","Russia","Spain","Italy","France","Chile","Japan"];
startDate = '2020-03-10';
plotType = plotExp;
tyyppi = kaikkiSairaatPPM;
lowerX = 10; lowerY = 0.1; upperY = 1000;
DailyAndTotal(startDate,valtiot,tyyppi,plotType,lowerX,lowerY,upperY);
tyyppi = kaikkiKuolleetPPM; 
lowerX = 1; lowerY = 0.01; upperY = 20;
DailyAndTotal(startDate,valtiot,tyyppi,plotType,lowerX,lowerY,upperY);
%% LETHALITY OF VIRUS OVER TIME (DEATHS/CASES)
startDate = '2020-03-07';
kuolleisuus(valtiot,startDate);

%% SAIRASTUNEIDEN OSUUS TESTATUISTA
% Anomaalista dataa: Sweden, France, Brazil, Germany, Japan, Spain,
% Argentina, Peru, Colombia

% Ongelma! Pitää tasoittaa...
startDate = '2020-03-20';
valtiot = ["Finland","Estonia","Hungary","Italy","United Kingdom","India","Spain","Switzerland","Turkey","Belgium","Russia","Israel","United States","South Africa"];
SairasOsuus(valtiot,startDate);


%% VERRATAAN PÄIVITTÄIN KUOLLEITA SAIRASTUNEIDEN OSUUTEEN TESTATUISTA

valtiot = "Finland";
startDate = '2020-03-24';
plotType = plotLinear;
useSubPlot = true;
tyyppi = uudetKuolleetTAS;
subplot(2,1,2);
moniValtio(valtiot,tyyppi,startDate,plotType,15,useSubPlot);
subplot(2,1,1);
%SairasOsuus(valtiot,startDate)

tyyppi = 20;
p = 7;
moniValtioJuokseva(p,valtiot,tyyppi,startDate,plotType,100,useSubPlot);

%% TESTAUSTA (onko 20 positive_rate? Ehkä 24 todennäköisemmin kun on < 1
plotType = plotExp;
moniValtio("Hungary",24,'2020-03-22',plotType);

%%
tyyppi = uudetSairaatTAS;
startDate = '2020-03-01';
SecondDerivative(7,"Finland",tyyppi,startDate);

tyyppi = uudetKuolleet;
SecondDerivative(7,"World",tyyppi);


%%
%%%%%%%%%% HERE EXPERIMENTAL STUFF %%%%%%%%%%
% 
% %% LIST OF DATES
% fprintf('Generating list of dates...');
% t0 = cputime;
% kaikkiPaivat = laskePaivat();
% fprintf(' ready. (%.2f s)\n', cputime-t0);