clc
clear all
close all
clf reset
%  ------------------------------------------------------------------------
%% Runs a fit to find the diffusion length of a bulk sample. 
%  Specify the desired file, cut the line to the desired length, and the
%  fitting fucntion will then find the diffusion length. This function also
%  outputs a .CSV file with the average intensity as a function of distance
%  from the electron beam (the data vector). This .CSV file is used to run
%  the PlotDistribution function.

%  Required Subfunctions: LoadandCut,Norm4Fit, LMA_LVA_v1, as well as the
%  required Subfunctions for LMA_LVA_v1. These should all be in the
%  subfunctions folder
%  ------------------------------------------------------------------------

% ------------------------------------------------------------------------
%% Values to be changed in the code
% -------------------------------------------------------------------------
Znaught = .5; %Penetration Depth in Microns
InitialDiffusionLength = 2.5; %Diffusion Length for first fit iteration                       %%%%
InitialRecombinationVelocity = 10; %RecombinationVelocity/Diffusivity for first fit iteration NOTE: although the variable is named InitialRecombinationVelocity (and later Recombination Velocity) this term is actually the Recombination Velocity diveded by the Diffusivity
InitialAmplitude = 1; %Amplitude for first fit iteration                                      %%%%
FileExtension = '.png'; %Extension for type of file
OutputDirectory = 'H:\MyDocs\Completed Matlab Programs\3D Fits\Output\';
FirstDatapoint = 2; %Set the first data point to be used in MICRONS
LastDatapoint = 20; %Set the last data point to be used in MICRONS
PixelResolution = .4; %current accepted pixel resolution is .4 microns per pixel
OutputExtension = '.CSV';

%--------------------------------------------------------------------------

FirstDatapoint = round(FirstDatapoint/PixelResolution);
LastDatapoint = round(LastDatapoint/PixelResolution);

%  -----------------------------------------------------------------------
%% Sets Paths -- Must be changed if file is moved
%  -----------------------------------------------------------------------

mainpath = 'H:\MyDocs\Completed Matlab Programs\3D Fits\'; %This path needs to be changed every time the file is moved

addpath([mainpath '/Images/']);
addpath([mainpath '/Output/']);
addpath([mainpath '/subfunctions/']);


%  ------------------------------------------------------------------------
%% Gather User Input (file names)
%  ------------------------------------------------------------------------

ImageFilename = input('Load which image file? ', 's');
plotname = ImageFilename;
ImageFilename = [ImageFilename FileExtension];


BackgroundFile = input('Name of Background File: ','s');%Use for manual input of background file name
    
   if strcmpi(BackgroundFile, 'none') || strcmpi(BackgroundFile, 'no') ||strcmpi(BackgroundFile,'') %If a background image file was not chosen, bgSubration is set to 0
        bgSubtraction = 0;
   else
        bgSubtraction = 1;
        BackgroundFile = [BackgroundFile FileExtension];
   end
   
OutputFilename = input('What should the output file be named? ','s');
OutputFilename = [OutputFilename FileExtension];

savename = [OutputDirectory OutputFilename];
   
%  ------------------------------------------------------------------------
%% Calls the function to load and cut the data
%  ------------------------------------------------------------------------
[CutImage] = LoadAndCut(ImageFilename, BackgroundFile, bgSubtraction);



%  ------------------------------------------------------------------------
%% Normalizes data (also does more background subtraction)
%  ------------------------------------------------------------------------

NormCut = Norm4fit(CutImage);

%  ------------------------------------------------------------------------
%% Takes the average of the cut data
%  ------------------------------------------------------------------------
NormCut = NormCut';
DataVector = mean(NormCut);

%  ------------------------------------------------------------------------
%% Creates the X Vector
%  ------------------------------------------------------------------------

XWidth = 1:length(DataVector);
XWidth = .4*XWidth;

%  ------------------------------------------------------------------------
%% Saves the DataVector and X values information 
%  to be used in PlotDistribution
%  ------------------------------------------------------------------------
HorizontalData(:,1) = XWidth';
HorizontalData(:,2) = DataVector';
dlmwrite([OutputDirectory plotname OutputExtension], HorizontalData(:,1:2), ',') %Sets up the output .CSV file


%  ------------------------------------------------------------------------
%% Clears variables prior to fit
%  ------------------------------------------------------------------------
clear CutImage

%  ------------------------------------------------------------------------
%% Does the fit
%  ------------------------------------------------------------------------


[DiffusionLength,RecombinationVelocity,Amplitude,phi] = LMA_LVA_v1(... 
    InitialDiffusionLength, InitialRecombinationVelocity, Znaught, InitialAmplitude,...
    XWidth(FirstDatapoint:LastDatapoint),DataVector(1,FirstDatapoint:LastDatapoint), plotname, savename);
