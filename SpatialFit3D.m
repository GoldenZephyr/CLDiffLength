ls "./images"
clear
clf reset
base = pwd;
addpath(pwd)
addpath([pwd "/subfunctions/"])
cd "images"
%  -------------------------------------------------------------------------
%% Values to be changed in the code
%  -------------------------------------------------------------------------

Points2Roll = 5;
Znaught = .5; %Penetration Depth in Microns
InitialDiffusionLength = 2.5; %Diffusion Length for first fit iteration                       %%%%
InitialRecombinationVelocity = 10; %RecombinationVelocity/Diffusivity for first fit iteration NOTE: although the variable is named InitialRecombinationVelocity (and later Recombination Velocity) this term is actually the Recombination Velocity diveded by the Diffusivity
InitialAmplitude = 1; %Amplitude for first fit iteration                                      %%%%
FileExtension = '.png'; %Extension for type of file
directory = pwd;
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

%mainpath = pwd; %This path needs to be changed every time the file is moved
%images = [mainpath '/images/'];
%output = [mainpath '/output/'];
%subfunctions '/subfunctions/'];

%addpath([pwd '/images/']);
%addpath([pwd '/output/']);
%addpath([pwd '/subfunctions/']);


%  ------------------------------------------------------------------------
%% Gather User Input (file names)
%  ------------------------------------------------------------------------

ImageFilename = input('Load which image file? ', 's');
plotname = ImageFilename;
%ImageFilename = [ImageFilename FileExtension];


BackgroundFile = input('Name of Background File: ','s');%Use for manual input of background file name
    
   if strcmpi(BackgroundFile, 'none') || strcmpi(BackgroundFile, 'no') ||strcmpi(BackgroundFile,'') %If a background image file was not chosen, bgSubration is set to 0
        bgSubtraction = 0;
   else
        bgSubtraction = 1;
        %BackgroundFile = [BackgroundFile FileExtension];
   end
   
OutputFilename = input('What should the output file be named? ','s');
savename = [base '/output/' OutputFilename FileExtension];
OutputFilename = [OutputFilename OutputExtension];
   

%  ------------------------------------------------------------------------
%% Calls the function to load and cut the data
%  ------------------------------------------------------------------------
[CutImage,startPixel] = LoadAndCut(ImageFilename, BackgroundFile, bgSubtraction);

%extra routine to plot start point on original image
fig4 = figure(4);
hold on;
dataPic = imread(ImageFilename);
imshow(dataPic);
[tmp,x] = max(mean(dataPic));
y = startPixel;
y2 = startPixel + length(CutImage(1,1:end));

r = 5;
t = linspace(0,2*pi,100)'; 
circsx = r.*cos(t) + x; 
circsy = r.*sin(t) + y; 
plot(circsx,circsy);

circsy2 = r.*sin(t) + y2
plot(circsx,circsy2);
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

XLength = 0:Length+ceil((Points2Roll+1)/2); %XLength is the Distance along the line scan
XLength = XLength+startPixel;
XLength = XLength*.4;
XLength = XLength';

XWidth = 0:Width-1; %XWidth is the pixel location for data points that are used for the fit, which are perpendicular to the line
XWidth = XWidth*.4;
%  ------------------------------------------------------------------------
%% Sends the Rolling Average Data to the fit program, and saves the output
%  to a file
%  ------------------------------------------------------------------------

DiffusionLength=zeros(length(RollingAverage(:,1)),1)*NaN; % Allocates size of the fit variables
RecombinationVelocity=zeros(length(RollingAverage(:,1)),1)*NaN;
Amplitude=zeros(length(RollingAverage(:,1)),1)*NaN;
phi=zeros(length(RollingAverage(:,1)),1)*NaN;
b=zeros(length(RollingAverage(:,1)),1)*NaN;
time=zeros(length(RollingAverage(:,1)),1)*NaN;
outData=zeros(length(RollingAverage(:,1)),3)*NaN;


[DiffusionLength(1),RecombinationVelocity(1),Amplitude(1),phi(1)] = LMA_LVA_v1(... % Does a preliminary fit with the specified start values. The fit results are stored in the first position of the fit vectors. 
    InitialDiffusionLength, InitialRecombinationVelocity, Znaught, InitialAmplitude,...
    XWidth(FirstDatapoint:LastDatapoint),RollingAverage(1,FirstDatapoint:LastDatapoint), plotname, savename);


outData(1,1) = XLength(ceil((Points2Roll+1)/2));
outData(1,2) = DiffusionLength(1);
outData(1,3) = Intensity(ceil((Points2Roll+1)/2));
%outData(1,4) = time(1);

dlmwrite([base  '/output/' OutputFilename], ['"x"' '"LD"' '"Int"'], ',') %Sets up the output .CSV file
dlmwrite([base '/output/' OutputFilename], outData(1,1:3), '-append')

%-------------------%
% Sets up plot
%-------------------%

figure6 = figure(6);
plot(XLength(ceil((Points2Roll+1)/2)),DiffusionLength(1,1), '.');
hold on;
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
    plot(XLength(ceil((Points2Roll+1)/2)+k-1),DiffusionLength(k,1), '.');
   
    outData(k,1) = XLength(ceil((Points2Roll+1)/2)+k-1); % Puts the desired output information into the outData matrix, which is then written to the output file.
    outData(k,2) = DiffusionLength(k);
    outData(k,3) = Intensity(ceil((Points2Roll+1)/2)+k-1);
    outData(k,4) = time(k);
    
    dlmwrite([base '/output/' OutputFilename], outData(k,1:3), '-append')
    



end

cd ".."
