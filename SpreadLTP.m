%% Full LFP fig
%%%%%%%%%%%%%%%%
% This script separates each individual stimulation out for each session
%%%%%%%%%%%%%%%%
function [ShamSpreadLFP,TBISpreadLFP] = SpreadLTP(ShamData,TBIData)

%%
for i = 1:length(ShamData) % iterate across slice
    for c = 7:length(ShamData{i,1})
        if isempty(ShamData{i,1}{c,1})
            c = c + 1;
        else
            ShamFullLFP{i,c-6} = ShamData{i,1}{c,1}.stim.lfpAmp;
        end
    end
end


for i = 1:length(ShamFullLFP(:,1))
    for c = 1:length(ShamFullLFP(1,:))
        ShamLFPMaxNew = mean(ShamFullLFP{i,1});
        ShamLFPNew{i,c} = ShamFullLFP{i,c}/ShamLFPMaxNew;
    end
end

%%
% ShamFullLFP = ShamFullLFP';
ShamLFPNew = ShamLFPNew';

%%
ShamSpreadLFP = [];

for c = 1:length(ShamLFPNew(1,:))
    BlankLFP = nan(40,1);
    BlankLFPNew = [];
for i = 1:length(ShamLFPNew(:,1))
%     for c = 1:length(ShamLFPNew(1,:))
        BlankLFPNew = [BlankLFPNew; ShamLFPNew{i,c}];       
end
    BlankLFP(1:length(BlankLFPNew)) = BlankLFPNew;
    ShamSpreadLFP(:,c) = BlankLFP;
    clear BlankLFP BlankLFPNew
end

%%
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
%%
for i = 1:length(TBIData) % iterate across slice
    for c = 7:length(TBIData{i,1})
        if isempty(TBIData{i,1}{c,1})
            c = c + 1;
        else
            TBIFullLFP{i,c-6} = TBIData{i,1}{c,1}.stim.lfpAmp;
        end
    end
end

for i = 1:length(TBIFullLFP(:,1))
    for c = 1:length(TBIFullLFP(1,:))
        TBILFPMaxNew = mean(TBIFullLFP{i,1});
        TBILFPNew{i,c} = TBIFullLFP{i,c}/TBILFPMaxNew;
    end
end
%%
% TBIFullLFP = TBIFullLFP';
TBILFPNew = TBILFPNew';

%%
TBISpreadLFP = [];

for c = 1:length(TBILFPNew(1,:))
    BlankLFP = nan(40,1);
    BlankLFPNew = [];
for i = 1:length(TBILFPNew(:,1))
%     for c = 1:length(TBILFPNew(1,:))
        BlankLFPNew = [BlankLFPNew; TBILFPNew{i,c}];       
end
    BlankLFP(1:length(BlankLFPNew)) = BlankLFPNew;
    TBISpreadLFP(:,c) = BlankLFP;
    clear BlankLFP BlankLFPNew
end


%%

ShamSpreadLFPAv = nanmean(ShamSpreadLFP(:,2:11)');
ShamSpreadLFPAv(2,:) = nanstd(ShamSpreadLFP(:,2:11)')/sqrt(10);

TBISpreadLFPAv = nanmean(TBISpreadLFP(:,:)');
TBISpreadLFPAv(2,:) = nanstd(TBISpreadLFP(:,:)')/sqrt(10);

SpreadLFPTime = [-180:10:-90 0:10:90 300:10:390 600:10:690];


%%
 SxFill = [SpreadLFPTime(1:1:40) SpreadLFPTime(40:-1:1)]; 
    % y vals are SEM forward above and back below
 SyFill = [ShamSpreadLFPAv(1,1:40)+ShamSpreadLFPAv(2,1:40)];
 SyFill(41:80) = [ShamSpreadLFPAv(1,40:-1:1)-ShamSpreadLFPAv(2,40:-1:1)];

    % Repeat for TBI
 TxFill = [SpreadLFPTime(1:1:40) SpreadLFPTime(40:-1:1)]; 
    % y vals are SEM forward above and back below
 TyFill = [TBISpreadLFPAv(1,1:40)+TBISpreadLFPAv(2,1:40)];
 TyFill(41:80) = [TBISpreadLFPAv(1,40:-1:1)-TBISpreadLFPAv(2,40:-1:1)];


% Plot 
figure
f = plot(SpreadLFPTime,ShamSpreadLFPAv(1,:),'-o','MarkerSize',30,'LineWidth',10);
t = get(f,'Color');
f.MarkerFaceColor = t;
f.MarkerEdgeColor = t;
ylim([0 4])
%     if max(SyFill)>=max(TyFill)
%       ylim([0 1.2*max(SyFill)]);
%     else
%       ylim([0 1.2*max(TyFill)]);  
%     end

hold on
g = plot(SpreadLFPTime,TBISpreadLFPAv(1,:),'-s','MarkerSize',30,'LineWidth',10);
u = get(g,'Color');
g.MarkerFaceColor = u;
g.MarkerEdgeColor = u;
fill(SxFill,SyFill','b','FaceAlpha',0.2,'EdgeColor',"none");
fill(TxFill,TyFill','r','FaceAlpha',0.2,'EdgeColor',"none");
legend('Sham','HFHI','Location','NorthWest');
xlabel('Time relative to HFS (sec)');
ylabel('Relative response')
ax = gca;
ax.FontWeight = 'bold';
ax.FontSize = 40;
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %%

% %%
% 
% clear ('ax','t','c','f','g','i','ShamLFPMaxNew','ShamLFPNew','ShamFullLFP','ShamSpreadLFPAv','ShamSpreadLFPTable','SpreadLFPTime','SxFill','SyFill','TxFill','TyFill','TBIFullLFP','TBILFPMaxNew','TBILFPNew','TBISpreadLFPAv','TBISpreadLFPTable','u');


% for i = 1:length(ShamFullLFP(:,1))
%     for c = 1:length(ShamFullLFP(1,:))
%         ShamLFPMaxNew = mean(ShamFullLFP{i,1});
%         ShamLFPNew{i,c} = ShamFullLFP{i,c}/ShamLFPMaxNew;
%     end
% end
%  
% for i = 1:length(ShamLFPNew(:,1))
%     ShamBlah(i,1:length(ShamLFPNew{i,1})) = ShamLFPNew{i,1};
%     ShamBlah(i,11:10+length(ShamLFPNew{i,2})) = ShamLFPNew{i,2};
%     ShamBlah(i,21:20+length(ShamLFPNew{i,3})) = ShamLFPNew{i,3};
%     ShamBlah(i,31:30+length(ShamLFPNew{i,4})) = ShamLFPNew{i,4};
% end
% 
% ShamFullLFPNew(1,1:10) = -0.9:0.1:0;
% ShamFullLFPNew(1,11:20) = 0.1:0.1:1;
% ShamFullLFPNew(1,21:30) = 5.1:0.1:6;
% ShamFullLFPNew(1,31:40) = 10.1:0.1:11;
% ShamFullLFPNew(2,:) = mean(ShamBlah);
% ShamFullLFPNew(3,:) = std(ShamBlah);

% ShamLFPMaxNew = mean(ShamFullLFP{1,1})
% ShamLFPNew{1,1} = ShamFullLFP{1,1}/ShamLFPMaxNew