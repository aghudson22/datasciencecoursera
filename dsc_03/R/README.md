This project works with the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) at the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.php). The goal of the project is to process that data and find summary measures of certain variables in that data. We find averages of the variables that correspond to means and standard deviations of raw measurement data, and these averages are grouped both by the experimental subject from which raw data were gathered and by the activity in which the experimental subject was engaged at the time of the raw data measurement.

Files included are described in the list below.

* `summ_data.txt`: Contains the data set created by the analysis script. Can be read into R using the command `read.table("summ_data.txt", header = TRUE, nrows = 180)`.
* `run_analysis.R`: Contains the R code used to obtain and process the original data and write `summ_data.txt`. Note that the script will write `summ_data.txt` to the working directory and will store downloaded files in a `data` directory one level up from the working directory.
* `CodeBook.md`: Describes how variables were collected, calculated, and named in the data file. Also includes information regarding the collection of data in the original data set.
* `README.md`: This file.
