%% Script to write xls files for data by slice

function ExcelWrite(SliceMaster,Name)

TableNames = {'0 mA','20 mA','30 mA','40 mA','60 mA','80 mA','Base','PostHFS','PostHFS5','PostHFS10'};

%%
% LFPArray = [];
NumROIArray = [];
AmpArray = [];
IEIArray = [];
DurArray = [];
FreqArray = [];
nEventsArray = [];
LFPArray = [];
CorrArray = [];
% StimEventsArray = [];
% StimAmpArray = [];
% StimDurArray = [];
% StimFreqArray = [];
% SpontEventArray = [];
% SpontAmpArray = [];
% SpontDurArray = [];
% SpontFreqArray = [];
% NetThreshArray = [];
% NetPropArray = [];
% CCThreshArray = [];
% CCPropArray = [];
% InnerThreshArray = [];
% InnerPropArray = [];
% EnsPeaksArray = [];
% EnsWidthArray = [];
% StimCellsArray = [];
for i = 1:length(SliceMaster)
    %     LFPArray = [LFPArray SliceMaster{i,1}(:,3)];
    if length(SliceMaster{i,1}(1,:))<18
        i = i+1;
    else
        NumROIArray = [NumROIArray SliceMaster{i,1}(:,4)];
        AmpArray = [AmpArray SliceMaster{i,1}(:,5)];
        IEIArray = [IEIArray SliceMaster{i,1}(:,6)];
        DurArray = [DurArray SliceMaster{i,1}(:,7)];
        FreqArray = [FreqArray SliceMaster{i,1}(:,8)];
        nEventsArray = [nEventsArray SliceMaster{i,1}(:,9)];
        LFPArray = [LFPArray SliceMaster{i,1}(:,3)];
        %         StimEventsArray = [StimEventsArray SliceMaster{i,1}(:,10)];
        %         StimAmpArray = [StimAmpArray SliceMaster{i,1}(:,11)];
        %         StimDurArray = [StimDurArray SliceMaster{i,1}(:,12)];
        %         StimFreqArray = [StimFreqArray SliceMaster{i,1}(:,13)];
        %         SpontEventArray = [SpontEventArray SliceMaster{i,1}(:,14)];
        %         SpontAmpArray = [SpontAmpArray SliceMaster{i,1}(:,15)];
        %         SpontDurArray = [SpontDurArray SliceMaster{i,1}(:,16)];
        %         SpontFreqArray = [SpontFreqArray SliceMaster{i,1}(:,17)];
        %         NetThreshArray = [NetThreshArray SliceMaster{i,1}(:,18)];
        %         NetPropArray = [NetPropArray SliceMaster{i,1}(:,19)];
        %     CCThreshArray = [CCThreshArray SliceMaster{i,1}(:,20)];
        %     CCPropArray = [CCPropArray SliceMaster{i,1}(:,21)];
        
        
        %           StimCellsArray = [StimCellsArray SliceMaster{i,1}(:,18)];
        %     if i == 2 || i == 11 || i == 12
        %         continue
        %     else
        %         InnerThreshArray = [InnerThreshArray SliceMaster{i,1}(:,22)];
        %         InnerPropArray = [InnerPropArray SliceMaster{i,1}(:,23)];
        %     EnsPeaksArray = [EnsPeaksArray SliceMaster{i,1}(:,25)];
        %     EnsWidthArray = [EnsWidthArray SliceMaster{i,1}(:,27)];
    end
end


LFPTable = array2table(LFPArray,'RowNames',TableNames');
writetable(LFPTable,'LFP.xls');

NumROITable = array2table(NumROIArray,'RowNames',TableNames');
writetable(NumROITable,strcat(Name,'ROI.xls'));

AmpTable = array2table(AmpArray,'RowNames',TableNames');
writetable(AmpTable,strcat(Name,'Amp.xls'));

IEITable = array2table(IEIArray,'RowNames',TableNames');
writetable(IEITable,strcat(Name,'IEI.xls'));

DurTable = array2table(DurArray,'RowNames',TableNames');
writetable(DurTable,strcat(Name,'Dur.xls'));

FreqTable = array2table(FreqArray,'RowNames',TableNames');
writetable(FreqTable,strcat(Name,'Freq.xls'));

nEventsTable = array2table(nEventsArray,'RowNames',TableNames');
writetable(nEventsTable,strcat(Name,'Events.xls'));

LFPTable = array2table(LFPArray,'RowNames',TableNames');
writetable(LFPTable,strcat(Name,'LFP.xls'));

% nStimEventsTable = array2table(StimEventsArray,'RowNames',TableNames');
% writetable(nStimEventsTable,'StimEvents.xls');
% 
% nStimAmpTable = array2table(StimAmpArray,'RowNames',TableNames');
% writetable(nStimAmpTable,'StimAmp.xls');
% 
% nStimDurTable = array2table(StimDurArray,'RowNames',TableNames');
% writetable(nStimDurTable,'StimDur.xls');
% 
% nStimFreqTable = array2table(StimFreqArray,'RowNames',TableNames');
% writetable(nStimFreqTable,'StimFreq.xls');
% 
% SpontEventArray(1,:) = nEventsArray(1,:);
% SpontEventTable = array2table(SpontEventArray,'RowNames',TableNames');
% writetable(SpontEventTable,'SpontEvent.xls');
% 
% SpontAmpArray(1,:) = AmpArray(1,:);
% SpontAmpTable = array2table(SpontAmpArray,'RowNames',TableNames');
% writetable(SpontAmpTable,'SpontAmp.xls');
% 
% SpontDurArray(1,:) = DurArray(1,:);
% SpontDurTable = array2table(SpontDurArray,'RowNames',TableNames');
% writetable(SpontDurTable,'SpontDur.xls');
% 
% SpontFreqArray(1,:) = FreqArray(1,:);
% SpontFreqTable = array2table(SpontFreqArray,'RowNames',TableNames');
% writetable(SpontFreqTable,'SpontFreq.xls');
% %
% NetThreshTable = array2table(NetThreshArray,'RowNames',TableNames');
% writetable(NetThreshTable,'NetThresh.xls');
% 
% NetPropTable = array2table(NetPropArray,'RowNames',TableNames');
% writetable(NetPropTable,'NetProp.xls');
% 
% CCThreshTable = array2table(CCThreshArray,'RowNames',TableNames');
% writetable(CCThreshTable,'CCThresh.xls');
% 
% CCPropTable = array2table(CCPropArray,'RowNames',TableNames');
% writetable(CCPropTable,'CCProp.xls');
% 
% InnerThreshTable = array2table(InnerThreshArray,'RowNames',TableNames');
% writetable(InnerThreshTable,'InnerThresh.xls');
% 
% InnerPropTable = array2table(InnerPropArray,'RowNames',TableNames');
% writetable(InnerPropTable,'InnerProp.xls');
% 
% PeaksTable = array2table(EnsPeaksArray,'RowNames',TableNames');
% writetable(PeaksTable,'EnsPeaks.xls');
% 
% WidthTable = array2table(EnsWidthArray,'RowNames',TableNames');
% writetable(WidthTable,'EnsWidth.xls');
% 
% StimCellsTable = array2table(StimCellsArray,'RowNames',TableNames');
% writetable(StimCellsTable,'StimCells.xls');

