clear
capture log close
cls

**  GENERAL DO-FILE COMMENTS
**  Program:		COVID_KABP_002.do
**  Project:      	COVID-19 KABP Barbados
**  Analyst:		Kern Rocke & Christina Howitt
**	Date Created:	12/05/2020
**	Date Modified: 	17/05/2020
**  Algorithm Task: Inital Descriptives for MoHW


** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

/*
NOTE:
The working directories here are set to both Windows and MAC OS

Thus before running this algorithm please ensure the appropriate *
are place under either MAC OS or Windows OS

For example if you are using Windows
Remove the * from all the code below WINDOW OS but leave the * under
MAC OS

*/


*Setting working directories

*WINDOWS OS
**Datasets to encrypted folder
*local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p153"
**Result outputs to unencrypted folder
*local outputpath "X:/The University of the West Indies/DataGroup - PROJECT_p153/05_Outputs"
*cd "X:/The University of the West Indies/DataGroup - repo_data/data_p153"

*MAC OS
**Datasets to encrypted folder
local datapath "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"
**Logfiles to unencrypted folder
local logpath "/Volumes/Secomba/kernrocke/Boxcryptor/OneDrive - The University of the West Indies/Github Repositories/repo_p153"
**Result outputs to unencrypted folder
local outputpath "/Volumes/Secomba/kernrocke/Boxcryptor/The University of the West Indies/DataGroup - PROJECT_p153/05_Outputs"
cd "/Volumes/Secomba/kernrocke/Boxcryptor/DataGroup - repo_data/data_p153"

** Close any open log files and open new log file
capture log close

*Install mrtab for dealing with multiple response questions- This user driven command can be used to tabulate variables used for multiple responses
ssc install mrtab, replace

*Load in data from encrypted location
use "`datapath'/version01/1-input/BarbadosCovid19_KABP.dta", clear

/*
This algorithm provides basic descriptives for key variables for reporting of 
results of the COVID-19 KABP Barbados study. 
*/

*-------------------------------------------------------------------------------

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
*keep if q0002 == 1

*Descriptives

*Age
rename q0001 age
destring age, replace

*Age categories (10-year bands)
gen agegrp = age
recode agegrp (18/29=1) (30/39=2) (40/49=3) (50/59=4) (60/69=5) (70/max=6)
label var agegrp "Age Category (10-year bands)"
label define agegrp 1	"18-29" ///
					2	"30-39" ///
					3	"40-49" ///
					4	"50-59" ///
					5	"60-69" ///
					6	"70 & over"
label value agegrp agegrp


//Keep male and female
rename q0004 gender
gen sex = .
replace sex =1 if gender == 1 // Female
replace sex =2 if gender == 2 // Male
label var sex "Sex"
label define sex 1"Female" 2"Male"
label value sex sex
*Note others (transgender women; gender fluid)

*Education
gen education = .
replace education = 1 if q0012 == 1 //no primary school
replace education = 1 if q0012 == 2 //primary school
replace education = 2 if q0012 == 3 //some secondary school
replace education = 2 if q0012 == 4 //completed secondary school
replace education = 3 if q0012 == 5 //polytechnic/ BCC
replace education = 4 if q0012 == 6 //University
label var education "Education"
label define education 1"Primary/less" 2"Secondary" 3"Polytechnic/BCC" 4"University"
label value education education
*How should we deal with q0012_other [other education]   CH: there are 196 text entries that could be backcoded, but I don't think we should have to do that now. ///
I think it could have been avoided if the wording was more clear (e.g. stressed highest completed level). I will make a note when we present results

*Ethnicity
gen ethnic = . 
replace ethnic = 1 if q0013 == 1 // Black or African-decent
replace ethnic = 2 if q0013 == 5 // Indo-decent
replace ethnic = 3 if q0013 == 7 // Multiracial
replace ethnic = 4 if q0013 == 4 // White
replace ethnic = 5 if q0013 == 0 // Other
replace ethnic = 5 if q0013 == 2 // Other
replace ethnic = 5 if q0013 == 3 // Other
replace ethnic = 5 if q0013 == 8 // Other
label var ethnic "Ethnic Groups"
label define ethnic 1"Black or African" ///
					2"Indo-decent" ///
					3"Multiracial" ///
					4"White" ///
					5"Other"
label value ethnic ethnic

*Religion
gen religion = .
replace religion = 1 if q0014 == 1 // Anglican
replace religion = 2 if q0014 == 2 // Catholic
replace religion = 3 if q0014 == 3 // Baptist
replace religion = 4 if q0014 == 4 // Seventh Day Adventist
replace religion = 5 if q0014 == 5 // Muslim
replace religion = 6 if q0014 == 6 // Rastafarian
replace religion = 7 if q0014 == 7 // Hindu
replace religion = 8 if q0014 == 0 // Other
label var religion "Religion"
label define religion 1"Anglican" ///
					  2"Roman Catholic" ///
					  3"Baptist" ///
					  4"Seventh Day Adventist" ///
					  5"Muslim" /// 
					  6"Rastafarian" ///
					  7"Hindu" ///
					  8"Other"
label value religion religion


*Employment
rename q0015 employment
replace employment = 8 if employment == 0
label define q0015 8"Other", modify
label value employment q0015

*Parent guardian of children

//Remove empty variables
drop q0020_0007 - q0020_0020
rename q0020_0021 q0020_0007
rename q0020_0022 q0020_0008

gen parent_child = . 
replace parent_child = 1 if q0020_0001 == 1 // Under 6 months old
replace parent_child = 2 if q0020_0002 == 1 // Between 6 and 12 months
replace parent_child = 3 if q0020_0003 == 1 // More than 1 year to 5 years old
replace parent_child = 4 if q0020_0004 == 1 // 6 years to 10 years old
replace parent_child = 5 if q0020_0005 == 1 // 11 years to 15 years old
replace parent_child = 6 if q0020_0006 == 1 // 16 years to 18 years old
replace parent_child = 7 if q0020_0007 == 1 // Older than 18
replace parent_child = 8 if q0020_0008 == 1 // I do not have children
label var parent_child "Are you the parent/ guardian of children of any of the following ages?"
label define parent_child 1 "Under 6 months old" ///
						  2 "Between 6 and 12 months" ///
						  3 "More than 1 year to 5 years old" ///
						  4 "6 years to 10 years old" ///
						  5 "11 years to 15 years old" ///
						  6 "16 years to 18 years old" ///
						  7 "Older than 18" ///
						  8 "I do not have children" 
label value parent_child parent_child
*Note: This question is multiple response and may need to be treated differently

label var q0020_0001 "Under 6 months old"
label var q0020_0002 "Between 6 and 12 months"
label var q0020_0003 "More than 1 year to 5 years old"
label var q0020_0004 "6 years to 10 years old"
label var q0020_0005 "11 years to 15 years old"
label var q0020_0006 "16 years to 18 years old"
label var q0020_0007 "Older than 18"
label var q0020_0008 "I do not have children"



*Job lost due to COVID-19
rename q0022 job_loss

*Savings to pay bills
rename q0023 save_bills
replace save_bills = 8 if save_bills == 0
label define q0023 8"Other", modify
label value save_bills q0023

*Work from home due to COVID
rename q0024 work_home
replace work_home = 5 if work_home == 0
label define q0024 5"Other", modify
label value work_home q0024

*Study from home due to COVID
rename q0025 study_home

//Essential workers
*Health workers
rename q0028 health_worker
*Essential worker
rename q0029 essential_worker

*Chronic Health conditions
gen health_condition = .
replace health_condition = 6 if q0031_0002 == 1 // Eye condititon
replace health_condition = 6 if q0031_0003 == 1 // Ear, nose and/ throat condition
replace health_condition = 5 if q0031_0004 == 1 // Cancer
replace health_condition = 6 if q0031_0005 == 1 // Epilepsy/Seizue
replace health_condition = 3 if q0031_0006 == 1 // Stroke
replace health_condition = 2 if q0031_0007 == 1 // Hypertension
replace health_condition = 3 if q0031_0008 == 1 // Heart disease
replace health_condition = 4 if q0031_0009 == 1 // Asthma
replace health_condition = 4 if q0031_0010 == 1 // Empysema, bronchitis
replace health_condition = 4 if q0031_0011 == 1 // Tuberculosis
replace health_condition = 6 if q0031_0012 == 1 // Thyroid glands
replace health_condition = 1 if q0031_0013 == 1 // Diabetes
replace health_condition = 6 if q0031_0014 == 1 // Hyperlipidemia
replace health_condition = 6 if q0031_0015 == 1 // Kidney condition
replace health_condition = 6 if q0031_0016 == 1 // Liver condition
replace health_condition = 6 if q0031_0017 == 1 // Bowel condition
replace health_condition = 6 if q0031_0018 == 1 // Anaemia
replace health_condition = 6 if q0031_0019 == 1 // Genetic blood disorder
replace health_condition = 6 if q0031_0020 == 1 // Skelettomuscular disorder
replace health_condition = 6 if q0031_0021 == 1 // Autoimmune disorder
replace health_condition = 6 if q0031_0022 == 1 // Skin coniditon
replace health_condition = 7 if q0031_0023 == 1 // Depression
replace health_condition = 7 if q0031_0024 == 1 // Anxiety
replace health_condition = 7 if q0031_0025 == 1 // Schizophrenia
replace health_condition = 6 if q0031_0028 == 1 // Other
replace health_condition = 8 if q0031_0001 == 1 // No health condition
label var health_condition "Health coniditions"
label define health_condition 1 "Diabetes" ///
							  2 "Hypertension" ///
							  3 "Heart Disease" ///
							  4 "Respiratory Disease" ///
							  5 "Cancer" ///
							  6 "Other" ///
							  7 "Mental Disease" ///
							  8 "No chronic conditions"
label value health_condition health_condition

//Heart Disease
gen heart_disease = .
replace heart_disease = 1 if q0031_0006 == 1 // Stroke
replace heart_disease = 1 if q0031_0008 == 1 // Heart disease
label var heart_disease "Heart Disease"
label define heart_disease 1 "Heart Disease"
label value heart_disease heart_disease

//Diabetes
gen diabetes = .
replace diabetes = 1 if q0031_0013 == 1 // Diabetes
label var diabetes "Diabetes"
label define diabetes 1 "Diabetes"
label value diabetes diabetes

//Hypertension
gen hypertension = .
replace hypertension = 1 if q0031_0007 == 1 // Hypertension
label var hypertension "Hypertension"
label define hypertension 1 "Hypertension"
label value hypertension hypertension

//Respiratory Disease
gen resp_disease = .
replace resp_disease = 1 if q0031_0010 == 1 // Empysema, bronchitis
replace resp_disease = 1 if q0031_0011 == 1 // Tuberculosis
replace resp_disease = 1 if q0031_0009 == 1 // Asthma
label var resp_disease "Respiratory Disease"
label define resp_disease 1 "Respiratory Disease"
label value resp_disease resp_disease

//Cancer
gen cancer = .
replace cancer = 1 if q0031_0004 == 1 // Cancer
label var cancer "Cancer"
label define cancer 1"Cancer"
label value cancer cancer

// Mental Health Disease
gen men_disease = .
replace men_disease = 1 if q0031_0023 == 1 // Depression
replace men_disease = 1 if q0031_0024 == 1 // Anxiety
replace men_disease = 1 if q0031_0025 == 1 // Schizophrenia
label var men_disease "Mental Health Disease"
label define men_disease 1" Mental Health Disease"
label value men_disease men_disease

//Other Disease
gen other_disease = .
replace other_disease = 1 if q0031_0002 == 1 // Eye condititon
replace other_disease = 1 if q0031_0003 == 1 // Ear, nose and/ throat condition
replace other_disease = 1 if q0031_0005 == 1 // Epilepsy/Seizue
replace other_disease = 1 if q0031_0012 == 1 // Thyroid glands
replace other_disease = 1 if q0031_0014 == 1 // Hyperlipidemia
replace other_disease = 1 if q0031_0015 == 1 // Kidney condition
replace other_disease = 1 if q0031_0016 == 1 // Liver condition
replace other_disease = 1 if q0031_0017 == 1 // Bowel condition
replace other_disease = 1 if q0031_0018 == 1 // Anaemia
replace other_disease = 1 if q0031_0019 == 1 // Genetic blood disorder
replace other_disease = 1 if q0031_0020 == 1 // Skelettomuscular disorder
replace other_disease = 1 if q0031_0021 == 1 // Autoimmune disorder
replace other_disease = 1 if q0031_0022 == 1 // Skin coniditon
replace other_disease = 1 if q0031_0028 == 1 // Other
label var other_disease "Other health condition"
label define other_disease 1 "Other"
label value other_disease other_disease

*No current health condition
rename q0031_0001 no_disease
label var no_disease "No chronic condition"

*Note: Should q0033 be analyzed?

*Worried about COVID-19
rename q0048 worried_covid

*Would like to be tested
rename q0050 test_interest

*Likely to be infected 
rename q0052 likely_infected

*Infection expectation
rename q0053 expect_infected
label define expect_infected 1 "Life-threatening" ///
							 2 "Severe" ///
							 3 "Moderate" ///
							 4 "Mild" ///
							 5 "No symptoms" ///
							 6 "Don't know"
label value expect_infected expect_infected

*Method of virus transmission
foreach x in q0054_0001 q0054_0002 q0054_0003 q0054_0004 q0054_0005 q0054_0006 ///
			 q0054_0007 q0054_0008 q0054_0009 q0054_0010 q0054_0011 {

recode `x' (1/2 =1) (4/5=2) (3=3) (6=4)
label define `x'       1 "Likely"  ///
					   2 "Unlikely"  ///
					   3 "Neither likely or unlikely" ///
					   4 "Don't know", modify
label value `x' `x'
}

