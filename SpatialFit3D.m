clc
clear
clf reset
%  -------------------------------------------------------------------------
%% Values to be changed in the code
%  -------------------------------------------------------------------------

Points2Roll = 5;
Znaught = .5; %Penetration Depth in Microns
InitialDiffusionLength = 2.5; %Diffusion Length for first fit iteration                       %%%%
InitialRecombinationVelocity = 10; %RecombinationVelocity/Diffusivity for first fit iteration NOTE: although the variable is named InitialRecombinationVelocity (and later Recombination Velocity) this term is actually the Recombination Velocity diveded by the Diffusivity
InitialAmplitude = 1; %Amplitude for first fit iteration                                      %%%%
FileExtension = '.png'; %Extension for type of file
OutputDirectory = 'H:\MyDocs\Completed Matlab Programs\3D Fits\Output\';
OutputExtension = '.CSV'; %Change if another output format is necessary
FirstDatapoint = 2; %Set the first data point to be used in MICRONS
LastDatapoint = 15; %Set the last data point to be used in MICRONS
PixelResolution = .4; %current accepted pixel resolution is .4 microns per pixel

%--------------------------------------------------------------------------

FirstDatapoint = round(FirstDatapoint/PixelResolution);
LastDatapoint = round(LastDatapoint/PixelResolution);

%  ------------------------------------------------------------------------
%% Sets Paths -- Must be changed if file is moved
%  ------------------------------------------------------------------------

mainpath = 'H:\MyDocs\Completed Matlab Programs\3D Fits'; %This path needs to be changed every time the file is moved

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
savename = [OutputDirectory OutputFilename FileExtension];
OutputFilename = [OutputFilename OutputExtension];
   

%  ------------------------------------------------------------------------
%% Calls the function to load and cut the data
%  ------------------------------------------------------------------------
[CutImage] = LoadAndCut(ImageFilename, BackgroundFile, bgSubtraction);


%  ------------------------------------------------------------------------
%% Gets the intensity data from the cut image
%  ------------------------------------------------------------------------

Intensity = CutImage(1,1:end);



%  ------------------------------------------------------------------------
%% Normalizes data (also does more background subtraction)
%  ------------------------------------------------------------------------

CutImage = Norm4fit(CutImage);




%  ------------------------------------------------------------------------
%% Takes the Rolling average of points along the line
%  ------------------------------------------------------------------------

[RollingAverage] = RollAvg(CutImage, Points2Roll);
%  ------------------------------------------------------------------------
%% Generates the two different X vectors
%  ------------------------------------------------------------------------

[Length, Width] = size(RollingAverage);

XLength = 0:Length-1; %XLength is the Distance along the line scan
XLength = XLength*.4;
XLength = XLength';

XWidth = 0:Width-1; %XWidth is the pixel location for data points that are used for the fit, which are perpendicular to the line
XWidth = XWidth*.4;
%  ------------------------------------------------------------------------
%% Sends the Rolling Average Data to the fit program, and saves the output
%  to a file
%  ------------------------------------------------------------------------

DiffusionLength=zeros(length(RollingAverage(:,1)),1); % Allocates size of the fit variables
RecombinationVelocity=zeros(length(RollingAverage(:,1)),1);
Amplitude=zeros(length(RollingAverage(:,1)),1);
phi=zeros(length(RollingAverage(:,1)),1);
b=zeros(length(RollingAverage(:,1)),1);
time=zeros(length(RollingAverage(:,1)),1);
outData=zeros(length(RollingAverage(:,1)),4);


[DiffusionLength(1),RecombinationVelocity(1),Amplitude(1),phi(1)] = LMA_LVA_v1(... % Does a preliminary fit with the specified start values. The fit results are stored in the first position of the fit vectors. 
    InitialDiffusionLength, InitialRecombinationVelocity, Znaught, InitialAmplitude,...
    XWidth(FirstDatapoint:LastDatapoint),RollingAverage(1,FirstDatapoint:LastDatapoint), plotname, savename);


outData(1,1) = XLength(1);
outData(1,2) = DiffusionLength(1);
outData(1,3) = Intensity(1);
outData(1,4) = time(1);

dlmwrite([OutputDirectory OutputFilename], ['x' 'L'], ',') %Sets up the output .CSV file
dlmwrite([OutputDirectory OutputFilename], outData(1,1:4), '-append')

%-------------------%
% Sets up plot
%-------------------%

figure6 = figure(6);
plot(XLength(1),DiffusionLength(1,1), '.');
hold;
grid();
xlabel('Distance into line','VerticalAlignment','cap','HorizontalAlignment','center');
ylabel('Diffusion Length','Visible','off','HorizontalAlignment','center');

for k = 2:length(RollingAverage(:,1)) %This is the main fitting loop. The loop runs for every rolling average point along the scan. The initial fit values for the Kth fit are the best fit values for the (K-1)th fit, which greatly improves speed.
    tic
    [DiffusionLength(k),RecombinationVelocity(k),Amplitude(k),phi(k)] = LMA_LVA_v1(...
    DiffusionLength(k-1), RecombinationVelocity(1), Znaught, Amplitude(k-1),... % The RecombinationVelocity fit parameter that is sent to the fit function is NOT the best fit parameter of the previous iteration. That lead to a runaway S/D value, so the program will start with the same RecombinationVelocity value for each fit.  
    XWidth(FirstDatapoint:LastDatapoint),RollingAverage(k,FirstDatapoint:LastDatapoint), plotname, savename);

    time(k) = toc;
    display(time(k))
    
    figure(6);
    plot(XLength(k),DiffusionLength(k,1), '.');
   
    outData(k,1) = XLength(k); % Puts the desired output information into the outData matrix, which is then written to the output file.
    outData(k,2) = DiffusionLength(k);
    outData(k,3) = Intensity(k);
    outData(k,4) = time(k);
    
    dlmwrite([OutputDirectory OutputFilename], outData(k,1:4), '-append')
    



end

