%% Master run script to analyze the data that comes out of the code from Caccavano et al., 2020

% Select folders containing folders of each day
[ShamPath] = uigetdir;
Shamfolders = dir(ShamPath);
[TBIPath] = uigetdir;
TBIfolders = dir(TBIPath);

%% import the data
[ShamData,TBIData] = ImportMatlab(Shamfolders,TBIfolders);

%% Analyze LTP
[ShamSpreadLFP,TBISpreadLFP] = SpreadLTP(ShamData,TBIData);

%% write LFP to excel
ShamSpreadLFPTable = array2table(ShamSpreadLFP);
writetable(ShamSpreadLFPTable,'ShamSpreadLFP.xls');

TBISpreadLFPTable = array2table(TBISpreadLFP);
writetable(TBISpreadLFPTable,'HFHISpreadLFP.xls');
%% Gather indices for kept ROI and exclude slices with less than 3 ROIs
[ShamKeptROI,TBIKeptROI] = FindKeptROI(ShamData,TBIData);

%% Exclude sessions with less than 3 ROIs
[ShamE,TBIE] = ExcludeSlice(ShamData,ShamKeptROI,TBIData,TBIKeptROI);

%% Gather event stats
[ShamSliceMaster,TBISliceMaster,ShamKeptROI,TBIKeptROI,ShamStimCDF,TBIStimCDF,ShamCellCDF,TBICellCDF,ShamCorr,TBICorr] = FullSummaryStats(ShamE,TBIE);

%% Write summary event stats to excel
ExcelWrite(ShamSliceMaster,'Sham')
ExcelWrite(TBISliceMaster,'HFHI')

for i = 2:10
     writematrix(ShamCorr{i,1},'ShamCorr.xlsx','Sheet',i);
     writematrix(TBICorr{i,1},'TBICorr.xlsx','Sheet',i);
end

%% Normalize interpolated calcium above 4 STD threshold
[ShamFullAboveThresh, TBIFullAboveThresh] = FullThresholdNormalization(ShamE,TBIE,ShamKeptROI,TBIKeptROI);

%% Gather activity in 10 millisecond epochs around minima after stim
TimeWindow = 20; % 2000 hz sampling rate so 20 samples is 10 ms 
[ShamBeforeEvents,ShamMinEvents,ShamAfterEvents,ShamMinTime,ShamPower,ShamBeforeSim,ShamMinSim,ShamAfterSim,ShamCorr,ShamCorrVec,ShamAvMax,ShamAvMin,ShamCrossCorr,ShamLags,ShamBeforeROI,ShamMinROI,ShamAfterROI,ShamMinRange,ShamMaxRange,ShamAfterMax] = StimNetActivity(ShamE,ShamFullAboveThresh,ShamKeptROI,TimeWindow);
[TBIBeforeEvents,TBIMinEvents,TBIAfterEvents,TBIMinTime,TBIPower,TBIBeforeSim,TBIMinSim,TBIAfterSim,TBICorr,TBICorrVec,TBIAvMax,TBIAvMin,TBICrossCorr,TBILags,TBIBeforeROI,TBIMinROI,TBIAfterROI,TBIMinRange,TBIMaxRange,TBIAfterMax] = StimNetActivity(TBIE,TBIFullAboveThresh,TBIKeptROI,TimeWindow);

%% Write data to excel files 
writematrix(TBIMinTime,'HFHIMinTime.xlsx');
writematrix(ShamMinTime,'ShamMinTime.xlsx');
writematrix(TBILags{1,1}{4,1}{1,1},'CrossCorrLags.xlsx');

writematrix(ShamBeforeROI,'ShamBeforeROI.xlsx');
writematrix(ShamMinROI,'ShamMinROI.xlsx');
writematrix(ShamAfterROI,'ShamAfterROI.xlsx');

writematrix(TBIBeforeROI,'HFHIBeforeROI.xlsx');
writematrix(TBIMinROI,'HFHIMinROI.xlsx');
writematrix(TBIAfterROI,'HFHIAfterROI.xlsx');

