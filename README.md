Mein first Project
My First Data Projects – A Journey into Data Science

These are two of my first projects in which I worked extensively with real-world data. They not only allowed me to dive into signal processing and statistical analysis but also sparked my passion for data science from the very start.

Project 1: Electrophysiological Data Preprocessing for EMG Signals

This project demonstrates the step-by-step processing of electromyographic (EMG) data recorded during a squat exercise. The code shows how to transform raw EMG signals into meaningful information.

Overview of the Code:

1. Initialization and Data Loading:
   - The workspace is cleared using `clc, clear, close all`.
   - Data is loaded from a file (`Squat1.mat`), which contains raw EMG data from eight channels corresponding to muscles on the left and right sides.

2. **Plotting the Raw Data:**
   - Two figures are created:
     - Raw Data Figure:  
       The data is plotted in a 4×2 grid of subplots. The left column contains signals from the left side (e.g., *M. Gastrocnemius medialis (left)*) and the right column contains the corresponding signals from the right side.
     - Each subplot includes a title and axis labels (Time in ms, Voltage in mV).

3. Full-Wave Rectification:
   - The raw data is converted to its absolute values using `abs(data)`. This step ensures that all the signal peaks become visible irrespective of the polarity.
   - A new figure displays the rectified data for visual verification.

4. Digital Filtering:
   - A 2nd-order Butterworth lowpass filter is applied. Given that human movement signals rarely exceed 10 Hz, the filter has a cutoff frequency of 10 Hz. The sample frequency is set to 1000 Hz.
   - The filter coefficients are computed with:  
     ```matlab
     [b,a] = butter(order, cutoff/(freq/2), 'low');
     ```
     and applied using `filter(b,a,data_abs)`.
   - The filtered data is plotted in another figure.

5. Data Smoothing:
   - A moving average is computed using `movmean(data_filt, window_length)` with a window length of 100 frames to smooth the data.
   - A separate figure shows the smoothed data.

6. Peak Detection:
   - Using MATLAB’s `findpeaks`, the code detects peaks in the smoothed data to identify moments of maximum muscle activation.
   - These peaks are overlaid on the plots (using red lines) for muscles like M. Rectus femoris and M. Biceps femoris.
   - A loop then plots the peaks for all muscles, allowing for side-by-side comparison of activation patterns.

7. Statistical Analysis:
   - Key statistical parameters (maximum, mean, standard deviation, and the integral via `trapz`) are computed for each muscle.
   - The results are pooled over different squat trials (Squat1 to Squat5, and Squat6 to Squat10) by summing the values and then dividing by the number of trials.
   - These aggregated results are visualized using bar charts with error bars representing the standard deviation.

Why It Matters:
This project illustrates how to preprocess raw EMG data—from initial visualization and rectification, through filtering and smoothing, to peak detection and statistical analysis. It provides a solid foundation for understanding muscle activation patterns during exercise and showcases a complete workflow from raw signal to actionable insights.

Project 2: Statistical Analysis and Correlation of Squat Data

In the second project, I extended my data analysis skills by performing statistical evaluations and correlation analyses on squat data. This project uses multiple datasets (from Squat1.mat to Squat10.mat) to derive and compare performance metrics.

Overview of the Code:

1. Pooling Statistical Parameters:
   - For each squat file (first Squat1 to Squat5), the code:
     - Loads the data and computes its absolute value.
     - Applies the same Butterworth lowpass filter as in Project 1.
     - For each of the 8 channels, calculates:
       - Maximum value (`max`)
       - Mean (`mean`)
       - Standard deviation (`std`)
       - Integral (using `trapz`)
     - These values are stored in a matrix and then summed into pooling variables.
   - After processing the files, the pooled values are divided by the number of files (5) to obtain overall averages for each muscle.

2. Visualization of Pooled Data:
   - Bar charts are created to display the aggregated maximum values for both left and right muscles.
   - Error bars based on the standard deviation are added to the plots.
   - A separate plot shows the integral of the signals for all muscles.

3. Correlation and Regression Analysis:
   - For each file (Squat1 to Squat10), the maximum and mean values are recalculated for each muscle.
   - For selected muscle groups on the left and right sides (e.g., M. Biceps femoris vs. M. Rectus femoris), the code:
     - Pools the data into separate matrices.
     - Computes the correlation coefficient using `corrcoef`.
     - Calculates a linear regression line via `polyfit` and `polyval`.
   - The correlation and regression are visualized using scatter plots with the regression line overlaid. The correlation coefficient is also displayed on the plots.

Why It Matters:
This project provides a comprehensive statistical analysis of muscle performance during squat exercises. By pooling data from multiple trials, calculating descriptive statistics, and performing correlation and regression analyses, I was able to evaluate the consistency and interdependence of muscle activation. These insights can help in understanding muscle coordination and overall performance in functional movements.

Final Thoughts

These two projects represent my very first forays into working with real-world data—specifically, electrophysiological signals and performance metrics from exercise. Through these projects, I not only learned how to process and analyze complex datasets but also fell in love with the potential of data science to uncover meaningful insights. Whether you're a recruiter, a fellow data enthusiast, or someone looking to collaborate, I invite you to explore my work further. 

Enjoy browsing through my projects—and perhaps consider hiring me for your next data challenge!



