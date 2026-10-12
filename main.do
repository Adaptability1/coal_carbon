global path "your_path"
*adopath + "/opt/stata_ado"

use $path/data/data,clear
*************************************************************table 1
reghdfe ln_Energy_consumption Output_factor , absorb(Unit Time) vce(cluster Unit)
est store m1
reghdfe ln_Carbon_emission Output_factor, absorb(Unit Time) vce(cluster Unit)
est store m2
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value , absorb(Unit Time) vce(cluster Unit)
est store m3
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value , absorb(Unit Time) vce(cluster Unit)
est store m4
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m5
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired, absorb(Unit Time) vce(cluster Unit)
est store m6
*esttab m1 m2 m3 m4 m5 m6 using $path/results/table_1.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
************************************************************
************************************************************  figure 1
use $path/data/data,clear
mkspline  Output_factor1 50 Output_factor2 60 Output_factor3 70 Output_factor4 80 Output_factor5 90 Output_factor6 = Output_factor
reghdfe ln_Energy_consumption  Output_factor1 Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m1
parmest , saving(si_1.dta, replace) idstr("a0") idnum(1)
reghdfe ln_Carbon_emission  Output_factor1 Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m2
parmest , saving(si_2.dta, replace) idstr("a1") idnum(1)
use si_1.dta,clear
gen  x=6 if parm=="Output_factor1"
replace  x=5 if parm=="Output_factor2"
replace  x=4 if parm=="Output_factor3"
replace  x=3 if parm=="Output_factor4"
replace  x=2 if parm=="Output_factor5"
replace  x=1 if parm=="Output_factor6"
keep if x!=.
graph twoway (rspike  max95 min95 x , fcolor("0 0 210") lcolor("0 0 210")) ///
(line estimate x, lcolor(gs10) lpattern(dash)) ///
(scatter estimate x, mcolor("0 0 210") mlcolor("0 0 210") msymbol(circle) msize(1.2)) ///
,scheme(plotplain) ///
xlab(6 "<50%" 5 "50-60%" 4 "60-70%" 3 "70-80%" 2 "80-90%" 1 ">=90%", labsize(*1.1) labcolor(black) axis(1) nogrid) ///
xscale(range(0 7)) ///
ylabel( -0.05 "-0.05"  0"0"  0.05"0.05" , labsize(*1.1) nogrid) ///
yline(0,lp(shortdash) lcolor(gs12) lwidth(middle)) ///
title( "(a):Energy consumption: Margin effect", pos(11) size(6)) ///
xtitle("") ///
ytitle("Estimation",size(4)) ///
graphregion(fcolor(white)) ///
legend(off) 
graph export "$path/results/figure1a.pdf", as(pdf)  replace
*********************
use si_2.dta,clear
gen   x=6 if parm=="Output_factor1"
replace  x=5 if parm=="Output_factor2"
replace  x=4 if parm=="Output_factor3"
replace  x=3 if parm=="Output_factor4"
replace  x=2 if parm=="Output_factor5"
replace  x=1 if parm=="Output_factor6"
keep if x!=.
graph twoway (rspike  max95 min95 x , fcolor("213 0 0") lcolor("213 0 0")) ///
(line estimate x, lcolor(gs10) lpattern(dash)) ///
(scatter estimate x, mcolor("213 0 0") mlcolor("213 0 0") msymbol(circle) msize(1.2)) ///
,scheme(plotplain) ///
xlab( 6 "<50%" 5 "50-60%" 4 "60-70%" 3 "70-80%" 2 "80-90%" 1 ">=90%", labsize(*1.1) labcolor(black) axis(1) nogrid) ///
xscale(range(0 7)) ///
ylabel(-0.05 "-0.05"  0"0"  0.05"0.05" , labsize(*1.2) nogrid) ///
yline(0,lp(shortdash) lcolor(gs12) lwidth(middle)) ///
title( "(b):Carbon emission: Margin effect", pos(11) size(6)) ///
xtitle("") ///
ytitle("Estimation",size(4)) ///
graphregion(fcolor(white)) ///
legend(off) 
graph export "$path/results/figure1b.pdf", as(pdf)  replace
*******************
use $path/data/data,clear
gen Output_factor2=1 if Output_factor<50 
gen Output_factor3=1 if Output_factor<60 & Output_factor>=50
gen Output_factor4=1 if Output_factor<70 & Output_factor>=60
gen Output_factor5=1 if Output_factor<80 & Output_factor>=70
gen Output_factor6=1 if Output_factor<90 & Output_factor>=80
gen Output_factor7=1 if Output_factor>=90
foreach var of varlist Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Output_factor7 {
replace `var'=0 if `var'==.
}
reghdfe ln_Energy_consumption  Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6  Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m3
parmest , saving(si_3.dta, replace) idstr("b0") idnum(1)
reghdfe ln_Carbon_emission  Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m4
parmest , saving(si_4.dta, replace) idstr("b1") idnum(1)