gen protect = .
replace protect = 1 if q0055_0001 == 1 // Worn face mask
replace protect = 2 if q0055_0002 == 1 // Washed hands more frequently with soap and water
replace protect = 3 if q0055_0003 == 1 // Used hand sanitizer more regularly
replace protect = 4 if q0055_0004 == 1 // Disinfected my home
replace protect = 5 if q0055_0005 == 1 // Covered my nose and mouth with a tissue or sleeve when sneezing and coughing
replace protect = 6 if q0055_0006 == 1 // Avoided being around with people who have a fever or cold like symptoms
replace protect = 7 if q0055_0007 == 1 // Avoided being  around people who have traveled
replace protect = 8 if q0055_0008 == 1 // Avoided going out in general
replace protect = 9 if q0055_0009 == 1 // Avoided crowded areas
replace protect = 10 if q0055_0010 == 1 // Avoided going to public markets that sell fresh meat, fish or poultry
replace protect = 11 if q0055_0011 == 1 // Avoided going to hospital and other healthcare settings
replace protect = 12 if q0055_0012 == 1 // Avoided taking public transport / bus
replace protect = 13 if q0055_0013 == 1 // Avoided going to work
replace protect = 14 if q0055_0014 == 1 // Avoided going to school / university
replace protect = 15 if q0055_0015 == 1 // Avoided letting my children go to school / university
replace protect = 16 if q0055_0016 == 1 // Avoided going into shops and supermarkets
replace protect = 17 if q0055_0017 == 1 // Avoided social events
replace protect = 18 if q0055_0018 == 1 // Avoided travel
replace protect = 19 if q0055_0019 == 1 // Avoided travel to other areas (outside Barbados) 
replace protect = 20 if q0055_0020 == 1 // Avoided travel to other areas (inside Barbados)
replace protect = 21 if q0055_0021 == 1 // Moved temporarily to the countryside or a remote location
replace protect = 22 if q0055_0022 == 1 // Gargle with salt water
replace protect = 23 if q0055_0023 == 1 // Bathe in the sea
replace protect = 24 if q0055_0024 == 1 // Drink herbal /ginger/bush tea
label var protect "Protective measures due to COVID-19"
label define protect 1 "Worn face mask" ///
					2 "Washed hands more frequently with soap and water" ///
					3 "Used hand sanitizer more regularly" ///
					4 "Disinfected my home" ///
					5 "Covered my nose and mouth with a tissue or sleeve when sneezing and coughing" ///
					6 "Avoided being around with people who have a fever or cold like symptoms" ///
					7 "Avoided being  around people who have traveled" ///
					8 "Avoided going out in general" ///
					9 "Avoided crowded areas" ///
					10 "Avoided going to public markets that sell fresh meat, fish or poultry" ///
					11 "Avoided going to hospital and other healthcare settings" ///
					12 "Avoided taking public transport / bus" ///
					13 "Avoided going to work" ///
					14 "Avoided going to school / university" ///
					15 "Avoided letting my children go to school / university" ///
					16 "Avoided going into shops and supermarkets" ///
					17 "Avoided social events" ///
					18 "Avoided travel" ///
					19 "Avoided travel to other areas (outside Barbados)" ///
					20 "Avoided travel to other areas (inside Barbados)" ///
					21 "Moved temporarily to the countryside or a remote location" ///
					22 "Gargle with salt water" ///
					23 "Bathe in the sea" ///
					24 "Drink herbal /ginger/bush tea"
label value protect protect

*lockdown experience
gen lockexp=.
replace lockexp=1 if q0058_0001 !=. // It has affected my mental health
replace lockexp=2 if q0058_0002 !=. // I find it difficult to find my own space in my household
replace lockexp=3 if q0058_0003 !=. // I find it difficult to get supplies, (e.g. food, medicines, etc.)
replace lockexp=4 if q0058_0004 !=. // I am caring for others and cannot find someone to help out 
replace lockexp=5 if q0058_0005 !=. // It has affected my social life
replace lockexp=6 if q0058_0006 !=. // I have less money
replace lockexp=7 if q0058_0007 !=. // My studies or education has suffered
replace lockexp=8 if q0058_0008 !=. // Don't know
replace lockexp=9 if q0058_0009 !=. // No problem 
replace lockexp=10 if q0058_0010 !=. // Other
label variable lockexp "lockdown problems"
label define lockexp 1 "mental health" 2 "Space in household" 3 "Obtaining supplies" 4 "Care with no help" 5 "Social life" 6 "financial" 7 "Impact on education" 8 "don't know" 9 "No problems" 10 "Other"
label values lockexp lockexp 

*Sources of information
gen infosource=.
replace infosource=1 if q0079_0001 !=. 
replace infosource=2 if q0079_0002 !=. 
replace infosource=3 if q0079_0003 !=. 
replace infosource=4 if q0079_0004 !=. 
replace infosource=5 if q0079_0005 !=. 
replace infosource=6 if q0079_0006 !=. 
replace infosource=7 if q0079_0007 !=. 
replace infosource=8 if q0079_0008 !=.
replace infosource=9 if q0079_0009 !=. 
replace infosource=10 if q0079_0010 !=. 
replace infosource=11 if q0079_0011 !=.  
replace infosource=12 if q0079_0012 !=.
replace infosource=13 if q0079_0013 !=. 
label variable infosource "Source of COVID information"
label define infosource 1 "newspaper" 2 "magazine" 3 "radio" 4 "CBC" 5 "International TV" 6 "Official websites" 7 "Unofficial websites" 8 "social media" 9 "My doctor" 10 "Other healthcare professional" 11 "family or friends" 12 "work or school" 13 "No information"
label values infosource infosource 

*Preference for information
gen infopref=.
replace infopref=1 if q0080_0001 !=. 
replace infopref=2 if q0080_0002 !=. 
replace infopref=3 if q0080_0003 !=. 
replace infopref=4 if q0080_0004 !=.  
replace infopref=5 if q0080_0005 !=. 
replace infopref=6 if q0080_0006 !=. 
replace infopref=7 if q0080_0007 !=. 
replace infopref=8 if q0080_0008 !=. 
replace infopref=9 if q0080_0009 !=. 
replace infopref=10 if q0080_0010 !=. 
replace infopref=11 if q0080_0011 !=. 
replace infopref=12 if q0080_0012 !=. 
replace infopref=13 if q0080_0013 !=. 
replace infopref=14 if q0080_0014 !=. 
label variable infopref "Preference for information"
label define infopref 1 "Research" 2 "Common signs" 3 "Less common signs" 4 "How to know if infected" 5 "Info on transmission" 6 "Info on prevention" 7 "High risk groups" 8 "Number of cases (Barbados)" 9 "Distribution cases (Bds)" 10 "Infection risk (Bds)" 11 "NPIs (Bds)" 12 "NPIs (Other countries)" 13 "NPIs (international organisations)" 14 "don't want info"
label values infopref infopref 



*Renaming q0081 to COVID-19 Bioweapon
rename q0081 covid_bio

*0-12 mo; 1-5; 6-10; 11-18, >18 

*Parent and Guardians
label var q0020_0001 "Under 6 months old"
label var q0020_0002 "Between 6 and 12 months"
label var q0020_0003 "More than 1 year to 5 years old" 
label var q0020_0004 "6 years to 10 years old" 
label var q0020_0005 "11 years to 15 years old"
label var q0020_0006 "16 years to 18 years old"
label var q0020_0007 "Older than 18"
label var q0020_0008 "I do not have children"

*Current Health Condition
label var diabetes "Diabetes"
label var hypertension "Hypertension"
label var heart_disease "Heart Disease"
label var resp_disease "Respiratory Disease"
label var cancer "Cancer"
label var men_disease "Mental Health Disease"
label var other_disease "Other Disease"
label var no_disease "No Health Condition"

*Method of COVID-19 Transmission
label var q0054_0001 "Talking with but not touching someone who has corona-virus but no symptoms"
label var q0054_0002 "Talking with but not touching with somone who has corona-virus"
label var q0054_0003 "Having physical contact with someone who has corona-virus but no symptoms"
label var q0054_0004 "Having physical contact with someone with corona-virus who has symptoms"
label var q0054_0005 "Being close (i.e. within 6 feet) to someone who has corona-virus, when they cough"
label var q0054_0006 "Being further away (i.e. further than 6 feet away) to someone who has corona-virus, when they cough or sneeze"
label var q0054_0007 "Touching contaminated objects (e.g. surfaces such as Shopping carts, door handles, etc.)"
label var q0054_0008 "Consumption of wild animal meat (e.g. rabbit, Iguana, monkey, yard fowl)"
label var q0054_0009 "Visiting public markets that sell fresh meat, fish or poultry"
label var q0054_0010 "Eating foods imported from China"
label var q0054_0011 "Using products imported from China"

*Protective Measures against COVID-19 transmission
label var q0055_0001 "Worn a face mask"
label var q0055_0002 "Washed hands more frequently with soap and water"
label var q0055_0003 "Used hand sanitizer more regularly"
label var q0055_0004 "Disinfected my home"
label var q0055_0005 "Covered my nose and mouth with a tissue or sleeve when sneezing and coughing"
label var q0055_0006 "Avoided being around with people who have a fever or cold like symptoms"
label var q0055_0007 "Avoided being  around people who have traveled"
label var q0055_0008 "Avoided going out in general"
label var q0055_0009 "Avoided crowded areas"
label var q0055_0010 "Avoided going to public markets that sell fresh meat, fish or poultry"
label var q0055_0011 "Avoided going to hospital and other healthcare settings"
label var q0055_0012 "Avoided taking public transport / bus"
label var q0055_0013 "Avoided going to work"
label var q0055_0014 "Avoided going to school / university"
label var q0055_0015 "Avoided letting my children go to school / university"
label var q0055_0016 "Avoided going into shops and supermarkets"
label var q0055_0017 "Avoided social events"
label var q0055_0018 "Avoided travel"
label var q0055_0019 "Avoided travel to other areas (outside Barbados) "
label var q0055_0020 "Avoided travel to other areas (inside Barbados)"
label var q0055_0021 "Moved temporarily to the countryside or a remote location"
label var q0055_0022 "Gargle with salt water"
label var q0055_0023 "Bathe in the sea"
label var q0055_0024 "Drink herbal /ginger/bush tea"

*Ability and Willingness to self-isolate
label var q0056_0001 "Ability to self-isolate"
label var q0056_0002 "Willingness to self-isolate"

*Lockdown Prepartions
label var q0057_0001 "Stocking up on food supplies"
label var q0057_0002 "Stocking up on toiletries"
label var q0057_0003 "Stocking up on prescription medicines"
label var q0057_0004 "Stocking up on over the counter medicines"
label var q0057_0005 "Stocking up on condoms, safe sex supplies"
label var q0057_0006 "Stocking up on birth control"
label var q0057_0007 "Establishing remote working capabilities"
label var q0057_0008 "Finding alternative childcare"

*Problems with lockdown
label var q0058_0001 "Reduced mental health"
label var q0058_0002 "Reduced space in household" 
label var q0058_0003 "Diffculty obtaining supplies" 
label var q0058_0004 "Primary caregiver with no help" 
label var q0058_0005 "Reduced Social Life"
label var q0058_0006 "Reduced financial resources"
label var q0058_0007 "Impact on education"
label var q0058_0008 "Don't know"
label var q0058_0009 "No problems"
label var q0058_0010 "Other"

*Source of COVID-19 Information
label var q0079_0001 "Newspaper(s)"
label var q0079_0002 "Magazine(s) (i.e. in print or online)" 
label var q0079_0003 "Radio" 
label var q0079_0004 "CBC / Channel 8" 
label var q0079_0005 "Cable television / Satellite"
label var q0079_0006 "Official websites"
label var q0079_0007 "Unofficial websites"
label var q0079_0008 "Social Media"
label var q0079_0009 "My doctor"
label var q0079_0010 "Other healthcare professional"
label var q0079_0011 "My family or friends" 
label var q0079_0012 "Work / school / college communications" 
label var q0079_0013 "I am not getting any information" 
label var q0079_0014 "Other" 

*Information Preference
label var q0080_0001 "Research"
label var q0080_0002 "Common Sign and symptoms of infection"
label var q0080_0003 "Less Common Sign and symptoms of infection"
label var q0080_0004 "How to know if infected"
label var q0080_0005 "Information on transmission"
label var q0080_0006 "Information on prevention"
label var q0080_0007 "High risk groups"
label var q0080_0008 "Number of cases (Barbados)"
label var q0080_0009 "Distribution of cases (Barbados)"
label var q0080_0010 "Infection risk (Barbados)"
label var q0080_0011 "NPIs (Barbados)"
label var q0080_0012 "NPIs (Other Countries)"
label var q0080_0013 "NPIs (International organizations)"
label var q0080_0014 "I do want to receive any information"
label var q0080_0015 "Other"


egen a0_5 = rowtotal(q0020_0001 q0020_0002 q0020_0003)
recode a0_5 (1/max=1)
label var a0_5 "Between 0 to 5 years"
label define a0_5 1"0-5 years"
label value a0_5 a0_5
 
gen a6_10 = q0020_0004
label var a6_10 "6 years to 10 years old"

egen a11_18 = rowtotal(q0020_0005 q0020_0006)
label var a11_18 "Between 11 to 18 years"
label define a11_18 1"11-18 years"
label value a11_18 a11_18

gen a18_over = q0020_0007
label var a18_over "Older than 18"

gen ano_child = q0020_0008
label var ano_child "I do not have children"

*Save data to encrypted location
save "`datapath'/version01/2-working/BarbadosCovid19_KABP_v2", replace


*-------------------------------------------------------------------------------
*clear screen for focus on result only
cls			  

*Open log file
log using "`logpath'/COVID_BIM_KABP_Descriptives_Overall", replace

*-------------------------------------------------------------------------------

// Demographics

*Mean Age
tabstat age, stat(mean median min max) long col(stat)format (%9.0f) 

*Sex
tabulate sex, miss 

*Age Groups
tabulate agegrp, miss 

*Education
tabulate education, miss 

*Religion
tabulate religion, miss 

*Parent and Guardians
mrtab q0020_0001 - q0020_0008, nonames 

*-------------------------------------------------------------------------------

//Economic Aspects

*Employment
tabulate employment, miss 

*Job/Business loss due to COVID-19
tabulate job_loss, miss 


*Using savings to pay bills
tabulate save_bills, miss 


*Ability to work from home
tabulate work_home, miss 


