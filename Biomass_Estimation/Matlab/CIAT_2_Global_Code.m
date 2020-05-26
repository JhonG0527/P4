



% CIAT Proyect Final Code
% Carlos Andres Devia
% 11.12.2017

close all
clear all
clc

scrsz = get(0,'ScreenSize');
Tam_Fig = [scrsz(3)/10 scrsz(4)/10 8*scrsz(3)/10 7*scrsz(4)/10];

% .........................................................................
% .........................................................................
% Data Labels

% First read the data
Photo_GPS_Data = cell(1,4);
% This cell will contain in each row the label data of a photo, the
% information is the following:

% Row 1 -> Name of the photo
% Row 2 -> Longitude 
% Row 3 -> Latitude
% Row 4 -> Altitude


CIAT_2_Data_Labels_6


% Now the cell 'Photo_GPS_Data' has the GPS information of the photos, next
% it is necessary to read the data of the photographs, this step also
% removes the empty photos, the complete data will be stored in a new cell
% called 'Complete_Data', it will have the same information of the cell 
% 'Photo_GPS_Data' but will have a new row in which the matrix with the
% vegetative indices will be stored

Complete_Data = cell(1,7);
CIAT_2_Read_Data

% Now the cell 'Complete_Data' has the information of the photos that will
% be used in the processing, the first four rows are the same as 
% 'Photo_GPS_Data' and for now the last row is empty but it will contain
% the matrix with the vegetative index information. For that the next code
% is used:

CIAT_2_Position
CIAT_2_Image_Processing








































