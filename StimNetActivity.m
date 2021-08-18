%%


function [SliceBeforeEvents,SliceMinEvents,SliceAfterEvents,SliceMinTime,SlicePower,SliceBeforeSim,SliceMinSim,SliceAfterSim,SliceCorr,SliceCorrNoOnes,SliceAvMax,SliceAvMin,CrossCorr,Lags,SliceBeforeROI,SliceMinROI,SliceAfterROI,SliceMinRange,SliceMaxRange,SliceAfterMax] = StimNetActivity(SliceE,SliceFullAboveThresh,SliceKeptROI,TimeWindow)

TW = TimeWindow;
[SliceAv,SliceBinned,SliceCellBinned,SliceMeanBin,SliceMin,SliceMinRange,SliceMaxRange,SliceAfterMax,SlicePower,SliceMinTime,SliceCorr,SliceCorrNoOnes,SliceAvMax,SliceAvMin,CrossCorr,Lags] = BinnedActivity(SliceE,SliceKeptROI,SliceFullAboveThresh,TW);

[SliceBeforeEvents, SliceBeforeVector,SliceMinEvents,SliceAfterVector,SliceAfterEvents,SliceBeforeSim,SliceMinSim,SliceAfterSim,SliceBeforeROI,SliceMinROI,SliceAfterROI] = GatherEvents(SliceE,SliceCellBinned,SliceMaxRange,SliceMinRange,SliceAfterMax,SliceKeptROI);
[SliceBeforeEvents,SliceAfterEvents,SliceMinEvents,SliceMinSim,SliceBeforeSim,SliceAfterSim,SlicePower,SliceMinTime,SliceBeforeROI,SliceMinROI,SliceAfterROI] = excludeSesh(SliceE,SliceBeforeEvents,SliceAfterEvents,SliceMinEvents,SliceMinSim,SliceBeforeSim,SliceAfterSim,SlicePower,SliceMinTime,SliceBeforeROI,SliceMinROI,SliceAfterROI);


















%%
% SliceNum = 13;
% StimNum = 2;
% SliceEnsAv = mean(SliceFullAboveThresh{SliceNum,1}{StimNum,1},2);
% clear('Binned')
% for i = 1:length(SliceE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA)
%     if i ==length(SliceE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA)
%         break
%     else
%         if i == 1
%             Binned(:,i) = SliceEnsAv(SliceE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA(i):SliceE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA(i+1),1);
%         else
%             Binned(:,i) = SliceEnsAv(SliceE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA(i):SliceE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA(i)+length(Binned(:,1))-1,1);
%         end
%     end
% end
%
% Time = linspace(1,length(Binned(:,1)),length(Binned(:,1)))./2000;
% MeanBin = mean(Binned,2);
% clear('STD')
% STD(:,1) = std(Binned,0,2);
% SxFill = [Time(1:end) Time(end:-1:1)];
% % y vals are SEM forward above and back below
% SyFill = [MeanBin+STD];
% SyFill(length(MeanBin)+1:length(SxFill)) = [MeanBin(length(MeanBin):-1:1)-STD(length(STD):-1:1)];
%
% figure
% plot(Time,MeanBin,'b','Linewidth',1)
% hold on
% fill(SxFill,SyFill,'b','FaceAlpha',0.15,'EdgeColor',"none")
%
%
% figure
% plot(Time,Binned)
%
% % 8 slices with more than 3 ROI's at level 8
% %
% figure
% pspectrum(MeanBin(12000:end),2000)
%
%
% %%
%
% SliceNum = 12;
% StimNum = 6;
% TBIEnsAv = mean(TBIFullAboveThresh{SliceNum,1}{StimNum,1},2);
% clear('Binned')
% for i = 1:length(TBIE{SliceNum,1}{StimNum,1}.stim.Ca.evEndA)
%     if i ==length(TBIE{SliceNum,1}{StimNum,1}.stim.Ca.evEndA)
%         break
%     else
%         if i == 1
%             Binned(:,i) = TBIEnsAv(TBIE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA(i):TBIE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA(i+1),1);
%         else
%             Binned(:,i) = TBIEnsAv(TBIE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA(i):TBIE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA(i)+length(Binned(:,1))-1,1);
%         end
%     end
% end
%
% Time = linspace(1,length(Binned(:,1)),length(Binned(:,1)))./2000;
% MeanBin = mean(Binned,2);
% STD(:,1) = std(Binned,0,2);
% SxFill = [Time(1:end) Time(end:-1:1)];
% % y vals are SEM forward above and back below
% SyFill = [MeanBin+STD];
% SyFill(length(MeanBin)+1:length(SxFill)) = [MeanBin(length(MeanBin):-1:1)-STD(length(STD):-1:1)];
%
% figure
% plot(Time,MeanBin,'r','Linewidth',1)
% hold on
% fill(SxFill,SyFill,'r','FaceAlpha',0.15,'EdgeColor',"none")
%
%
% % figure
% % plot(Time,Binned)
%
% % 12 HFHI slices with > 3 ROIs at 8%%
%
% SliceNum = 13;
% StimNum = 1
% TBIEnsAv = mean(TBIFullAboveThresh{SliceNum,1}{StimNum,1},2);
%
% figure
% plot(TBIEnsAv);
% hold on
%
%
% pspectrum(TBIEnsAv)
%
%
% % for i = 1:length(SliceE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA)
% %     SP = SliceE{SliceNum,1}{StimNum,1}.stim.Ca.evEndA(i,1);
% %     xline(SP,'Linewidth',1)
% %     SPP = SliceE{SliceNum,1}{StimNum,1}.stim.Ca.evStartA(i,1);
% %     xline(SPP,'Linewidth',1,'Color','r')
% % end
%
%