for i = 2:10
    writematrix(ShamBeforeEvents{i,1},'ShamBeforeEvents.xlsx','Sheet',i);
    writematrix(ShamMinEvents{i,1},'ShamMinEvents.xlsx','Sheet',i);
    writematrix(ShamAfterEvents{i,1},'ShamAfterEvents.xlsx','Sheet',i);
    writematrix(TBIBeforeEvents{i,1},'HFHIBeforeEvents.xlsx','Sheet',i);
    writematrix(TBIMinEvents{i,1},'HFHIMinEvents.xlsx','Sheet',i);
    writematrix(TBIAfterEvents{i,1},'HFHIAfterEvents.xlsx','Sheet',i);
    writematrix(ShamCorrVec{i,1},'ShamCorr.xlsx','Sheet',i);
    writematrix(TBICorrVec{i,1},'HFHICorr.xlsx','Sheet',i);
    writematrix(ShamPower{i,1},'ShamPower.xlsx','Sheet',i);
    writematrix(TBIPower{i,1},'HFHIPower.xlsx','Sheet',i);
    writematrix(ShamBeforeSim{i,1},'ShamBeforeSim.xlsx','Sheet',i);
    writematrix(ShamMinSim{i,1},'ShamMinSim.xlsx','Sheet',i);
    writematrix(ShamAfterSim{i,1},'ShamAfterSim.xlsx','Sheet',i);
    writematrix(TBIBeforeSim{i,1},'HFHIBeforeSim.xlsx','Sheet',i);
    writematrix(TBIMinSim{i,1},'HFHIMinSim.xlsx','Sheet',i);
    writematrix(TBIAfterSim{i,1},'HFHIAfterSim.xlsx','Sheet',i);
    writecell(ShamAvMax{i,1},'ShamAvMax.xlsx','Sheet',i);
    writecell(ShamAvMin{i,1},'ShamAvMin.xlsx','Sheet',i);
    writecell(TBIAvMax{i,1},'HFHIAvMax.xlsx','Sheet',i);
    writecell(TBIAvMin{i,1},'HFHIAvMin.xlsx','Sheet',i);
    writematrix(ShamCrossCorr{i,1},'ShamCrossCor.xlsx','Sheet',i);
    writematrix(TBICrossCorr{i,1},'HFHICrossCor.xlsx','Sheet',i);

end

%% Generate shuffled dataset
[ShamShufBeforeSim,ShamShufAfterSim,ShamShufMinSim,ShamShufBeforeEvents,ShamShufAfterEvents,ShamShufMinEvents] = ShuffleData(ShamFullAboveThresh, ShamMinRange,ShamMaxRange,ShamAfterMax,ShamE,ShamKeptROI);
[TBIShufBeforeSim,TBIShufAfterSim,TBIShufMinSim,TBIShufBeforeEvents,TBIShufAfterEvents,TBIShufMinEvents] = ShuffleData(TBIFullAboveThresh, TBIMinRange,TBIMaxRange,TBIAfterMax,TBIE,TBIKeptROI);

%% Analyze the post stim activity periods
[ShamShufMinSimVec, ShamShufBeforeSimVec,ShamShufAfterSimVec,ShamShufMinEventsVec,ShamShufBeforeEventsVec,ShamShufAfterEventsVec,ShamShufMinLEventsVec,ShamShufBeforeLEventsVec,ShamShufAfterLEventsVec,ShamShufMinSimSTD,ShamShufAfterSimSTD,ShamShufBeforeSimSTD] = getShuffleData(ShamShufMinSim,ShamShufBeforeSim,ShamShufAfterSim,ShamShufMinEvents,ShamShufAfterEvents,ShamShufBeforeEvents);
[TBIShufMinSimVec, TBIShufBeforeSimVec,TBIShufAfterSimVec,TBIShufMinEventsVec,TBIShufBeforeEventsVec,TBIShufAfterEventsVec,TBIShufMinLEventsVec,TBIShufBeforeLEventsVec,TBIShufAfterLEventsVec,TBIShufMinSimSTD,TBIShufAfterSimSTD,TBIShufBeforeSimSTD] = getShuffleData(TBIShufMinSim,TBIShufBeforeSim,TBIShufAfterSim,TBIShufMinEvents,TBIShufAfterEvents,TBIShufBeforeEvents);