*Ability to study from home
tabulate study_home, miss 


*Healthcare Worker
tabulate health_worker, miss 


*Essential Worker
tabulate essential_worker, miss 


*-------------------------------------------------------------------------------

//Current Health

*Parent and Guardians
mrtab diabetes hypertension heart_disease resp_disease cancer men_disease other_disease no_disease, nonames


*-------------------------------------------------------------------------------

//Attitudes to COVID-19

*Worried about COVID-19
tabulate worried_covid, miss 


*Interested in getting tested
tabulate test_interest, miss 


*Likely infected under Barbados current preventive measures
tabulate likely_infected, miss 

*Expectation of effect of COVID-19 if infected
tabulate expect_infected, miss 



*Protective Measures against COVID-19 transmission

**Yes
mrtab q0055_0001 - q0055_0024, nonames response(1)

**No
mrtab q0055_0001 - q0055_0024, nonames response(2)

**Not applicable
mrtab q0055_0001 - q0055_0024, nonames response(3)

*Ability to self isolate
tabulate q0056_0001, miss 

*Willingness to self isolate
tabulate q0056_0002, miss 

*-------------------------------------------------------------------------------
 
//Practices and Experiences

*Lockdown Prepartions

**Yes
mrtab q0057_0001 - q0057_0008, nonames response(1)

**No
mrtab q0057_0001 - q0057_0008, nonames response(2)
 
**Not applicable
mrtab q0057_0001 - q0057_0008, nonames response(3)


*Problems with lockdown
mrtab q0058_0001 - q0058_0010, nonames

*-------------------------------------------------------------------------------

//Knowledge 


*Method of COVID-19 Transmission

**Likely
mrtab q0054_0001 - q0054_0011, nonames response(1)

**Unlikely
mrtab q0054_0001 - q0054_0011, nonames response(2)

**Neither likely or unlikely
mrtab q0054_0001 - q0054_0011, nonames response(3)

*Not applicable
mrtab q0054_0001 - q0054_0011, nonames response(4)


*Source of COVID-19 Information
mrtab q0079_0001 - q0079_0014, nonames


*Information Preference
mrtab q0080_0001 - q0080_0015, nonames

*Misconceptions

tabulate covid_bio, miss 

*Eating foods imported from China
tabulate q0054_0010, miss 

*Using products imported from China
tabulate q0054_0011, miss 

log close

*-------------------------------------------------------------------------------

*Open log file
log using "`logpath'/COVID_BIM_KABP_Descriptives_BySex", replace

*-------------------------------------------------------------------------------

// Demographics

*Mean Age
tabstat age, by(sex) stat(mean median min max) long col(stat)format (%9.0f) 

*Age Groups
tabulate agegrp sex, miss col

*Education
tabulate education sex, miss col

*Religion
tabulate religion sex, miss col

*Parent and Guardians
mrtab q0020_0001 - q0020_0008, nonames by(sex)

*-------------------------------------------------------------------------------

//Economic Aspects

*Employment
tabulate employment sex, miss col

*Job/Business loss due to COVID-19
tabulate job_loss sex, miss col


*Using savings to pay bills
tabulate save_bills sex, miss col


*Ability to work from home
tabulate work_home sex, miss col


*Ability to study from home
tabulate study_home sex, miss col


*Healthcare Worker
tabulate health_worker sex, miss col


*Essential Worker
tabulate essential_worker sex, miss col


*-------------------------------------------------------------------------------

//Current Health

*Parent and Guardians
mrtab diabetes hypertension heart_disease resp_disease cancer men_disease other_disease no_disease, nonames by(sex)


*-------------------------------------------------------------------------------

//Attitudes to COVID-19

*Worried about COVID-19
tabulate worried_covid sex, miss col


*Interested in getting tested
tabulate test_interest sex, miss col


*Likely infected under Barbados current preventive measures
tabulate likely_infected sex, miss col

*Expectation of effect of COVID-19 if infected
tabulate expect_infected sex, miss col



*Protective Measures against COVID-19 transmission

**Yes
mrtab q0055_0001 - q0055_0024, nonames response(1) by(sex)

**No
mrtab q0055_0001 - q0055_0024, nonames response(2) by(sex)

**Not applicable
mrtab q0055_0001 - q0055_0024, nonames response(3) by(sex)

*Ability to self isolate
tabulate q0056_0001 sex, miss col

*Willingness to self isolate
tabulate q0056_0002 sex, miss col

*-------------------------------------------------------------------------------
 
//Practices and Experiences

*Lockdown Prepartions

**Yes
mrtab q0057_0001 - q0057_0008, nonames response(1) by(sex)

**No
mrtab q0057_0001 - q0057_0008, nonames response(2) by(sex)
 
**Not applicable
mrtab q0057_0001 - q0057_0008, nonames response(3) by(sex)


*Problems with lockdown
mrtab q0058_0001 - q0058_0010, nonames by(sex)

*-------------------------------------------------------------------------------

//Knowledge 


*Method of COVID-19 Transmission

**Likely
mrtab q0054_0001 - q0054_0011, nonames response(1) by(sex)

**Unlikely
mrtab q0054_0001 - q0054_0011, nonames response(2) by(sex)

**Neither likely or unlikely
mrtab q0054_0001 - q0054_0011, nonames response(3) by(sex)

*Not applicable
mrtab q0054_0001 - q0054_0011, nonames response(4) by(sex)


*Source of COVID-19 Information
mrtab q0079_0001 - q0079_0014, nonames by(sex)


*Information Preference
mrtab q0080_0001 - q0080_0015, nonames by(sex)

*Misconceptions

tabulate covid_bio sex, miss col

*Eating foods imported from China
tabulate q0054_0010 sex, miss col

*Using products imported from China
tabulate q0054_0011 sex, miss col

log close

*-------------------------------------------------------------------------------

*Open log file
log using "`logpath'/COVID_BIM_KABP_Descriptives_ByAgegrp", replace

*-------------------------------------------------------------------------------

// Demographics

*Mean Age
tabstat age, by(agegrp) stat(mean median min max) long col(stat)format (%9.0f) 

*Sex Groups
tabulate sex agegrp, miss col

*Education
tabulate education agegrp, miss col

*Religion
tabulate religion agegrp, miss col

*Parent and Guardians
mrtab q0020_0001 - q0020_0008, nonames by(agegrp)

*-------------------------------------------------------------------------------

//Economic Aspects

*Employment
tabulate employment agegrp, miss col

*Job/Business loss due to COVID-19
tabulate job_loss agegrp, miss col


*Using savings to pay bills
tabulate save_bills agegrp, miss col


*Ability to work from home
tabulate work_home agegrp, miss col


*Ability to study from home
tabulate study_home agegrp, miss col


*Healthcare Worker
tabulate health_worker agegrp, miss col


*Essential Worker
tabulate essential_worker agegrp, miss col


*-------------------------------------------------------------------------------

//Current Health

*Parent and Guardians
mrtab diabetes hypertension heart_disease resp_disease cancer men_disease other_disease no_disease, nonames by(agegrp)


*-------------------------------------------------------------------------------

//Attitudes to COVID-19

*Worried about COVID-19
tabulate worried_covid agegrp, miss col


*Interested in getting tested
tabulate test_interest agegrp, miss col


*Likely infected under Barbados current preventive measures
tabulate likely_infected agegrp, miss col

*Expectation of effect of COVID-19 if infected
tabulate expect_infected agegrp, miss col



*Protective Measures against COVID-19 transmission

**Yes
mrtab q0055_0001 - q0055_0024, nonames response(1) by(agegrp)

**No
mrtab q0055_0001 - q0055_0024, nonames response(2) by(agegrp)

**Not applicable
mrtab q0055_0001 - q0055_0024, nonames response(3) by(agegrp)

*Ability to self isolate
tabulate q0056_0001 agegrp, miss col

*Willingness to self isolate
tabulate q0056_0002 agegrp, miss col

*-------------------------------------------------------------------------------
 
//Practices and Experiences

*Lockdown Prepartions

**Yes
mrtab q0057_0001 - q0057_0008, nonames response(1) by(agegrp)

**No
mrtab q0057_0001 - q0057_0008, nonames response(2) by(agegrp)
 
**Not applicable
mrtab q0057_0001 - q0057_0008, nonames response(3) by(agegrp)


*Problems with lockdown
mrtab q0058_0001 - q0058_0010, nonames by(agegrp)

*-------------------------------------------------------------------------------

//Knowledge 


*Method of COVID-19 Transmission

**Likely
mrtab q0054_0001 - q0054_0011, nonames response(1) by(agegrp)

**Unlikely
mrtab q0054_0001 - q0054_0011, nonames response(2) by(agegrp)

**Neither likely or unlikely
mrtab q0054_0001 - q0054_0011, nonames response(3) by(agegrp)

*Not applicable
mrtab q0054_0001 - q0054_0011, nonames response(4) by(agegrp)


*Source of COVID-19 Information
mrtab q0079_0001 - q0079_0014, nonames by(agegrp)


*Information Preference
mrtab q0080_0001 - q0080_0015, nonames by(agegrp)

*Misconceptions

tabulate covid_bio agegrp, miss col

*Eating foods imported from China
tabulate q0054_0010 agegrp, miss col

*Using products imported from China
tabulate q0054_0011 agegrp, miss col

log close

/*------------------------------------------------------------------------------
						EXPORTING RESULTS TO EXCEL
------------------------------------------------------------------------------*/
*Create excel files for result output
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Demographics") replace

*-------------------------------------------------------------------------------

// Demographics

tabstat age, stat(mean median min max) long col(stat)format (%9.0f) save 
return list
matlist r(StatTotal)
matrix results = r(StatTotal)'
matlist results
putexcel C3 = ("Mean")
putexcel D3 = ("Median")
putexcel E3 = ("Minimum")
putexcel F3 = ("Maximum")
putexcel B4 = ("Age")
putexcel C4 = matrix(results)

*Sex
tabulate sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Demographics") modify 
putexcel B6=("Sex") C6=("Freq.") D6=("Percent")
putexcel B7=matrix(names) C7=matrix(freq) D7=matrix(freq/r(N)*100)
putexcel B7=("Female") B8=("Male") B9=("Missing") B11 = ("Total") D11=(100)
putexcel C11= matrix(T)

*Age Groups
tabulate agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Demographics") modify 
putexcel B14=("Age Groups") C14=("Freq.") D14=("Percent")
putexcel B15=matrix(names) C15=matrix(freq) D15=matrix(freq/r(N)*100)
putexcel B15=("18-29") B16=("30-39") B17=("40-49") B18=("50-59") B19=("60-69") B20=("70 & over") B21=("Missing") B23 = ("Total") D23=(100)
putexcel C23= matrix(T)


*Education
tabulate education, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Demographics") modify 
putexcel B26=("Education") C26=("Freq.") D26=("Percent")
putexcel B27=matrix(names) C27=matrix(freq) D27=matrix(freq/r(N)*100)
putexcel B27=("Primary") B28=("Secondary") B29=("Polytechnic/BCC") B30=("University") B31=("Missing") B33 = ("Total") D33=(100)
putexcel C33= matrix(T)

*Religion
tabulate religion, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Demographics") modify 
putexcel B36=("Religion") C36=("Freq.") D36=("Percent")
putexcel B37=matrix(names) C37=matrix(freq) D37=matrix(freq/r(N)*100)
putexcel B37=("Anglican") B38=("Roman Catholic") B39=("Baptist") B40=("Seventh Day Adventist") ///
			B41=("Muslim") B42 = ("Rastafarian") B43 =("Hindu") B44 =("Other") B45=("Missing") B47=("Total") D47=(100)
putexcel C47= matrix(T)

*Parent and Guardians
mrtab q0020_0001 - q0020_0008, nonames 
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Demographics") modify 
putexcel B50=("Dependant Parent/Guardian") C50=("Freq") D50=("Percent of Responses") E50=("Percent of Cases")
putexcel C51=matrix(freq) D51=matrix(freq/r(N)*100) E51=matrix(freq/4522*100) 
putexcel C59=matrix(miss) D59=matrix((miss/4522)*100) C61=(4522)
putexcel B51=("Under 6 months old")
putexcel B52=("Between 6 and 12 months" )
putexcel B53=("More than 1 year to 5 years old" )
putexcel B54=("6 years to 10 years old" )
putexcel B55=("11 years to 15 years old")
putexcel B56=("16 years to 18 years old")
putexcel B57=("Older than 18")
putexcel B58=("I do not have children")
putexcel B59=("Missing")
putexcel B61=("Total")


*-------------------------------------------------------------------------------

//Economic Aspects

*Employment
tabulate employment, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("EconomicAspects") modify 
putexcel B6=("Employment Categories") C6=("Freq.") D6=("Percent")
putexcel B7=matrix(names) C7=matrix(freq) D7=matrix(freq/r(N)*100)
putexcel B7=("Working full-time") B8=("Working part-time") B9=("Full-time student") B10=("Retired") B11=("Self-employed") B12=("Unemployed NOT seeking work") B13=("Unemployed and seeking work") B14=("Other") B15=("Missing")
putexcel C17= matrix(T) B17= ("Total") D17=(100)

*Job/Business loss due to COVID-19
tabulate job_loss, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("EconomicAspects") modify 
putexcel B20=("Job/Business Loss due to COVID-19") C20=("Freq.") D20=("Percent")
putexcel B21=matrix(names) C21=matrix(freq) D21=matrix(freq/r(N)*100)
putexcel B21=("Yes") B22=("No") B23=("Missing")
putexcel C25= matrix(T) B25 = ("Total") D25=(100)

*Using savings to pay bills
tabulate save_bills, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("EconomicAspects") modify 
putexcel B28=("Savings to pay bills") C28=("Freq.") D28=("Percent")
putexcel B29=matrix(names) C29=matrix(freq) D29=matrix(freq/r(N)*100)
putexcel B29=("Less than 1 month") B30=("1 to 2 months") B31=("2 to 3 months") B32=("4 to 5 months") B33=("6 months") B34=("More than 6 months") B35=("Not applicable") B36=("Other") B37=("Missing")
putexcel C39= matrix(T) B39 = ("Total") D39=(100)