use si_3.dta,clear
keep if strmatch(parm,"*Output_factor*")==1
gen  x=6 if parm=="Output_factor2"
replace  x=5 if parm=="Output_factor3"
replace  x=4 if parm=="Output_factor4"
replace  x=3 if parm=="Output_factor5"
replace  x=2 if parm=="Output_factor6"
set obs `= _N + 1'
replace  parm="Output_factor7" if parm==""
replace  x=1 if parm=="Output_factor7"
replace max95=0 if  parm=="Output_factor7"
replace min95=0 if  parm=="Output_factor7"
replace estimate=0 if parm=="Output_factor7"
keep if x!=.
graph twoway (rspike  max95 min95 x , fcolor("0 0 210") lcolor("0 0 210")) ///
(line estimate x, lcolor(gs10) lpattern(dash)) ///
(scatter estimate x, mcolor("0 0 210") mlcolor("0 0 210") msymbol(circle) msize(1.2)) ///
,scheme(plotplain) ///
xlab(6 "<50%" 5 "50-60%" 4 "60-70%" 3 "70-80%" 2 "80-90%" 1 ">=90%" , labsize(*1.1) labcolor(black) axis(1) nogrid) ///
xscale(range(0 7)) ///
ylabel(-0.5 "0.5" 0"0" 0.5"0.5"  , labsize(*1.2) nogrid) ///
yline(0,lp(shortdash) lcolor(gs12) lwidth(middle)) ///
title( "(c):Energy consumption: Exist effect", pos(11) size(6)) ///
xtitle("") ///
ytitle("Estimation",size(4)) ///
graphregion(fcolor(white)) ///
legend(off) 
graph export "$path/results/figure1c.pdf", as(pdf)  replace

*******
use si_4.dta,clear
keep if strmatch(parm,"*Output_factor*")==1
gen   x=6 if parm=="Output_factor2"
replace  x=5 if parm=="Output_factor3"
replace  x=4 if parm=="Output_factor4"
replace  x=3 if parm=="Output_factor5"
replace  x=2 if parm=="Output_factor6"
set obs `= _N + 1'
replace  parm="Output_factor7" if parm==""
replace  x=1 if parm=="Output_factor7"
replace max95=0 if  parm=="Output_factor7"
replace min95=0 if  parm=="Output_factor7"
replace estimate=0 if parm=="Output_factor7"
keep if x!=.
graph twoway (rspike  max95 min95 x , fcolor("213 0 0") lcolor("213 0 0")) ///
(line estimate x, lcolor(gs10) lpattern(dash)) ///
(scatter estimate x, mcolor("213 0 0") mlcolor("213 0 0") msymbol(circle) msize(1.2)) ///
,scheme(plotplain) ///
xlab(6 "<50%" 5 "50-60%" 4 "60-70%" 3 "70-80%" 2 "80-90%" 1 ">=90%" , labsize(*1.1) labcolor(black) axis(1) nogrid) ///
xscale(range(0 7)) ///
ylabel(-0.5 "0.5" 0"0" 0.5"0.5"    , labsize(*1.2) nogrid) ///
yline(0,lp(shortdash) lcolor(gs12) lwidth(middle)) ///
title( "(d):Carbon emission: Exist effect", pos(11) size(6)) ///
xtitle("") ///
ytitle("Estimation",size(4)) ///
graphregion(fcolor(white)) ///
legend(off) 
graph export "$path/results/figure1d.pdf",as(pdf) replace
******************************************************
******************************************************figure 2
use $path/data/data,clear
gen season=1 if month=="01"
replace season=1 if month=="02"
replace season=1 if month=="03"
replace season=2 if month=="04"
replace season=2 if month=="05"
replace season=2 if month=="06"
replace season=3 if month=="07"
replace season=3 if month=="08"
replace season=3 if month=="09"
replace season=4 if month=="10"
replace season=4 if month=="11"
replace season=4 if month=="12"
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if season==1, absorb(Unit Time) vce(cluster Unit)
est store m1
parmest , saving(temporary_r1.dta, replace) idstr("纯0") idnum(1) 
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired  if season==1, absorb(Unit Time) vce(cluster Unit)
est store m2
parmest , saving(temporary_r2.dta, replace) idstr("纯1") idnum(1) 
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if season==2, absorb(Unit Time) vce(cluster Unit)
est store m3
parmest , saving(temporary_r3.dta, replace) idstr("非0") idnum(1) 
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if season==2, absorb(Unit Time) vce(cluster Unit)
est store m4
parmest , saving(temporary_r4.dta, replace) idstr("非1") idnum(1) 
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if season==3, absorb(Unit Time) vce(cluster Unit)
est store m5
parmest , saving(temporary_r5.dta, replace) idstr("气0") idnum(1) 
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if season==3, absorb(Unit Time) vce(cluster Unit)
est store m6
parmest , saving(temporary_r6.dta, replace) idstr("气1") idnum(1) 
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if season==4, absorb(Unit Time) vce(cluster Unit)
est store m7
parmest , saving(temporary_r7.dta, replace) idstr("油0") idnum(1) 
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if season==4, absorb(Unit Time) vce(cluster Unit)
parmest , saving(temporary_r8.dta, replace) idstr("油1") idnum(1)
est store m8
use temporary_r1.dta,clear
forvalues i=2/8{
append using temporary_r`i'.dta
}
save temporary_season.dta,replace
use temporary_season.dta,clear
keep if parm == "Output_factor"
gen poor=substr(idstr,4,1)
destring poor,replace
gen n=1 if idstr=="纯0"
replace n=2 if idstr=="纯1"
replace n=4 if idstr=="非0"
replace n=5 if idstr=="非1"
replace n=7 if idstr=="气0"
replace n=8 if idstr=="气1"
replace n=10 if idstr=="油0"
replace n=11 if idstr=="油1"
graph twoway (rspike max95 min95 n if poor==0, fcolor("0 0 210") lcolor("0 0 210")) ///
(scatter estimate n if poor==0, mcolor("0 0 210") mlcolor("0 0 210") msymbol(circle) msize(1.2)) ///
(rspike max95 min95 n if poor==1, fcolor("213 0 0") lcolor("213 0 0")) ///
(scatter estimate n if poor==1, mcolor("213 0 0") mlcolor("213 0 0") msymbol(circle) msize(1.2)) ///
,scheme(plotplain) ///
xlab(1.5 "First"  4.5 "Second" 7.5 "Third" 10.4 "Forth" , labsize(*1.2) labcolor(black) axis(1) nogrid) ///
xscale(range(0 12)) ///
ylabel(-0.04 "-0.04"   -0.02 "-0.02"   -0.0 "0"  0.02 "0.02"  , labsize(*1.2) nogrid) ///
yline(0,lp(shortdash) lcolor(gs12) lwidth(middle)) ///
title( "(a)Seasonal effect", pos(11) size(6)) ///
xtitle("") ///
ytitle("Estimation",size(4)) ///
graphregion(fcolor(white)) ///
legend(order( 2 4) label(2 "Energy consumption") label(4 "Carbon emission")  size(3.4)  color(gs3) col(3) row(3) ring(0) pos(11) rowgap(0.4) colgap(0.4) keygap(0.4) region(lcolor(white)) ) 
graph export "$path/results/figure2a.pdf", as(pdf)  replace

***figure 2 b
use $path/data/data,clear
gen 单=1 if Coal_fired_unit ==1| Oil_coal_fired==1| Oil_fired==1
replace 单=0 if Gas_coal_fired_unit==1 
*****************
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired  if 单==1 , absorb(Unit Time) vce(cluster Unit)
est store m1
parmest , saving(temporary_s1.dta, replace) idstr("单一0") idnum(1) 
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if 单==1 , absorb(Unit Time) vce(cluster Unit)
est store m2
parmest , saving(temporary_s2.dta, replace) idstr("单一1") idnum(1) 
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired  if 单==0 , absorb(Unit Time) vce(cluster Unit)
est store m3
parmest , saving(temporary_s3.dta, replace) idstr("非单0") idnum(1) 
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if 单==0 , absorb(Unit Time) vce(cluster Unit)
parmest , saving(temporary_s4.dta, replace) idstr("非单1") idnum(1) 
est store m4
use temporary_s1,clear
forvalues i=2/4{
append using temporary_s`i'.dta
}
save Types_of_units.dta,replace
use Types_of_units.dta,clear
keep if parm == "Output_factor"
gen poor=substr(idstr,7,1)
destring poor,replace
gen n=1 if idstr=="单一0"
replace n=2 if idstr=="单一1"
replace n=4 if idstr=="非单0"
replace n=5 if idstr=="非单1"
graph twoway (rspike max95 min95 n if poor==0, fcolor("0 0 210") lcolor("0 0 210")) ///
(scatter estimate n if poor==0, mcolor("0 0 210") mlcolor("0 0 210") msymbol(circle) msize(1.2)) ///
(rspike max95 min95 n if poor==1, fcolor("213 0 0") lcolor("213 0 0")) ///
(scatter estimate n if poor==1, mcolor("213 0 0") mlcolor("213 0 0") msymbol(circle) msize(1.2)) ///
,scheme(plotplain) ///
xlab(1.5 "Fossil fuel-fired units"  4.5 "Coal and gas co-fired units" , labsize(*1.2) labcolor(black) axis(1) nogrid) ///
xscale(range(0 6)) ///
ylabel(-0.02 "-0.02"   -0.0 "0"  0.02 "0.02"  , labsize(*1.2) nogrid) ///
yline(0,lp(shortdash) lcolor(gs12) lwidth(middle)) ///
title( "(b) Types of units", pos(11) size(6)) ///
xtitle("") ///
ytitle("Estimation",size(4)) ///
graphregion(fcolor(white)) ///
legend(order( 2 4) label(2 "Energy consumption") label(4 "Carbon emission")  size(3.4)  color(gs3) col(3) row(3) ring(0) pos(11) rowgap(0.4) colgap(0.4) keygap(0.4) region(lcolor(white)) ) 
graph export "$path/results/figure2b.pdf", as(pdf)  replace

