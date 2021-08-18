function [SliceBeforeEvents,SliceAfterEvents,SliceMinEvents,SliceMinSim,SliceBeforeSim,SliceAfterSim,SlicePower,SliceMinTime,SliceBeforeROI,SliceMinROI,SliceAfterROI] = excludeSesh(SliceE,SliceBeforeEvents,SliceAfterEvents,SliceMinEvents,SliceMinSim,SliceBeforeSim,SliceAfterSim,SlicePower,SliceMinTime,SliceBeforeROI,SliceMinROI,SliceAfterROI)
for i = 1:length(SliceE)
    for c = 2:length(SliceE{i,1})
        if isempty(SliceE{i,1}{c,1})
            %             SliceBeforeTotal{c,1}(i,1) = nan;
            %             SliceAfterTotal{c,1}(i,1) = nan;
            %             SliceMinTotal{c,1}(i,1) = nan;
            SliceBeforeEvents{c,1}(i,:) = nan;
            SliceAfterEvents{c,1}(i,:) = nan;
            SliceMinEvents{c,1}(i,:) = nan;
            SliceBeforeSim{c,1}(i,1) = nan;
            SliceMinSim{c,1}(i,1) = nan;
            SliceAfterSim{c,1}(i,1) = nan;
            SlicePower{c,1}(i,:) = nan;
            SliceMinTime(c,i) = nan;
            SliceBeforeROI(c,i) = nan;
            SliceMinROI(c,i) = nan;
            SliceAfterROI(c,i) = nan;
        else
            continue
        end
    end
end