*Ability to work from home
tabulate work_home, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("EconomicAspects") modify 
putexcel B42=("Working from home") C42=("Freq.") D42=("Percent")
putexcel B43=matrix(names) C43=matrix(freq) D43=matrix(freq/r(N)*100)
putexcel B43=("Yes") B44=("No") B45=("Don't know") B46=("Not applicable") B47=("Other") B48=("Missing")
putexcel C50= matrix(T) B50=("Total") D50=(100)

*Ability to study from home
tabulate study_home, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("EconomicAspects") modify 
putexcel B53=("Studying from home") C53=("Freq.") D53=("Percent")
putexcel B54=matrix(names) C54=matrix(freq) D54=matrix(freq/r(N)*100)
putexcel B54=("Yes") B55=("No") B56=("Don't know") B57=("Not applicable") B58=("Other") B59=("Missing")
putexcel C61= matrix(T) B61=("Total") D61=(100)

*Healthcare Worker
tabulate health_worker, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("EconomicAspects") modify 
putexcel B64=("Healthcare Worker") C64=("Freq.") D64=("Percent")
putexcel B65=matrix(names) C65=matrix(freq) D65=matrix(freq/r(N)*100)
putexcel B65=("Yes") B66=("No") B67=("Missing")
putexcel C69= matrix(T) B69 = ("Total") D69=(100)

*Essential Worker
tabulate essential_worker, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("EconomicAspects") modify 
putexcel B72=("Essential Worker") C72=("Freq.") D72=("Percent")
putexcel B73=matrix(names) C73=matrix(freq) D73=matrix(freq/r(N)*100)
putexcel B73=("Yes") B74=("No") B75=("Missing")
putexcel C77= matrix(T) B77 = ("Total") D77=(100)

*-------------------------------------------------------------------------------

//Current Health

*Parent and Guardians
mrtab diabetes hypertension heart_disease resp_disease cancer men_disease other_disease no_disease, nonames
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("CurrentHealth") modify 
putexcel B6=("Health Conditions") C6=("Freq") D6=("Percent of Responses") E6=("Percent of Cases")
putexcel C7=matrix(freq) D7=matrix(freq/r(N)*100) E7=matrix(freq/4522*100) 
putexcel C15=matrix(miss) D15=matrix((miss/4522)*100) C17=(4522)
putexcel B7=("Diabetes")
putexcel B8=("Hypertension" )
putexcel B9=("Heart Disease" )
putexcel B10=("Respiratory Disease" )
putexcel B11=("Cancer")
putexcel B12=("Mental Disease")
putexcel B13=("Other")
putexcel B14=("No chronic conditions")
putexcel B15=("Missing")
putexcel B17=("Total")

*-------------------------------------------------------------------------------

//Attitudes to COVID-19

*Worried about COVID-19
tabulate worried_covid, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("AttitudesToCovid") modify 
putexcel B6=("Worried about COVID-19") C6=("Freq.") D6=("Percent")
putexcel B7=matrix(names) C7=matrix(freq) D7=matrix(freq/r(N)*100)
putexcel B7=("Very worried") B8=("Fairly worried") B9=("Not very worried") B10=("Don't know") B11=("Missing") 
putexcel C13= matrix(T) B13= ("Total") D13=(100)

*Interested in getting tested
tabulate test_interest, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("AttitudesToCovid") modify 
putexcel B16=("If you haven't been tested would you likely to be tested") C16=("Freq.") D16=("Percent")
putexcel B17=matrix(names) C17=matrix(freq) D17=matrix(freq/r(N)*100)
putexcel B17=("Yes") B18=("No") B19=("Missing") 
putexcel C21= matrix(T) B21= ("Total") D21=(100)

*Likely infected under Barbados current preventive measures
tabulate likely_infected, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("AttitudesToCovid") modify 
putexcel B24=("Likely infected under Barbados current preventive measures") C24=("Freq.") D24=("Percent")
putexcel B25=matrix(names) C25=matrix(freq) D25=matrix(freq/r(N)*100)
putexcel B25=("Very likely") B26=("Fairly likely") B27=("Neither likely or unlikely") B28=("Fairly unlikely") B29=("Very unlikely") B30=("Don't know") B31=("Missing")
putexcel C33= matrix(T) B33= ("Total") D33=(100)

*Expectation of effect of COVID-19 if infected
tabulate expect_infected, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("AttitudesToCovid") modify 
putexcel B36=("Expectation if infected with COVID-19") C36=("Freq.") D36=("Percent")
putexcel B37=matrix(names) C37=matrix(freq) D37=matrix(freq/r(N)*100)
putexcel B37=("Life-threatening") B38=("Severe") B39=("Moderate") B40=("Mild") B41=("No symptoms") B42=("Don't know") B43=("Missing")
putexcel C45= matrix(T) B45= ("Total") D45=(100)

*Protective Measures against COVID-19 transmission
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("AttitudesToCovid") modify 
putexcel C48=("Yes") E48=("No") G48=("Not applicable")
putexcel C49=("n") D49=("(%)") E49=("n") F49=("(%)") G49=("n") H49=("(%)")
putexcel B50=("Worn a face mask")
putexcel B51=("Washed hands more frequently with soap and water")
putexcel B52=("Used hand sanitizer more regularly")
putexcel B53=("Disinfected my home")
putexcel B54=("Covered my nose and mouth with a tissue or sleeve when sneezing and coughing")
putexcel B55=("Avoided being around with people who have a fever or cold like symptoms")
putexcel B56=("Avoided being  around people who have traveled")
putexcel B57=("Avoided going out in general")
putexcel B58=("Avoided crowded areas")
putexcel B59=("Avoided going to public markets that sell fresh meat, fish or poultry")
putexcel B60=("Avoided going to hospital and other healthcare settings")
putexcel B61=("Avoided taking public transport / bus")
putexcel B62=("Avoided going to work")
putexcel B63=("Avoided going to school / university")
putexcel B64=("Avoided letting my children go to school / university")
putexcel B65=("Avoided going into shops and supermarkets")
putexcel B66=("Avoided social events")
putexcel B67=("Avoided travel")
putexcel B68=("Avoided travel to other areas (outside Barbados) ")
putexcel B69=("Avoided travel to other areas (inside Barbados)")
putexcel B70=("Moved temporarily to the countryside or a remote location")
putexcel B71=("Gargle with salt water")
putexcel B72=("Bathe in the sea")
putexcel B73=("Drink herbal /ginger/bush tea")
**Yes
mrtab q0055_0001 - q0055_0024, nonames response(1)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("AttitudesToCovid") modify 
putexcel B6=("Protective Measures") 
putexcel C50=matrix(freq) D50=matrix(freq/4522*100) 
**No
mrtab q0055_0001 - q0055_0024, nonames response(2)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("AttitudesToCovid") modify 
putexcel B6=("Protective Measures") 
putexcel E50=matrix(freq) F50=matrix(freq/4522*100) 
**Not applicable
mrtab q0055_0001 - q0055_0024, nonames response(3)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("AttitudesToCovid") modify 
putexcel B6=("Protective Measures") 
putexcel G50=matrix(freq) H50=matrix(freq/4522*100) 

*Ability to self isolate
tabulate q0056_0001, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("AttitudesToCovid") modify 
putexcel B76=("Ability to Self Isolate") C76=("Freq.") D76=("Percent")
putexcel B77=matrix(names) C77=matrix(freq) D77=matrix(freq/r(N)*100)
putexcel B77=("Yes I would") B78=("No I wouldn't") B79=("Don't know") B80=("Missing") 
putexcel C82= matrix(T) B82= ("Total") D82=(100)

*Willingness to self isolate
tabulate q0056_0002, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("AttitudesToCovid") modify 
putexcel B85=("Willingness to Self Isolate") C85=("Freq.") D85=("Percent")
putexcel B86=matrix(names) C86=matrix(freq) D86=matrix(freq/r(N)*100)
putexcel B86=("Yes I would") B87=("No I wouldn't") B88=("Don't know") B89=("Missing") 
putexcel C91= matrix(T) B91= ("Total") D91=(100)

*-------------------------------------------------------------------------------
 
//Practices and Experiences

*Lockdown Prepartions

putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("PracticesExperiences") modify 
putexcel C6=("Yes") E6=("No") G6=("Not applicable")
putexcel C7=("n") D7=("(%)") E7=("n") F7=("(%)") G7=("n") H7=("(%)")
putexcel B8=("Stocking up on food supplies")
putexcel B9=("Stocking up on toiletries")
putexcel B10=("Stocking up on prescription medicines")
putexcel B11=("Stocking up on over the counter medicines")
putexcel B12=("Stocking up on condoms, safe sex supplies")
putexcel B13=("Stocking up on birth control")
putexcel B14=("Establishing remote working capabilities")
putexcel B15=("Finding alternative childcare")
**Yes
mrtab q0057_0001 - q0057_0008, nonames response(1)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("PracticesExperiences") modify 
putexcel B6=("Lockdown Preparations") 
putexcel C8=matrix(freq) D8=matrix(freq/4522*100) 
**No
mrtab q0057_0001 - q0057_0008, nonames response(2)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("PracticesExperiences") modify 
putexcel E8=matrix(freq) F8=matrix(freq/4522*100) 
**Not applicable
mrtab q0057_0001 - q0057_0008, nonames response(3)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("PracticesExperiences") modify 
putexcel G8=matrix(freq) H8=matrix(freq/4522*100) 

*Problems with lockdown
mrtab q0058_0001 - q0058_0010, nonames
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("PracticesExperiences") modify 
putexcel B18=("Problems with lockdown") C18=("Freq") D18=("Percent of Responses") E18=("Percent of Cases")
putexcel C19=matrix(freq) D19=matrix(freq/r(N)*100) E19=matrix(freq/4522*100) 
putexcel C29=matrix(miss) D29=matrix((miss/4522)*100) C31=(4522)
putexcel B19=("Mental Health")
putexcel B20=("Space in household" )
putexcel B21=("Obtaining supplies" )
putexcel B22=("Carer with no help" )
putexcel B23=("Social Life")
putexcel B24=("Financial")
putexcel B25=("Impact on education")
putexcel B26=("Don't know")
putexcel B27=("No problems")
putexcel B28=("Other")
putexcel B29=("Missing")
putexcel B31=("Total")

*-------------------------------------------------------------------------------

//Knowledge 


*Method of COVID-19 Transmission
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Knowledge") modify 
putexcel C5=("Likely") E5=("Unlikely") G5=("Neither likely or unlikely") I5=("Don't know")
putexcel C6=("n") D6=("(%)") E6=("n") F6=("(%)") G6=("n") H6=("(%)") I6=("n") J6=("(%)")
putexcel B7=("Talking with but not touching someone who has corona-virus but no symptoms")
putexcel B8=("Talking with but not touching with somone who has corona-virus")
putexcel B9=("Having physical contact with someone who has corona-virus but no symptoms")
putexcel B10=("Having physical contact with someone with corona-virus who has symptoms")
putexcel B11=("Being close (i.e. within 6 feet) to someone who has corona-virus, when they cough")
putexcel B12=("Being further away (i.e. further than 6 feet away) to someone who has corona-virus, when they cough or sneeze")
putexcel B13=("Touching contaminated objects (e.g. surfaces such as Shopping carts, door handles, etc.)")
putexcel B14=("Consumption of wild animal meat (e.g. rabbit, Iguana, monkey, yard fowl)")
putexcel B15=("Visiting public markets that sell fresh meat, fish or poultry")
putexcel B16=("Eating foods imported from China")
putexcel B17=("Using products imported from China")
**Likely
mrtab q0054_0001 - q0054_0011, nonames response(1)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Knowledge") modify 
putexcel B6=("Method of COVID-19 Transmission") 
putexcel C7=matrix(freq) D7=matrix(freq/4522*100) 
**Unlikely
mrtab q0054_0001 - q0054_0011, nonames response(2)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Knowledge") modify 
putexcel E7=matrix(freq) F7=matrix(freq/4522*100) 
**Neither likely or unlikely
mrtab q0054_0001 - q0054_0011, nonames response(3)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Knowledge") modify 
putexcel G7=matrix(freq) H7=matrix(freq/4522*100) 
*Not applicable
mrtab q0054_0001 - q0054_0011, nonames response(4)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Knowledge") modify 
putexcel I7=matrix(freq) J7=matrix(freq/4522*100) 

*Source of COVID-19 Information
mrtab q0079_0001 - q0079_0014, nonames
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Knowledge") modify 
putexcel B20=("COVID-19 Information Source") C20=("Freq") D20=("Percent of Responses") E20=("Percent of Cases")
putexcel C21=matrix(freq) D21=matrix(freq/r(N)*100) E21=matrix(freq/4522*100) 
putexcel C35=matrix(miss) D35=matrix((miss/4522)*100) C37=(4522)
putexcel B21=("Newspaper(s)")
putexcel B22=("Magazine(s) (i.e. in print or online)" )
putexcel B23=("Radio" )
putexcel B24=("CBC / Channel 8" )
putexcel B25=("Cable television / Satellite")
putexcel B26=("Official websites")
putexcel B27=("Unofficial websites")
putexcel B28=("Social Media")
putexcel B29=("My doctor")
putexcel B30=("Other healthcare professional")
putexcel B31=("My family or friends" )
putexcel B32=("Work / school / college communications" )
putexcel B33=("I am not getting any information" )
putexcel B34=("Other" )
putexcel B35=("Missing")
putexcel B37=("Total")

*Information Preference
mrtab q0080_0001 - q0080_0015, nonames
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Knowledge") modify 
putexcel B40=("COVID-19 Information Preference") C40=("Freq") D40=("Percent of Responses") E40=("Percent of Cases")
putexcel C41=matrix(freq) D41=matrix(freq/r(N)*100) E41=matrix(freq/4522*100) 
putexcel C56=matrix(miss) D56=matrix((miss/4522)*100) C58=(4522)
putexcel B41=("Research")
putexcel B42=("Common Sign and symptoms of infection" )
putexcel B43=("Less Common Sign and symptoms of infection" )
putexcel B44=("How to know if infected" )
putexcel B45=("Information on transmission")
putexcel B46=("Information on prevention")
putexcel B47=("High risk groups")
putexcel B48=("Number of cases (Barbados)")
putexcel B49=("Distribution of cases (Barbados)")
putexcel B50=("Infection risk (Barbados)")
putexcel B51=("NPIs (Barbados)" )
putexcel B52=("NPIs (Other Countries)" )
putexcel B53=("NPIs (International organizations)" )
putexcel B54=("I do want to receive any information" )
putexcel B55=("Other")
putexcel B56=("Missing")
putexcel B58=("Total")