************************************************************
************************************************************  figure 3
*****step 1, compute the mean estimated coefficients by technology type
use $path/data/sigle_unit,clear
gen Output_factor2=1 if Output_factor<50 
gen Output_factor3=1 if Output_factor<60 & Output_factor>=50
gen Output_factor4=1 if Output_factor<70 & Output_factor>=60
gen Output_factor5=1 if Output_factor<80 & Output_factor>=70
gen Output_factor6=1 if Output_factor<90 & Output_factor>=80
gen Output_factor7=1 if Output_factor>=90
foreach var of varlist  Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Output_factor7 {
replace `var'=0 if `var'==.
}
mixed Carbon_emission  Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired i.Time || sig_unit:  Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6
predict re_* , reffects
forvalues i=2/6{
    quietly lincom Output_factor`i'
    gen ub_`i' = r(ub)          
    gen lb_`i' = r(lb)          
    gen b_`i'  = r(estimate)    
}
forvalues i=2/6{
    gen est_Output_factor`i' =_b[Output_factor`i']+re_`i'
}
forvalues i=2/6{
    gen ub_Output_factor`i' = ub_`i' + re_`i'
}
forvalues i=2/6{
    gen lb_Output_factor`i' = lb_`i' + re_`i'
}
egen z=tag(sig_unit)
drop if z==0
keep  sig_unit est_Output_factor* lb_Output_factor* ub_Output_factor*
save sig_unit_estimate,replace 
*****Extract the technology type for each unit
use $path/data/sigle_unit,clear
egen z=tag(sig_unit) 
drop if z==0
drop z
keep  sig_unit  unit_tech tech
save Unit_tech,replace
*****************Average of random coefficients (use the full-sample mean if technology type is unknown; otherwise use the mean of the corresponding group)
use sig_unit_estimate,clear
merge m:1 sig_unit using Unit_tech
drop _merge 
forvalues i=2/6{
egen mean_est_out_`i' = mean(est_Output_factor`i')
}
forvalues i=2/6{
    egen ub_mean_est_out_`i' = mean(ub_Output_factor`i')
}
forvalues i=2/6{
    egen lb_mean_est_out_`i' = mean(lb_Output_factor`i')
}
keep mean_est_out_2 -mean_est_out_6 unit_tech tech  ub_mean_est_out_2 -ub_mean_est_out_6  lb_mean_est_out_2 -lb_mean_est_out_6 
keep if unit_tech=="unknown"
egen z=tag(unit_tech)
drop if z==0
drop z
save sig_unit_estimate_mean_all,replace
use sig_unit_estimate,clear
merge m:1 sig_unit using Unit_tech
drop _merge 
forvalues i=2/6{
bys unit_tech: egen mean_est_out_`i' = mean(est_Output_factor`i')
}
forvalues i=2/6{
bys unit_tech: egen ub_mean_est_out_`i' = mean(ub_Output_factor`i')
}
forvalues i=2/6{
bys unit_tech: egen lb_mean_est_out_`i' = mean(lb_Output_factor`i')
}
keep mean_est_out_2 -mean_est_out_6 unit_tech tech   lb_mean_est_out_2 -lb_mean_est_out_6   ub_mean_est_out_2 -ub_mean_est_out_6
egen z=tag(unit_tech)
drop if z==0
drop z
drop if unit_tech=="unknown"
append using sig_unit_estimate_mean_all
save $path/results/sig_unit_estimate_mean,replace
*************step 2, compute the mean estimated coefficients by technology type
use $path/data/province_unit_reg,clear
forvalues i=2/7{
tobit  Output_factor_share`i'  tech_1 tech_2 tech_3  gdp_pc wind_ele_pc solar_ele_pc service_share, ll(0)  ul(1)
preserve
gen ke=1
drop if ke==1
append using $path/data/province_unit_append
predict Output_factor_sha_exp`i', ystar(0,1)
keep id Output_factor_sha_exp`i' province year
save Output_factor_sha_exp`i',replace 
restore
}
********
use Output_factor_sha_exp2,clear
forvalues i=3/7{
merge 1:1 id using Output_factor_sha_exp`i' 
drop _merge
}
foreach var of varlist Output_factor_sha_exp2-Output_factor_sha_exp7{
replace `var'=0 if `var'==.
}
gen sum=Output_factor_sha_exp2 +Output_factor_sha_exp3+Output_factor_sha_exp4+Output_factor_sha_exp5+Output_factor_sha_exp6+Output_factor_sha_exp7
forvalues i=2/7{
gen pre_Output_factor_sha`i'=Output_factor_sha_exp`i'/sum
}
keep pre_Output_factor_sha* province year id
save $path/results/output_factor_share,replace
********************step 3  Calculate the overestimation
use $path/data/province_unit_tech_share,clear
merge m:1 tech using $path/results/sig_unit_estimate_mean
keep if _merge==3
drop _merge
bys province tech:gen year=_n+2022
tostring year,replace
gen id=province+year
merge m:1 id using $path/data/coal_power_generation
keep if _merge==3
drop _merge

