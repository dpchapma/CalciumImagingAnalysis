%% Above thresh normalization for all slices with kept ROI
% Script to get only activity above threshold and normalize to each cell
% to it's own max
% for full interpolated data

function [ShamFullAbove, TBIFullAbove] = FullThresholdNormalization(ShamData,TBIData,ShamKeptROI,TBIKeptROI)
%
for i = 1:length(ShamData) % iterate across data
    for c = 2:length(ShamData{i,1}) % iterate across each session
        % Set new cell = to tSeriesF data of kept ROI
        disp(i)
        disp(c)
        if isempty(ShamData{i,1}{c,1})
            ShamAboveThresh{i,1}{c,1} = [];
            continue
        else
            ShamFullAbove{i,1}{c,1} = ShamData{i,1}{c,1}.Ca.stim.tSeriesA(:,ShamKeptROI{i,1}{c,1});
            % Set new cell = to the threshold for kept ROI to call later
            ShamKeptThresh{i,1}{c,1} = ShamData{i,1}{c,1}.Ca.baseThresh(ShamKeptROI{i,1}{c,1});
            % iterate across each cell
            for d = 1:length(ShamKeptROI{i,1}{c,1})
                
                % Add logic to set points less than thresh = 0
                ShamAboveIndex = find(ShamFullAbove{i,1}{c,1}(:,d)<ShamKeptThresh{i,1}{c,1}(d));
                ShamFullAbove{i,1}{c,1}(ShamAboveIndex,d) = 0;
                
                % Find the max for that slice
                
                %            ShamMin(d) = min(ShamFullAbove{i,1}{c,1}(:,d));
                %            % Divide (normalize) tSeries by the max
                %            ShamFullAbove{i,1}{c,1}(:,d) = ShamFullAbove{i,1}{c,1}(:,d)+abs(ShamMin(d));
                ShamMax(d) = max(ShamFullAbove{i,1}{c,1}(:,d));
                ShamFullAbove{i,1}{c,1}(:,d) = ShamFullAbove{i,1}{c,1}(:,d)./ShamMax(d);
            end
        end
    end
end
%%
% Repeat for TBI
for i = 1:length(TBIData) % iterate across data
    for c = 2:length(TBIData{i,1}) % iterate across each session
        % Set new cell = to tSeriesF data of kept ROI
        disp(i)
        disp(c)
        if isempty(TBIData{i,1}{c,1})
            TBIAboveThresh{i,1}{c,1} = [];
            continue
        else
            TBIFullAbove{i,1}{c,1} = TBIData{i,1}{c,1}.Ca.stim.tSeriesA(:,TBIKeptROI{i,1}{c,1});
            % Set new cell = to the threshold for kept ROI to call later
            TBIKeptThresh{i,1}{c,1} = TBIData{i,1}{c,1}.Ca.baseThresh(TBIKeptROI{i,1}{c,1});
            % iterate across each cell
            for d = 1:length(TBIKeptROI{i,1}{c,1})
                
                % Add logic to set points less than thresh = 0
                TBIAboveIndex = find(TBIFullAbove{i,1}{c,1}(:,d)<TBIKeptThresh{i,1}{c,1}(d));
                TBIFullAbove{i,1}{c,1}(TBIAboveIndex,d) = 0;
                
                % Find the max for that slice
                
                %            TBIMin(d) = min(TBIFullAbove{i,1}{c,1}(:,d));
                %            % Divide (normalize) tSeries by the max
                %            TBIFullAbove{i,1}{c,1}(:,d) = TBIFullAbove{i,1}{c,1}(:,d)+abs(TBIMin(d));
                TBIMax(d) = max(TBIFullAbove{i,1}{c,1}(:,d));
                TBIFullAbove{i,1}{c,1}(:,d) = TBIFullAbove{i,1}{c,1}(:,d)./TBIMax(d);
            end
        end
    end
end