*Misconceptions

putexcel B62=("Misconceptions")
putexcel B64=("Do you think it is likely that the new coronavirus is a bioweapon developed by a government or terrorist organization?")

tabulate covid_bio, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Knowledge") modify 
putexcel B65=("COVID-19 Bioterrorism") C65=("Freq.") D65=("Percent")
putexcel B66=matrix(names) C66=matrix(freq) D66=matrix(freq/r(N)*100)
putexcel B66=("Likely") B67=("Unlikely") B68=("Missing") 
putexcel C70= matrix(T) B70= ("Total") D70=(100)

putexcel B73=("How likely or unlikely, do you think it is that the corona-virus (i.e COVID-19) is transmitted through each of the following")

*Eating foods imported from China
tabulate q0054_0010, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Knowledge") modify 
putexcel B75=("Eating foods imported from China") C75=("Freq.") D75=("Percent")
putexcel B76=matrix(names) C76=matrix(freq) D76=matrix(freq/r(N)*100)
putexcel B76=("Likely") B77=("Unlikely") B78=("Neither likely or unlikely") B79=("Don't know") B80=("Missing") 
putexcel C82= matrix(T) B82= ("Total") D82=(100)

*Using products imported from China
tabulate q0054_0011, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_Overall.xlsx", sheet("Knowledge") modify 
putexcel B85=("Using products imported from China") C85=("Freq.") D85=("Percent")
putexcel B86=matrix(names) C86=matrix(freq) D86=matrix(freq/r(N)*100)
putexcel B86=("Likely") B87=("Unlikely") B88=("Neither likely or unlikely") B89=("Don't know") B90=("Missing") 
putexcel C92= matrix(T) B92= ("Total") D92=(100)

*-------------------------------------------------------------------------------

putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Demographics") replace


*-------------------------------------------------------------------------------

// Demographics

*Age Groups
tabulate agegrp sex, col miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Demographics") modify
putexcel C13=("Frequency") G13=("Percent")
putexcel B14=("Age Groups") 
putexcel C14=("Female") D14=("Male") E14=("Missing")  // Frequency
putexcel G14=("Female") H14=("Male") I14=("Missing")	// Percentage
putexcel B15=matrix(names) C15=matrix(freq) G15=matrix(freq/r(N)*100)
putexcel B15=("18-29") B16=("30-39") B17=("40-49") B18=("50-59") B19=("60-69") B20=("70 & over") B21=("Missing") B23 = ("Total") 
putexcel C23= matrix(T)

*Education
tabulate education sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Demographics") modify
putexcel C26=("Frequency") G26=("Percent") 
putexcel B27=("Education") 
putexcel C27=("Female") D27=("Male") E27=("Missing") // Frequency
putexcel G27=("Female") H27=("Male") I27=("Missing") // Percentage
putexcel B28=matrix(names) C28=matrix(freq) G28=matrix(freq/r(N)*100)
putexcel B28=("Primary") B29=("Secondary") B30=("Polytechnic/BCC") B31=("University") B32=("Missing") B34 = ("Total") 
putexcel C34= matrix(T)

*Religion
tabulate religion sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Demographics") modify 
putexcel C36=("Frequency") G36=("Percent") 
putexcel B37=("Religion") 
putexcel C37=("Female") D37=("Male") E37=("Missing") // Frequency
putexcel G37=("Female") H37=("Male") I37=("Missing") // Percentage
putexcel B38=matrix(names) C38=matrix(freq) G38=matrix(freq/r(N)*100)
putexcel B38=("Anglican") B39=("Roman Catholic") B40=("Baptist") B41=("Seventh Day Adventist") ///
			B42=("Muslim") B43 = ("Rastafarian") B44 =("Hindu") B45 =("Other") B46=("Missing") B48=("Total") 
putexcel C48= matrix(T)

*Parent and Guardians
mrtab q0020_0001 - q0020_0008, by(sex) nonames 
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Demographics") modify 
putexcel C51=("Frequency") G51=("Percent")
putexcel B52=("Dependant Parent/Guardian")
putexcel C52=("Female") D52=("Male")  // Frequency
putexcel G52=("Female") H52=("Male")  // Percentage
putexcel C53=matrix(freq) G53=matrix(freq/4522*100) 
putexcel B53=("Under 6 months old")
putexcel B54=("Between 6 and 12 months" )
putexcel B55=("More than 1 year to 5 years old" )
putexcel B56=("6 years to 10 years old" )
putexcel B57=("11 years to 15 years old")
putexcel B58=("16 years to 18 years old")
putexcel B59=("Older than 18")
putexcel B60=("I do not have children")

*-------------------------------------------------------------------------------

//Economic Aspects

*Employment
tabulate employment sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("EconomicAspects") modify 
putexcel C5=("Frequency") G5=("Percent") 
putexcel B6=("Employment Categories")
putexcel C6=("Female") D6=("Male") E6=("Missing") // Frequency
putexcel G6=("Female") H6=("Male") I6=("Missing") // Percentage
putexcel B7=matrix(names) C7=matrix(freq) G7=matrix(freq/r(N)*100)
putexcel B7=("Working full-time") B8=("Working part-time") B9=("Full-time student") B10=("Retired") B11=("Self-employed") B12=("Unemployed NOT seeking work") B13=("Unemployed and seeking work") B14=("Other") B15=("Missing")
putexcel C17= matrix(T) B17= ("Total") 

*Job/Business loss due to COVID-19
tabulate job_loss sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("EconomicAspects") modify 
putexcel C20=("Frequency") G20=("Percent") 
putexcel B21=("Job/Business Loss due to COVID-19") 
putexcel C21=("Female") D21=("Male") E21=("Missing") // Frequency
putexcel G21=("Female") H21=("Male") I21=("Missing") // Percentage
putexcel B22=matrix(names) C22=matrix(freq) G22=matrix(freq/r(N)*100)
putexcel B22=("Yes") B23=("No") B24=("Missing")
putexcel C26= matrix(T) B26 = ("Total") 

*Using savings to pay bills
tabulate save_bills sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("EconomicAspects") modify 
putexcel C28=("Frequency") G28=("Percent") 
putexcel B29=("Savings to pay bills") 
putexcel C29=("Female") D29=("Male") E29=("Missing") // Frequency
putexcel G29=("Female") H29=("Male") I29=("Missing") // Percentage
putexcel B30=matrix(names) C30=matrix(freq) G30=matrix(freq/r(N)*100)
putexcel B30=("Less than 1 month") B31=("1 to 2 months") B32=("2 to 3 months") B33=("4 to 5 months") B34=("6 months") B35=("More than 6 months") B36=("Not applicable") B37=("Other") B38=("Missing")
putexcel C40= matrix(T) B40 = ("Total") 

*Ability to work from home
tabulate work_home sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("EconomicAspects") modify 
putexcel C43=("Frequency") G43=("Percent") 
putexcel B44=("Working from home") 
putexcel C44=("Female") D44=("Male") E44=("Missing") // Frequency
putexcel G44=("Female") H44=("Male") I44=("Missing") // Percentage
putexcel B45=matrix(names) C45=matrix(freq) G45=matrix(freq/r(N)*100)
putexcel B45=("Yes") B46=("No") B47=("Don't know") B48=("Not applicable") B49=("Other") B50=("Missing")
putexcel C52= matrix(T) B52=("Total") 

*Ability to study from home
tabulate study_home sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("EconomicAspects") modify 
putexcel C55=("Frequency") G55=("Percent")
putexcel B56=("Studying from home") 
putexcel C56=("Female") D56=("Male") E56=("Missing") // Frequency
putexcel G56=("Female") H56=("Male") I56=("Missing") // Percentage
putexcel B57=matrix(names) C57=matrix(freq) G57=matrix(freq/r(N)*100)
putexcel B57=("Yes") B58=("No") B59=("Don't know") B60=("Not applicable") B61=("Other") B62=("Missing")
putexcel C64= matrix(T) B64=("Total") 

*Healthcare Worker
tabulate health_worker sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("EconomicAspects") modify
putexcel C67=("Frequency") G67=("Percent")
putexcel B68=("Healthcare Worker") 
putexcel C68=("Female") D68=("Male") E68=("Missing") // Frequency
putexcel G68=("Female") H68=("Male") I68=("Missing") // Percentage
putexcel B69=matrix(names) C69=matrix(freq) G69=matrix(freq/r(N)*100)
putexcel B69=("Yes") B70=("No") B71=("Missing")
putexcel C73= matrix(T) B73 = ("Total") 

*Essential Worker
tabulate essential_worker sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("EconomicAspects") modify 
putexcel C76=("Frequency") G76=("Percent")
putexcel B77=("Essential Worker") 
putexcel C77=("Female") D77=("Male") E77=("Missing") // Frequency
putexcel G77=("Female") H77=("Male") I77=("Missing") // Percentage
putexcel B78=matrix(names) C78=matrix(freq) G78=matrix(freq/r(N)*100)
putexcel B78=("Yes") B79=("No") B80=("Missing")
putexcel C82= matrix(T) B82 = ("Total") 

*-------------------------------------------------------------------------------

//Current Health

*Chronic Health Conditions
mrtab diabetes hypertension heart_disease resp_disease cancer men_disease other_disease no_disease, nonames by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("CurrentHealth") modify 
putexcel C5=("Frequency") G5=("Percent")
putexcel B6=("Health Conditions")
putexcel C6=("Female") D6=("Male")  // Frequency
putexcel G6=("Female") H6=("Male")  // Percentage
putexcel C7=matrix(freq) G7=matrix(freq/4522*100) 
putexcel C15=matrix(miss) G15=matrix((miss/4522)*100) 
putexcel B7=("Diabetes")
putexcel B8=("Hypertension" )
putexcel B9=("Heart Disease" )
putexcel B10=("Respiratory Disease" )
putexcel B11=("Cancer")
putexcel B12=("Mental Disease")
putexcel B13=("Other")
putexcel B14=("No chronic conditions")
putexcel B15=("Missing")
putexcel B17=("Total")

*-------------------------------------------------------------------------------

//Attitudes to COVID-19

*Worried about COVID-19
tabulate worried_covid sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("AttitudesToCovid") modify 
putexcel C5=("Frequency") G5=("Percent")
putexcel B6=("Worried about COVID-19") 
putexcel C6=("Female") D6=("Male") // Frequency
putexcel G6=("Female") H6=("Male") // Percentage
putexcel B7=matrix(names) C7=matrix(freq) G7=matrix(freq/r(N)*100)
putexcel B7=("Very worried") B8=("Fairly worried") B9=("Not very worried") B10=("Don't know") B11=("Missing") 
putexcel C13= matrix(T) B13= ("Total") 

*Interested in getting tested
tabulate test_interest sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("AttitudesToCovid") modify 
putexcel C16=("Frequency") G16=("Percent")
putexcel B17=("If you haven't been tested would you likely to be tested") 
putexcel C17=("Female") D17=("Male")
putexcel G17=("Female") H17=("Male")
putexcel B18=matrix(names) C18=matrix(freq) G18=matrix(freq/r(N)*100)
putexcel B18=("Yes") B19=("No") B20=("Missing") 
putexcel C22= matrix(T) B22= ("Total") 

*Likely infected under Barbados current preventive measures
tabulate likely_infected sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("AttitudesToCovid") modify 
putexcel C25=("Frequency") G25=("Percent")
putexcel B26=("Likely infected under Barbados current preventive measures") 
putexcel C26=("Female") D26=("Male")
putexcel G26=("Female") H26=("Male")
putexcel B27=matrix(names) C27=matrix(freq) G27=matrix(freq/r(N)*100)
putexcel B27=("Very likely") B28=("Fairly likely") B29=("Neither likely or unlikely") B30=("Fairly unlikely") B31=("Very unlikely") B32=("Don't know") B33=("Missing")
putexcel C34= matrix(T) B34= ("Total") 

*Expectation of effect of COVID-19 if infected
tabulate expect_infected sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("AttitudesToCovid") modify 
putexcel C37=("Frequency") G37=("Percent")
putexcel B38=("Expectation if infected with COVID-19") 
putexcel C38=("Female") D38=("Male")
putexcel G38=("Female") H38=("Male")
putexcel B39=matrix(names) C39=matrix(freq) G39=matrix(freq/r(N)*100)
putexcel B39=("Life-threatening") B40=("Severe") B41=("Moderate") B42=("Mild") B43=("No symptoms") B44=("Don't know") B45=("Missing")
putexcel C47= matrix(T) B47= ("Total") 

