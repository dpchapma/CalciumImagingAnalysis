%% Summary stats
% Script that generates summary stats of slices (number of cells, number of
% events, etc.)

function [ShamSliceMaster,TBISliceMaster,ShamKeptROI,TBIKeptROI,ShamStimCDF,TBIStimCDF, ShamCellCDF,TBICellCDF,ShamCorr,TBICorr] = FullSummaryStats(ShamData,TBIData)

Stimlevel = [0 2 3 4 6 8 -1 0 5 10]; % First 6 are Io curve and represent
for i = 1:length(ShamData)
    ShamSliceMaster{i,1}(:,1) = Stimlevel;
end

for i = 1:length(TBIData)
    TBISliceMaster{i,1}(:,1) = Stimlevel;
end

nBins    = 50;
nBinsIn  = linspace(0, 1, nBins)';

% Start by putting the stats into master arrays


% Sham
for i = 1:length(ShamSliceMaster) % Iterate across slices
    % Iterate across slice level and find means
    for d = 1:length(ShamSliceMaster{i,1}(:,1))
        % Find kept ROI and create index for it will use later for ensemble
        % analysis as well
        if isempty(ShamData{i,1}{d,1})
            ShamSliceMaster{i,1}(d,:) = nan;
            d = d + 1;
        else
            
            ShamKeptROI{i,1}{d,1} = find(~isnan(ShamData{i,1}{d,1}.Ca.nEvents));
            % Make dummy variable so it's easier to call for each metric
            KeptROI = find(~isnan(ShamData{i,1}{d,1}.Ca.nEvents));
            % Now find metrics in data struct and put them in slicemaster
            ShamSliceMaster{i,1}(d,4) = length(KeptROI);
            ShamSliceMaster{i,1}(d,5) = mean(ShamData{i,1}{d,1}.Ca.ampAve(KeptROI));
            ShamSliceMaster{i,1}(d,6) = nanmean(ShamData{i,1}{d,1}.Ca.IEIAve(KeptROI));
            ShamSliceMaster{i,1}(d,7) = mean(ShamData{i,1}{d,1}.Ca.durAve(KeptROI));
            ShamSliceMaster{i,1}(d,8) = mean(ShamData{i,1}{d,1}.Ca.frequency(KeptROI));
            ShamSliceMaster{i,1}(d,9) = mean(ShamData{i,1}{d,1}.Ca.nEvents(KeptROI));
            
            % Now we'll do stimulation/spont metrics
            % Add logic to make sure no stim trials are not included in this
            if d == 1
                ShamSliceMaster{i,1}(d,10:17) = nan;
            elseif d > 1
                ShamSliceMaster{i,1}(d,10) = nanmean(ShamData{i,1}{d,1}.Ca.stim.stim.nEvents(KeptROI));
                ShamSliceMaster{i,1}(d,11) = nanmean(ShamData{i,1}{d,1}.Ca.stim.stim.ampAve(KeptROI));
                ShamSliceMaster{i,1}(d,12) = nanmean(ShamData{i,1}{d,1}.Ca.stim.stim.durAve(KeptROI));
                ShamSliceMaster{i,1}(d,13) = nanmean(ShamData{i,1}{d,1}.Ca.stim.stim.frequency(KeptROI));
                ShamSliceMaster{i,1}(d,14) = nanmean(ShamData{i,1}{d,1}.Ca.stim.spont.nEvents(KeptROI));
                ShamSliceMaster{i,1}(d,15) = nanmean(ShamData{i,1}{d,1}.Ca.stim.spont.ampAve(KeptROI));
                ShamSliceMaster{i,1}(d,16) = nanmean(ShamData{i,1}{d,1}.Ca.stim.spont.durAve(KeptROI));
                ShamSliceMaster{i,1}(d,17) = nanmean(ShamData{i,1}{d,1}.Ca.stim.spont.frequency(KeptROI));
                StimCellDummy = cellfun(@isempty,ShamData{i,1}{d,1}.stim.Ca.evIndex);
                ShamSliceMaster{i,1}(d,18) = length(ShamData{i,1}{d,1}.stim.Ca.evIndex) - sum(StimCellDummy);
                