%% Write data to excel
writematrix(ShamShufMinSimVec,'ShamShufMinSim.xlsx');
writematrix(ShamShufBeforeSimVec,'ShamShufBeforeSim.xlsx');
writematrix(ShamShufAfterSimVec,'ShamShufAfterSim.xlsx');
writematrix(ShamShufMinEventsVec,'ShamShufMinEvents.xlsx');
writematrix(ShamShufBeforeEventsVec,'ShamShufBeforeEvents.xlsx');
writematrix(ShamShufAfterEventsVec,'ShamShufAfterEvents.xlsx');


writematrix(TBIShufMinSimVec,'HFHIShufMinSim.xlsx');
writematrix(TBIShufBeforeSimVec,'HFHIShufBeforeSim.xlsx');
writematrix(TBIShufAfterSimVec,'HFHIShufAfterSim.xlsx');
writematrix(TBIShufMinEventsVec,'HFHIShufMinEvents.xlsx');
writematrix(TBIShufBeforeEventsVec,'HFHIShufBeforeEvents.xlsx');
writematrix(TBIShufAfterEventsVec,'HFHIShufAfterEvents.xlsx');

for i = 1:length(ShamShufMinLEventsVec)
    writematrix(ShamShufMinLEventsVec{i,1},'ShamShufMinLTPEvents.xlsx','Sheet',i);
    writematrix(ShamShufBeforeLEventsVec{i,1},'ShamShufBeforeLTPEvents.xlsx','Sheet',i);
    writematrix(ShamShufAfterLEventsVec{i,1},'ShamShufAfterLTPEvents.xlsx','Sheet',i);
    writematrix(TBIShufMinLEventsVec{i,1},'HFHIShufMinLTPEvents.xlsx','Sheet',i);
    writematrix(TBIShufBeforeLEventsVec{i,1},'HFHIShufBeforeLTPEvents.xlsx','Sheet',i);
    writematrix(TBIShufAfterLEventsVec{i,1},'HFHIShufAfterLTPEvents.xlsx','Sheet',i);
end

ShamMinSimCell = cell2mat(ShamMinSim);
ShamMinSimMat = reshape(ShamMinSimCell,[],[9]);
ShamBeforeSimCell = cell2mat(ShamBeforeSim);
ShamBeforeSimMat = reshape(ShamBeforeSimCell,[],[9]);
ShamAfterSimCell = cell2mat(ShamAfterSim);
ShamAfterSimMat = reshape(ShamAfterSimCell,[],[9]);

TBIMinSimCell = cell2mat(TBIMinSim);
TBIMinSimMat = reshape(TBIMinSimCell,[],[9]);
TBIBeforeSimCell = cell2mat(TBIBeforeSim);
TBIBeforeSimMat = reshape(TBIBeforeSimCell,[],[9]);
TBIAfterSimCell = cell2mat(TBIAfterSim);
TBIAfterSimMat = reshape(TBIAfterSimCell,[],[9]);

ShamMinSimZ = (ShamMinSimMat-ShamShufMinSimVec(:,2:10))./ShamShufMinSimSTD(:,2:10);
ShamBeforeSimZ = (ShamBeforeSimMat-ShamShufBeforeSimVec(:,2:10))./ShamShufBeforeSimSTD(:,2:10);
ShamAfterSimZ = (ShamAfterSimMat-ShamShufAfterSimVec(:,2:10))./ShamShufAfterSimSTD(:,2:10);


TBIMinSimZ = (TBIMinSimMat-TBIShufMinSimVec(:,2:10))./TBIShufMinSimSTD(:,2:10);
TBIBeforeSimZ = (TBIBeforeSimMat-TBIShufBeforeSimVec(:,2:10))./TBIShufBeforeSimSTD(:,2:10);
TBIAfterSimZ = (TBIAfterSimMat-TBIShufAfterSimVec(:,2:10))./TBIShufAfterSimSTD(:,2:10);

writematrix(ShamMinSimZ,'ShamMinSimZ.xlsx');
writematrix(ShamBeforeSimZ,'ShamBeforeSimZ.xlsx');
writematrix(ShamAfterSimZ,'ShamAfterSimZ.xlsx');

writematrix(TBIMinSimZ,'HFHIMinSimZ.xlsx');
writematrix(TBIBeforeSimZ,'HFHIBeforeSimZ.xlsx');
writematrix(TBIAfterSimZ,'HFHIAfterSimZ.xlsx');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

