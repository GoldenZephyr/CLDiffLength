% pvec - parameter vector [ L V Zo A]
% M - matrix of most recent 10 parameters [phi ; L ; V ; Zo ; A]
% phi - squarred error vector (evec.*evec)
% evec - error vector
% L - diffusion length in meters
% V - S/D in 1/sec
% Zo - penetration depth of electon beam for model
% A - Amplitude of model

% FIT - is the final matrix that contains the data for each of the fits
% Lfit - temporary vector to save corresponding final values for L
% Vfit - same - for V
% Afit - same for A
% phifit - same for phi

% Dvec - vector of with all data points recorded
% dvec - vector in use for fitting of current data set

% Xvec - position vector of all the x-values
% xvec - position vector in use for fitting current data set

% Uest - Full length vector of fitted values with current parameters
% uest - vector of fitted values cut to desird length

% UpL - vector of partial derrivatives with respect to L
% UpV - wrt V
% UpZ - wrt Z
% UpA - wrt A

% Ln - normalized vector of partial derrivatives with respect to L
% Vn - wrt V
% Zn - wrt Z
% An - wrt A
% En - normalized error vector

% grad - gradient vector with the four paramters
% Ngrad - normalized gradient vector

% first_data_point_2_use - # of data points moving away from the source to skip
% number_of_data_points_2_use  - # of data points to be used in the fitting of the model

% M - Matrix that contains the last 10 values throught the iteration
%     process for [phi pvec(1) pvec(2) pvec(3) pvec(4)  phistep ]
% cc - is the percentage of change in each paramter of pvec allowed to
%      determine convergence

% gM - AMatrix of 4 colums consiting of the normalized partials derivatives
%      for UpL,UpV,UpZ,UpA

% LMA - Levenberg-Marquardt-Algorithm step direction

% stepvec - vector used to gage a the best next step between the max and
%           min of the step vector
% stepVecVariance - the amount that will be used in varying phistep (as a
%                   percentage) when creating the next 'stepvec'
% stepvec_start - used to keep track of the initial stepvec so that if
%                 max(stepvec) is greater than '1' stepvec will be reset
%                 to 'stepvec_start'

% fitcount - the number of times that the fitting will be performed - the
%            fit with the lowest phi value in all this will be used.
% fitmat - matrix used to store the fitted values for each iteration of
%          fitcount
% pvec - parameter vector [ L V Zo A]
% M - matrix of most recent 10 parameters [phi ; L ; V ; Zo ; A]
% phi - squarred error vector (evec.*evec)
% evec - error vector

% Dvec - vector of with all data points recorded
% dvec - vector in use for fitting of current data set

% Xvec - position vector of all the x-values
% xvec - position vector in use for fitting current data set

% Uest - Full length vector of fitted values with current parameters
% uest - vector of fitted values cut to desird length

% UpL - vector of partial derrivatives with respect to L
% UpV - wrt V
% UpZ - wrt Z
% UpA - wrt A

% Ln - normalized vector of partial derrivatives with respect to L
% Vn - wrt V
% Zn - wrt Z
% An - wrt A
% En - normalized error vector

% grad - gradient vector with the four paramter
% Ngrad - normalized gradient vector

% dp2skip - # of data points moving away from the source to skip
% dp2use  - # of data points to be used in the fitting of the model

% M - Matrix that contains the last 10 values throught the iteration
%     process for [phi pvec(1) pvec(2) pvec(3) pvec(4)  phistep ]
% cc - is the percentage of change in each paramter of pvec allowed to
%      determine convergence

% gM - AMatrix of 4 colums consiting of the normalized partials derivatives
%      for UpL,UpV,UpZ,UpA

% LMA - Levenberg-Marquardt-Algorithm step direction

% stepvec - vector used to gage a the best next step between the max and
%           min of the step vector
% stepVecVariance - the amount that will be used in varying phistep (as a
%                   percentage) when creating the next 'stepvec'
% stepvec_start - used to keep track of the initial stepvec so that if
%                 max(stepvec) is greater than '1' stepvec will be reset
%                 to 'stepvec_start'