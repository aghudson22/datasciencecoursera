The accompanying data file, `summ_data.txt`, contains 180 measurements on 69 variables. It contains grouped summary measures (specifically, means) on the data provided in the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) at the [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.php). Descriptions of the variable names and relevant information follow.

* `activity_name`: The name of the recorded activity during which original measurements were taken.
* `subject`: The integer identifier (between 1 and 30) of the experimental subject from whom original measurements were gathered.

The remaining 67 variables represent summary measures. Each represents the average of all corresponding original measurements for the experimental subject and recorded activity noted in the row. The measurements in the original data set from which these summaries were derived have similar variable names to those below with `_avg` removed. Note that the characters `-`, `(`, `)`, and `,` in the original variable names were replaced with periods, `.`, due to the requirements of the functions used in the analysis. Further note that these summary measures do not include all measurements from the original data set; they are only a subset of 67 of the original 561 measurements. Details on how the original measurements were obtained will be given at the end of this document as a quote from the corresponding document in the original data set.

* `tBodyAcc.mean...X_avg`
* `tBodyAcc.mean...Y_avg`
* `tBodyAcc.mean...Z_avg`
* `tGravityAcc.mean...X_avg`
* `tGravityAcc.mean...Y_avg`
* `tGravityAcc.mean...Z_avg`
* `tBodyAccJerk.mean...X_avg`
* `tBodyAccJerk.mean...Y_avg`
* `tBodyAccJerk.mean...Z_avg`
* `tBodyGyro.mean...X_avg`
* `tBodyGyro.mean...Y_avg`
* `tBodyGyro.mean...Z_avg`
* `tBodyGyroJerk.mean...X_avg`
* `tBodyGyroJerk.mean...Y_avg`
* `tBodyGyroJerk.mean...Z_avg`
* `tBodyAccMag.mean.._avg`
* `tGravityAccMag.mean.._avg`
* `tBodyAccJerkMag.mean.._avg`
* `tBodyGyroMag.mean.._avg`
* `tBodyGyroJerkMag.mean.._avg`
* `fBodyAcc.mean...X_avg`
* `fBodyAcc.mean...Y_avg`
* `fBodyAcc.mean...Z_avg`
* `fBodyAccJerk.mean...X_avg`
* `fBodyAccJerk.mean...Y_avg`
* `fBodyAccJerk.mean...Z_avg`
* `fBodyGyro.mean...X_avg`
* `fBodyGyro.mean...Y_avg`
* `fBodyGyro.mean...Z_avg`
* `fBodyAccMag.mean.._avg`
* `fBodyBodyAccJerkMag.mean.._avg`
* `fBodyBodyGyroMag.mean.._avg`
* `fBodyBodyGyroJerkMag.mean.._avg`
* `angle.tBodyAccJerkMean..gravityMean._avg`
* `tBodyAcc.std...X_avg`
* `tBodyAcc.std...Y_avg`
* `tBodyAcc.std...Z_avg`
* `tGravityAcc.std...X_avg`
* `tGravityAcc.std...Y_avg`
* `tGravityAcc.std...Z_avg`
* `tBodyAccJerk.std...X_avg`
* `tBodyAccJerk.std...Y_avg`
* `tBodyAccJerk.std...Z_avg`
* `tBodyGyro.std...X_avg`
* `tBodyGyro.std...Y_avg`
* `tBodyGyro.std...Z_avg`
* `tBodyGyroJerk.std...X_avg`
* `tBodyGyroJerk.std...Y_avg`
* `tBodyGyroJerk.std...Z_avg`
* `tBodyAccMag.std.._avg`
* `tGravityAccMag.std.._avg`
* `tBodyAccJerkMag.std.._avg`
* `tBodyGyroMag.std.._avg`
* `tBodyGyroJerkMag.std.._avg`
* `fBodyAcc.std...X_avg`
* `fBodyAcc.std...Y_avg`
* `fBodyAcc.std...Z_avg`
* `fBodyAccJerk.std...X_avg`
* `fBodyAccJerk.std...Y_avg`
* `fBodyAccJerk.std...Z_avg`
* `fBodyGyro.std...X_avg`
* `fBodyGyro.std...Y_avg`
* `fBodyGyro.std...Z_avg`
* `fBodyAccMag.std.._avg`
* `fBodyBodyAccJerkMag.std.._avg`
* `fBodyBodyGyroMag.std.._avg`
* `fBodyBodyGyroJerkMag.std.._avg`

Details on original measurement collection and original variable naming convention follow.

> The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
> 
> Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
> 
> Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
> 
> These signals were used to estimate variables of the feature vector for each pattern:  
> '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
> 
> tBodyAcc-XYZ  
> tGravityAcc-XYZ  
> tBodyAccJerk-XYZ  
> tBodyGyro-XYZ  
> tBodyGyroJerk-XYZ  
> tBodyAccMag  
> tGravityAccMag  
> tBodyAccJerkMag  
> tBodyGyroMag  
> tBodyGyroJerkMag  
> fBodyAcc-XYZ  
> fBodyAccJerk-XYZ  
> fBodyGyro-XYZ  
> fBodyAccMag  
> fBodyAccJerkMag  
> fBodyGyroMag  
> fBodyGyroJerkMag  
> 
> The set of variables that were estimated from these signals are: 
> 
> mean(): Mean value  
> std(): Standard deviation  
> mad(): Median absolute deviation   
> max(): Largest value in array  
> min(): Smallest value in array  
> sma(): Signal magnitude area  
> energy(): Energy measure. Sum of the squares divided by the number of values.   
> iqr(): Interquartile range   
> entropy(): Signal entropy  
> arCoeff(): Autorregresion coefficients with Burg order equal to 4  
> correlation(): correlation coefficient between two signals  
> maxInds(): index of the frequency component with largest magnitude  
> meanFreq(): Weighted average of the frequency components to obtain a mean frequency  
> skewness(): skewness of the frequency domain signal   
> kurtosis(): kurtosis of the frequency domain signal   
> bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.  
> angle(): Angle between to vectors.  
> 
> Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:
> 
> gravityMean  
> tBodyAccMean  
> tBodyAccJerkMean  
> tBodyGyroMean  
> tBodyGyroJerkMean  
