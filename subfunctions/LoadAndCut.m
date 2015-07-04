function [CutImage,startPixel] = LoadAndCut( ImageFilename, BackgroundFilename, doBackgroundSubtraction)
%   LoadAndCut Loads and cuts the Image
%   Loads the image specified by user, runs background subtraction and cuts
%   the image to the desired length. Returns the cut image.

%  ------------------------------------------------------------------------
%% Loads Images and does background subtraction
%  ------------------------------------------------------------------------
if doBackgroundSubtraction ==1
    
    ImageFile = imread(ImageFilename);
    ImageFile = double(ImageFile);

    BackgroundFile = imread(BackgroundFilename);
    BackgroundFile = double(BackgroundFile);

    ImageFile = ImageFile-BackgroundFile;
    ImageFile = ImageFile';
else
    ImageFile = imread(ImageFilename);
    ImageFile = double(ImageFile);
    ImageFile = ImageFile';
end

%  ------------------------------------------------------------------------
%% Lets you cut the data as much as you want
%  ------------------------------------------------------------------------
startPixel = 0;

    
i = 1;
while i<2 %this loops allows you to continue cutting the edges of the data until the desired part is reached.
    startX = input('Start Point: ');
    endX = input('End Point: ');
    if isempty(startX) || isempty(endX)
       baseline = mean(ImageFile(1,:))
       cutoff = 5 * baseline
       [tmp,hotrow] = max(mean(ImageFile'));
       xi = find(ImageFile(hotrow,:)>cutoff,1)
       xf = find(ImageFile(hotrow,:)>cutoff,1,'last')
       ImageFile = ImageFile(:,xi:xf);
       startPixel = xi;
       
       break;
    end

    startPixel = startPixel + startX;
    ImageFile = ImageFile(:,startX:endX);
    
   
    
    
    again = input('Would you like to trim again? ','s');
    if strcmpi(again,'no') || strcmpi(again,'n')
        i = 2;
    end
end

%  ------------------------------------------------------------------------
%% Cuts the line in half
%  ------------------------------------------------------------------------
Xmax = input('\nEnter the number of pixels to the right of the peak to keep: ');
AVG = mean(ImageFile,2); % These lines of code checks to see if the number of pixels you want to keep is valid. If it is not, you can re-enter a different number
[Max, k] = max(AVG);
[c,v] = size(ImageFile)
while (Xmax > (c-k))
    Xmax = input('You chose too many pixels. Choose a new number: ');
end

[ImageFile] = CenterCut_v2(ImageFile,Xmax);
CutImage = ImageFile;

end