*Protective Measures against COVID-19 transmission
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("AttitudesToCovid") modify 
putexcel C50=("Frequency") K50=("Percent")
putexcel B51=("Protective Measures") 
putexcel C52=("Yes") E52=("No") G52=("Not applicable")
putexcel K52=("Yes") M52=("No") O52=("Not applicable")
putexcel C53=("Female") D53=("Male") // Yes - Frequency
putexcel E53=("Female") F53=("Male") // No - Frequency
putexcel G53=("Female") H53=("Male") // Not applicable - Frequency
putexcel K53=("Female") L53=("Male") // Yes - Percent
putexcel M53=("Female") N53=("Male") // No - Percent
putexcel O53=("Female") P53=("Male") // Not applicable - Percent
putexcel B54=("Worn a face mask")
putexcel B55=("Washed hands more frequently with soap and water")
putexcel B56=("Used hand sanitizer more regularly")
putexcel B57=("Disinfected my home")
putexcel B58=("Covered my nose and mouth with a tissue or sleeve when sneezing and coughing")
putexcel B59=("Avoided being around with people who have a fever or cold like symptoms")
putexcel B60=("Avoided being  around people who have traveled")
putexcel B61=("Avoided going out in general")
putexcel B62=("Avoided crowded areas")
putexcel B63=("Avoided going to public markets that sell fresh meat, fish or poultry")
putexcel B64=("Avoided going to hospital and other healthcare settings")
putexcel B65=("Avoided taking public transport / bus")
putexcel B66=("Avoided going to work")
putexcel B67=("Avoided going to school / university")
putexcel B68=("Avoided letting my children go to school / university")
putexcel B69=("Avoided going into shops and supermarkets")
putexcel B70=("Avoided social events")
putexcel B71=("Avoided travel")
putexcel B72=("Avoided travel to other areas (outside Barbados) ")
putexcel B73=("Avoided travel to other areas (inside Barbados)")
putexcel B74=("Moved temporarily to the countryside or a remote location")
putexcel B75=("Gargle with salt water")
putexcel B76=("Bathe in the sea")
putexcel B77=("Drink herbal /ginger/bush tea")
**Yes
mrtab q0055_0001 - q0055_0024, nonames response(1) by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("AttitudesToCovid") modify 
putexcel C54=matrix(freq) K54=matrix(freq/4522*100) 
**No
mrtab q0055_0001 - q0055_0024, nonames response(2) by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("AttitudesToCovid") modify 
putexcel E54=matrix(freq) M54=matrix(freq/4522*100) 
**Not applicable
mrtab q0055_0001 - q0055_0024, nonames response(3) by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("AttitudesToCovid") modify 
putexcel B6=("Protective Measures") 
putexcel G54=matrix(freq) O54=matrix(freq/4522*100) 

*Ability to self isolate
tabulate q0056_0001 sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("AttitudesToCovid") modify 
putexcel C80=("Frequency") G80=("Percent")
putexcel B81=("Ability to Self Isolate") 
putexcel C81=("Female") D81=("Male")
putexcel G81=("Female") H81=("Male")
putexcel B82=matrix(names) C82=matrix(freq) G82=matrix(freq/r(N)*100)
putexcel B82=("Yes I would") B83=("No I wouldn't") B84=("Don't know") B85=("Missing") 
putexcel C87= matrix(T) B87= ("Total") 

*Willingness to self isolate
tabulate q0056_0002 sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("AttitudesToCovid") modify 
putexcel C90=("Frequency") G90=("Percent")
putexcel B91=("Willingness to Self Isolate") 
putexcel C91=("Female") D91=("Male")
putexcel G91=("Female") H91=("Male")
putexcel B92=matrix(names) C92=matrix(freq) G92=matrix(freq/r(N)*100)
putexcel B92=("Yes I would") B93=("No I wouldn't") B94=("Don't know") B95=("Missing") 
putexcel C97= matrix(T) B97= ("Total") 

*-------------------------------------------------------------------------------
 
//Practices and Experiences

*Lockdown Prepartions

putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("PracticesExperiences") modify 
putexcel C5=("Frequency") K5=("Percent")
putexcel B6=("Lockdown Preparations") 
putexcel C6=("Yes") E6=("No") G6=("Not applicable")
putexcel K6=("Yes") M6=("No") O6=("Not applicable")
putexcel C7=("Female") D7=("Male") // Yes - Frequency
putexcel E7=("Female") F7=("Male") // No - Frequency
putexcel G7=("Female") H7=("Male") // Not applicable - Frequency
putexcel K7=("Female") L7=("Male") // Yes - Percent
putexcel M7=("Female") N7=("Male") // No - Percent
putexcel O7=("Female") P7=("Male") // Not applicable - Percent
putexcel B8=("Stocking up on food supplies")
putexcel B9=("Stocking up on toiletries")
putexcel B10=("Stocking up on prescription medicines")
putexcel B11=("Stocking up on over the counter medicines")
putexcel B12=("Stocking up on condoms, safe sex supplies")
putexcel B13=("Stocking up on birth control")
putexcel B14=("Establishing remote working capabilities")
putexcel B15=("Finding alternative childcare")
**Yes
mrtab q0057_0001 - q0057_0008, nonames response(1) by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel C8=matrix(freq) K8=matrix(freq/4522*100) 
**No
mrtab q0057_0001 - q0057_0008, nonames response(2) by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel E8=matrix(freq) M8=matrix(freq/4522*100) 
**Not applicable
mrtab q0057_0001 - q0057_0008, nonames response(3) by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel G8=matrix(freq) O8=matrix(freq/4522*100) 

*Problems with lockdown
mrtab q0058_0001 - q0058_0010, nonames by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("PracticesExperiences") modify 
putexcel C18=("Frequency") G18=("Percent")
putexcel B19=("Problems with lockdown") 
putexcel C19=("Female") D19=("Male")  // Frequency
putexcel G19=("Female") H19=("Male")  // Percentage
putexcel C20=matrix(freq) G20=matrix(freq/r(N)*100) 
putexcel C30=matrix(miss) G30=matrix((miss/4522)*100) C32=(4522)
putexcel B20=("Mental Health")
putexcel B21=("Space in household" )
putexcel B22=("Obtaining supplies" )
putexcel B23=("Carer with no help" )
putexcel B24=("Social Life")
putexcel B25=("Financial")
putexcel B26=("Impact on education")
putexcel B27=("Don't know")
putexcel B28=("No problems")
putexcel B29=("Other")
putexcel B30=("Missing")
putexcel B32=("Total")

*-------------------------------------------------------------------------------

//Knowledge 

*Method of COVID-19 Transmission
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Knowledge") modify 
putexcel C4=("Frequency") L4=("Percent")
putexcel B5=("Method of COVID-19 Transmission") 
putexcel C5=("Likely") E5=("Unlikely") G5=("Neither likely or unlikely") I5=("Don't know")
putexcel L5=("Likely") N5=("Unlikely") P5=("Neither likely or unlikely") R5=("Don't know")
putexcel C6=("Female") D6=("Male") E6=("Female") F6=("Male") G6=("Female") H6=("Male") I6=("Female") J6=("Male")
putexcel L6=("Female") M6=("Male") N6=("Female") O6=("Male") P6=("Female") Q6=("Male") R6=("Female") S6=("Male")
putexcel B7=("Talking with but not touching someone who has corona-virus but no symptoms")
putexcel B8=("Talking with but not touching with somone who has corona-virus")
putexcel B9=("Having physical contact with someone who has corona-virus but no symptoms")
putexcel B10=("Having physical contact with someone with corona-virus who has symptoms")
putexcel B11=("Being close (i.e. within 6 feet) to someone who has corona-virus, when they cough")
putexcel B12=("Being further away (i.e. further than 6 feet away) to someone who has corona-virus, when they cough or sneeze")
putexcel B13=("Touching contaminated objects (e.g. surfaces such as Shopping carts, door handles, etc.)")
putexcel B14=("Consumption of wild animal meat (e.g. rabbit, Iguana, monkey, yard fowl)")
putexcel B15=("Visiting public markets that sell fresh meat, fish or poultry")
putexcel B16=("Eating foods imported from China")
putexcel B17=("Using products imported from China")
**Likely
mrtab q0054_0001 - q0054_0011, nonames response(1) by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel C7=matrix(freq) L7=matrix(freq/4522*100) 
**Unlikely
mrtab q0054_0001 - q0054_0011, nonames response(2) by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel E7=matrix(freq) N7=matrix(freq/4522*100) 
**Neither likely or unlikely
mrtab q0054_0001 - q0054_0011, nonames response(3) by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel G7=matrix(freq) P7=matrix(freq/4522*100) 
**Not applicable
mrtab q0054_0001 - q0054_0011, nonames response(4) by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel I7=matrix(freq) R7=matrix(freq/4522*100) 

*Source of COVID-19 Information
mrtab q0079_0001 - q0079_0014, nonames by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Knowledge") modify 
putexcel C20=("Frequency") G20=("Percent")
putexcel B21=("COVID-19 Information Source") 
putexcel C21=("Female") D21=("Male") // Frequency
putexcel G21=("Female") H21=("Male") // Percent
putexcel C22=matrix(freq)  G22=matrix(freq/4522*100) 
putexcel C36=matrix(miss) D36=matrix((miss/4522)*100) C38=(4522)
putexcel B22=("Newspaper(s)")
putexcel B23=("Magazine(s) (i.e. in print or online)" )
putexcel B24=("Radio" )
putexcel B25=("CBC / Channel 8" )
putexcel B26=("Cable television / Satellite")
putexcel B27=("Official websites")
putexcel B28=("Unofficial websites")
putexcel B29=("Social Media")
putexcel B30=("My doctor")
putexcel B31=("Other healthcare professional")
putexcel B32=("My family or friends" )
putexcel B33=("Work / school / college communications" )
putexcel B34=("I am not getting any information" )
putexcel B35=("Other" )
putexcel B36=("Missing")
putexcel B38=("Total")


*Information Preference
mrtab q0080_0001 - q0080_0015, nonames by(sex)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Knowledge") modify 
putexcel C40=("Frequency") G40=("Percent")
putexcel B41=("COVID-19 Information Preference") 
putexcel C41=("Female") D41=("Male")  // Frequency
putexcel G41=("Female") H41=("Male")  // Percentage
putexcel C42=matrix(freq) G42=matrix(freq/4522*100) 
putexcel C57=matrix(miss) G57=matrix((miss/4522)*100) C59=(4522)
putexcel B42=("Research")
putexcel B43=("Common Sign and symptoms of infection" )
putexcel B44=("Less Common Sign and symptoms of infection" )
putexcel B45=("How to know if infected" )
putexcel B46=("Information on transmission")
putexcel B47=("Information on prevention")
putexcel B48=("High risk groups")
putexcel B49=("Number of cases (Barbados)")
putexcel B50=("Distribution of cases (Barbados)")
putexcel B51=("Infection risk (Barbados)")
putexcel B52=("NPIs (Barbados)" )
putexcel B53=("NPIs (Other Countries)" )
putexcel B54=("NPIs (International organizations)" )
putexcel B55=("I do want to receive any information" )
putexcel B56=("Other")
putexcel B57=("Missing")
putexcel B59=("Total")

*Misconceptions

putexcel B62=("Misconceptions")
putexcel B64=("Do you think it is likely that the new coronavirus is a bioweapon developed by a government or terrorist organization?")
**

tabulate covid_bio sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Knowledge") modify 
putexcel C66=("Frequency") G66=("Percent")
putexcel B67=("COVID-19 Bioterrorism") 
putexcel C67=("Female") D67=("Male") E67=("Missing")  // Frequency
putexcel G67=("Female") H67=("Male") I67=("Missing")	// Percentage
putexcel B68=matrix(names) C68=matrix(freq) G68=matrix(freq/r(N)*100)
putexcel B68=("Likely") B69=("Unlikely") B70=("Missing") 
putexcel C72= matrix(T) B72= ("Total") 

**
putexcel B73=("How likely or unlikely, do you think it is that the corona-virus (i.e COVID-19) is transmitted through each of the following")

*Eating foods imported from China
tabulate q0054_0010 sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Knowledge") modify 
putexcel C75=("Frequency") G75=("Percent")
putexcel B76=("Eating foods imported from China") 
putexcel C76=("Female") D76=("Male") E76=("Missing")  // Frequency
putexcel G76=("Female") H76=("Male") I76=("Missing")	// Percentage
putexcel B77=matrix(names)  G77=matrix(freq/r(N)*100)
putexcel B77=("Likely") B78=("Unlikely") B79=("Neither likely or unlikely") B80=("Don't know") B81=("Missing") 
putexcel C83= matrix(T) B83= ("Total") 

*Using products imported from China
tabulate q0054_0011 sex, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_BySex.xlsx", sheet("Knowledge") modify 
putexcel C85=("Frequency") G85=("Percent")
putexcel B86=("Using products imported from China")
putexcel C86=("Female") D86=("Male") E86=("Missing")  // Frequency
putexcel G86=("Female") H86=("Male") I86=("Missing")	// Percentage
putexcel B87=matrix(names) G87=matrix(freq/r(N)*100)
putexcel B87=("Likely") B88=("Unlikely") B89=("Neither likely or unlikely") B90=("Don't know") B91=("Missing") 
putexcel C93= matrix(T) B93= ("Total") 

*-------------------------------------------------------------------------------

putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Demographics") replace


*-------------------------------------------------------------------------------

// Demographics

*Age Groups
tabulate sex agegrp, col miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Demographics") modify
putexcel C13=("Frequency") K13=("Percent")
putexcel B14=("Sex") 
putexcel C14=("18-29") D14=("30-39") E14=("40-49") F14=("50-59") G14=("60-69") H14=("70 & over") I14=("Missing")
putexcel K14=("18-29") L14=("30-39") M14=("40-49") N14=("50-59") O14=("60-69") P14=("70 & over") Q14=("Missing")
putexcel B15=matrix(names) C15=matrix(freq) K15=matrix(freq/r(N)*100)
putexcel B15=("Female") B16=("Male") B17=("Missing") 
putexcel B19 = ("Total")  C19= matrix(T)

*Education
tabulate education agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Demographics") modify
putexcel C26=("Frequency") K26=("Percent") 
putexcel B27=("Education") 
putexcel C27=("18-29") D27=("30-39") E27=("40-49") F27=("50-59") G27=("60-69") H27=("70 & over") I27=("Missing")
putexcel K27=("18-29") L27=("30-39") M27=("40-49") N27=("50-59") O27=("60-69") P27=("70 & over") Q27=("Missing")
putexcel B28=matrix(names) C28=matrix(freq) K28=matrix(freq/r(N)*100)
putexcel B28=("Primary") B29=("Secondary") B30=("Polytechnic/BCC") B31=("University") B32=("Missing")  
putexcel B34 = ("Total") C34= matrix(T)