merge m:1 id using  $path/results/output_factor_share
keep if _merge==3
drop _merge
forvalues i=2/4{
gen cha_est_out_`i'=mean_est_out_`i'-mean_est_out_5
}
forvalues i=2/4{
gen coal_increased_`i'=coal_ele*pre_Output_factor_sha`i'*cha_est_out_`i' *tech_share 
replace coal_increased_`i'=0 if coal_increased_`i'==.
}
egen carbon_increased = rowtotal(coal_increased_2-coal_increased_4)
replace carbon_increased =carbon_increased /10000
***province
egen z=tag(province)
drop if z==0
gen carbon_coal=1.158249*coal_ele
replace carbon_coal=(carbon_coal)/10000
gen new_carbon=carbon_coal+carbon_increased 
merge 1:1 province using $path/data/province
drop _merge
keep  carbon_increased coal_ele province year new_carbon carbon_coal iso
export delimited using "$path/results/figure3.csv", replace 
***all
egen all_carbon_coal=sum(carbon_coal)
egen all_carbon_increased=sum(carbon_increased)
gen bi=all_carbon_increased/all_carbon_coal
egen all_new_carbon=sum(new_carbon)
sum bi

************************robustness test 95% CI ub
use $path/data/province_unit_tech_share,clear
merge m:1 tech using $path/results/sig_unit_estimate_mean
keep if _merge==3
drop _merge
bys province tech:gen year=_n+2022
tostring year,replace
gen id=province+year
merge m:1 id using $path/data/coal_power_generation
keep if _merge==3
drop _merge

