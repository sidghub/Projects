libname x"P:\Project";
/*data x.final_timeseries_test;
set x.final_timeseries_data
if year(date)>2015;
run;
*/
proc gplot
data = x.final_timeseries_data;
plot dji_closing_value*Date;
run;
quit;
proc arima data=x.final_timeseries_data;
/*by age;*/
identify var=goldprice_dollar (2);
estimate p=7 q=7;
identify var=dji_closing_value crosscorr=goldprice_dollar ;
run
;
ods graphics on;
proc arima data=x.final_timeseries_data;
/*by age;*/
identify var=CrudeOil_Price (1);
estimate p=2 q=1;
identify var=dji_closing_value crosscorr=CrudeOil_Price ;
run
;
ods graphics on;

proc arima data=x.final_timeseries_data ;
identify var=dji_closing_value crosscorr= (goldprice_dollar (2) CrudeOil_Price (1));
estimate p=2 q=0 input=(2 $ (1)/(2) goldprice_dollar  2 $ (1)/(1) CrudeOil_Price) noconstant plot ; 
forecast id = date LEAD = 500 interval = month out=x.output printall;
run;
quit;





