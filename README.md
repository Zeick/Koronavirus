# Koronavirus
MATLAB scripts for downloading latest coronavirus information and visualizing it in a beautiful way.

Data Source: https://github.com/owid/covid-19-data/tree/master/public/data

## Main file and interesting functions

* CoronaMaailma.m - **Main file.** Downloads the data, demonstrates the functions and produces the most important plots.
* afterNcases.m - produces the plot after a specific number has been achieved for a statistic.
* DailyAndTotal.m - produces a plot, where the total statistic is on horizontal axis and the daily statistic on vertical axis
* moniValtio.m - produces a plot for several countries. Legend is included if less than 15 countries are inserted.
* moniValtioJuokseva.m - produces a p-day average of a statistic for several countries. Legend is included if less than 15 countries are inserted.
* SairasOsuus.m - produces a plot for the rate of positive COVID-19 test results for several countries.
* yksiValtio.m - quick and simple script for a fast checkout of the situation of a single country.
* kuolleisuus.m - produces a plot for the mortality rate for several countries

## Not interesting functions

* laskePaivat.m - Counts the dates.
* laskeValtiot.m - Counts the countries. Note that there are also non-countries and continents included in the data, like "World".
* LogNormalTest.m - A test script, demonstrates how we may fit a lognormal distribution to data.
