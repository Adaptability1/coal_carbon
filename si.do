global path "your_path"
*adopath + "/opt/stata_ado"
*************************************table s1
use $path/data/data,clear
sum2docx Energy_consumption Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value  using Summary.docx, replace stats(N mean(%9.2f) sd(%9.2f) min max) landscape title("$path/results/table_s1") 
****************************************************table s2
use $path/data/data,clear
reghdfe Energy_consumption Output_factor , absorb(Unit Time) vce(cluster Unit)
est store m1
reghdfe Carbon_emission Output_factor, absorb(Unit Time) vce(cluster Unit)
est store m2
reghdfe Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value , absorb(Unit Time) vce(cluster Unit)
est store m3
reghdfe Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value , absorb(Unit Time) vce(cluster Unit)
est store m4
reghdfe Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m5
reghdfe Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired, absorb(Unit Time) vce(cluster Unit)
est store m6
*esttab m1 m2 m3 m4 m5 m6 using table_s2.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*************************************table s3
use $path/data/data,clear
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster company)
est store m1
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired, absorb(Unit Time) vce(cluster company)
est store m2
*esttab m1 m2  using $path/results/table_s3.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*************************************table s4
use $path/data/data,clear
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster city)
est store m1
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired, absorb(Unit Time) vce(cluster city)
est store m2
*esttab m1 m2  using $path/results/table_s4.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*************************************table s5
use $path/data/data,clear
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time year#company) vce(cluster Unit)
est store m1
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired, absorb(Unit Time year#company) vce(cluster Unit)
est store m2
*esttab m1 m2  using $path/results/table_s5.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*************************************table s6
use $path/data/data,clear
bootstrap, cluster(Unit) reps(1000) seed(123): reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m1
bootstrap, cluster(Unit) reps(1000) seed(123): reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired, absorb(Unit Time) vce(cluster Unit)
est store m2
*esttab m1 m2  using $path/results/table_s6.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
***************table s7
use $path/data/sigle_unit,clear
bys tech Time: egen sum_Capacities=sum(Capacities)
merge m:1 tech using $path/data/all_Capacities
drop _merge
gen bi=Capacities/sum_Capacities
gen unit_Capacities=bi*tech_Capacities
gen weight=unit_Capacities/all_Capacities
gen ln_Energy_consumption=ln(Energy_consumption)
gen ln_Carbon_emission=ln(Carbon_emission)
reghdfe ln_Energy_consumption Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired [pw=weight], absorb(Unit Time) vce(cluster Unit)
est store m1
reghdfe ln_Carbon_emission Output_factor Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired [pw=weight], absorb(Unit Time) vce(cluster Unit)
est store m2
*esttab m1 m2  using $path/results/table_s7.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*****************************************table s8
use $path/data/data,clear
mkspline  Output_factor1 50 Output_factor2 60 Output_factor3 70 Output_factor4 80 Output_factor5 90 Output_factor6 = Output_factor
bootstrap, cluster(Unit) reps(1000) seed(123): reghdfe ln_Energy_consumption  Output_factor1 Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m1
bootstrap, cluster(Unit) reps(1000) seed(123):reghdfe ln_Carbon_emission  Output_factor1 Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m2
*esttab m1 m2  using $path/results/table_s8.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
********************************************table s9
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
bootstrap, cluster(Unit) reps(1000) seed(123): reghdfe ln_Energy_consumption Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6  Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m1
bootstrap, cluster(Unit) reps(1000) seed(123): reghdfe ln_Carbon_emission  Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m2
*esttab m1 m2 using $path/results/table_s9.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*****************************************table s10
use $path/data/sigle_unit,clear
bys tech Time: egen sum_Capacities=sum(Capacities)
merge m:1 tech using $path/data/all_Capacities
drop _merge
gen bi=Capacities/sum_Capacities
gen unit_Capacities=bi*tech_Capacities
gen weight=unit_Capacities/all_Capacities
gen ln_Energy_consumption=ln(Energy_consumption)
gen ln_Carbon_emission=ln(Carbon_emission)
mkspline  Output_factor1 50 Output_factor2 60 Output_factor3 70 Output_factor4 80 Output_factor5 90 Output_factor6 = Output_factor
reghdfe ln_Energy_consumption  Output_factor1 Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired [pw=weight], absorb(Unit Time) vce(cluster Unit)
est store m1
reghdfe ln_Carbon_emission  Output_factor1 Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired [pw=weight], absorb(Unit Time) vce(cluster Unit)
est store m2
*esttab m1 m2 using $path/results/table_s10.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
********************************************table s11
use $path/data/sigle_unit,clear
bys tech Time: egen sum_Capacities=sum(Capacities)
merge m:1 tech using $path/data/all_Capacities
drop _merge
gen bi=Capacities/sum_Capacities
gen unit_Capacities=bi*tech_Capacities
gen weight=unit_Capacities/all_Capacities
gen ln_Energy_consumption=ln(Energy_consumption)
gen ln_Carbon_emission=ln(Carbon_emission)
gen Output_factor2=1 if Output_factor<50 
gen Output_factor3=1 if Output_factor<60 & Output_factor>=50
gen Output_factor4=1 if Output_factor<70 & Output_factor>=60
gen Output_factor5=1 if Output_factor<80 & Output_factor>=70
gen Output_factor6=1 if Output_factor<90 & Output_factor>=80
gen Output_factor7=1 if Output_factor>=90
foreach var of varlist Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Output_factor7 {
replace `var'=0 if `var'==.
}
reghdfe ln_Energy_consumption Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6  Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired [pw=weight], absorb(Unit Time) vce(cluster Unit)
est store m1
reghdfe ln_Carbon_emission  Output_factor2 Output_factor3 Output_factor4 Output_factor5 Output_factor6 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired [pw=weight], absorb(Unit Time) vce(cluster Unit)
est store m2
*esttab m1 m2 using $path/results/table_s11.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*******************************table s12
use $path/data/data,clear
reghdfe ln_Energy_consumption c.Output_factor##c.Capacities Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if Capacities<0.6, absorb(Unit Time) vce(cluster Unit)
est store m1
reghdfe ln_Carbon_emission c.Output_factor##c.Capacities Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if Capacities<0.6, absorb(Unit Time) vce(cluster Unit)
est store m2
reghdfe ln_Energy_consumption c.Output_factor##c.Capacities Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if Capacities>=0.6, absorb(Unit Time) vce(cluster Unit)
est store m3
reghdfe ln_Carbon_emission c.Output_factor##c.Capacities Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired if Capacities>=0.6, absorb(Unit Time) vce(cluster Unit)
est store m4
*esttab m1 m2 m3 m4 using $path/results/table_s12.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
*******************************table s13
use $path/data/data,clear
reghdfe ln_Energy_consumption c.Output_factor##c.Full_time Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m1
reghdfe ln_Carbon_emission c.Output_factor##c.Full_time Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
est store m2
*esttab m1 m2  using $path/results/table_s13.csv,scalars(r2 r2_w r2_o r2_b) pr2  se  replace nogap  b(%9.4f) star(* 0.10 ** 0.05 *** 0.01)
**************************************figure 1
use $path/data/data,clear
gen big=0  if   Capacities<0.6
replace big=1  if   Capacities>=0.6
gen single=1 if Coal_fired_unit ==1| Oil_coal_fired==1| Oil_fired==1
replace single=0 if Gas_coal_fired_unit==1  
graph box Output_factor, box(1, color(dkgreen%60) lcolor(dkgreen)) marker(1, mcolor(dkgreen) msymbol(circle)) ytitle("Load output factor(%)") title("(a)All", pos(11) size(4)) ylabel(20 "20" 40"40"  60"60"  80"80" 100"100"  120"120", labsize(*1) nogrid) text(85 51.5 "71.93", size(middle) placement(bottom))
graph save b_1.gph,replace
graph box Output_factor if big==0, box(1, color(dkgreen%60) lcolor(dkgreen)) marker(1, mcolor(dkgreen) msymbol(circle))  ytitle("Load output factor(%)") title("(b)Capacity<0.6GW", pos(11) size(4)) ylabel(20 "20" 40"40"  60"60"  80"80" 100"100"  120"120", labsize(*1) nogrid) text(85 52 "72.37", size(middle) placement(bottom))
graph save b_2.gph ,replace
graph box Output_factor if big==1, box(1, color(dkgreen%60) lcolor(dkgreen)) marker(1, mcolor(dkgreen) msymbol(circle)) ytitle("Load output factor(%)") title("(c)Capacity>=0.6GW", pos(11) size(4)) ylabel(20 "20" 40"40"  60"60"  80"80" 100"100"  120"120", labsize(*1) nogrid) text(85 52 "70.68", size(middle) placement(bottom))
graph save b_3.gph,replace
graph box Output_factor if single==1, box(1, color(dkgreen%60) lcolor(dkgreen)) marker(1, mcolor(dkgreen) msymbol(circle)) ytitle("Load output factor(%)") title("(d)Units without natural gas fuel", pos(11) size(4)) ylabel(20 "20" 40"40"  60"60"  80"80" 100"100"  120"120", labsize(*1) nogrid)  text(85 52 "71.74", size(middle) placement(bottom)) 
graph save b_4.gph,replace
graph box Output_factor if single==0, box(1, color(dkgreen%60) lcolor(dkgreen)) marker(1, mcolor(dkgreen) msymbol(circle)) ytitle("Load output factor(%)") title("(e)Coal and gas co-fired units", pos(11) size(4)) ylabel(20 "20" 40"40"  60"60"  80"80" 100"100"  120"120", labsize(*1) nogrid)  text(95 52 "78.80", size(middle) placement(bottom))
graph save b_5.gph ,replace
graph combine (b_1.gph b_2.gph b_3.gph b_4.gph b_5.gph), row(1) xsize(4) ysize(1.5)
graph export "$path/results/figure_s1.pdf", as(pdf)  replace
************************************* figure 2
use $path/data/data,clear
mkspline Output_factor_spline =Output_factor,cubic k (50 60 70 80 90) di
reghdfe Energy_consumption Output_factor_spline1 Output_factor_spline2 Output_factor_spline3 Output_factor_spline4 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
keep if e(sample)
set more off
gen Output_factor_rounded = round(Output_factor, 0.1)
levelsof Output_factor_rounded if inrange(Output_factor_rounded, 14.4, 105.6), local(levels)
xblc Output_factor_spline1-Output_factor_spline4, covname(Output_factor_rounded) at (`levels') reference(100.1) gen(a1 a2 a3 a4) line
keep a1 a2 a3 a4
drop if a1==.
gen d=_n
rename a2 estimate
rename a3 max95
rename a4 min95
twoway (line max95 a1, lpattern(dash) lcolor(grey)) ///
       (line min95 a1, lpattern(dash) lcolor(grey)) ///
       (line estimate a1, lpattern(solid) lcolor(blue)) ///
	   ,legend(off) xtitle("Output_factor") ytitle("Relative intensity") title( "{bf:(a) Energy consumption}", pos(11) size(4)) xlab(20 "20" 40 "40" 60 "60" 80 "80" 100 "100"  , labsize(*0.8) labcolor(black) axis(1) nogrid)
graph export "$path/results/figure_s2_a.pdf", as(pdf)  replace	   
	   
use $path/data/data,clear
mkspline Output_factor_spline =Output_factor,cubic k ( 50 60 70 80 90) di
reghdfe Carbon_emission Output_factor_spline1 Output_factor_spline2 Output_factor_spline3 Output_factor_spline4 Operating_hours Oxidation_rate Carbon_content Sulfur_content Moisture_content Lower_heating_value Coal_fired_unit Gas_coal_fired_unit Oil_coal_fired Coal_oil_gas_fired Oil_fired , absorb(Unit Time) vce(cluster Unit)
keep if e(sample)
set more off
gen Output_factor_rounded = round(Output_factor, 0.1)
levelsof Output_factor_rounded if inrange(Output_factor_rounded, 14.4, 105.6), local(levels)
xblc Output_factor_spline1-Output_factor_spline4, covname(Output_factor_rounded) at (`levels') reference(100.1) gen(a1 a2 a3 a4) line
keep a1 a2 a3 a4
drop if a1==.
gen d=_n
rename a2 estimate
rename a3 max95
rename a4 min95
twoway (line max95 a1, lpattern(dash) lcolor(grey)) ///
       (line min95 a1, lpattern(dash) lcolor(grey)) ///
       (line estimate a1, lpattern(solid) lcolor(blue)) ///
	   ,legend(off) xtitle("Output_factor") ytitle("Relative intensity") title( "{bf:(b) Carbon_emission}", pos(11) size(4)) xlab(20 "20" 40 "40" 60 "60" 80 "80" 100 "100"  , labsize(*0.8) labcolor(black) axis(1) nogrid)
graph export "$path/results/figure_s2_b.pdf", as(pdf)  replace




********************************figure3 
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
sum Carbon_emission if inrange(Output_factor, 99, 101)
gen base100 = r(mean)
set more off
gen factor_rounded = round(Output_factor, 0.1)
levelsof factor_rounded if inrange(factor_rounded, 14.4, 105.6), local(levels)
xblc factor1-factor6, covname(factor_rounded) at (`levels') reference(100.1) gen(a1 a2 a3 a4) line
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
keep a1 estimate_filled  base100

preserve
keep base100
keep if base100!=.
gen h=1
egen z=tag(h) 
drop if z==0
drop z
save base100,replace
restore
gen h=1 
drop base100
merge m:1 h using base100
drop _merge

tset a1
gen abo_estimate_filled=  base100+estimate_filled
drop if a1<300
preserve 
keep if a1==1000
keep  h abo_estimate_filled
rename abo_estimate_filled abo_estimate_filled100
save abo_estimate_filled100,replace
restore

preserve 
keep if a1==300
keep  h abo_estimate_filled
rename abo_estimate_filled abo_estimate_filled30
save abo_estimate_filled30,replace
restore

merge m:1 h using abo_estimate_filled30
drop _merge
merge m:1 h using abo_estimate_filled100
drop _merge
gen tarabo_estimate_filled=abo_estimate_filled100*1.2 
gen bi=abo_estimate_filled/abo_estimate_filled30
gen newabo_estimate_filled=tarabo_estimate_filled*bi
keep a1 newabo_estimate_filled h

preserve 
keep if a1==650
keep  h newabo_estimate_filled
rename newabo_estimate_filled newabo_estimate_filled65
save abo_estimate_filled65,replace
restore

merge m:1 h using abo_estimate_filled65
drop _merge
gen tech_estimate_filled=newabo_estimate_filled-newabo_estimate_filled65
keep tech_estimate_filled a1
rename a1 lf_linear_pct50_round
rename tech_estimate_filled tech_lf_linear_pct50_filled
save tech_lf_linear_pct50.dta, replace

use $path/data/different_path,clear
foreach var of varlist lf_linear_pct50 {
gen `var'_round=round(`var'*10, 1)
}
foreach var of varlist lf_linear_pct50 {
merge m:1 `var'_round using tech_`var'.dta
keep if _merge==3
drop _merge
}
keep year tech_lf_linear_pct50_filled
save $path/results/target_est_tech_estimate_filled,replace 


use $path/data/ele_pred,clear
merge m:1 year using  $path/data/target_est.dta
drop _merge
merge m:1 year using $path/results/target_est_tech_estimate_filled
drop _merge
tset year
foreach var of varlist lf_linear_pct40 lf_linear_pct60  {
gen carbon_`var'=`var'_filled*coal_ele_cn_filled
}
foreach var of varlist lf_linear_pct50  {
gen times_carbon_`var'=`var'_filled*times_coal_ele_cn_filled
}
foreach var of varlist lf_linear_pct50  {
gen message_carbon_`var'=`var'_filled*message_coal_ele_cn_filled
}
foreach var of varlist lf_linear_pct50  {
gen sys_carbon_`var'=`var'_filled*sys_coal_ele_cn_filled
}
foreach var of varlist lf_linear_pct50  {
gen tech_carbon_`var'=tech_`var'_filled*coal_ele_cn_filled
}
foreach var of varlist carbon_lf_linear_pct40-tech_carbon_lf_linear_pct50{
replace `var'=`var'/10000
}
foreach var of varlist carbon_lf_linear_pct40-tech_carbon_lf_linear_pct50{
gen c_`var'=sum(`var')
} 
drop if year==2023
keep year carbon_lf_linear_pct40-c_tech_carbon_lf_linear_pct50
save $path/results/si_predi_target,replace
export delimited using $path/results/si_predi_target.csv, replace