*Religion
tabulate religion agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Demographics") modify 
putexcel C36=("Frequency") K36=("Percent") 
putexcel B37=("Religion")
putexcel C37=("18-29") D37=("30-39") E37=("40-49") F37=("50-59") G37=("60-69") H37=("70 & over") I37=("Missing")
putexcel K37=("18-29") L37=("30-39") M37=("40-49") N37=("50-59") O37=("60-69") P37=("70 & over") Q37=("Missing")
putexcel B38=matrix(names) C38=matrix(freq) K38=matrix(freq/r(N)*100)
putexcel B38=("Anglican") B39=("Roman Catholic") B40=("Baptist") B41=("Seventh Day Adventist") ///
			B42=("Muslim") B43 = ("Rastafarian") B44 =("Hindu") B45 =("Other") B46=("Missing") 
putexcel B48=("Total") C48= matrix(T)

*Parent and Guardians
mrtab q0020_0001 - q0020_0008, by(agegrp) nonames 
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Demographics") modify 
putexcel C51=("Frequency") K51=("Percent")
putexcel B52=("Dependant Parent/Guardian")
putexcel C52=("18-29") D52=("30-39") E52=("40-49") F52=("50-59") G52=("60-69") H52=("70 & over")
putexcel K52=("18-29") L52=("30-39") M52=("40-49") N52=("50-59") O52=("60-69") P52=("70 & over")
putexcel C53=matrix(freq) K53=matrix(freq/4522*100) 
putexcel B53=("Under 6 months old")
putexcel B54=("Between 6 and 12 months" )
putexcel B55=("More than 1 year to 5 years old" )
putexcel B56=("6 years to 10 years old" )
putexcel B57=("11 years to 15 years old")
putexcel B58=("16 years to 18 years old")
putexcel B59=("Older than 18")
putexcel B60=("I do not have children")

*-------------------------------------------------------------------------------

//Economic Aspects

*Employment
tabulate employment agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("EconomicAspects") modify 
putexcel C5=("Frequency") K5=("Percent") 
putexcel B6=("Employment Categories")
putexcel C6=("18-29") D6=("30-39") E6=("40-49") F6=("50-59") G6=("60-69") H6=("70 & over") I6=("Missing")
putexcel K6=("18-29") L6=("30-39") M6=("40-49") N6=("50-59") O6=("60-69") P6=("70 & over") Q6=("Missing")
putexcel B7=matrix(names) C7=matrix(freq) K7=matrix(freq/r(N)*100)
putexcel B7=("Working full-time") B8=("Working part-time") B9=("Full-time student") B10=("Retired") B11=("Self-employed") B12=("Unemployed NOT seeking work") B13=("Unemployed and seeking work") B14=("Other") B15=("Missing")
putexcel C17= matrix(T) B17= ("Total") 

*Job/Business loss due to COVID-19
tabulate job_loss agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("EconomicAspects") modify 
putexcel C20=("Frequency") K20=("Percent") 
putexcel B21=("Job/Business Loss due to COVID-19") 
putexcel C21=("18-29") D21=("30-39") E21=("40-49") F21=("50-59") G21=("60-69") H21=("70 & over") I21=("Missing")
putexcel K21=("18-29") L21=("30-39") M21=("40-49") N21=("50-59") O21=("60-69") P21=("70 & over") Q21=("Missing")
putexcel B22=matrix(names) C22=matrix(freq) K22=matrix(freq/r(N)*100)
putexcel B22=("Yes") B23=("No") B24=("Missing")
putexcel C26= matrix(T) B26 = ("Total") 

*Using savings to pay bills
tabulate save_bills agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("EconomicAspects") modify 
putexcel C28=("Frequency") K28=("Percent") 
putexcel B29=("Savings to pay bills") 
putexcel C29=("18-29") D29=("30-39") E29=("40-49") F29=("50-59") G29=("60-69") H29=("70 & over") I29=("Missing")
putexcel K29=("18-29") L29=("30-39") M29=("40-49") N29=("50-59") O29=("60-69") P29=("70 & over") Q29=("Missing")
putexcel B30=matrix(names) C30=matrix(freq) K30=matrix(freq/r(N)*100)
putexcel B30=("Less than 1 month") B31=("1 to 2 months") B32=("2 to 3 months") B33=("4 to 5 months") B34=("6 months") B35=("More than 6 months") B36=("Not applicable") B37=("Other") B38=("Missing")
putexcel C40= matrix(T) B40 = ("Total") 

*Ability to work from home
tabulate work_home agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("EconomicAspects") modify 
putexcel C43=("Frequency") K43=("Percent") 
putexcel B44=("Working from home") 
putexcel C44=("18-29") D44=("30-39") E44=("40-49") F44=("50-59") G44=("60-69") H44=("70 & over") I44=("Missing")
putexcel K44=("18-29") L44=("30-39") M44=("40-49") N44=("50-59") O44=("60-69") P44=("70 & over") Q44=("Missing")
putexcel B45=matrix(names) C45=matrix(freq) K45=matrix(freq/r(N)*100)
putexcel B45=("Yes") B46=("No") B47=("Don't know") B48=("Not applicable") B49=("Other") B50=("Missing")
putexcel C52= matrix(T) B52=("Total") 

*Ability to study from home
tabulate study_home agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("EconomicAspects") modify 
putexcel C55=("Frequency") K55=("Percent")
putexcel B56=("Studying from home") 
putexcel C56=("18-29") D56=("30-39") E56=("40-49") F56=("50-59") G56=("60-69") H56=("70 & over") I56=("Missing")
putexcel K56=("18-29") L56=("30-39") M56=("40-49") N56=("50-59") O56=("60-69") P56=("70 & over") Q56=("Missing")
putexcel B57=matrix(names) C57=matrix(freq) K57=matrix(freq/r(N)*100)
putexcel B57=("Yes") B58=("No") B59=("Don't know") B60=("Not applicable") B61=("Other") B62=("Missing")
putexcel C64= matrix(T) B64=("Total") 

*Healthcare Worker
tabulate health_worker agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("EconomicAspects") modify
putexcel C67=("Frequency") K67=("Percent")
putexcel B68=("Healthcare Worker") 
putexcel C68=("18-29") D68=("30-39") E68=("40-49") F68=("50-59") G68=("60-69") H68=("70 & over") I68=("Missing")
putexcel K68=("18-29") L68=("30-39") M68=("40-49") N68=("50-59") O68=("60-69") P68=("70 & over") Q68=("Missing")
putexcel B69=matrix(names) C69=matrix(freq) K69=matrix(freq/r(N)*100)
putexcel B69=("Yes") B70=("No") B71=("Missing")
putexcel C73= matrix(T) B73 = ("Total") 

*Essential Worker
tabulate essential_worker agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("EconomicAspects") modify 
putexcel C76=("Frequency") K76=("Percent")
putexcel B77=("Essential Worker") 
putexcel C77=("18-29") D77=("30-39") E77=("40-49") F77=("50-59") G77=("60-69") H77=("70 & over") I77=("Missing")
putexcel K77=("18-29") L77=("30-39") M77=("40-49") N77=("50-59") O77=("60-69") P77=("70 & over") Q77=("Missing")
putexcel B78=matrix(names) C78=matrix(freq) K78=matrix(freq/r(N)*100)
putexcel B78=("Yes") B79=("No") B80=("Missing")
putexcel C82= matrix(T) B82 = ("Total") 

*-------------------------------------------------------------------------------

//Current Health

*Chronic Health Conditions
mrtab diabetes hypertension heart_disease resp_disease cancer men_disease other_disease no_disease, nonames by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("CurrentHealth") modify 
putexcel C5=("Frequency") K5=("Percent")
putexcel B6=("Health Conditions")
putexcel C6=("18-29") D6=("30-39") E6=("40-49") F6=("50-59") G6=("60-69") H6=("70 & over") 
putexcel K6=("18-29") L6=("30-39") M6=("40-49") N6=("50-59") O6=("60-69") P6=("70 & over") 
putexcel C7=matrix(freq) K7=matrix(freq/4522*100) 
putexcel C15=matrix(miss) K15=matrix((miss/4522)*100) C17=(4522)
putexcel B7=("Diabetes")
putexcel B8=("Hypertension" )
putexcel B9=("Heart Disease" )
putexcel B10=("Respiratory Disease" )
putexcel B11=("Cancer")
putexcel B12=("Mental Disease")
putexcel B13=("Other")
putexcel B14=("No chronic conditions")
putexcel B15=("Missing")
putexcel B17=("Total")

*-------------------------------------------------------------------------------

//Attitudes to COVID-19

*Worried about COVID-19
tabulate worried_covid agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("AttitudesToCovid") modify 
putexcel C5=("Frequency") K5=("Percent")
putexcel B6=("Worried about COVID-19") 
putexcel C6=("18-29") D6=("30-39") E6=("40-49") F6=("50-59") G6=("60-69") H6=("70 & over") I6=("Missing")
putexcel K6=("18-29") L6=("30-39") M6=("40-49") N6=("50-59") O6=("60-69") P6=("70 & over") Q6=("Missing")
putexcel B7=matrix(names) C7=matrix(freq) K7=matrix(freq/r(N)*100)
putexcel B7=("Very worried") B8=("Fairly worried") B9=("Not very worried") B10=("Don't know") B11=("Missing") 
putexcel C13= matrix(T) B13= ("Total") 

*Interested in getting tested
tabulate test_interest agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("AttitudesToCovid") modify 
putexcel C16=("Frequency") K16=("Percent")
putexcel B17=("If you haven't been tested would you likely to be tested") 
putexcel C17=("18-29") D17=("30-39") E17=("40-49") F17=("50-59") G17=("60-69") H17=("70 & over") I17=("Missing")
putexcel K17=("18-29") L17=("30-39") M17=("40-49") N17=("50-59") O17=("60-69") P17=("70 & over") Q17=("Missing")
putexcel B18=matrix(names) C18=matrix(freq) K18=matrix(freq/r(N)*100)
putexcel B18=("Yes") B19=("No") B20=("Missing") 
putexcel C22= matrix(T) B22= ("Total") 

*Likely infected under Barbados current preventive measures
tabulate likely_infected agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("AttitudesToCovid") modify 
putexcel C25=("Frequency") K25=("Percent")
putexcel B26=("Likely infected under Barbados current preventive measures") 
putexcel C26=("18-29") D26=("30-39") E26=("40-49") F26=("50-59") G26=("60-69") H26=("70 & over") I26=("Missing")
putexcel K26=("18-29") L26=("30-39") M26=("40-49") N26=("50-59") O26=("60-69") P26=("70 & over") Q26=("Missing")
putexcel B27=matrix(names) C27=matrix(freq) K27=matrix(freq/r(N)*100)
putexcel B27=("Very likely") B28=("Fairly likely") B29=("Neither likely or unlikely") B30=("Fairly unlikely") B31=("Very unlikely") B32=("Don't know") B33=("Missing")
putexcel C34= matrix(T) B34= ("Total") 

*Expectation of effect of COVID-19 if infected
tabulate expect_infected agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("AttitudesToCovid") modify 
putexcel C37=("Frequency") K37=("Percent")
putexcel B38=("Expectation if infected with COVID-19") 
putexcel C38=("18-29") D38=("30-39") E38=("40-49") F38=("50-59") G38=("60-69") H38=("70 & over") I38=("Missing")
putexcel K38=("18-29") L38=("30-39") M38=("40-49") N38=("50-59") O38=("60-69") P38=("70 & over") Q38=("Missing")
putexcel B39=matrix(names) C39=matrix(freq) K39=matrix(freq/r(N)*100)
putexcel B39=("Life-threatening") B40=("Severe") B41=("Moderate") B42=("Mild") B43=("No symptoms") B44=("Don't know") B45=("Missing")
putexcel C47= matrix(T) B47= ("Total") 

*Protective Measures against COVID-19 transmission
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("AttitudesToCovid") modify 
putexcel C50=("Frequency") V50=("Percent")
putexcel B51=("Protective Measures") 
putexcel C52=("Yes") I52=("No") O52=("Not applicable")
putexcel V52=("Yes") AB52=("No") AH52=("Not applicable")
*Frequency
putexcel C53=("18-29") D53=("30-39") E53=("40-49") F53=("50-59") G53=("60-69") H53=("70 & over") 
putexcel I53=("18-29") J53=("30-39") K53=("40-49") L53=("50-59") M53=("60-69") N53=("70 & over") 
putexcel O53=("18-29") P53=("30-39") Q53=("40-49") R53=("50-59") S53=("60-69") T53=("70 & over") 
*Percent
putexcel V53=("18-29") W53=("30-39") X53=("40-49") Y53=("50-59") Z53=("60-69") AA53=("70 & over") 
putexcel AB53=("18-29") AC53=("30-39") AD53=("40-49") AE53=("50-59") AF53=("60-69") AG53=("70 & over") 
putexcel AH53=("18-29") AI53=("30-39") AJ53=("40-49") AK53=("50-59") AL53=("60-69") AM53=("70 & over") 
putexcel B54=("Worn a face mask")
putexcel B55=("Washed hands more frequently with soap and water")
putexcel B56=("Used hand sanitizer more regularly")
putexcel B57=("Disinfected my home")
putexcel B58=("Covered my nose and mouth with a tissue or sleeve when sneezing and coughing")
putexcel B59=("Avoided being around with people who have a fever or cold like symptoms")
putexcel B60=("Avoided being  around people who have traveled")
putexcel B61=("Avoided going out in general")
putexcel B62=("Avoided crowded areas")
putexcel B63=("Avoided going to public markets that sell fresh meat, fish or poultry")
putexcel B64=("Avoided going to hospital and other healthcare settings")
putexcel B65=("Avoided taking public transport / bus")
putexcel B66=("Avoided going to work")
putexcel B67=("Avoided going to school / university")
putexcel B68=("Avoided letting my children go to school / university")
putexcel B69=("Avoided going into shops and supermarkets")
putexcel B70=("Avoided social events")
putexcel B71=("Avoided travel")
putexcel B72=("Avoided travel to other areas (outside Barbados) ")
putexcel B73=("Avoided travel to other areas (inside Barbados)")
putexcel B74=("Moved temporarily to the countryside or a remote location")
putexcel B75=("Gargle with salt water")
putexcel B76=("Bathe in the sea")
putexcel B77=("Drink herbal /ginger/bush tea")
**Yes
mrtab q0055_0001 - q0055_0024, nonames response(1) by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("AttitudesToCovid") modify 
putexcel C54=matrix(freq) V54=matrix(freq/4522*100) 
**No
mrtab q0055_0001 - q0055_0024, nonames response(2) by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("AttitudesToCovid") modify 
putexcel I54=matrix(freq) AB54=matrix(freq/4522*100) 
**Not applicable
mrtab q0055_0001 - q0055_0024, nonames response(3) by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("AttitudesToCovid") modify 
putexcel O54=matrix(freq) AH54=matrix(freq/4522*100) 

