library(readr)
library(ggplot2)
library(forecast)
library(tseries)

# Data Preparation --------------------------------------------------------

daily_data = read.csv('day.csv', header=TRUE, stringsAsFactors=FALSE)
# Checking missing data
daily_data[!complete.cases(daily_data),]  
daily_data$Date = as.Date(daily_data$dteday)
ggplot(daily_data, aes(Date, cnt)) +
  geom_line() + scale_x_date('month')  + ylab("Daily Bike Checkouts") +
  xlab("")

# Replot the CNT Series
count_ts = ts(daily_data[, c('cnt')])
daily_data$clean_cnt = tsclean(count_ts)
ggplot() +
  geom_line(data = daily_data, aes(x = Date, y = clean_cnt)) + 
  ylab('Cleaned Bicycle Count')


# Use Moving average to smooth CNT series
daily_data$cnt_ma = ma(daily_data$clean_cnt, order=7) # using the clean count with no outliers
daily_data$cnt_ma30 = ma(daily_data$clean_cnt, order=30)

ggplot() +
  geom_line(data = daily_data, aes(x = Date, y = clean_cnt, colour = "Counts")) +
  geom_line(data = daily_data, aes(x = Date, y = cnt_ma,   colour = "Weekly Moving Average"))  +
  geom_line(data = daily_data, aes(x = Date, y = cnt_ma30, colour = "Monthly Moving Average"))  +
  ylab('Bicycle Count')


# Data analysis and Results: ----------------------------------------------

# Remove Seasonal Component
count_ma = ts(na.omit(daily_data$cnt_ma), frequency=30)
decomp = stl(count_ma, s.window="periodic")
deseasonal_cnt <- seasadj(decomp)
plot(decomp)

# Stationarity Test
adf.test(count_ma)

# Apply differencing  
count_d1 = diff(deseasonal_cnt,1)
adf.test(count_d1)

# reapply ADF and PADF test
Acf(count_d1, main='ACF for Differenced Series')
Pacf(count_d1, main='PACF for Differenced Series')

# Compare three non-seasonal ARIMA model using AIC
ARIMA_111 = arima(deseasonal_cnt, order = c(1,1,1))
ARIMA_111
ARIMA_117 = arima(deseasonal_cnt, order = c(1,1,7))
ARIMA_117
ARIMA_711 = arima(deseasonal_cnt, order = c(7,1,1))
ARIMA_711

# Run dia
tsdiag(ARIMA_117)

# Forecasting 
train=deseasonal_cnt[1:700]
test=deseasonal_cnt[701:725]
fit_1=arima(train,order=c(1,1,7))
arimafcast_1=forecast(fit_1,h=25)
arimaerr_1=test-arimafcast_1$mean
arimamae_1=mean(abs(arimaerr_1))
arimarmse_1=sqrt(mean(arimaerr_1^2))
arimamape_1=mean(abs((arimaerr_1*100)/test)) 
plot(arimafcast_1, main="ARIMA(1,1,7) Model Forecasting")
lines(ts(deseasonal_cnt))

fit_w_seasonality = auto.arima(train, seasonal = TRUE)

arimafcast_2=forecast(fit_w_seasonality,h=25)
arimaerr_2=test-arimafcast_2$mean
arimamae_1=mean(abs(arimaerr_2))
arimarmse_2=sqrt(mean(arimaerr_2^2))
arimamape_2=mean(abs((arimaerr_2*100)/test)) 
plot(arimafcast_2, main="")
lines(ts(deseasonal_cnt))




