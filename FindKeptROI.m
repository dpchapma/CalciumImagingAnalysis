function [ShamKeptROI,TBIKeptROI] = FindKeptROI(ShamData,TBIData)
Stimlevel = [0 2 3 4 6 8 -1 0 5 10]; % First 6 are Io curve and represent
for i = 1:length(ShamData)
    ShamSliceMaster{i,1}(:,1) = Stimlevel;
end

for i = 1:length(TBIData)
    TBISliceMaster{i,1}(:,1) = Stimlevel;
end

for i = 1:length(ShamSliceMaster) % Iterate across slices
    % Iterate across slice level and find means
    for d = 1:length(ShamSliceMaster{i,1}(:,1))
        % Find kept ROI and create index for it will use later for ensemble
        % analysis as well
        if isempty(ShamData{i,1}{d,1})
            ShamKeptROI{i,1}{d,1} = [];
            d = d + 1;
        else
            
            ShamKeptROI{i,1}{d,1} = find(~isnan(ShamData{i,1}{d,1}.Ca.nEvents));
            % Make dummy variable so it's easier to call for each metric
            KeptROI = find(~isnan(ShamData{i,1}{d,1}.Ca.nEvents));
            % Now find metrics in data struct and put them in slicemaster
            ShamSliceMaster{i,1}(d,4) = length(KeptROI);
        end
    end
end




for i = 1:length(TBISliceMaster) % Iterate across slices
    % Iterate across slice level and find means
    for d = 1:length(TBISliceMaster{i,1}(:,1))
        % Find kept ROI and create index for it will use later for ensemble
        % analysis as well
        if isempty(TBIData{i,1}{d,1})
            TBIKeptROI{i,1}{d,1} = [];
            d = d + 1;
        else
            
            TBIKeptROI{i,1}{d,1} = find(~isnan(TBIData{i,1}{d,1}.Ca.nEvents));
            % Make dummy variable so it's easier to call for each metric
            KeptROI = find(~isnan(TBIData{i,1}{d,1}.Ca.nEvents));
        end
    end
end