merge m:1 id using  $path/results/output_factor_share
keep if _merge==3
drop _merge
forvalues i=2/4{
gen ub_cha_est_out_`i'=ub_mean_est_out_`i'-ub_mean_est_out_5
}
forvalues i=2/4{
gen ub_coal_increased_`i'=coal_ele*pre_Output_factor_sha`i'*ub_cha_est_out_`i' *tech_share 
replace ub_coal_increased_`i'=0 if ub_coal_increased_`i'==.
}
forvalues i=2/4{
gen lb_cha_est_out_`i'=lb_mean_est_out_`i'-lb_mean_est_out_5
}
forvalues i=2/4{
gen lb_coal_increased_`i'=coal_ele*pre_Output_factor_sha`i'*lb_cha_est_out_`i' *tech_share 
replace lb_coal_increased_`i'=0 if lb_coal_increased_`i'==.
}
egen ub_carbon_increased = rowtotal(ub_coal_increased_2-ub_coal_increased_4)
replace ub_carbon_increased =ub_carbon_increased /10000
egen lb_carbon_increased = rowtotal(lb_coal_increased_2-lb_coal_increased_4)
replace lb_carbon_increased =lb_carbon_increased /10000
***all
egen z=tag(province)
drop if z==0
gen carbon_coal=1.158249*coal_ele
replace carbon_coal=(carbon_coal)/10000
egen all_carbon=sum(carbon_coal)
gen ub_new_carbon=carbon_coal+ub_carbon_increased 
gen lb_new_carbon=carbon_coal+lb_carbon_increased 
egen ub_all_new_carbon=sum(ub_new_carbon)
egen lb_all_new_carbon=sum(lb_new_carbon)
egen ub_all_carbon_increased=sum(ub_carbon_increased)
egen lb_all_carbon_increased=sum(lb_carbon_increased)
gen ub_bi=ub_all_carbon_increased/ all_carbon
gen lb_bi=lb_all_carbon_increased/ all_carbon
sum ub_bi lb_bi

