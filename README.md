# AFRIC Statistical learning workshop

Materials for 2023 AFRIC Statistical learning workshop including data, scripts,
and slides


## Scripts

Script for the 2023 AFRIC Statistical learning workshop. Scripts are:

- **0_SL_Afric_LoadPackages.R**: Load and install required packages
- **1_SL_Afric_DataPreparationExploration**: Prepare data and do exploratory plots
- **2_SL_Afric_GLM_Lasso**: Fit glm (logistic regression) and lasso
- **3_SL_Afric_Tree_RF_Boosting**: Fit tree, Random Forest and Boosting
- **4_SL_ModelEvaluation**: Plot ROC for models and calculate AUC



# Data

The workshop data can be donwloaded from

https://www.dropbox.com/s/4b8gtufilgmb4az/VicRoadFatalData.csv?dl=0. 

The  dataset consists of real road crashes in Victoria obtained from the [\underline{CrashStats}](https://discover.data.vic.gov.au/dataset/crash-stats-data-extract) datasets provided by VicRoads. The CrashStats data allows us to analyse serious vehicle crashes based on time, location, conditions, crash type, road user type, object hit etc.

The workshop dataset `VicRoadFatalData.csv` has been prepared by linking and cleaning several of the files available in CrashStats. This dataset includes data for 200,000 drivers involved in road crashes in Victoria between 2006 and 2020. For each of the 200,000 instances we have information on 27 variables describing the driver, the driver's vehicle, and other accident-related information (e.g., time, road conditions, etc.). These are described below:

**Driver data**

| FIELD NAME                 | FIELD DEFINITION                                         | FIELD DOMAIN               |
|----------------------------|----------------------------------------------------------|----------------------------|
| `DRIVER_ID`                | Unique identifier for each driver                        | Text                       |
| `SEX`                      | Sex or gender of the driver                              | Male (`M`), Female (`F`), Unknown (`U`)               |
| `AGE`                      | Age of the driver at the time of the accident       | Integer                    |
| `Age Group`                | Age group that the driver falls into                     | 16--17, 18--21, etc.    |
| `LICENCE_STATE`            | State where the driver's license is registered           | Victoria, Other       |
| `HELMET_BELT_WORN`         | Whether a helmet or seatbelt was worn by the driver                   | Seatbelt worn, Seatbelt not worn, Other                    |


**Vehicle data**

| FIELD NAME                 | FIELD DEFINITION                                                           | FIELD DOMAIN               |
|----------------------------|----------------------------------------------------------------------------|----------------------------|
| `VEHICLE_ID`               | Unique identifier for each vehicle                                         | Text                    |
| `VEHICLE_YEAR_MANUF`       | The year the vehicle was manufactured                                      | Year                       |
| `VEHICLE_BODY_STYLE`       | The body style of the vehicle                                              | Sedan, Coupe, etc.     |
| `VEHICLE_MAKE`             | The make of the vehicle                                                    | Toyota, Ford, etc.   |
| `VEHICLE_TYPE`             | The type or category of vehicle                                            | Car, Taxi, etc.     |
| `FUEL_TYPE`                | The type of fuel the vehicle uses                                          | Petrol, Diesel, etc. |
| `VEHICLE_COLOUR`           | The colour of the vehicle                                                  | Various colors             |
| `OWNER_POSTCODE`           | The postcode of the vehicle's owner                                        | Postcode                   |
| `TOTAL_NO_OCCUPANTS`       | The total number of occupants in the vehicle at the time of the accident   | Integer                    |


**Other Accident data**

| FIELD NAME                 | FIELD DEFINITION                                                           | FIELD DOMAIN               |
|----------------------------|----------------------------------------------------------------------------|----------------------------|
| `ACCIDENT_NO`              | Unique identifier for each accident                                        | Text                    |
| `ACCIDENTDATE`             | The date of the accident                                                   | Date                       |
| `ACCIDENTTIME`             | The time of the accident                                                   | Time                       |
| `DAY_OF_WEEK`              | The day of the week when the accident occurred                             | Monday, Tuesday, etc.|
| `ACCIDENT_TYPE`            | The type of accident                                                       | Various types              |
| `LIGHT_CONDITION`          | The light condition at the time of the accident                            | Day, Dark Street lights on, etc.|
| `ROAD_GEOMETRY`            | The layout of the road where the accident occurred                         | Various types              |
| `SPEED_ZONE`               | The speed limit in the area where the accident occurred                    | Various speed limits       |
| `SURFACE_COND`             | The condition of the road's surface at the time of the accident            | Wet, Dry, Other.       |
| `ATMOSPH_COND`             | The atmospheric condition at the time of the accident                      | Clear, Raining, Fog, Other   |
| `ROAD_SURFACE_TYPE`        | The type of road surface where the accident occurred                       | Paved, Unpaved, Gravel|



**Output variable (desired target)**

| FIELD NAME                 | FIELD DEFINITION                                                           | FIELD DOMAIN               |
|----------------------------|----------------------------------------------------------------------------|----------------------------|
| fatal                      | Whether the accident was fatal or not                                      | Yes (`TRUE`), No (`FALSE`)                    |


You can see further information about the variables in the [\underline{metadata file}](https://data.vicroads.vic.gov.au/Metadata/Crash%20Stats%20-%20Data%20Extract%20-%20Open%20Data.html) provided by VicRoads.

