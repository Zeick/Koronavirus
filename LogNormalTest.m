% LogNormal probability distribution function fitting to coronavirus data
% See https://se.mathworks.com/help/curvefit/custom-nonlinear-models.html
% for manual
%
% (C) Timo Kärkkäinen 2020
x = 0:0.01:5;
mu0 = 0;
sigma0 = 0.8;
y = lognpdf(x,mu0,sigma0);

% Create random data which is almost lognormal
y0 = zeros(1,length(y));
i = 1;
for yi = y
    y0(i) = yi*(1+0.2*(rand(1) - 0.5));
    i = i+1;
end

%% For visualization
%plot(x,y,'LineWidth',2);
%hold on;
%plot(x,y0,'LineWidth',1);

%% Method of least squares (well... not squared, abs-values here)
maxdiff = 1e20;
bestmu = 0;
bestsigma = 0.1;
bestfit = y;
% Loop over PDF parameters mu and sigma
for mu = 0:0.1:1
    for sigma = 0.1:0.1:10
        yfit = lognpdf(x,mu,sigma);
        % Calculate the deviation of fit
        ydiff = abs(yfit - y0);
        % If fit is improved from previous, save it
        if sum(ydiff) < maxdiff
            maxdiff = sum(ydiff);
            bestmu = mu;
            bestsigma = sigma;
            bestfit = yfit;
        end
    end
end
plot(x,y0,'LineWidth',1);
hold on;
plot(x,bestfit,'LineWidth',2);
legend('Data','Fit','Location','NorthEast');
title(['\mu_{fit} = ', num2str(bestmu,2), ', \sigma_{fit} = ', num2str(bestsigma,2), ', \mu_{true} = ', num2str(mu0,2), ', \sigma_{true} = ', num2str(sigma0,2)],'FontSize',15);
set(gca,'FontSize',15);