%                 ShamSliceMaster{i,1}(d,19) = ShamData{i,1}{d,1}.Ca.stim.corrVector;
%                 formatSpec = "ShamData{%d,1}{%d,1}.Ca.stim";
%                 A1 = i;
%                 A2 = d;
%                 str = sprintf(formatSpec,A1,A2)
                if isfield(ShamData{i,1}{d,1}.Ca.stim,'cdfF') == 1
                    ShamStimCDF{d,1}(i,:) = standardizeCDF(ShamData{i,1}{d,1}.Ca.stim.cdfX,ShamData{i,1}{d,1}.Ca.stim.cdfF,nBinsIn);
                else
                   continue
                end
                
                if isfield(ShamData{i,1}{d,1}.Ca.stim,'corrVector') == 1
                    disp('worked')
                    [f, x] = ecdf(ShamData{i,1}{d,1}.Ca.stim.corrVector);
                    ShamCellCDF{d,1}(i,:) = standardizeCDF(x,f,nBinsIn);
                    ShamCorr{d,1}(i,:) = mean(ShamData{i,1}{d,1}.Ca.stim.corrVector);
                else
                   continue
                end
                
                
            end
        end
    end
end

% Repeat for TBI
% TBICellCorr{i,1}(d,:) = NaN(1000);
% TBIStimCDF{i,1}(d,:) = NaN(1000);
% TBIStimCDFX{i,1}(d,:) = NaN(1000);


for i = 1:length(TBISliceMaster) % Iterate across slices
    % Iterate across slice level and find means
    for d = 1:length(TBISliceMaster{i,1}(:,1))
        % Find kept ROI and create index for it will use later for ensemble
        % analysis as well
        if isempty(TBIData{i,1}{d,1})
            TBISliceMaster{i,1}(d,:) = nan;
            d = d + 1;
        else
            
            TBIKeptROI{i,1}{d,1} = find(~isnan(TBIData{i,1}{d,1}.Ca.nEvents));
            % Make dummy variable so it's easier to call for each metric
            KeptROI = find(~isnan(TBIData{i,1}{d,1}.Ca.nEvents));
            % Now find metrics in data struct and put them in slicemaster
            TBISliceMaster{i,1}(d,4) = length(KeptROI);
            TBISliceMaster{i,1}(d,5) = mean(TBIData{i,1}{d,1}.Ca.ampAve(KeptROI));
            TBISliceMaster{i,1}(d,6) = nanmean(TBIData{i,1}{d,1}.Ca.IEIAve(KeptROI));
            TBISliceMaster{i,1}(d,7) = mean(TBIData{i,1}{d,1}.Ca.durAve(KeptROI));
            TBISliceMaster{i,1}(d,8) = mean(TBIData{i,1}{d,1}.Ca.frequency(KeptROI));
            TBISliceMaster{i,1}(d,9) = mean(TBIData{i,1}{d,1}.Ca.nEvents(KeptROI));
            % Now we'll do stimulation/spont metrics
            % Add logic to make sure no stim trials are not included in this
            if d == 1
                TBISliceMaster{i,1}(d,10:17) = nan;
            elseif d > 1
                TBISliceMaster{i,1}(d,10) = nanmean(TBIData{i,1}{d,1}.Ca.stim.stim.nEvents(KeptROI));
                TBISliceMaster{i,1}(d,11) = nanmean(TBIData{i,1}{d,1}.Ca.stim.stim.ampAve(KeptROI));
                TBISliceMaster{i,1}(d,12) = nanmean(TBIData{i,1}{d,1}.Ca.stim.stim.durAve(KeptROI));
                TBISliceMaster{i,1}(d,13) = nanmean(TBIData{i,1}{d,1}.Ca.stim.stim.frequency(KeptROI));
                TBISliceMaster{i,1}(d,14) = nanmean(TBIData{i,1}{d,1}.Ca.stim.spont.nEvents(KeptROI));
                TBISliceMaster{i,1}(d,15) = nanmean(TBIData{i,1}{d,1}.Ca.stim.spont.ampAve(KeptROI));
                TBISliceMaster{i,1}(d,16) = nanmean(TBIData{i,1}{d,1}.Ca.stim.spont.durAve(KeptROI));
                TBISliceMaster{i,1}(d,17) = nanmean(TBIData{i,1}{d,1}.Ca.stim.spont.frequency(KeptROI));
                StimCellDummy = cellfun(@isempty,TBIData{i,1}{d,1}.stim.Ca.evIndex);
                TBISliceMaster{i,1}(d,18) = length(TBIData{i,1}{d,1}.stim.Ca.evIndex) - sum(StimCellDummy);
                
                