************************robustness test 95% bootstrap CI
*Bootstrap is slow; save and reuse per-iteration results.
/*
use $path/data/sigle_unit,clear
gen Output_factor2=1 if Output_factor<50 
gen Output_factor3=1 if Output_factor<60 & Output_factor>=50
gen Output_factor4=1 if Output_factor<70 & Output_factor>=60
gen Output_factor5=1 if Output_factor<80 & Output_factor>=70
gen Output_factor6=1 if Output_factor<90 & Output_factor>=80
gen Output_factor7=1 if Output_factor>=90
foreach var of varlist  Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Output_factor7 {
replace `var'=0 if `var'==.
}
capture program drop boot_mixed_coef
program boot_mixed_coef, rclass
    version 15
    mixed Carbon_emission  Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value    Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired i.Time || sig_unit: Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 , iterate(100) difficult
    return scalar beta2 = _b[Output_factor2]
    return scalar beta3 = _b[Output_factor3]
    return scalar beta4 = _b[Output_factor4]
    return scalar beta5 = _b[Output_factor5]
    return scalar beta6 = _b[Output_factor6]
end
bootstrap ///
    beta2=r(beta2) ///
    beta3=r(beta3) ///
    beta4=r(beta4) ///
    beta5=r(beta5) ///
    beta6=r(beta6) ///
    , cluster(sig_unit) idcluster(new_sigid) reps(1000) seed(123) saving(boot_coef_raw, replace) ///
: boot_mixed_coef
mixed Carbon_emission  Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired i.Time || sig_unit: Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 , iterate(100) difficult
predict re* , reffects  
preserve
use boot_coef_raw, clear
_pctile beta2, p(2.5 97.5)
scalar lb2 = r(r1)
scalar ub2 = r(r2)
_pctile beta3, p(2.5 97.5)
scalar lb3 = r(r1)
scalar ub3 = r(r2)
_pctile beta4, p(2.5 97.5)
scalar lb4 = r(r1)
scalar ub4 = r(r2)
_pctile beta5, p(2.5 97.5)
scalar lb5 = r(r1)
scalar ub5 = r(r2)
_pctile beta6, p(2.5 97.5)
scalar lb6 = r(r1)
scalar ub6 = r(r2)
restore
scalar b2 = _b[Output_factor2]
scalar b3 = _b[Output_factor3]
scalar b4 = _b[Output_factor4]
scalar b5 = _b[Output_factor5]
scalar b6 = _b[Output_factor6]
gen b_2 = b2
gen b_3 = b3
gen b_4 = b4
gen b_5 = b5
gen b_6 = b6
gen lb_2 = lb2
gen lb_3 = lb3
gen lb_4 = lb4
gen lb_5 = lb5
gen lb_6 = lb6
gen ub_2 = ub2
gen ub_3 = ub3
gen ub_4 = ub4
gen ub_5 = ub5
gen ub_6 = ub6
forvalues i=2/6{
    local re_idx = `i' -1
    gen random_Output_factor`i' = b_`i' + re`re_idx'
    gen random_lb_Output_factor`i' = lb_`i' + re`re_idx'
    gen random_ub_Output_factor`i' = ub_`i' + re`re_idx'
}
egen z=tag(sig_unit)
preserve
keep if z==1
keep sig_unit random_ub_Output_factor*
rename random_ub_Output_factor2 ub_Output_factor2
rename random_ub_Output_factor3  ub_Output_factor3
rename random_ub_Output_factor4  ub_Output_factor4
rename random_ub_Output_factor5  ub_Output_factor5
rename random_ub_Output_factor6 ub_Output_factor6
save boos_ub,replace
restore
preserve
keep if z==1
keep sig_unit random_lb_Output_factor*
rename random_lb_Output_factor2 lb_Output_factor2
rename random_lb_Output_factor3  lb_Output_factor3
rename random_lb_Output_factor4  lb_Output_factor4
rename random_lb_Output_factor5  lb_Output_factor5
rename random_lb_Output_factor6 lb_Output_factor6
save boos_lb,replace
restore

use boos_lb,clear
merge 1:1  sig_unit using  boos_ub
drop _merge
merge m:1 sig_unit using Unit_tech
drop _merge 
forvalues i=2/6{
    egen ub_mean_est_out_`i' = mean(ub_Output_factor`i')
}
forvalues i=2/6{
    egen lb_mean_est_out_`i' = mean(lb_Output_factor`i')
}
keep  unit_tech tech  ub_mean_est_out_2 -ub_mean_est_out_6  lb_mean_est_out_2 -lb_mean_est_out_6 
keep if unit_tech=="unknown"
egen z=tag(unit_tech)
drop if z==0
drop z
save boos_sig_unit_estimate_mean_all,replace


use boos_lb,clear
merge 1:1  sig_unit using  boos_ub
drop _merge
merge m:1 sig_unit using Unit_tech
drop _merge 
forvalues i=2/6{
bys unit_tech: egen ub_mean_est_out_`i' = mean(ub_Output_factor`i')
}
forvalues i=2/6{
bys unit_tech: egen lb_mean_est_out_`i' = mean(lb_Output_factor`i')
}
keep unit_tech tech   lb_mean_est_out_2 -lb_mean_est_out_6   ub_mean_est_out_2 -ub_mean_est_out_6
egen z=tag(unit_tech)
drop if z==0
drop z
drop if unit_tech=="unknown"
append using boos_sig_unit_estimate_mean_all
save $path/results/boos_sig_unit_estimate_mean,replace
save $path/data/boos_sig_unit_estimate_mean,replace
*/


use $path/data/province_unit_tech_share,clear
merge m:1 tech using $path/data/boos_sig_unit_estimate_mean
keep if _merge==3
drop _merge
bys province tech:gen year=_n+2022
tostring year,replace
gen id=province+year
merge m:1 id using $path/data/coal_power_generation
keep if _merge==3
drop _merge