*Ability to self isolate
tabulate q0056_0001 agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("AttitudesToCovid") modify 
putexcel C80=("Frequency") K80=("Percent")
putexcel B81=("Ability to Self Isolate") 
putexcel C81=("18-29") D81=("30-39") E81=("40-49") F81=("50-59") G81=("60-69") H81=("70 & over") I81=("Missing")
putexcel K81=("18-29") L81=("30-39") M81=("40-49") N81=("50-59") O81=("60-69") P81=("70 & over") Q81=("Missing")
putexcel B82=matrix(names) C82=matrix(freq) K82=matrix(freq/r(N)*100)
putexcel B82=("Yes I would") B83=("No I wouldn't") B84=("Don't know") B85=("Missing") 
putexcel C87= matrix(T) B87= ("Total") 

*Willingness to self isolate
tabulate q0056_0002 agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("AttitudesToCovid") modify 
putexcel C90=("Frequency") K90=("Percent")
putexcel B91=("Willingness to Self Isolate") 
putexcel C91=("18-29") D91=("30-39") E91=("40-49") F91=("50-59") G91=("60-69") H91=("70 & over") I91=("Missing")
putexcel K91=("18-29") L91=("30-39") M91=("40-49") N91=("50-59") O91=("60-69") P91=("70 & over") Q91=("Missing")
putexcel B92=matrix(names) C92=matrix(freq) K92=matrix(freq/r(N)*100)
putexcel B92=("Yes I would") B93=("No I wouldn't") B94=("Don't know") B95=("Missing") 
putexcel C97= matrix(T) B97= ("Total") 

*-------------------------------------------------------------------------------
 
//Practices and Experiences

*Lockdown Prepartions

putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("PracticesExperiences") modify 
putexcel C5=("Frequency") V5=("Percent")
putexcel B6=("Lockdown Preparations") 
putexcel C6=("Yes") I6=("No") O6=("Not applicable")
putexcel V6=("Yes") AB6=("No") AH6=("Not applicable")
*Frequency
putexcel C7=("18-29") D7=("30-39") E7=("40-49") F7=("50-59") G7=("60-69") H7=("70 & over") 
putexcel I7=("18-29") J7=("30-39") K7=("40-49") L7=("50-59") M7=("60-69") N7=("70 & over") 
putexcel O7=("18-29") P7=("30-39") Q7=("40-49") R7=("50-59") S7=("60-69") T7=("70 & over") 
*Percent
putexcel V7=("18-29") W7=("30-39") X7=("40-49") Y7=("50-59") Z7=("60-69") AA7=("70 & over") 
putexcel AB7=("18-29") AC7=("30-39") AD7=("40-49") AE7=("50-59") AF7=("60-69") AG7=("70 & over") 
putexcel AH7=("18-29") AI7=("30-39") AJ7=("40-49") AK7=("50-59") AL7=("60-69") AM7=("70 & over") 
putexcel B8=("Stocking up on food supplies")
putexcel B9=("Stocking up on toiletries")
putexcel B10=("Stocking up on prescription medicines")
putexcel B11=("Stocking up on over the counter medicines")
putexcel B12=("Stocking up on condoms, safe sex supplies")
putexcel B13=("Stocking up on birth control")
putexcel B14=("Establishing remote working capabilities")
putexcel B15=("Finding alternative childcare")
**Yes
mrtab q0057_0001 - q0057_0008, nonames response(1) by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel C8=matrix(freq) V8=matrix(freq/4522*100) 
**No
mrtab q0057_0001 - q0057_0008, nonames response(2) by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel I8=matrix(freq) AB8=matrix(freq/4522*100) 
**Not applicable
mrtab q0057_0001 - q0057_0008, nonames response(3) by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel O8=matrix(freq) AH8=matrix(freq/4522*100) 

*Problems with lockdown
mrtab q0058_0001 - q0058_0010, nonames by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("PracticesExperiences") modify 
putexcel C18=("Frequency") K18=("Percent")
putexcel B19=("Problems with lockdown") 
putexcel C19=("18-29") D19=("30-39") E19=("40-49") F19=("50-59") G19=("190-199") H19=("70 & over") 
putexcel K19=("18-29") L19=("30-39") M19=("40-49") N19=("50-59") O19=("190-199") P19=("70 & over") 
putexcel C20=matrix(freq) K20=matrix(freq/r(N)*100) 
putexcel C30=matrix(miss) K30=matrix((miss/4522)*100) C32=(4522)
putexcel B20=("Mental Health")
putexcel B21=("Space in household" )
putexcel B22=("Obtaining supplies" )
putexcel B23=("Carer with no help" )
putexcel B24=("Social Life")
putexcel B25=("Financial")
putexcel B26=("Impact on education")
putexcel B27=("Don't know")
putexcel B28=("No problems")
putexcel B29=("Other")
putexcel B30=("Missing")
putexcel B32=("Total")

*-------------------------------------------------------------------------------

//Knowledge 

*Method of COVID-19 Transmission
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Knowledge") modify 
putexcel C4=("Frequency") AC4=("Percent")
putexcel B5=("Method of COVID-19 Transmission") 
putexcel C5=("Likely") I5=("Unlikely") O5=("Neither likely or unlikely") U5=("Don't know")
putexcel AC5=("Likely") AI5=("Unlikely") AO5=("Neither likely or unlikely") AU5=("Don't know")
*Frequency
putexcel C6=("18-29") D6=("30-39") E6=("40-49") F6=("50-59") G6=("60-69") H6=("70 & over") 
putexcel I6=("18-29") J6=("30-39") K6=("40-49") L6=("50-59") M6=("60-69") N6=("70 & over") 
putexcel O6=("18-29") P6=("30-39") Q6=("40-49") R6=("50-59") S6=("60-69") T6=("70 & over") 
putexcel U6=("18-29") V6=("30-39") W6=("40-49") X6=("50-59") Y6=("60-69") Z6=("70 & over") 
*Percent
putexcel AC6=("18-29") AD6=("30-39") AE6=("40-49") AF6=("50-59") AG6=("60-69") AH6=("70 & over") 
putexcel AI6=("18-29") AJ6=("30-39") AK6=("40-49") AL6=("50-59") AM6=("60-69") AN6=("70 & over") 
putexcel AO6=("18-29") AP6=("30-39") AQ6=("40-49") AR6=("50-59") AS6=("60-69") AT6=("70 & over") 
putexcel AU6=("18-29") AV6=("30-39") AW6=("40-49") AX6=("50-59") AY6=("60-69") AZ6=("70 & over") 
putexcel B7=("Talking with but not touching someone who has corona-virus but no symptoms")
putexcel B8=("Talking with but not touching with somone who has corona-virus")
putexcel B9=("Having physical contact with someone who has corona-virus but no symptoms")
putexcel B10=("Having physical contact with someone with corona-virus who has symptoms")
putexcel B11=("Being close (i.e. within 6 feet) to someone who has corona-virus, when they cough")
putexcel B12=("Being further away (i.e. further than 6 feet away) to someone who has corona-virus, when they cough or sneeze")
putexcel B13=("Touching contaminated objects (e.g. surfaces such as Shopping carts, door handles, etc.)")
putexcel B14=("Consumption of wild animal meat (e.g. rabbit, Iguana, monkey, yard fowl)")
putexcel B15=("Visiting public markets that sell fresh meat, fish or poultry")
putexcel B16=("Eating foods imported from China")
putexcel B17=("Using products imported from China")
**Likely
mrtab q0054_0001 - q0054_0011, nonames response(1) by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel C7=matrix(freq) AC7=matrix(freq/4522*100) 
**Unlikely
mrtab q0054_0001 - q0054_0011, nonames response(2) by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel I7=matrix(freq) AI7=matrix(freq/4522*100) 
**Neither likely or unlikely
mrtab q0054_0001 - q0054_0011, nonames response(3) by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel O7=matrix(freq) AO7=matrix(freq/4522*100) 
**Not applicable
mrtab q0054_0001 - q0054_0011, nonames response(4) by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel U7=matrix(freq) AU7=matrix(freq/4522*100) 

*Source of COVID-19 Information
mrtab q0079_0001 - q0079_0014, nonames by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Knowledge") modify 
putexcel C20=("Frequency") K20=("Percent")
putexcel B21=("COVID-19 Information Source") 
putexcel C21=("18-29") D21=("30-39") E21=("40-49") F21=("50-59") G21=("210-219") H21=("70 & over") 
putexcel K21=("18-29") L21=("30-39") M21=("40-49") N21=("50-59") O21=("210-219") P21=("70 & over") 
putexcel C22=matrix(freq) K22=matrix(freq/4522*100) 
putexcel C36=matrix(miss) K36=matrix((miss/4522)*100) C38=(4522)
putexcel B22=("Newspaper(s)")
putexcel B23=("Magazine(s) (i.e. in print or online)" )
putexcel B24=("Radio" )
putexcel B25=("CBC / Channel 8" )
putexcel B26=("Cable television / Satellite")
putexcel B27=("Official websites")
putexcel B28=("Unofficial websites")
putexcel B29=("Social Media")
putexcel B30=("My doctor")
putexcel B31=("Other healthcare professional")
putexcel B32=("My family or friends" )
putexcel B33=("Work / school / college communications" )
putexcel B34=("I am not getting any information" )
putexcel B35=("Other" )
putexcel B36=("Missing")
putexcel B38=("Total")


*Information Preference
mrtab q0080_0001 - q0080_0015, nonames by(agegrp)
matlist r(responses)
matrix freq = r(responses)
matrix miss = r(N_miss)
matrix T = r(N)
matlist freq
matlist miss
matlist T
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Knowledge") modify 
putexcel C40=("Frequency") K40=("Percent")
putexcel B41=("COVID-19 Information Preference") 
putexcel C41=("18-29") D41=("30-39") E41=("40-49") F41=("50-59") G41=("410-419") H41=("70 & over") 
putexcel K41=("18-29") L41=("30-39") M41=("40-49") N41=("50-59") O41=("410-419") P41=("70 & over") 
putexcel C42=matrix(freq) K42=matrix(freq/4522*100) 
putexcel C57=matrix(miss) K57=matrix((miss/4522)*100) C59=(4522)
putexcel B42=("Research")
putexcel B43=("Common Sign and symptoms of infection" )
putexcel B44=("Less Common Sign and symptoms of infection" )
putexcel B45=("How to know if infected" )
putexcel B46=("Information on transmission")
putexcel B47=("Information on prevention")
putexcel B48=("High risk groups")
putexcel B49=("Number of cases (Barbados)")
putexcel B50=("Distribution of cases (Barbados)")
putexcel B51=("Infection risk (Barbados)")
putexcel B52=("NPIs (Barbados)" )
putexcel B53=("NPIs (Other Countries)" )
putexcel B54=("NPIs (International organizations)" )
putexcel B55=("I do want to receive any information" )
putexcel B56=("Other")
putexcel B57=("Missing")
putexcel B59=("Total")

*Misconceptions

putexcel B62=("Misconceptions")
putexcel B64=("Do you think it is likely that the new coronavirus is a bioweapon developed by a government or terrorist organization?")
**

tabulate covid_bio agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Knowledge") modify 
putexcel C66=("Frequency") K66=("Percent")
putexcel B67=("COVID-19 Bioterrorism") 
putexcel C67=("18-29") D67=("30-39") E67=("40-49") F67=("50-59") G67=("60-69") H67=("70 & over") I67=("Missing")
putexcel K67=("18-29") L67=("30-39") M67=("40-49") N67=("50-59") O67=("60-69") P67=("70 & over") Q67=("Missing")
putexcel B68=matrix(names) C68=matrix(freq) K68=matrix(freq/r(N)*100)
putexcel B68=("Likely") B69=("Unlikely") B70=("Missing") 
putexcel C72= matrix(T) B72= ("Total") 

**
putexcel B73=("How likely or unlikely, do you think it is that the corona-virus (i.e COVID-19) is transmitted through each of the following")

*Eating foods imported from China
tabulate q0054_0010 agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Knowledge") modify 
putexcel C75=("Frequency") K75=("Percent")
putexcel B76=("Eating foods imported from China") 
putexcel C76=("18-29") D76=("30-39") E76=("40-49") F76=("50-59") G76=("60-69") H76=("70 & over") I76=("Missing")
putexcel K76=("18-29") L76=("30-39") M76=("40-49") N76=("50-59") O76=("60-69") P76=("70 & over") Q76=("Missing")
putexcel B77=matrix(names)  K77=matrix(freq/r(N)*100)
putexcel B77=("Likely") B78=("Unlikely") B79=("Neither likely or unlikely") B80=("Don't know") B81=("Missing") 
putexcel C83= matrix(T) B83= ("Total") 

*Using products imported from China
tabulate q0054_0011 agegrp, miss matcell(freq) matrow(names)
matrix list freq
matrix list names
mat T = r(N)
putexcel set "`outputpath'/MoHWReportResults_ByAgeGrp.xlsx", sheet("Knowledge") modify 
putexcel C85=("Frequency") K85=("Percent")
putexcel B86=("Using products imported from China")
putexcel C86=("18-29") D86=("30-39") E86=("40-49") F86=("50-59") G86=("60-69") H86=("70 & over") I86=("Missing")
putexcel K86=("18-29") L86=("30-39") M86=("40-49") N86=("50-59") O86=("60-69") P86=("70 & over") Q86=("Missing")
putexcel B87=matrix(names) K87=matrix(freq/r(N)*100)
putexcel B87=("Likely") B88=("Unlikely") B89=("Neither likely or unlikely") B90=("Don't know") B91=("Missing") 
putexcel C93= matrix(T) B93= ("Total") 

*-------------------------------------------------------------------------------