%                 TBISliceMaster{i,1}(d,19) = mean(TBIData{i,1}{d,1}.Ca.stim.corrVector);
%                 formatSpec = "TBIData{%d,1}{%d,1}.Ca.stim";
%                 A1 = i;
%                 A2 = d;
%                 str = sprintf(formatSpec,A1,A2)
                if isfield(TBIData{i,1}{d,1}.Ca.stim,'cdfF') == 1
                   disp(i)
                   disp(d)
                   TBIStimCDF{d,1}(i,:) = standardizeCDF(TBIData{i,1}{d,1}.Ca.stim.cdfX,TBIData{i,1}{d,1}.Ca.stim.cdfF,nBinsIn);
                else
                   continue
                end
                
                if isfield(TBIData{i,1}{d,1}.Ca.stim,'corrVector') == 1
                    disp('worked')
                    [f, x] = ecdf(TBIData{i,1}{d,1}.Ca.stim.corrVector);
                    TBICellCDF{d,1}(i,:) = standardizeCDF(x,f,nBinsIn);
                    TBICorr{d,1}(i,:) = mean(TBIData{i,1}{d,1}.Ca.stim.corrVector);
                else
                    continue
                end
                
                
            end
        end
    end
end
% Update master columns


%%% Old code, don't need this anymore 

