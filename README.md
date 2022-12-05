<div align="center">
  <img src="./MTU_Logo.jpg" width="250">
  <h2> Data Science @ MTU</h2>
  <h4>A collection of projects from selected Data Science modules.</h4>
</div>

- [STAT8008 Time Series](https://github.com/pachristopher/data-science-mtu#stat8008)
  - [A1: Household Electric Consumption](https://github.com/pachristopher/data-science-mtu#a1-household-electric-consumption)
  - [A2: Principal Component Analysis](https://github.com/pachristopher/data-science-mtu#a2-PCA)

---

## STAT8008 Time Series and PCA

Autumn Term, 2021

### A1: Forecasting Household Electric Consumption 

For a detailed report, please see [proj_pdf2.pdf](./stat8008/proj1-ts/proj_pdf2.pdf).

The objective of this assignment is to develop and test a model for forecasting electrical power consumption within a household from historical power consumption time series data. The open-source dataset contains over 2 million measurements of power consumption which was gathered in a house in France between December 2006 and November 2010, at one minute intervals. 

- **Technology stack chosen:** [RStudio: forecast, imputeTS packages](https://pkg.robjhyndman.com/forecast/)
- **Data:** [stat8008/proj1-ts/elec.rds](https://archive.ics.uci.edu/ml/datasets/individual+household+electric+power+consumption)
- **Notebook:** [proj_pdf2.Rmd](./data8008/proj1-ts/proj_pdf2.Rmd)

#### Tasks:

- [Data Preparation and Analysis](./stat8008/proj1-ts/Data_prep.R):
  - Load the stored dataset from a delimited text file and conduct preliminary tests on it.
  - Conduct tests to check for missing values and, where necessary impute missing values with appropriate techniques.
  - Apply any pre-processing steps that might be required to clean, filter or engineer the dataset before analysis.
  - Analyse, characterise, and summarise the cleaned dataset, using tables and visualisations where appropriate.
  - Summarise any insights which you gained from your analysis of the dataset, and suggest ideas for further analysis.
  - Reshape the data into monthly averages.
  - Save the transformed data in an appropriate structure (.rds file) for re-use.

- [Data Analysis](./stat8008/proj1-ts/proj_pdf2.Rmd):
    - Analyse, characterise and summarise the cleaned dataset, using tables and visualisations where appropriate.
        - Seasonplots; lag-plots; correlograms.
        - Decompose time series into: trend, seasonal and remainder components in preliminary plots.
        - Check for stationarity, integration and auto-correlation.

- [Model Creation](./stat8008/proj1-ts/proj_pdf2.Rmd):
    - Forecast models:
        - Exponential smoothing methods.
        - ARIMA models.

- [Model Assessment](./stat8008/proj1-ts/proj_pdf2.Rmd):
    - holdout test data.

### A2: Principal Component Analysis 

The objective of this assignment is to ascertain the extent to which the dimensionality of a given dataset can be reduced through the method of principal component analysis.

- **Data:** [stat8008/proj2-pca/data/PCA_Project.sav](./stat8008/proj2-pca/PCA_Project.sav)
- **Notebook:** [PCAProj.Rmd](./stat8008/proj2-pca/PCAProj.Rmd)

#### Tasks:

<ul>
  <li>
  <details>
    <summary>Data ingestion and cleaning</summary>
    <ul>
      <li>
        Read in data from SPSS .sav file. 
      </li>
      <li>
        Extract the make and model and use that for the row name. 
      </li>
      <li>
        Remove variables deemed to be uninformative, such as the number of passengers, insurance category and the length of the car.
      </li>
      <li>
        Transform 'cylinders' variable from factor to numeric type.?
      </li>
      <li>
        Report summary statistics for the dataset; plot correlation matrix and create pairs plot for summary of data.
      </li>
    </ul>
  </details>
  </li>
  <li>
    <details>
      <summary>Principal component analysis</summary>
      <ul>
        <li>
          Test whether data suitable for data reduction techniques using Bartlett's Sphericity test.
        </li>
        <li>
          Perform PCA using base R and FactoMineR functions, after standardising the variables.
        </li>
        <li>
          Compare and contrast the principal component scores and correlations of principal components
          with original variables for both functions. 
        </li>
        <li>
          Decide how many components to retain using scree plots. .
        </li>
        <li>
          Split the dataset into two groups: USA cars and non-USA cars and re-perform the foregoing analysis on the two seperate groups.
        </li>  
      </ul>
    </details>
  </li>
</ul>

