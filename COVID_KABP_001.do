clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		COVID_KABP_001.do
**  Project:      	COVID-19 KABP Barbados
**  Analyst:		Kern Rocke
**	Date Created:	11/05/2020
**	Date Modified: 	15/05/2020
**  Algorithm Task: Population Pyramid


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

/*
Note the working directories here are set to both Windows and MAC OS

Thus before running this algorithm please ensure the appropriate *
are place under either MAC OS or Windows OS

For example if you are using Windows
Remove the * from all the code below WINDOW OS but leave the * under
MAC OS

*/


*Setting working directory
** Dataset to encrypted location

*WINDOWS OS
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p153"
*local outputpath "X:/The University of the West Indies/DataGroup - repo_data/data_p153/version01/3-output"
*cd "X:/The University of the West Indies/DataGroup - repo_data/data_p153"

*MAC OS
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153/version01/3-output"
cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"

*Load in data from encrypted location
use "`datapath'/version01/1-input/BarbadosCovid19_KABP.dta", clear

/*
Consider keeping only those who stated living in Barbados

        Where do you |
   normally live for |
  more than 3 months |
        in the year? |      Freq.     Percent        Cum.
---------------------+-----------------------------------
Other (please state) |         29        0.65        0.65
            Barbados |      4,333       97.63       98.29
       Other CARICOM |         18        0.41       98.69
               China |          3        0.07       98.76
               India |          3        0.07       98.83
              Canada |         12        0.27       99.10
                  UK |         20        0.45       99.55
                 USA |         20        0.45      100.00
---------------------+-----------------------------------
               Total |      4,438      100.00

*/
keep if q0002 == 1


*General cleaning
rename q0001 age
rename q0004 gender

*Destring age to numeric
destring age, replace

gen agegrp = age
recode agegrp (18/19=1) (20/24=2) (25/29=3) (30/34=4) (35/39=5) (40/44=6) ///
			  (45/49=7) (50/54=8) (55/59=9) (60/64=10) (65/69=11) (70/74=12) ///
			  (75/79=13) (80/84=14) (85/max=15)
label var agegrp "Age Groups"
label define agegrp 1 "18-19" ///
					2 "20-24" ///
					3 "25-29" ///
					4 "30-34" ///
					5 "35-39" ///
					6 "40-44" ///
					7 "45-49" ///
					8 "50-54" ///
					9 "55-59" ///
					10 "60-64" ///
					11 "65-69" ///
					12 "70-74" ///
					13 "75-79" ///
					14 "80-84" ///
					15 "85- & over"
label value agegrp agegrp					


//Keep male and female
gen sex = .
replace sex =1 if gender == 1 // Female
replace sex =2 if gender == 2 // Male
label var sex "Sex"
label define sex 1"Female" 2"Male"
label value sex sex

tab agegrp sex

gen pop = 1
collapse (sum) pop, by(agegrp sex)

//Remove missinng data
drop if sex == .
drop if agegrp == .


egen sp1 = sum(pop)
gen pop1 = pop/sp1

** Now we change those 2000 numbers to 2010
gen pop_bb = .
//Female
replace pop_bb=9418 if sex==1 & agegrp==1
replace pop_bb=9108 if sex==1 & agegrp==2
replace pop_bb=9775 if sex==1 & agegrp==3
replace pop_bb=9635 if sex==1 & agegrp==4
replace pop_bb=10632 if sex==1 & agegrp==5
replace pop_bb=10450 if sex==1 & agegrp==6
replace pop_bb=11303 if sex==1 & agegrp==7
replace pop_bb=10639 if sex==1 & agegrp==8
replace pop_bb=8782 if sex==1 & agegrp==9
replace pop_bb=7160 if sex==1 & agegrp==10
replace pop_bb=5640 if sex==1 & agegrp==11
replace pop_bb=4876 if sex==1 & agegrp==12
replace pop_bb=4074 if sex==1 & agegrp==13
replace pop_bb=3167 if sex==1 & agegrp==14
replace pop_bb=3388 if sex==1 & agegrp==15

//Male
replace pop_bb=9452 if sex==2 & agegrp==1
replace pop_bb=9061 if sex==2 & agegrp==2
replace pop_bb=9313 if sex==2 & agegrp==3
replace pop_bb=9150 if sex==2 & agegrp==4
replace pop_bb=9884 if sex==2 & agegrp==5
replace pop_bb=9663 if sex==2 & agegrp==6
replace pop_bb=10062 if sex==2 & agegrp==7
replace pop_bb=9411 if sex==2 & agegrp==8
replace pop_bb=7871 if sex==2 & agegrp==9
replace pop_bb=6326 if sex==2 & agegrp==10
replace pop_bb=4511 if sex==2 & agegrp==11
replace pop_bb=3804 if sex==2 & agegrp==12
replace pop_bb=2863 if sex==2 & agegrp==13
replace pop_bb=1968 if sex==2 & agegrp==14
replace pop_bb=1660 if sex==2 & agegrp==15

