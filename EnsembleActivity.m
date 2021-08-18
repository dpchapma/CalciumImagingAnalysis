%% Script to analyze network activity for all sessions 

function [ShamSliceMaster,TBISliceMaster] = EnsembleActivity(ShamData,TBIData,ShamAboveThresh,TBIAboveThresh,ShamEnsShuffledF,TBIEnsShuffledF)



% Sham
for i = 1:length(ShamAboveThresh) % iterate across slice
    for c = 1:length(ShamAboveThresh{i,1}) % iterate across session
        if length(ShamAboveThresh{i,1}{c,1})<3
            ShamEnsemble{i,1}{c,1} = [];
        else
        % Network activity = the mean activity at eac htimepoint 
            ShamEnsemble{i,1}{c,1} = mean(ShamAboveThresh{i,1}{c,1}');
        end
    end
end 

% Repeat for TBI 
for i = 1:length(TBIAboveThresh) % iterate across slice
    for c = 1:length(TBIAboveThresh{i,1}) % iterate across session
        if length(TBIAboveThresh{i,1}{c,1})<3
            TBIEnsemble{i,1}{c,1} = [];
        else
            % Network activity = the mean activity at eac htimepoint 
            TBIEnsemble{i,1}{c,1} = mean(TBIAboveThresh{i,1}{c,1}');
        end
    end
end 


%% Quick plot 
% figure
% subplot(2,1,1)
% plot(TBIData{3,1}{6,1}.LFP.tSeries,'r')
% xlim([0 956327])
% ax1 = gca;
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none');
% hold on
% plot(TBIEnsemble{3,1}{6,1})
% subplot(2,1,2)
% heatmap(TBIAboveThresh{3,1}{6,1}', 'Colormap',winter,'GridVisible','off')
        
%% Repeat for shuffled data 
% Sham shuffled
for i = 1:length(ShamEnsShuffledF) % iterate across slice
    for c = 1:length(ShamEnsShuffledF{i,1}) % iterate across session
        if length(ShamAboveThresh{i,1}{c,1})<3
            ShamEnsembleShuf{i,1}{c,1} = [];
        else
        % Network activity = the mean activity at eac htimepoint 
            ShamEnsembleShuf{i,1}{c,1} = mean(ShamEnsShuffledF{i,1}{c,1}');
        end
    end
end 

% TBI shuffled          
for i = 1:length(TBIEnsShuffledF) % iterate across slice
    for c = 1:length(TBIEnsShuffledF{i,1}) % iterate across session
        if length(TBIAboveThresh{i,1}{c,1})<3
            TBIEnsembleShuf{i,1}{c,1} = [];
        else
            % Network activity = the mean activity at eac htimepoint 
            TBIEnsembleShuf{i,1}{c,1} = mean(TBIEnsShuffledF{i,1}{c,1}');
        end
    end
end 

%% Find the top 1% of ensemble activity for each shuffled session 
% ensemble activity at chance level
ShamNetCutoff = [];
ShamShuffledSort = [];
for i = 1:length(ShamEnsShuffledF) %iterate across slice
    for c = 1:length(ShamEnsShuffledF{i,1}) % iterate across session
        if isempty(ShamEnsShuffledF{i,1}{c,1})
            ShamEnsShuffledF{i,1}{c,1} = [];
            ShamShuffledSort{i,1}{c,1} = [];
            ShamNetCutoff{i,1}(c,1) = nan;
            ShamSliceMaster{i,1}(c,1) = nan;
        else
        % Sort the data and store in new variable
        ShamEnsShuffledF{i,1}{c,1} = reshape(ShamEnsShuffledF{i,1}{c,1},[],1);
%         ShamShuffledSort{i,1}{c,1} = sort(ShamEnsembleShuf{i,1}{c,1});
        ShamShuffledSort{i,1}{c,1} = sort(ShamEnsShuffledF{i,1}{c,1});
        % Find the the value at 99th percentile of the sorted data
        ShamNetCutoff{i,1}(c,1) = ShamShuffledSort{i,1}{c,1}(round(length(ShamShuffledSort{i,1}{c,1})-0.01*length(ShamShuffledSort{i,1}{c,1})));
        % Import into slice master
        ShamSliceMaster{c,1}(i,1) = ShamShuffledSort{i,1}{c,1}(round(length(ShamShuffledSort{i,1}{c,1})-0.01*length(ShamShuffledSort{i,1}{c,1})));
    end        
end
end

TBINetCutoff = [];
TBIShuffledSort = [];
for i = 1:length(TBIEnsShuffledF) %iterate across slice
    for c = 1:length(TBIEnsShuffledF{i,1}) % iterate across session
        if isempty(TBIEnsShuffledF{i,1}{c,1})
            TBIEnsShuffledF{i,1}{c,1} = [];
            TBIShuffledSort{i,1}{c,1} = [];
            TBINetCutoff{i,1}(c,1) = nan;
            TBISliceMaster{i,1}(c,1) = nan;
        else
        % Sort the data and store in new variable
        TBIEnsShuffledF{i,1}{c,1} = reshape(TBIEnsShuffledF{i,1}{c,1},[],1);
%         TBIShuffledSort{i,1}{c,1} = sort(TBIEnsembleShuf{i,1}{c,1});
        TBIShuffledSort{i,1}{c,1} = sort(TBIEnsShuffledF{i,1}{c,1});
        % Find the the value at 99th percentile of the sorted data
        TBINetCutoff{i,1}(c,1) = TBIShuffledSort{i,1}{c,1}(round(length(TBIShuffledSort{i,1}{c,1})-0.01*length(TBIShuffledSort{i,1}{c,1})));
        % Import into slice master
        TBISliceMaster{c,1}(i,1) = TBIShuffledSort{i,1}{c,1}(round(length(TBIShuffledSort{i,1}{c,1})-0.01*length(TBIShuffledSort{i,1}{c,1})));
    end        
end
end

% Update slice master columns
% SliceMasterColumns = [SliceMasterColumns '1% Network threshold'];

%% Calculate percentage of non-shuffled data above threshold for each session

ShamNetProps = [];
for i = 1:length(ShamEnsemble) % iterate over slice
    for c = 1:length(ShamEnsemble{i,1}) % iterate over session
        % Find number of frames that are above threshold and pass into
        % dummy varaible
        if isempty(ShamEnsemble{i,1}{c,1})
            ShamSliceMaster{c,1}(i,2) = nan;
        else
            NumberofNets = length(find(ShamEnsemble{i,1}{c,1} > ShamNetCutoff{i,1}(c,1)));
            % Find propotion by dividing by length and pass inot slice master
            ShamSliceMaster{c,1}(i,2) = NumberofNets/length(ShamEnsemble{i,1}{c,1});
    end
end
end

% Repeat for TBI
TBINetProps = [];
for i = 1:length(TBIEnsemble) % iterate over slice
    for c = 1:length(TBIEnsemble{i,1}) % iterate over session
        % Find number of frames that are above threshold and pass into
        % dummy varaible
        if isempty(TBIEnsemble{i,1}{c,1})
            TBISliceMaster{c,1}(i,2) = nan;
        else
        NumberofNets = length(find(TBIEnsemble{i,1}{c,1} > TBINetCutoff{i,1}(c,1)));
        % Find propotion by dividing by length and pass inot slice master
        TBISliceMaster{c,1}(i,2) = NumberofNets/length(TBIEnsemble{i,1}{c,1});
    end
end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

%% Find peaks of ensemble activity above threshold to see if number of incidences differs
ShamEnsPeaksAll = NaN(10,length(ShamData));
clear('ShamEnsWidth')
for i = 1:length(ShamEnsemble)
    for c = 1:length(ShamEnsemble{i,1})
        if isempty(ShamEnsemble{i,1}{c,1})||length(ShamEnsemble{i,1}{c,1}(1,:))<700
            ShamEnsPeaks{i,1}(c,1) = nan;
            ShamEnsWidth{i,1}(c,1) = nan;
            ShamSliceMaster{c,1}(i,3) = nan;
            ShamSliceMaster{c,1}(i,4) = nan;
            ShamSliceMaster{c,1}(i,5) = nan;
            ShamSliceMaster{c,1}(i,6) = nan;
        else
            [ShamA ShamB ShamC ShamD] = findpeaks(ShamEnsemble{i,1}{c,1},'MinPeakHeight',ShamNetCutoff{i,1}(c,1));
            ShamEnsPeaks{i,1}(c,1) = length(ShamA);
            ShamEnsWidth{i,1}(c,1) = mean(ShamC);
            ShamSliceMaster{c,1}(i,3) = length(ShamA);
            ShamSliceMaster{c,1}(i,4) = std(ShamA);
            ShamSliceMaster{c,1}(i,5) = mean(ShamC);
            ShamSliceMaster{c,1}(i,6) = std(ShamC);
        end
    end
%     ShamEnsPeaksAll(1:length(ShamEnsPeaks{i,1}),i) = ShamEnsPeaks{i,1};
%     ShamEnsWidthAll(1:length(ShamEnsWidth{i,1}),i) = ShamEnsWidth{i,1};
end

TBIEnsPeaksAll = NaN(10,length(TBIData));
for i = 1:length(TBIEnsemble)
    for c = 1:length(TBIEnsemble{i,1})
        if isempty(TBIEnsemble{i,1}{c,1})||length(TBIEnsemble{i,1}{c,1}(1,:))<700
            TBIEnsPeaks{i,1}(c,1) = nan;
            TBIEnsWidth{i,1}(c,1) = nan;
            TBISliceMaster{c,1}(i,3) = nan;
            TBISliceMaster{c,1}(i,4) = nan;
            TBISliceMaster{c,1}(i,5) = nan;
            TBISliceMaster{c,1}(i,6) = nan;
        else
            [TBIA TBIB TBIC TBID] = findpeaks(TBIEnsemble{i,1}{c,1},'MinPeakHeight',TBINetCutoff{i,1}(c,1));
            TBIEnsPeaks{i,1}(c,1) = length(TBIA);
            TBISliceMaster{c,1}(i,3) = length(TBIA);
            TBISliceMaster{c,1}(i,4) = std(TBIA);
            TBIEnsWidth{i,1}(c,1) = mean(TBIC);
            TBISliceMaster{c,1}(i,5) = mean(TBIC);
            TBISliceMaster{c,1}(i,6) = std(TBIC);
        end
    end
%         TBIEnsPeaksAll(1:length(TBIEnsPeaks{i,1}),i) = TBIEnsPeaks{i,1};
%         TBIEnsWidthAll(1:length(TBIEnsWidth{i,1}),i) = TBIEnsWidth{i,1};
end

%% Now lets average and plot these 
% 
% ShamEnsPeaksMean = nanmean(ShamEnsPeaksAll,2);
% ShamEnsPeaksMean(:,2) = nanstd(ShamEnsPeaksAll')/length(ShamEnsPeaksAll(~isnan(ShamEnsPeaksAll(1,:))));
% 
% ShamEnsWidthMean = nanmean(ShamEnsWidthAll,2);
% ShamEnsWidthMean = ShamEnsWidthMean/7.5;
% ShamEnsWidthMean(:,2) = nanstd(ShamEnsWidthAll')/length(ShamEnsWidthAll(~isnan(ShamEnsWidthAll(1,:))));
% 
% TBIEnsPeaksMean = nanmean(TBIEnsPeaksAll,2);
% TBIEnsPeaksMean(:,2) = nanstd(TBIEnsPeaksAll')/length(TBIEnsPeaksAll(~isnan(TBIEnsPeaksAll(1,:))));
% 
% TBIEnsWidthMean = nanmean(TBIEnsWidthAll,2);
% TBIEnsWidthMean = TBIEnsWidthMean/7.5;
% TBIEnsWidthMean(:,2) = nanstd(TBIEnsWidthAll')/length(TBIEnsWidthAll(~isnan(TBIEnsWidthAll(1,:))));


%% Next run CC analysis 