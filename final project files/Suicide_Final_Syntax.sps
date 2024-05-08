* Encoding: UTF-8.



GET DATA
  /TYPE=XLSX
  /FILE='C:\Users\ranap\OneDrive\Documents\BA_PROJECT_WSU\Suicide_Rates_1990-2022.xlsx'
  /SHEET=name 'age_std_suicide_rates_1990-2022'
  /CELLRANGE=FULL
  /READNAMES=ON
  /LEADINGSPACES IGNORE=YES
  /TRAILINGSPACES IGNORE=YES
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.




DATASET ACTIVATE DataSet1.
DESCRIPTIVES VARIABLES=Year SuicideCount CauseSpecificDeathPercentage StdDeathRate DeathRatePer100K 
    Population GDPPerCapita GNIPerCapita InflationRate EmploymentPopulationRatio
  /STATISTICS=MEAN STDDEV MIN MAX.




FREQUENCIES VARIABLES=RegionName CountryName Year Sex SuicideCount CauseSpecificDeathPercentage 
    StdDeathRate DeathRatePer100K Population GDP GDPPerCapita GNI GNIPerCapita InflationRate 
    EmploymentPopulationRatio
  /FORMAT=NOTABLE
  /STATISTICS=STDDEV VARIANCE
  /ORDER=ANALYSIS.




REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10) TOLERANCE(.0001)
  /NOORIGIN 
  /DEPENDENT DeathRatePer100K
  /METHOD=ENTER Year SuicideCount CauseSpecificDeathPercentage StdDeathRate Population GDPPerCapita 
    GNIPerCapita  EmploymentPopulationRatio InflationRate Gender
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS DURBIN HISTOGRAM(ZRESID) NORMPROB(ZRESID).



**Splitting into training and test data**
USE ALL.
COMPUTE filter_$=(uniform(1)<=.80).
VARIABLE LABELS filter_$ 'Approximately 80% of the cases (SAMPLE)'.
FORMATS filter_$ (f1.0).
FILTER  BY filter_$.
EXECUTE.



FILTER OFF.
USE ALL.
EXECUTE.



**training data**

USE ALL.
COMPUTE filter_$=(sample=1).
VARIABLE LABELS filter_$ 'sample=1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

**regression on Training data**
    




REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10) TOLERANCE(.0001)
  /NOORIGIN 
  /DEPENDENT DeathRatePer100K
  /METHOD=ENTER Year SuicideCount CauseSpecificDeathPercentage StdDeathRate Population GDPPerCapita 
    GNIPerCapita InflationRate  EmploymentPopulationRatio Gender
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS DURBIN HISTOGRAM(ZRESID) NORMPROB(ZRESID).


**computing the predicted value**

COMPUTE Predicted=-28.097+ 0.015 * Year+7.782E-5 * SuicideCount+ -0.408 * 
    CauseSpecificDeathPercentage+1.125 * StdDeathRate+ -3.793E-9 * Population+ 
    1.306E-5*GDPPerCapita+2.278E-5 * GNIPerCapita+0.000 * InflationRate+ -0.058 * 
    EmploymentPopulationRatio+0.195 * Gender.
EXECUTE.



*splitting on groups**
SORT CASES  BY Sample.
SPLIT FILE LAYERED BY Sample.



**Correlation between training and test data**


CORRELATIONS
  /VARIABLES=Predicted DeathRatePer100K
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.


