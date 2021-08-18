function [SliceShufMinSimVec, SliceShufBeforeSimVec,SliceShufAfterSimVec,SliceShufMinEventsVec,SliceShufBeforeEventsVec,SliceShufAfterEventsVec,SliceShufMinLEventsVec,SliceShufBeforeLEventsVec,SliceShufAfterLEventsVec,SliceShufMinSimSTD,SliceShufAfterSimSTD,SliceShufBeforeSimSTD] = getShuffleData(SliceShufMinSim,SliceShufBeforeSim,SliceShufAfterSim,SliceShufMinEvents,SliceShufAfterEvents,SliceShufBeforeEvents)
for i = 2:10
    for c = 1:length(SliceShufMinSim)
        if isempty(SliceShufMinSim{c,i})
            SliceShufMinSimVec(c,i) = nan;
            SliceShufBeforeSimVec(c,i) = nan;
            SliceShufAfterSimVec(c,i) = nan;
            SliceShufMinEventsVec(c,i) = nan;
            SliceShufBeforeEventsVec(c,i) = nan;
            SliceShufAfterEventsVec(c,i) = nan;
            continue
        else
            MinSimTemp = nanmean(SliceShufMinSim{c,i},2);
            SliceShufMinSimVec(c,i) = nanmean(MinSimTemp);
            MinSimSTDTemp = nanstd(SliceShufMinSim{c,i},0,2);
            SliceShufMinSimSTD(c,i) = nanmean(MinSimSTDTemp);
            
            
            BeforeSimTemp = nanmean(SliceShufBeforeSim{c,i},2);
            SliceShufBeforeSimVec(c,i) = nanmean(BeforeSimTemp);
            BeforeSimSTDTemp = nanstd(SliceShufBeforeSim{c,i},0,2);
            SliceShufBeforeSimSTD(c,i) = nanmean(BeforeSimSTDTemp);
            
            AfterSimTemp = nanmean(SliceShufAfterSim{c,i},2);
            SliceShufAfterSimVec(c,i) = nanmean(AfterSimTemp);
            AfterSimSTDTemp = nanstd(SliceShufAfterSim{c,i},0,2);
            SliceShufAfterSimSTD(c,i) = nanmean(AfterSimSTDTemp);
            
            MinEventsTemp = nanmean(SliceShufMinEvents{c,i},2);
            SliceShufMinEventsVec(c,i) = nanmean(MinEventsTemp);
            
            SliceShufMinLEventsVec{i,1}(c,1:9) = nan;
            SliceShufMinLEventsVec{i,1}(c,1:length(MinEventsTemp)) = MinEventsTemp;
            
            BeforeEventsTemp = nanmean(SliceShufBeforeEvents{c,i},2);
            SliceShufBeforeEventsVec(c,i) = nanmean(BeforeEventsTemp);
            
            SliceShufBeforeLEventsVec{i,1}(c,1:9) = nan;
            SliceShufBeforeLEventsVec{i,1}(c,1:length(BeforeEventsTemp)) = BeforeEventsTemp;
            
            AfterEventsTemp = nanmean(SliceShufAfterEvents{c,i},2);
            SliceShufAfterEventsVec(c,i) = nanmean(AfterEventsTemp);
            
            SliceShufAfterLEventsVec{i,1}(c,1:9) = nan;
            SliceShufAfterLEventsVec{i,1}(c,1:length(AfterEventsTemp)) = AfterEventsTemp;
        end
    end
end
            