merge m:1 id using  $path/results/output_factor_share
keep if _merge==3
drop _merge
forvalues i=2/4{
gen ub_cha_est_out_`i'=ub_mean_est_out_`i'-ub_mean_est_out_5
}
forvalues i=2/4{
gen ub_coal_increased_`i'=coal_ele*pre_Output_factor_sha`i'*ub_cha_est_out_`i' *tech_share 
replace ub_coal_increased_`i'=0 if ub_coal_increased_`i'==.
}
forvalues i=2/4{
gen lb_cha_est_out_`i'=lb_mean_est_out_`i'-lb_mean_est_out_5
}
forvalues i=2/4{
gen lb_coal_increased_`i'=coal_ele*pre_Output_factor_sha`i'*lb_cha_est_out_`i' *tech_share 
replace lb_coal_increased_`i'=0 if lb_coal_increased_`i'==.
}
egen ub_carbon_increased = rowtotal(ub_coal_increased_2-ub_coal_increased_4)
replace ub_carbon_increased =ub_carbon_increased /10000
egen lb_carbon_increased = rowtotal(lb_coal_increased_2-lb_coal_increased_4)
replace lb_carbon_increased =lb_carbon_increased /10000
***all
egen z=tag(province)
drop if z==0
gen carbon_coal=1.158249*coal_ele
replace carbon_coal=(carbon_coal)/10000
egen all_carbon=sum(carbon_coal)
gen ub_new_carbon=carbon_coal+ub_carbon_increased 
gen lb_new_carbon=carbon_coal+lb_carbon_increased 
egen ub_all_new_carbon=sum(ub_new_carbon)
egen lb_all_new_carbon=sum(lb_new_carbon)
egen ub_all_carbon_increased=sum(ub_carbon_increased)
egen lb_all_carbon_increased=sum(lb_carbon_increased)
gen ub_bi=ub_all_carbon_increased/ all_carbon
gen lb_bi=lb_all_carbon_increased/ all_carbon
sum ub_bi lb_bi









****************************************************************************
**********************************************************figure 4 
use $path/data/sigle_unit,clear
bys tech Time: egen sum_Capacities=sum(Capacities)
merge m:1 tech using $path/data/all_Capacities
drop _merge
gen bi=Capacities/sum_Capacities
gen unit_Capacities=bi*tech_Capacities
gen weight=unit_Capacities/all_Capacities
mkspline factor =Output_factor,cubic k (50 65 70 75 80 85 90) di
reghdfe Carbon_emission factor1 factor2 factor3 factor4 factor5  factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired [pw=weight], absorb(sig_unit Time) vce(cluster sig_unit)
keep if e(sample)
set more off
gen factor_rounded = round(Output_factor, 0.1)
levelsof factor_rounded if inrange(factor_rounded, 14.4, 105.6), local(levels)
xblc factor1-factor6, covname(factor_rounded) at (`levels') reference(65) gen(a1 a2 a3 a4) line
keep a1 a2 a3 a4
drop if a1==.
gen d=_n
rename a2 estimate
rename a3 max95
rename a4 min95
replace a1=a1*10
replace a1 = round(a1)
tset a1
tsfill
ipolate estimate  a1, gen(estimate_filled)
ipolate max95  a1, gen(ub_filled)
ipolate min95  a1, gen(lb_filled)
keep a1 estimate_filled ub_filled  lb_filled 

foreach var in lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50  lf_linear_pct40 lf_linear_pct60{
    preserve
    rename a1 `var'_round
    rename estimate_filled `var'_filled
	rename ub_filled ub_`var'_filled
	rename lb_filled lb_`var'_filled
    save `var'.dta, replace
    restore
}

