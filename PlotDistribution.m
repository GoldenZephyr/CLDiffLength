clear
clf
cd './output'
ls
warning('off','MATLAB:Axes:NegativeDataInLogAxis')

%  ------------------------------------------------------------------------
%% Setting to change
%  ------------------------------------------------------------------------

FileExtension = '.CSV'; %Extension for type of file
%OutputDirectory = 'H:\MyDocs\Completed Matlab Programs\3D Fits\Output';
xmax = 25; %how far from zero the graph should show


apostrophe = {''''};
comma = {','};
%  ------------------------------------------------------------------------
%% Set Paths -- Must be changed when file is moved
%  ------------------------------------------------------------------------

mainpath = 'H:\MyDocs\Completed Matlab Programs\3D Fits\'; %This path needs to be changed every time the file is moved

%addpath([mainpath '/Images/']);
addpath([mainpath '/Output/']);
addpath([mainpath '/subfunctions/']);

%  ------------------------------------------------------------------------
%% Sets the order for colors of the lines
%  ------------------------------------------------------------------------

color = ['r  ';'g  ';'c  ';'m  ';'b  ';'y  ';'k  ';'r--';'g--';'b--';'c--';'m--';'y--';'k--';'r*-';'g*-';'b*-';'c*-';'m*-';'y*-';'k*-'];
%  ------------------------------------------------------------------------
%% Asks for user input about files to load
%  ------------------------------------------------------------------------
for k = 1:100
    File2Load{k} = input('Enter Desired File to Graph: ', 's');
    legendEntryCell{k} = strcat(apostrophe, File2Load{k}, apostrophe, comma);
    legendEntry(k) = legendEntryCell{1,k};
    
    
    if strcmpi(File2Load(k), 'none') || strcmpi(File2Load(k), 'stop') || strcmpi(File2Load(k), 'done')|| strcmpi(File2Load(k), 'leave')|| strcmpi(File2Load(k), 'enough')|| strcmpi(File2Load(k), 'complete')|| strcmpi(File2Load(k), 'finished')|| strcmpi(File2Load(k), 'graph')|| strcmpi(File2Load(k), 'no')|| strcmpi(File2Load(k), '')|| strcmpi(File2Load(k), 'go'), break,end
    File2Load{k} = [File2Load{k} FileExtension];
end

for p = 1:length(File2Load)-1
   Line(p,:,:) = importdata(File2Load{p}, ',');
end
legendEntry = cell2mat(legendEntry(1:length(File2Load)-1));
apostrophe = cell2mat(apostrophe);
comma = cell2mat(comma);
%  ------------------------------------------------------------------------
%% Graphs the data
%  ------------------------------------------------------------------------
figure(1)

for M = 1:length(File2Load)-1
    X = Line(M,1:end,1);
    Y = Line(M,1:end,2);
    semilogy(X,Y,color(M,1:end))
    hold('on');
end

%  ------------------------------------------------------------------------
%% Puts the Legend Entries together
%  ------------------------------------------------------------------------
LegendText = '';
for N = 1:length(File2Load)-1
   LegendText = [LegendText legendEntry(N)]; 
end
%  ------------------------------------------------------------------------
%% Labels the plot
%  ------------------------------------------------------------------------

xlabel('Position (\mum)','FontSize',20,'FontWeight','b') 
xmin = 0; 
xlim([xmin xmax])
ylabel('Intensity (Arb. units)','FontSize',20,'FontWeight','b')
ymin = 1e-3; 
ymax = 1; 
ylim([ymin ymax])
set(gca,'FontSize',16,'fontWeight','b'); 
set(gca,'XMinorGrid','off','YMinorGrid','off')

str = ['legend(' legendEntry apostrophe 'Location' apostrophe comma apostrophe 'NorthEast' apostrophe ')'];
eval (str)

cd ..