%% Average across slice master and import into master
% clear('Dummy')
% for c = 1:length(ShamMaster(:,1)) % iterate across each stim level
%     for d = 1:length(ShamSliceMaster(:,1)) % iterate across each slice
%         store each value in dummy variable across slices
%         if isempty(ShamData{d,1}{c,1})
%             d = d + 1;
%         else
%         Dummy(d,1) = ShamSliceMaster{d,1}(c,4);
%         Dummy2(d,1) = ShamSliceMaster{d,1}(c,5);
%         Dummy3(d,1) = ShamSliceMaster{d,1}(c,6);
%         Dummy4(d,1) = ShamSliceMaster{d,1}(c,7);
%         Dummy5(d,1) = ShamSliceMaster{d,1}(c,8);
%         Dummy6(d,1) = ShamSliceMaster{d,1}(c,9);
%         Dummy7(d,1) = ShamSliceMaster{d,1}(c,10);
%         Dummy8(d,1) = ShamSliceMaster{d,1}(c,11);
%         Dummy9(d,1) = ShamSliceMaster{d,1}(c,12);
%         Dummy10(d,1) = ShamSliceMaster{d,1}(c,13);
%         Dummy11(d,1) = ShamSliceMaster{d,1}(c,14);
%         Dummy12(d,1) = ShamSliceMaster{d,1}(c,15);
%         Dummy13(d,1) = ShamSliceMaster{d,1}(c,16);
%         Dummy14(d,1) = ShamSliceMaster{d,1}(c,17);
%     end
%     Now take averages of dummy variables and import them into master
%     NROIs
%     ShamMaster(c,4) = nanmean(Dummy);
%     ShamMaster(c,5) = (nanstd(Dummy)/sqrt(length(find(~isnan(Dummy)))));
%
%     Amp
%     ShamMaster(c,6) = nanmean(Dummy2);
%     ShamMaster(c,7) = (nanstd(Dummy2)/sqrt(length(find(~isnan(Dummy2)))));
%     IEI
%     ShamMaster(c,8) = nanmean(Dummy3);
%     ShamMaster(c,9) = (nanstd(Dummy3)/sqrt(length(find(~isnan(Dummy3)))));
%     Dur
%     ShamMaster(c,10) = nanmean(Dummy4);
%     ShamMaster(c,11) = (nanstd(Dummy4)/sqrt(length(find(~isnan(Dummy4)))));
%     Freq
%     ShamMaster(c,12) = nanmean(Dummy5);
%     ShamMaster(c,13) = (nanstd(Dummy5)/sqrt(length(find(~isnan(Dummy5)))));
%     NEvents
%     ShamMaster(c,14) = nanmean(Dummy6);
%     ShamMaster(c,15) = (nanstd(Dummy6)/sqrt(length(find(~isnan(Dummy6)))));
%     Stim Nevents
%     ShamMaster(c,16) = nanmean(Dummy7);
%     ShamMaster(c,17) = (nanstd(Dummy7)/sqrt(length(find(~isnan(Dummy7)))));
%     Stim ampAve
%     ShamMaster(c,18) = nanmean(Dummy8);
%     ShamMaster(c,19) = (nanstd(Dummy8)/sqrt(length(find(~isnan(Dummy8)))));
%     Stim durAve
%     ShamMaster(c,20) = nanmean(Dummy9);
%     ShamMaster(c,21) = (nanstd(Dummy9)/sqrt(length(find(~isnan(Dummy9)))));
%     Stim Freq
%     ShamMaster(c,22) = nanmean(Dummy10);
%     ShamMaster(c,23) = (nanstd(Dummy10)/sqrt(length(find(~isnan(Dummy10)))));
%     Spont NEvents
%     ShamMaster(c,24) = nanmean(Dummy11);
%     ShamMaster(c,25) = (nanstd(Dummy11)/sqrt(length(find(~isnan(Dummy11)))));
%     Spont AmpAve
%     ShamMaster(c,26) = nanmean(Dummy12);
%     ShamMaster(c,27) = (nanstd(Dummy12)/sqrt(length(find(~isnan(Dummy12)))));
%     Spont DurAve
%     ShamMaster(c,28) = nanmean(Dummy13);
%     ShamMaster(c,29) = (nanstd(Dummy13)/sqrt(length(find(~isnan(Dummy13)))));
%     Spont Freq
%     ShamMaster(c,30) = nanmean(Dummy14);
%     ShamMaster(c,31) = (nanstd(Dummy14)/sqrt(length(find(~isnan(Dummy14)))));
% end
% end
%
% clear dummy variables
% clear('Dummy','Dummy1','Dummy2','Dummy3','Dummy4','Dummy5','Dummy6','Dummy7')
% Repeat for TBI
% for c = 1:length(TBIMaster(:,1)) % iterate across each stim level
%     for d = 1:length(TBISliceMaster(:,1)) % iterate across each slice
%         store each value in dummy variable across slices
%         if isempty(TBIData{d,1}{c,1})
%             d = d + 1;
%         else
%         Dummy(d,1) = TBISliceMaster{d,1}(c,4);
%         Dummy2(d,1) = TBISliceMaster{d,1}(c,5);
%         Dummy3(d,1) = TBISliceMaster{d,1}(c,6);
%         Dummy4(d,1) = TBISliceMaster{d,1}(c,7);
%         Dummy5(d,1) = TBISliceMaster{d,1}(c,8);
%         Dummy6(d,1) = TBISliceMaster{d,1}(c,9);
%         Dummy7(d,1) = TBISliceMaster{d,1}(c,10);
%         Dummy8(d,1) = TBISliceMaster{d,1}(c,11);
%         Dummy9(d,1) = TBISliceMaster{d,1}(c,12);
%         Dummy10(d,1) = TBISliceMaster{d,1}(c,13);
%         Dummy11(d,1) = TBISliceMaster{d,1}(c,14);
%         Dummy12(d,1) = TBISliceMaster{d,1}(c,15);
%         Dummy13(d,1) = TBISliceMaster{d,1}(c,16);
%         Dummy14(d,1) = TBISliceMaster{d,1}(c,17);
%     end
%     Now take averages of dummy variables and import them into master
%     NROIs
%     TBIMaster(c,4) = nanmean(Dummy);
%     TBIMaster(c,5) = (nanstd(Dummy)/sqrt(length(find(~isnan(Dummy)))));
%     Amp
%     TBIMaster(c,6) = nanmean(Dummy2);
%     TBIMaster(c,7) = (nanstd(Dummy2)/sqrt(length(find(~isnan(Dummy2)))));
%     IEI
%     TBIMaster(c,8) = nanmean(Dummy3);
%     TBIMaster(c,9) = (nanstd(Dummy3)/sqrt(length(find(~isnan(Dummy3)))));
%     Dur
%     TBIMaster(c,10) = nanmean(Dummy4);
%     TBIMaster(c,11) = (nanstd(Dummy4)/sqrt(length(find(~isnan(Dummy4)))));
%     Freq
%     TBIMaster(c,12) = nanmean(Dummy5);
%     TBIMaster(c,13) = (nanstd(Dummy5)/sqrt(length(find(~isnan(Dummy5)))));
%     NEvents
%     TBIMaster(c,14) = nanmean(Dummy6);
%     TBIMaster(c,15) = (nanstd(Dummy6)/sqrt(length(find(~isnan(Dummy6)))));
%     Stim Nevents
%     TBIMaster(c,16) = nanmean(Dummy7);
%     TBIMaster(c,17) = (nanstd(Dummy7)/sqrt(length(find(~isnan(Dummy7)))));
%     Stim ampAve
%     TBIMaster(c,18) = nanmean(Dummy8);
%     TBIMaster(c,19) = (nanstd(Dummy8)/sqrt(length(find(~isnan(Dummy8)))));
%     Stim durAve
%     TBIMaster(c,20) = nanmean(Dummy9);
%     TBIMaster(c,21) = (nanstd(Dummy9)/sqrt(length(find(~isnan(Dummy9)))));
%     Stim Freq
%     TBIMaster(c,22) = nanmean(Dummy10);
%     TBIMaster(c,23) = (nanstd(Dummy10)/sqrt(length(find(~isnan(Dummy10)))));
%     Spont NEvents
%     TBIMaster(c,24) = nanmean(Dummy11);
%     TBIMaster(c,25) = (nanstd(Dummy11)/sqrt(length(find(~isnan(Dummy11)))));
%     Spont AmpAve
%     TBIMaster(c,26) = nanmean(Dummy12);
%     TBIMaster(c,27) = (nanstd(Dummy12)/sqrt(length(find(~isnan(Dummy12)))));
%     Spont DurAve
%     TBIMaster(c,28) = nanmean(Dummy13);
%     TBIMaster(c,29) = (nanstd(Dummy13)/sqrt(length(find(~isnan(Dummy13)))));
%     Spont Freq
%     TBIMaster(c,30) = nanmean(Dummy14);
%     TBIMaster(c,31) = (nanstd(Dummy14)/sqrt(length(find(~isnan(Dummy14)))));
% end
% end
% clear dummy variables
% clear('Dummy','Dummy1','Dummy2','Dummy3','Dummy4','Dummy5','Dummy6','Dummy7',...
%     'Dummy8','Dummy9','Dummy10','Dummy11','Dummy12','Dummy13','Dummy14');
% Update master columns
% MasterColumns = [MasterColumns 'NCellsActive' 'NCellsSEM' 'AmpAve' 'AmpSEM'...
%     'IEI Ave' 'IEISEM' 'DurAve' 'DurSEM' 'Freq' 'FreqSEM' 'nEvents' 'EventsSEM',...
%     'StimNEvents','StimNEventsSEM','StimAmp','StimAmpSEM','StimDur','StimDurSEM',...
%     'StimFreq','StimFreqSEM','SpontNEvents','SpontNEventsSEM','SpontAmp','SpontAmpSEM',...
%     'SpontDur','SpontDurSEM','SpontFreq','SpontFreqSEM'];


%% Run anovas

% Ask mark about two way repeated anova???

%% NEXT RUN Threshold normalization