******
use $path/data/different_path,clear
foreach var of varlist lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50 lf_linear_pct40 lf_linear_pct60{
gen `var'_round=round(`var'*10, 1)
}
foreach var of varlist lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50 lf_linear_pct40 lf_linear_pct60{
merge m:1 `var'_round using `var'.dta
keep if _merge==3
drop _merge
}
save $path/data/target_est,replace
save $path/results/target_est,replace 
***ci 95
use $path/data/ele_pred,clear
merge m:1 year using  $path/results/target_est.dta
drop _merge
tset year
foreach var of varlist lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50 {
gen carbon_`var'=`var'_filled*coal_ele_cn_filled
}
foreach var of varlist lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50 {
gen ub_carbon_`var'=ub_`var'_filled*coal_ele_cn_filled
}
foreach var of varlist lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50 {
gen lb_carbon_`var'=lb_`var'_filled*coal_ele_cn_filled
}
foreach var of varlist carbon_lf_logistic_pct50-lb_carbon_lf_linear_pct50{
replace `var'=`var'/10000
}
foreach var of varlist carbon_lf_logistic_pct50-lb_carbon_lf_linear_pct50{
gen cum_`var'=sum(`var')
} 
keep year carbon_lf_logistic_pct50-cum_lb_carbon_lf_linear_pct50
save $path/results/predi_target,replace
export delimited using $path/results/predi_target.csv, replace
****boostrap 95
*Bootstrap is slow; save and reuse per-iteration results.
/*
use $path/data/sigle_unit,clear
bys tech Time: egen sum_Capacities=sum(Capacities)
merge m:1 tech using $path/data/all_Capacities
drop _merge
gen bi=Capacities/sum_Capacities
gen unit_Capacities=bi*tech_Capacities
gen weight=unit_Capacities/all_Capacities
save $path/results/sigle_unit_boos,replace

clear all
set more off
set seed 12345
capture postutil clear
forvalues b = 1/1000 {
    use $path/results/sigle_unit_boos,clear
	gen bs_weight = .
    capture bsample, cluster(sig_unit) weight(bs_weight)
    if _rc != 0 continue
    gen new_weight = bs_weight * weight
    capture mkspline factor = Output_factor, cubic k(50 65 70 75 80 85 90) di
    if _rc != 0 continue
    capture reghdfe Carbon_emission factor1 factor2 factor3 factor4 factor5 factor6 Operating_hours Oxidation_rate Carbon_content ///
        Sulfur_content Moisture_content Lower_heating_value ///
        Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired ///
        Coal_oil_gas_fired Oil_fired [pw=new_weight], ///
        absorb(sig_unit Time) vce(cluster sig_unit)
    if _rc != 0 continue
    keep if e(sample)
    capture drop factor_rounded
    gen factor_rounded = round(Output_factor, 0.1)
    levelsof factor_rounded if inrange(factor_rounded, 14.4, 105.6), local(levels)
    capture xblc factor1-factor5, covname(factor_rounded) ///
        at(`levels') reference(65) gen(a1 a2 a3 a4) line
    if _rc != 0 continue
    keep a1 a2 a3 a4
    drop if a1 == .
    rename a1 factor_val
    rename a2 estimate
    rename a3 max95_analytic
    rename a4 min95_analytic
    gen boot_id = `b'
    save boot_curve_`b'.dta, replace
    if mod(`b', 50) == 0 di "bootstrap `b' / 1000"
}
*
clear
local first = 1
forvalues b = 1/1000 {
    capture confirm file boot_curve_`b'.dta
    if _rc == 0 {
        if `first' == 1 {
            use boot_curve_`b'.dta, clear
            local first = 0
        }
        else {
            append using boot_curve_`b'.dta
        }
    }
}
replace factor_val = factor_val * 10
replace factor_val = round(factor_val)
bys factor_val: egen estimate_mean = mean(estimate)
bys factor_val: egen ci_low  = pctile(estimate), p(2.5)
bys factor_val: egen ci_high = pctile(estimate), p(97.5)
bys factor_val: keep if _n == 1
keep factor_val estimate_mean ci_low ci_high
rename factor_val a1
rename estimate_mean estimate
tsset a1
tsfill
ipolate estimate a1, gen(estimate_filled)
ipolate ci_low   a1, gen(lb_filled)
ipolate ci_high  a1, gen(ub_filled)
keep a1 estimate_filled lb_filled  ub_fille

foreach var in lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50  lf_linear_pct40 lf_linear_pct60{
    preserve
    rename a1 `var'_round
    rename estimate_filled `var'_filled
	rename ub_filled ub_`var'_filled
	rename lb_filled lb_`var'_filled
    save boos`var'.dta, replace
    restore
}

use $path/data/different_path,clear
foreach var of varlist lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50 {
gen `var'_round=round(`var'*10, 1)
}
foreach var of varlist lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50 {
merge m:1 `var'_round using boos`var'.dta
keep if _merge==3
drop _merge
}
save $path/data/boos_target_est,replace 
save $path/results/boos_target_est,replace 
*/
use $path/data/ele_pred,clear
merge m:1 year using  $path/data/boos_target_est.dta
drop _merge
tset year
foreach var of varlist lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50 {
gen ub_carbon_`var'=ub_`var'_filled*coal_ele_cn_filled
}
foreach var of varlist lf_logistic_pct50 lf_exp_pct50 lf_linear_pct50 {
gen lb_carbon_`var'=lb_`var'_filled*coal_ele_cn_filled
}
foreach var of varlist ub_carbon_lf_logistic_pct50-lb_carbon_lf_linear_pct50{
replace `var'=`var'/10000
}
foreach var of varlist ub_carbon_lf_logistic_pct50-lb_carbon_lf_linear_pct50{
gen cum_`var'=sum(`var')
} 
keep year ub_carbon_lf_logistic_pct50-cum_lb_carbon_lf_linear_pct50
save $path/results/boos_predi_target,replace
export delimited using $path/results/boos_predi_target.csv, replace