gen pop_wpps = .
//Female
replace pop_wpps = 9218 if sex==1 & agegrp==1 
replace pop_wpps = 9230 if sex==1 & agegrp==2 
replace pop_wpps = 9402 if sex==1 & agegrp==3 
replace pop_wpps = 9086 if sex==1 & agegrp==4 
replace pop_wpps = 9749 if sex==1 & agegrp==5 
replace pop_wpps = 9584 if sex==1 & agegrp==6 
replace pop_wpps = 10515 if sex==1 & agegrp==7 
replace pop_wpps = 10241 if sex==1 & agegrp==8 
replace pop_wpps = 10848 if sex==1 & agegrp==9 
replace pop_wpps = 10000 if sex==1 & agegrp==10 
replace pop_wpps = 8093 if sex==1 & agegrp==11 
replace pop_wpps = 6407 if sex==1 & agegrp==12 
replace pop_wpps = 4689 if sex==1 & agegrp==13 
replace pop_wpps = 3508 if sex==1 & agegrp==14 
replace pop_wpps = 4036 if sex==1 & agegrp==15 

//Male
replace pop_wpps = 9714 if sex==2 & agegrp==1 
replace pop_wpps = 9539 if sex==2 & agegrp==2 
replace pop_wpps = 9407 if sex==2 & agegrp==3 
replace pop_wpps = 9015 if sex==2 & agegrp==4 
replace pop_wpps = 9274 if sex==2 & agegrp==5 
replace pop_wpps = 9220 if sex==2 & agegrp==6 
replace pop_wpps = 9748 if sex==2 & agegrp==7 
replace pop_wpps = 9394 if sex==2 & agegrp==8 
replace pop_wpps = 9453 if sex==2 & agegrp==9 
replace pop_wpps = 8540 if sex==2 & agegrp==10 
replace pop_wpps = 6940 if sex==2 & agegrp==11 
replace pop_wpps = 5482 if sex==2 & agegrp==12 
replace pop_wpps = 3576 if sex==2 & agegrp==13 
replace pop_wpps = 2601 if sex==2 & agegrp==14 
replace pop_wpps = 2664 if sex==2 & agegrp==15 


egen sp2 = sum(pop_bb)
egen sp3 = sum(pop_wpps)
drop pop1
reshape wide pop pop_bb pop_wpps, i(agegrp) j(sex)

browse
gen zero = 0
gen pop1_per = pop1/sp1 // Sample Female
gen pop2_per = pop2/sp1 // Sample Male
gen pop_bb1_per = pop_bb1/sp2 // BSS Female
gen pop_bb2_per = pop_bb2/sp2 // BSS Male
gen pop_wpps1_per = pop_wpps1/sp3 // WPPS Female
gen pop_wpps2_per = pop_wpps2/sp3 // WPPS Female


replace pop2_per = -pop2_per
replace pop_bb2_per = -pop_bb2_per
replace pop_wpps2_per = -pop_wpps2_per


#delimit ;
	twoway 
	/// COVID KABP - women
	(bar pop1_per agegrp, horizontal lw(thin) lc(gs11) fc(red*0.8) ) ||
	/// COVID KABP - men 
	(bar pop2_per agegrp, horizontal lw(thin) lc(gs11) fc(blue*0.8) ) ||
	/// BSS 2010
	(connect agegrp pop_bb1_per, symbol(T) mc(gs0) lc(gs0))
	(connect agegrp pop_bb2_per, symbol(T) mc(gs0) lc(gs0))
	/// WPPS 2020
	(connect agegrp pop_wpps1_per, symbol(S) mc(green) lc(green))
	(connect agegrp pop_wpps2_per, symbol(S) mc(green) lc(green))

	(sc agegrp zero, mlabel(agegrp) mlabcolor(black) msymbol(i))
	, 

	plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
	graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(3)

	title("Barbados COVID-10 KABP Survey Population by Age Groups", c(black))
	xtitle("Proportion of Residents withn Age Group", size(small)) ytitle("")
	plotregion(style(none))
	ysca(noline) ylabel(none)
	xsca(noline titlegap(0.5))
	xlabel(-0.1 "0.1" -0.08 "0.08" -0.06 "0.06" -0.04 "0.04" -0.02 "0.02" 0 "0" 
	0.02 "0.02" 0.04 "0.04" 0.06 "0.06" 0.08 "0.08" 0.1 "0.1", tlength(0) 
	nogrid gmin gmax)
	caption("Source: COVID-19 KABP, Barbados Statistical Service, UN World Population Prospectus", span size(vsmall))
	legend(size(small) position(12) bm(t=1 b=0 l=0 r=0) colf cols(4)
	region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(1 2 3 5)
	lab(1 "Females") 
	lab(2 "Males")
	lab(3 "BSS 2010")
	lab(5 "WPPS 2020")
	);
#delimit cr

graph export "`outputpath'/COVID_19_KABP.png", replace

