clc
clear all
close all

if ~ exist('Results')
    
    mkdir('Results')
    addpath('Results')

end

if ~ exist('SavedFigures')
    
    mkdir('SavedFigures')
    addpath('SavedFigures')

end

if ~ exist('Tables')
    
    mkdir('Tables')
    addpath('Tables')

end

% load the datasets
disp('LOAD Data')

CurrentDir=pwd;
PathLoadData=[CurrentDir filesep 'Results'];
PathSaveFigures=[CurrentDir filesep 'SavedFigures'];
PathSaveTables=[CurrentDir filesep 'Tables'];
PathSaveResults=[CurrentDir filesep 'Results'];

datasetName='Result_2.mat';

load(fullfile(PathLoadData, datasetName), 'result');

disp('Data LOADED')
pause(0.5)

%% Parameters

Cell_Types={'EXC', 'PV', 'VIP', 'SST'};

t_bef=-0.5;
t_aft=0.5;

baseline_WP=[-0.5 0];
baseline_Vm=[-0.5 -0.3];
baseline_AP=[-0.5 -0.3];

Vm_Levels_Times=[-0.5 -0.3; 0 0.2];

AP_FR_Times=[-0.5 -0.3; 0 0.2];
bin_size=0.05;
 
%% Create Result table for each cell

Cell_Table_Part2=[];

Cell_Table_Part2=table(vertcat(result.EXC.Cell_Name, result.PV.Cell_Name, result.VIP.Cell_Name, result.SST.Cell_Name), ...
        vertcat(result.EXC.Cell_Type, result.PV.Cell_Type, result.VIP.Cell_Type, result.SST.Cell_Type), ...
        vertcat(result.EXC.Cell_Depth, result.PV.Cell_Depth, result.VIP.Cell_Depth, result.SST.Cell_Depth), ...
        vertcat(result.EXC.Numb_Onset,result.PV.Numb_Onset, result.VIP.Numb_Onset,result.SST.Numb_Onset), ...
        vertcat(result.EXC.Vm_Amplitude,result.PV.Vm_Amplitude, result.VIP.Vm_Amplitude,result.SST.Vm_Amplitude), ...
        vertcat(result.EXC.AP_FiringRate,result.PV.AP_FiringRate, result.VIP.AP_FiringRate,result.SST.AP_FiringRate), ...
        'VariableNames',{'Cell_Name', 'Cell_Type', 'Cell_Depth', 'Number of Onset', 'Vm', 'Firing Rate'});

Expression=[PathSaveTables filesep 'Cell_Table_Part2.xls'];
writetable(Cell_Table_Part2, Expression)

%% Make a table for average across cell class

CellClassMeans=[];
Mean_Table_Part2=[];

Cell_Types={'EXC', 'PV', 'VIP', 'SST'};

for i=1:size(Cell_Types,2) % loop through the cell types
    
    CellClassMeans.Cell_Class{i,1}=Cell_Types{i};
    
    Delta_Firing_Rate=[];
    Delta_Firing_Rate=result.(cell2mat(Cell_Types(i))).AP_FiringRate(:,2)-result.(cell2mat(Cell_Types(i))).AP_FiringRate(:,1);
    CellClassMeans.Change_FR_Mean(i,1)=mean(Delta_Firing_Rate, 'omitnan');
    CellClassMeans.Change_FR_SD(i,1)=std(Delta_Firing_Rate, 'omitnan');
    
    Delta_Vm=[];
    Delta_Vm=result.(cell2mat(Cell_Types(i))).Vm_Amplitude(:,2)-result.(cell2mat(Cell_Types(i))).Vm_Amplitude(:,1);
    CellClassMeans.Change_Vm_Mean(i,1)=mean(Delta_Vm, 'omitnan');
    CellClassMeans.Change_Vm_SD(i,1)=std(Delta_Vm, 'omitnan');
    
end

Mean_Table_Part2=table(CellClassMeans.Cell_Class, CellClassMeans.Change_FR_Mean, CellClassMeans.Change_FR_SD,...
CellClassMeans.Change_Vm_Mean,CellClassMeans.Change_Vm_SD,...
'VariableNames',{'Cell Class', 'Change Firing Rate','± SD1', 'Change Vm','± SD2'})
Expression=[PathSaveTables filesep 'Mean_Table_Part2.xls'];
writetable(Mean_Table_Part2, Expression)


%%


cnt=1;
WP_Mtrx=[];
for i=1:size(result.EXC.Cell_Name,1)
    AVG_WP=[];
    SR_WP=[];
    bas1=[];
    bas2=[];
    AVG_WP=result.EXC.WP_avg{i,1};
    SR_WP=result.EXC.SR_WP(i,1);
    bas1=(baseline_WP(1,1)-t_bef)*SR_WP+1;
    bas2=(baseline_WP(1,2)-t_bef)*SR_WP;
    
    if isnan(AVG_WP)==0
        
       AVG_WP=AVG_WP-mean(AVG_WP(1,bas1:bas2));
       WP_Mtrx(cnt,:)=AVG_WP;
       
       cnt=cnt+1;
       
    end
    
end

GRD_AVG_EXC_WP_mean=mean(WP_Mtrx,1);
GRD_AVG_EXC_WP_sem=std(WP_Mtrx,1)/sqrt(size(WP_Mtrx,1));

cnt=1;
WP_Mtrx=[];

for i=1:size(result.PV.Cell_Name,1)
    AVG_WP=[];
    SR_WP=[];
    bas1=[];
    bas2=[];
    AVG_WP=result.PV.WP_avg{i,1};
    SR_WP=result.PV.SR_WP(i,1);
    bas1=(baseline_WP(1,1)-t_bef)*SR_WP+1;
    bas2=(baseline_WP(1,2)-t_bef)*SR_WP;
    
    if isnan(AVG_WP)==0
        
        AVG_WP=AVG_WP-mean(AVG_WP(1,bas1:bas2));
        WP_Mtrx(cnt,:)=AVG_WP;
        
        cnt=cnt+1;
        
    end
    
end

GRD_AVG_PV_WP_mean=mean(WP_Mtrx,1);
GRD_AVG_PV_WP_sem=std(WP_Mtrx,1)/sqrt(size(WP_Mtrx,1));

cnt=1;
WP_Mtrx=[];
for i=1:size(result.VIP.Cell_Name,1)
    AVG_WP=[];
    SR_WP=[];
    bas1=[];
    bas2=[];
    AVG_WP=result.VIP.WP_avg{i,1};
    SR_WP=result.VIP.SR_WP(i,1);
    bas1=(baseline_WP(1,1)-t_bef)*SR_WP+1;
    bas2=(baseline_WP(1,2)-t_bef)*SR_WP;
    
    if isnan(AVG_WP)==0
        
        AVG_WP=AVG_WP-mean(AVG_WP(1,bas1:bas2));
        WP_Mtrx(cnt,:)=AVG_WP;
        
        cnt=cnt+1;
    end
    
end

GRD_AVG_VIP_WP_mean=mean(WP_Mtrx,1);
GRD_AVG_VIP_WP_sem=std(WP_Mtrx,1)/sqrt(size(WP_Mtrx,1));

cnt=1;
WP_Mtrx=[];

for i=1:size(result.SST.Cell_Name,1)
   AVG_WP=[];
    SR_WP=[];
    bas1=[];
    bas2=[];
    AVG_WP=result.SST.WP_avg{i,1};
    SR_WP=result.SST.SR_WP(i,1);
    bas1=(baseline_WP(1,1)-t_bef)*SR_WP+1;
    bas2=(baseline_WP(1,2)-t_bef)*SR_WP;
    
    if isnan(AVG_WP)==0
        
        AVG_WP=AVG_WP-mean(AVG_WP(1,bas1:bas2));
        WP_Mtrx(cnt,:)=AVG_WP;
        
        cnt=cnt+1;
    end
    
end

GRD_AVG_SST_WP_mean=mean(WP_Mtrx,1);
GRD_AVG_SST_WP_sem=std(WP_Mtrx,1)/sqrt(size(WP_Mtrx,1));

%

cnt=1;
Vm_Mtrx=[];

for i=1:size(result.EXC.Cell_Name,1)
    
    AVG_Vm=[];
    SR_Vm=[];
    bas1=[];
    bas2=[];
    AVG_Vm=result.EXC.Vm_avg{i,1};
    SR_Vm=result.EXC.SR_Vm(i,1);
    
    bas1=round((baseline_Vm(1,1)-t_bef)*SR_Vm+1);
    bas2=round((baseline_Vm(1,2)-t_bef)*SR_Vm);

    if isnan(AVG_Vm)==0
        
        AVG_Vm=AVG_Vm-mean(AVG_Vm(1,bas1:bas2));
        Vm_Mtrx(cnt,:)=AVG_Vm; 
        
        cnt=cnt+1;
    end
    
end

GRD_AVG_EXC_Vm_mean=mean(Vm_Mtrx,1);
GRD_AVG_EXC_Vm_sem=std(Vm_Mtrx,1)/sqrt(size(Vm_Mtrx,1));


cnt=1;
Vm_Mtrx=[];

for i=1:size(result.PV.Cell_Name,1)
    AVG_Vm=[];
    SR_Vm=[];
    bas1=[];
    bas2=[];
    AVG_Vm=result.PV.Vm_avg{i,1};
    SR_Vm=result.PV.SR_Vm(i,1);
    
    bas1=round((baseline_Vm(1,1)-t_bef)*SR_Vm+1);
    bas2=round((baseline_Vm(1,2)-t_bef)*SR_Vm);
    
    if isnan(AVG_Vm)==0
        
        AVG_Vm=AVG_Vm-mean(AVG_Vm(1,bas1:bas2));          
        Vm_Mtrx(cnt,:)=AVG_Vm;
      
        cnt=cnt+1;
    end
    
end

GRD_AVG_PV_Vm_mean=mean(Vm_Mtrx,1);
GRD_AVG_PV_Vm_sem=std(Vm_Mtrx,1)/sqrt(size(Vm_Mtrx,1));

cnt=1;
Vm_Mtrx=[];

for i=1:size(result.VIP.Cell_Name,1)
    AVG_Vm=[];
    SR_Vm=[];
    bas1=[];
    bas2=[];
    AVG_Vm=result.VIP.Vm_avg{i,1};
    SR_Vm=result.VIP.SR_Vm(i,1);
    
    bas1=round((baseline_Vm(1,1)-t_bef)*SR_Vm+1);
    bas2=round((baseline_Vm(1,2)-t_bef)*SR_Vm);
   
    if isnan(AVG_Vm)==0
        
        AVG_Vm=AVG_Vm-mean(AVG_Vm(1,bas1:bas2));  
        Vm_Mtrx(cnt,:)=AVG_Vm;
                
        cnt=cnt+1;
    end
    
end

GRD_AVG_VIP_Vm_mean=mean(Vm_Mtrx,1);
GRD_AVG_VIP_Vm_sem=std(Vm_Mtrx,1)/sqrt(size(Vm_Mtrx,1));


cnt=1;
Vm_Mtrx=[];

for i=1:size(result.SST.Cell_Name,1)
    AVG_Vm=[];
    SR_Vm=[];
    bas1=[];
    bas2=[];
    AVG_Vm=result.SST.Vm_avg{i,1};
    SR_Vm=result.SST.SR_Vm(i,1);
    
    bas1=round((baseline_Vm(1,1)-t_bef)*SR_Vm+1);
    bas2=round((baseline_Vm(1,2)-t_bef)*SR_Vm);
        
    if isnan(AVG_Vm)==0
        
        AVG_Vm=AVG_Vm-mean(AVG_Vm(1,bas1:bas2));            
        Vm_Mtrx(cnt,:)=AVG_Vm;
       
        cnt=cnt+1;
        
    end
    
end

GRD_AVG_SST_Vm_mean=mean(Vm_Mtrx,1);
GRD_AVG_SST_Vm_sem=std(Vm_Mtrx,1)/sqrt(size(Vm_Mtrx,1));

%
cnt=1;
AP_Mtrx=[];

for i=1:size(result.EXC.Cell_Name,1)
    
    AVG_AP=[];
    SR_Vm=[];
    bas1=[];
    bas2=[];
    AVG_AP=result.EXC.AP_avg{i,1};
    SR_Vm=result.EXC.SR_Vm(i,1);
    
    bas1=round((baseline_Vm(1,1)-t_bef)*SR_Vm+1);
    bas2=round((baseline_Vm(1,2)-t_bef)*SR_Vm);
    
    if isnan(AVG_AP)==0
        
         AVG_AP=AVG_AP-mean(AVG_AP(1,bas1:bas2));
        
        AP_PSTH=[];
       [AP_PSTH]=function_PSTH(AVG_AP', SR_Vm,t_bef, t_aft, bin_size);
 
        AP_Mtrx(cnt,:)=AP_PSTH(:,2)';       
        cnt=cnt+1;
    end
    
end

GRD_AVG_EXC_AP_mean=mean(AP_Mtrx,1);
GRD_AVG_EXC_AP_sem=std(AP_Mtrx,1)/sqrt(size(AP_Mtrx,1));

%

cnt=1;
AP_Mtrx=[];

for i=1:size(result.PV.Cell_Name,1)
    
    AVG_AP=[];
    SR_Vm=[];
    bas1=[];
    bas2=[];
    AVG_AP=result.PV.AP_avg{i,1};
    SR_Vm=result.PV.SR_Vm(i,1);
    
    bas1=round((baseline_Vm(1,1)-t_bef)*SR_Vm+1);
    bas2=round((baseline_Vm(1,2)-t_bef)*SR_Vm);
    
    if isnan(AVG_AP)==0
        
        AVG_AP=AVG_AP-mean(AVG_AP(1,bas1:bas2));
        
        AP_PSTH=[];
       [AP_PSTH]=function_PSTH(AVG_AP', SR_Vm,t_bef, t_aft, bin_size);
        
        AP_Mtrx(cnt,:)=AP_PSTH(:,2)';       
        cnt=cnt+1;
    end
    
end

GRD_AVG_PV_AP_mean=mean(AP_Mtrx,1);
GRD_AVG_PV_AP_sem=std(AP_Mtrx,1)/sqrt(size(AP_Mtrx,1));

%

cnt=1;
AP_Mtrx=[];

for i=1:size(result.VIP.Cell_Name,1)
    
    AVG_AP=[];
    SR_Vm=[];
    bas1=[];
    bas2=[];
    AVG_AP=result.VIP.AP_avg{i,1};
    SR_Vm=result.VIP.SR_Vm(i,1);
    
    bas1=round((baseline_Vm(1,1)-t_bef)*SR_Vm+1);
    bas2=round((baseline_Vm(1,2)-t_bef)*SR_Vm);
    
    if isnan(AVG_AP)==0
        
        AVG_AP=AVG_AP-mean(AVG_AP(1,bas1:bas2));
        
        AP_PSTH=[];
       [AP_PSTH]=function_PSTH(AVG_AP', SR_Vm,t_bef, t_aft, bin_size);
    
        AP_Mtrx(cnt,:)=AP_PSTH(:,2)';       
        cnt=cnt+1;
    end
    
end

GRD_AVG_VIP_AP_mean=mean(AP_Mtrx,1);
GRD_AVG_VIP_AP_sem=std(AP_Mtrx,1)/sqrt(size(AP_Mtrx,1));

%

cnt=1;
AP_Mtrx=[];

for i=1:size(result.SST.Cell_Name,1)
    
    AVG_AP=[];
    SR_Vm=[];
    bas1=[];
    bas2=[];
    AVG_AP=result.SST.AP_avg{i,1};
    SR_Vm=result.SST.SR_Vm(i,1);
    
    bas1=round((baseline_Vm(1,1)-t_bef)*SR_Vm+1);
    bas2=round((baseline_Vm(1,2)-t_bef)*SR_Vm);
    
    if isnan(AVG_AP)==0
        
        AVG_AP=AVG_AP-mean(AVG_AP(1,bas1:bas2));
        
        AP_PSTH=[];
       [AP_PSTH]=function_PSTH(AVG_AP', SR_Vm,t_bef, t_aft, bin_size);
           
        AP_Mtrx(cnt,:)=AP_PSTH(:,2)';       
        cnt=cnt+1;
    end
    
end

GRD_AVG_SST_AP_mean=mean(AP_Mtrx,1);
GRD_AVG_SST_AP_sem=std(AP_Mtrx,1)/sqrt(size(AP_Mtrx,1));


%%

WP_Range=[-2 15];
Vm_Range=[-0.003 0.005];
AP_Range=[-10 20];

GRD_AVG_EXC_WP_mean_sup=GRD_AVG_EXC_WP_mean+GRD_AVG_EXC_WP_sem;
GRD_AVG_EXC_WP_mean_inf=GRD_AVG_EXC_WP_mean-GRD_AVG_EXC_WP_sem;

GRD_AVG_PV_WP_mean_sup=GRD_AVG_PV_WP_mean+GRD_AVG_PV_WP_sem;
GRD_AVG_PV_WP_mean_inf=GRD_AVG_PV_WP_mean-GRD_AVG_PV_WP_sem;

GRD_AVG_VIP_WP_mean_sup=GRD_AVG_VIP_WP_mean+GRD_AVG_VIP_WP_sem;
GRD_AVG_VIP_WP_mean_inf=GRD_AVG_VIP_WP_mean-GRD_AVG_VIP_WP_sem;

GRD_AVG_SST_WP_mean_sup=GRD_AVG_SST_WP_mean+GRD_AVG_SST_WP_sem;
GRD_AVG_SST_WP_mean_inf=GRD_AVG_SST_WP_mean-GRD_AVG_SST_WP_sem;

GRD_AVG_EXC_Vm_mean_sup=GRD_AVG_EXC_Vm_mean+GRD_AVG_EXC_Vm_sem;
GRD_AVG_EXC_Vm_mean_inf=GRD_AVG_EXC_Vm_mean-GRD_AVG_EXC_Vm_sem;

GRD_AVG_PV_Vm_mean_sup=GRD_AVG_PV_Vm_mean+GRD_AVG_PV_Vm_sem;
GRD_AVG_PV_Vm_mean_inf=GRD_AVG_PV_Vm_mean-GRD_AVG_PV_Vm_sem;

GRD_AVG_VIP_Vm_mean_sup=GRD_AVG_VIP_Vm_mean+GRD_AVG_VIP_Vm_sem;
GRD_AVG_VIP_Vm_mean_inf=GRD_AVG_VIP_Vm_mean-GRD_AVG_VIP_Vm_sem;

GRD_AVG_SST_Vm_mean_sup=GRD_AVG_SST_Vm_mean+GRD_AVG_SST_Vm_sem;
GRD_AVG_SST_Vm_mean_inf=GRD_AVG_SST_Vm_mean-GRD_AVG_SST_Vm_sem;

GRD_AVG_EXC_AP_mean_sup=GRD_AVG_EXC_AP_mean+GRD_AVG_EXC_AP_sem;
GRD_AVG_EXC_AP_mean_inf=GRD_AVG_EXC_AP_mean-GRD_AVG_EXC_AP_sem;

GRD_AVG_PV_AP_mean_sup=GRD_AVG_PV_AP_mean+GRD_AVG_PV_AP_sem;
GRD_AVG_PV_AP_mean_inf=GRD_AVG_PV_AP_mean-GRD_AVG_PV_AP_sem;

GRD_AVG_VIP_AP_mean_sup=GRD_AVG_VIP_AP_mean+GRD_AVG_VIP_AP_sem;
GRD_AVG_VIP_AP_mean_inf=GRD_AVG_VIP_AP_mean-GRD_AVG_VIP_AP_sem;

GRD_AVG_SST_AP_mean_sup=GRD_AVG_SST_AP_mean+GRD_AVG_SST_AP_sem;
GRD_AVG_SST_AP_mean_inf=GRD_AVG_SST_AP_mean-GRD_AVG_SST_AP_sem;

time_vect_AP=AP_PSTH(:,1);
time_vect_wp=linspace(t_bef,t_aft,size(GRD_AVG_EXC_WP_mean,2));
time_vect_vm=linspace(t_bef,t_aft,size(GRD_AVG_EXC_Vm_mean,2));

figure('Position', [100 100 1200 800])

subplot(3,4,1)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],WP_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
plot(time_vect_wp, GRD_AVG_EXC_WP_mean_inf, 'color', [0 0.8 0], 'LineWidth', 0.5)
hold on
plot(time_vect_wp, GRD_AVG_EXC_WP_mean_sup, 'color', [0 0.8 0], 'LineWidth', 0.5)
hold on
plot(time_vect_wp, GRD_AVG_EXC_WP_mean, 'color', [0 0.5 0], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim(WP_Range)
xlim([-0.5 0.5])
Graph_Title=['EXC'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('deg') % label the x axis


subplot(3,4,2)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],WP_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
plot(time_vect_wp, GRD_AVG_PV_WP_mean_inf, 'color', [0 0.8 0], 'LineWidth', 0.5)
hold on
plot(time_vect_wp, GRD_AVG_PV_WP_mean_sup, 'color', [0 0.8 0], 'LineWidth', 0.5)
hold on
plot(time_vect_wp, GRD_AVG_PV_WP_mean, 'color', [0 0.5 0], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim(WP_Range)
xlim([-0.5 0.5])
Graph_Title=['PV'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('deg') % label the x axis


subplot(3,4,3)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],WP_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
plot(time_vect_wp, GRD_AVG_VIP_WP_mean_inf, 'color', [0 0.8 0], 'LineWidth', 0.5)
hold on
plot(time_vect_wp, GRD_AVG_VIP_WP_mean_sup, 'color', [0 0.8 0], 'LineWidth', 0.5)
hold on
plot(time_vect_wp, GRD_AVG_VIP_WP_mean, 'color', [0 0.5 0], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim(WP_Range)
xlim([-0.5 0.5])
Graph_Title=['VIP'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('deg') % label the x axis

subplot(3,4,4)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],WP_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
plot(time_vect_wp, GRD_AVG_SST_WP_mean_inf, 'color', [0 0.8 0], 'LineWidth', 0.5)
hold on
plot(time_vect_wp, GRD_AVG_SST_WP_mean_sup, 'color', [0 0.8 0], 'LineWidth', 0.5)
hold on
plot(time_vect_wp, GRD_AVG_SST_WP_mean, 'color', [0 0.5 0], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim(WP_Range)
xlim([-0.5 0.5])
Graph_Title=['SST'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('deg') % label the x axis

subplot(3,4,5)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],Vm_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
plot(time_vect_vm, GRD_AVG_EXC_Vm_mean_inf, 'color', [0.5 0.5 0.5], 'LineWidth', 0.5)
hold on
plot(time_vect_vm, GRD_AVG_EXC_Vm_mean_sup, 'color', [0.5 0.5 0.5], 'LineWidth', 0.5)
hold on
plot(time_vect_vm, GRD_AVG_EXC_Vm_mean, 'color', [0 0 0], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim(Vm_Range)
xlim([-0.5 0.5])
Graph_Title=['EXC'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('Vm (V)') % label the y axis

subplot(3,4,6)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],Vm_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
plot(time_vect_vm, GRD_AVG_PV_Vm_mean_inf, 'color', [1 0.5 0.5], 'LineWidth', 0.5)
hold on
plot(time_vect_vm, GRD_AVG_PV_Vm_mean_sup, 'color', [1 0.5 0.5], 'LineWidth', 0.5)
hold on
plot(time_vect_vm, GRD_AVG_PV_Vm_mean, 'color', [1 0 0], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim(Vm_Range)
xlim([-0.5 0.5])
Graph_Title=['PV'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('Vm (V)') % label the y axis

subplot(3,4,7)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],Vm_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
plot(time_vect_vm, GRD_AVG_VIP_Vm_mean_inf, 'color', [0.5 0.5 1], 'LineWidth', 0.5)
hold on
plot(time_vect_vm, GRD_AVG_VIP_Vm_mean_sup, 'color', [0.5 0.5 1], 'LineWidth', 0.5)
hold on
plot(time_vect_vm, GRD_AVG_VIP_Vm_mean, 'color', [0 0 1], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim(Vm_Range)
xlim([-0.5 0.5])
Graph_Title=['VIP'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('Vm (V)') % label the y axis

subplot(3,4,8)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],Vm_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
plot(time_vect_vm, GRD_AVG_SST_Vm_mean_inf, 'color', [1 0.8 0.5], 'LineWidth', 0.5)
hold on
plot(time_vect_vm, GRD_AVG_SST_Vm_mean_sup, 'color', [1 0.8 0.5], 'LineWidth', 0.5)
hold on
plot(time_vect_vm, GRD_AVG_SST_Vm_mean, 'color', [1 0.5 0], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim(Vm_Range)
xlim([-0.5 0.5])
Graph_Title=['SST'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('Vm (V)') % label the y axis

subplot(3,4,9)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],AP_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
stairs(time_vect_AP, GRD_AVG_EXC_AP_mean_inf, 'color', [0.5 0.5 0.5], 'LineWidth', 0.5)
hold on
stairs(time_vect_AP, GRD_AVG_EXC_AP_mean_sup, 'color', [0.5 0.5 0.5], 'LineWidth', 0.5)
hold on
stairs(time_vect_AP, GRD_AVG_EXC_AP_mean, 'color', [0 0 0], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim(AP_Range)
xlim([-0.5 0.5])
Graph_Title=['EXC'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('FR (Hz)') % label the y axis

subplot(3,4,10)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],AP_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
stairs(time_vect_AP, GRD_AVG_PV_AP_mean_inf, 'color', [1 0.5 0.5], 'LineWidth', 0.5)
hold on
stairs(time_vect_AP, GRD_AVG_PV_AP_mean_sup, 'color', [1 0.5 0.5], 'LineWidth', 0.5)
hold on
stairs(time_vect_AP, GRD_AVG_PV_AP_mean, 'color', [1 0 0], 'LineWidth', 1)


ax = gca;
ax.TickDir = 'out';
ylim(AP_Range)
xlim([-0.5 0.5])
Graph_Title=['PV'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('FR (Hz)') % label the y axis

subplot(3,4,11)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],AP_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
stairs(time_vect_AP, GRD_AVG_VIP_AP_mean_inf, 'color', [0.5 0.5 1], 'LineWidth', 0.5)
hold on
stairs(time_vect_AP, GRD_AVG_VIP_AP_mean_sup, 'color', [0.5 0.5 1], 'LineWidth', 0.5)
hold on
stairs(time_vect_AP, GRD_AVG_VIP_AP_mean, 'color', [0 0 1], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim([AP_Range])
xlim([-0.5 0.5])
Graph_Title=['VIP'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('FR (Hz)') % label the y axis

subplot(3,4,12)
plot([-0.5 0.5],[0 0], '--', 'color', [0.5 0.5 0.5], 'LineWidth', 1)
hold on
plot([0 0],AP_Range, 'color', [0 0.5 0], 'LineWidth', 1)
hold on
stairs(time_vect_AP, GRD_AVG_SST_AP_mean_inf, 'color', [1 0.8 0.5], 'LineWidth', 0.5)
hold on
stairs(time_vect_AP, GRD_AVG_SST_AP_mean_sup, 'color', [1 0.8 0.5], 'LineWidth', 0.5)
hold on
stairs(time_vect_AP, GRD_AVG_SST_AP_mean, 'color', [1 0.5 0], 'LineWidth', 1)

ax = gca;
ax.TickDir = 'out';
ylim(AP_Range)
xlim([-0.5 0.5])
Graph_Title=['SST'];
title(Graph_Title) % write the tittle of the graph
xlabel('Time (s)') % label the x axis
ylabel('FR (Hz)') % label the y axis

%% SAVE THE RESULT FIGURES

disp('Saving Figure')
pause(0.5)

Expression=[PathSaveFigures filesep '9_WhiskOnset_GRD_AVG'];

print('-painters', '-depsc', Expression) % save in eps format
print('-painters', '-djpeg', Expression) % save in jpeg fornat

disp('DONE')
pause(0.5)

%% Plot Vm change at whisking onset

Vm_Amp_EXC=[];
Vm_Amp_EXC=result.EXC.Vm_Amplitude(:,2)-result.EXC.Vm_Amplitude(:,1);
Vm_Amp_PV=[];
Vm_Amp_PV=result.PV.Vm_Amplitude(:,2)-result.PV.Vm_Amplitude(:,1);
Vm_Amp_VIP=[];
Vm_Amp_VIP=result.VIP.Vm_Amplitude(:,2)-result.VIP.Vm_Amplitude(:,1);
Vm_Amp_SST=[];
Vm_Amp_SST=result.SST.Vm_Amplitude(:,2)-result.SST.Vm_Amplitude(:,1);

Vm_Amp_EXC_vect=[];
Vm_Amp_PV_vect=[];
Vm_Amp_VIP_vect=[];
Vm_Amp_SST_vect=[];

Vm_Amp_EXC_vect(1:size(Vm_Amp_EXC,1),1)=1.2;
Vm_Amp_PV_vect(1:size(Vm_Amp_PV,1),1)=2.2;
Vm_Amp_VIP_vect(1:size(Vm_Amp_VIP,1),1)=3.2;
Vm_Amp_SST_vect(1:size(Vm_Amp_SST,1),1)=4.2;

Vm_Amp_EXC_vect=Vm_Amp_EXC_vect-rand(length(Vm_Amp_EXC),1)./3;
Vm_Amp_PV_vect=Vm_Amp_PV_vect-rand(length(Vm_Amp_PV),1)./3;
Vm_Amp_VIP_vect=Vm_Amp_VIP_vect-rand(length(Vm_Amp_VIP),1)./3;
Vm_Amp_SST_vect=Vm_Amp_SST_vect-rand(length(Vm_Amp_SST),1)./3;

figure
plot([0 5], [0 0], 'color', [0 0 0])
hold on
plot(Vm_Amp_EXC_vect, Vm_Amp_EXC, 'o', 'color', [0 0 0])
hold on
errorbar([1.5],mean(Vm_Amp_EXC,1, 'omitnan'), std(Vm_Amp_EXC,1, 'omitnan'), 'o', 'Markersize', 10, 'color', [0 0 0])
hold on
plot(Vm_Amp_PV_vect, Vm_Amp_PV, 'o', 'color', [1 0 0])
hold on
errorbar([2.5],mean(Vm_Amp_PV,1, 'omitnan'), std(Vm_Amp_PV,1, 'omitnan'), 'o', 'Markersize', 10, 'color', [1 0 0])
hold on
plot(Vm_Amp_VIP_vect, Vm_Amp_VIP, 'o', 'color', [0 0 1])
hold on
errorbar([3.5],mean(Vm_Amp_VIP,1, 'omitnan'), std(Vm_Amp_VIP,1, 'omitnan'), 'o', 'Markersize', 10, 'color', [0 0 1])
hold on
plot(Vm_Amp_SST_vect, Vm_Amp_SST, 'o', 'color', [1 0.5 0])
hold on
errorbar([4.5],mean(Vm_Amp_SST,1, 'omitnan'), std(Vm_Amp_SST,1, 'omitnan'), 'o', 'Markersize', 10, 'color', [1 0.5 0])


ax = gca;
ax.TickDir = 'out';
ylim([-0.01 0.015])
xlim([0.5 5])
ax.XTick=[1, 2, 3, 4];
ax.XTickLabels={'EXC', 'PV', 'VIP', 'SST'};
Graph_Title=['Whisking onset Vm change'];
title(Graph_Title) % write the tittle of the graph
ylabel('Vm (V)') % label the y axis

p_val_EXC=signrank(Vm_Amp_EXC);
N_EXC=size(Vm_Amp_EXC,1)-sum(isnan(Vm_Amp_EXC));
expression=['N= ',num2str(N_EXC), ' ; p=', num2str(p_val_EXC)];
text(ax, 0.8,0.014,expression, 'FontSize',8)

p_val_PV=signrank(Vm_Amp_PV);
N_PV=size(Vm_Amp_PV,1)-sum(isnan(Vm_Amp_PV));
expression=['N= ',num2str(N_PV), ' ; p=', num2str(p_val_PV)];
text(ax, 1.8,0.012,expression, 'FontSize',8)

p_val_VIP=signrank(Vm_Amp_VIP);
N_VIP=size(Vm_Amp_VIP,1)-sum(isnan(Vm_Amp_VIP));
expression=['N= ',num2str(N_VIP), ' ; p=', num2str(p_val_VIP)];
text(ax, 2.8,0.014,expression, 'FontSize',8)

p_val_SST=signrank(Vm_Amp_SST);
N_SST=size(Vm_Amp_SST,1)-sum(isnan(Vm_Amp_SST));
expression=['N= ',num2str(N_SST), ' ; p=', num2str(p_val_SST)];
text(ax, 3.8,0.012,expression, 'FontSize',8)

%% SAVE THE RESULT FIGURES

disp('Saving Figure')
pause(0.5)

Expression=[PathSaveFigures filesep '10_WhiskOnset_Vm_Amplitude'];

print('-painters', '-depsc', Expression) % save in eps format
print('-painters', '-djpeg', Expression) % save in jpeg fornat

disp('DONE')
pause(0.5)

%% Compare change in Vm across cells

Vm_Amp_Mean(1,1)=mean(Vm_Amp_EXC, 'omitnan');
Vm_Amp_Mean(2,1)=mean(Vm_Amp_PV, 'omitnan');
Vm_Amp_Mean(3,1)=mean(Vm_Amp_VIP, 'omitnan');
Vm_Amp_Mean(4,1)=mean(Vm_Amp_SST, 'omitnan');

Vm_Amp_Mean(1,2)=std(Vm_Amp_EXC, 'omitnan');
Vm_Amp_Mean(2,2)=std(Vm_Amp_PV, 'omitnan');
Vm_Amp_Mean(3,2)=std(Vm_Amp_VIP, 'omitnan');
Vm_Amp_Mean(4,2)=std(Vm_Amp_SST, 'omitnan');


Group_All=[];
Vm_Amp_All=[];

KW_p_Vm_Amp=[];
NPMC_Vm_Amp=[];

Group_All=[ones(1,length(result.EXC.Cell_Name)) repmat(2,1,length(result.PV.Cell_Name)) repmat(3,1,length(result.VIP.Cell_Name)) repmat(4,1,length(result.SST.Cell_Name))]';
Vm_Amp_All=vertcat(Vm_Amp_EXC, Vm_Amp_PV, Vm_Amp_VIP,Vm_Amp_SST);

stats=[];
[KW_p_Vm_Amp,tbl,stats] = kruskalwallis(Vm_Amp_All, Group_All, 'off');
NPMC_Vm_Amp = multcompare(stats, Display="off");

MPMC_p_Vm_Amp_EXC_PV=NPMC_Vm_Amp(1,6);
MPMC_p_Vm_Amp_EXC_VIP=NPMC_Vm_Amp(2,6);
MPMC_p_Vm_Amp_EXC_SST=NPMC_Vm_Amp(3,6);
MPMC_p_Vm_Amp_PV_VIP=NPMC_Vm_Amp(4,6);
MPMC_p_Vm_Amp_PV_SST=NPMC_Vm_Amp(5,6);
MPMC_p_Vm_Amp_VIP_SST=NPMC_Vm_Amp(6,6);

disp('Compare Change in Vm between cell types')
disp(['P value EXC vs PV =' num2str(NPMC_Vm_Amp(1,6))]);
disp(['P value EXC vs VIP =' num2str(NPMC_Vm_Amp(2,6))]);
disp(['P value EXC vs SST =' num2str(NPMC_Vm_Amp(3,6))]);
disp(['P value PV vs VIP =' num2str(NPMC_Vm_Amp(4,6))]);
disp(['P value PV vs SST =' num2str(NPMC_Vm_Amp(5,6))]);
disp(['P value VIP vs SST =' num2str(NPMC_Vm_Amp(6,6))]);

%%

AP_Amp_EXC=[];
AP_Amp_EXC=result.EXC.AP_FiringRate(:,2)-result.EXC.AP_FiringRate(:,1);
AP_Amp_PV=[];
AP_Amp_PV=result.PV.AP_FiringRate(:,2)-result.PV.AP_FiringRate(:,1);
AP_Amp_VIP=[];
AP_Amp_VIP=result.VIP.AP_FiringRate(:,2)-result.VIP.AP_FiringRate(:,1);
AP_Amp_SST=[];
AP_Amp_SST=result.SST.AP_FiringRate(:,2)-result.SST.AP_FiringRate(:,1);

AP_Amp_EXC_vect=[];
AP_Amp_PV_vect=[];
AP_Amp_VIP_vect=[];
AP_Amp_SST_vect=[];

AP_Amp_EXC_vect(1:size(AP_Amp_EXC,1),1)=1.2;
AP_Amp_PV_vect(1:size(AP_Amp_PV,1),1)=2.2;
AP_Amp_VIP_vect(1:size(AP_Amp_VIP,1),1)=3.2;
AP_Amp_SST_vect(1:size(AP_Amp_SST,1),1)=4.2;

AP_Amp_EXC_vect=AP_Amp_EXC_vect-rand(length(AP_Amp_EXC_vect),1)./3;
AP_Amp_PV_vect=AP_Amp_PV_vect-rand(length(AP_Amp_PV_vect),1)./3;
AP_Amp_VIP_vect=AP_Amp_VIP_vect-rand(length(AP_Amp_VIP_vect),1)./3;
AP_Amp_SST_vect=AP_Amp_SST_vect-rand(length(AP_Amp_SST_vect),1)./3;

figure
plot([0 5], [0 0],'--', 'color', [0.5 0.5 0.5])
hold on
plot(AP_Amp_EXC_vect, AP_Amp_EXC, 'o', 'color', [0 0 0])
hold on
errorbar([1.5],mean(AP_Amp_EXC,1, 'omitnan'), std(AP_Amp_EXC,1, 'omitnan'), 'o', 'Markersize', 10, 'color', [0 0 0])
hold on
plot(AP_Amp_PV_vect, AP_Amp_PV, 'o', 'color', [1 0 0])
hold on
errorbar([2.5],mean(AP_Amp_PV,1, 'omitnan'), std(AP_Amp_PV,1, 'omitnan'), 'o', 'Markersize', 10, 'color', [1 0 0])
hold on
plot(AP_Amp_VIP_vect, AP_Amp_VIP, 'o', 'color', [0 0 1])
hold on
errorbar([3.5],mean(AP_Amp_VIP,1, 'omitnan'), std(AP_Amp_VIP,1, 'omitnan'), 'o', 'Markersize', 10, 'color', [0 0 1])
hold on
plot(AP_Amp_SST_vect, AP_Amp_SST, 'o', 'color', [1 0.5 0])
hold on
errorbar([4.5],mean(AP_Amp_SST,1, 'omitnan'), std(AP_Amp_SST,1, 'omitnan'), 'o', 'Markersize', 10, 'color', [1 0.5 0])

ax = gca;
ax.TickDir = 'out';
ylim([-30 60])
xlim([0.5 5])
ax.XTick=[1, 2, 3, 4];
ax.XTickLabels={'EXC', 'PV', 'VIP', 'SST'};
Graph_Title=['Whisking onset delta FR'];
title(Graph_Title) % write the tittle of the graph
ylabel('FR (Hz)') % label the y axis

p_val_EXC=signrank(AP_Amp_EXC);
N_EXC=size(AP_Amp_EXC,1)-sum(isnan(AP_Amp_EXC));
expression=['N= ',num2str(N_EXC), ' ; p=', num2str(p_val_EXC)];
text(ax, 0.8,20,expression, 'FontSize',8)

p_val_PV=signrank(AP_Amp_PV);
N_PV=size(AP_Amp_PV,1)-sum(isnan(AP_Amp_PV));
expression=['N= ',num2str(N_PV), ' ; p=', num2str(p_val_PV)];
text(ax, 1.8,58,expression, 'FontSize',8)

p_val_VIP=signrank(AP_Amp_VIP);
N_VIP=size(AP_Amp_VIP,1)-sum(isnan(AP_Amp_VIP));
expression=['N= ',num2str(N_VIP), ' ; p=', num2str(p_val_VIP)];
text(ax, 2.8,40,expression, 'FontSize',8)

p_val_SST=signrank(AP_Amp_SST);
N_SST=size(AP_Amp_SST,1)-sum(isnan(AP_Amp_SST));
expression=['N= ',num2str(N_SST), ' ; p=', num2str(p_val_SST)];
text(ax, 3.8,50,expression, 'FontSize',8)

%% SAVE THE RESULT FIGURES

disp('Saving Figure')
pause(0.5)

Expression=[PathSaveFigures filesep '11_WhiskOnset_DeltaFR'];

print('-painters', '-depsc', Expression) % save in eps format
print('-painters', '-djpeg', Expression) % save in jpeg fornat

disp('DONE')
pause(0.5)


%% Compare change in Vm across cells

AP_Amp_Mean(1,1)=mean(AP_Amp_EXC, 'omitnan');
AP_Amp_Mean(2,1)=mean(AP_Amp_PV, 'omitnan');
AP_Amp_Mean(3,1)=mean(AP_Amp_VIP, 'omitnan');
AP_Amp_Mean(4,1)=mean(AP_Amp_SST, 'omitnan');

AP_Amp_Mean(1,2)=std(AP_Amp_EXC, 'omitnan');
AP_Amp_Mean(2,2)=std(AP_Amp_PV, 'omitnan');
AP_Amp_Mean(3,2)=std(AP_Amp_VIP, 'omitnan');
AP_Amp_Mean(4,2)=std(AP_Amp_SST, 'omitnan');


Group_All=[];
AP_Amp_All=[];

KW_p_AP_Amp=[];
NPMC_AP_Amp=[];

Group_All=[ones(1,length(result.EXC.Cell_Name)) repmat(2,1,length(result.PV.Cell_Name)) repmat(3,1,length(result.VIP.Cell_Name)) repmat(4,1,length(result.SST.Cell_Name))]';
AP_Amp_All=vertcat(AP_Amp_EXC, AP_Amp_PV, AP_Amp_VIP, AP_Amp_SST);

stats=[];
[KW_p_AP_Amp,tbl,stats] = kruskalwallis(AP_Amp_All, Group_All, "off");
NPMC_AP_Amp = multcompare(stats, Display="off");

disp('Compare Change in FR between cell types')
disp(['P value EXC vs PV =' num2str(NPMC_AP_Amp(1,6))]);
disp(['P value EXC vs VIP =' num2str(NPMC_AP_Amp(2,6))]);
disp(['P value EXC vs SST =' num2str(NPMC_AP_Amp(3,6))]);
disp(['P value PV vs VIP =' num2str(NPMC_AP_Amp(4,6))]);
disp(['P value PV vs SST =' num2str(NPMC_AP_Amp(5,6))]);
disp(['P value VIP vs SST =' num2str(NPMC_AP_Amp(6,6))]);


%%

Vm_Amp_EXC=Vm_Amp_EXC(~isnan(Vm_Amp_EXC));
AP_Amp_EXC=AP_Amp_EXC(~isnan(AP_Amp_EXC));
[R_EXC P_EXC]=corrcoef(Vm_Amp_EXC, AP_Amp_EXC);

Vm_Amp_PV=Vm_Amp_PV(~isnan(Vm_Amp_PV));
AP_Amp_PV=AP_Amp_PV(~isnan(AP_Amp_PV));
[R_PV P_PV]=corrcoef(Vm_Amp_PV, AP_Amp_PV);

Vm_Amp_VIP=Vm_Amp_VIP(~isnan(Vm_Amp_VIP));
AP_Amp_VIP=AP_Amp_VIP(~isnan(AP_Amp_VIP));
[R_VIP P_VIP]=corrcoef(Vm_Amp_VIP, AP_Amp_VIP);

Vm_Amp_SST=Vm_Amp_SST(~isnan(Vm_Amp_SST));
AP_Amp_SST=AP_Amp_SST(~isnan(AP_Amp_SST));
[R_SST P_SST]=corrcoef(Vm_Amp_SST, AP_Amp_SST);

figure('position', [200 200 800 800])
fx1=fit(Vm_Amp_EXC, AP_Amp_EXC, 'poly1')

subplot(2,2,1)
plot(Vm_Amp_EXC, AP_Amp_EXC, 'o', 'color', [0 0 0])
hold on
plot([0 0],[-20 70], 'color', [0 0 0])
hold on
plot([-0.01 0.015],[0 0], 'color', [0 0 0])
hold on
plot(fx1, 'b')

ax = gca;
ax.TickDir = 'out';
xlim([-0.01 0.015])
ylim([-20 70])
Graph_Title=['EXC'];
title(Graph_Title) % write the tittle of the graph
xlabel('Delta Vm (V)') % label the x axis
ylabel('Delta FR (Hz)') % label the y axis
expression=['r=', num2str(R_EXC(1,2))];
text(ax, -0.008, 60, expression, 'FontSize',8)
expression=['p=',num2str(P_EXC(1,2))];
text(ax, -0.008, 50, expression, 'FontSize',8)

%
fx2=fit(Vm_Amp_PV, AP_Amp_PV, 'poly1');
subplot(2,2,2)
plot(Vm_Amp_PV, AP_Amp_PV, 'o', 'color', [1 0 0])
hold on
plot([0 0],[-20 70], 'color', [0 0 0])
hold on
plot([-0.01 0.015],[0 0], 'color', [0 0 0])
hold on
plot(fx2, 'b')
ax = gca;
ax.TickDir = 'out';
xlim([-0.01 0.015])
ylim([-20 70])
Graph_Title=['PV'];
title(Graph_Title) % write the tittle of the graph
xlabel('Delta Vm (V)') % label the x axis
ylabel('Delta FR (Hz)') % label the y axis
expression=['r=', num2str(R_PV(1,2))];
text(ax, -0.008, 60, expression, 'FontSize',8)
expression=['p=',num2str(P_PV(1,2))];
text(ax, -0.008, 50, expression, 'FontSize',8)

%
fx3=fit(Vm_Amp_VIP, AP_Amp_VIP, 'poly1');
subplot(2,2,3)
plot(Vm_Amp_VIP, AP_Amp_VIP, 'o', 'color', [0 0 1])
hold on
plot([0 0],[-20 70], 'color', [0 0 0])
hold on
plot([-0.01 0.015],[0 0], 'color', [0 0 0])
hold on
plot(fx3, 'b')

ax = gca;
ax.TickDir = 'out';
xlim([-0.01 0.015])
ylim([-20 70])
Graph_Title=['VIP'];
title(Graph_Title) % write the tittle of the graph
xlabel('Delta Vm (V)') % label the x axis
ylabel('Delta FR (Hz)') % label the y axis
expression=['r=', num2str(R_VIP(1,2))];
text(ax, -0.008, 60, expression, 'FontSize',8)
expression=['p=',num2str(P_VIP(1,2))];
text(ax, -0.008, 50, expression, 'FontSize',8)

%
fx4=fit(Vm_Amp_SST, AP_Amp_SST, 'poly1');
subplot(2,2,4)
plot(Vm_Amp_SST, AP_Amp_SST, 'o', 'color', [1 0.5 0])
hold on
plot([0 0],[-20 70], 'color', [0 0 0])
hold on
plot([-0.01 0.015],[0 0], 'color', [0 0 0])
hold on
plot(fx4, 'b')

ax = gca;
ax.TickDir = 'out';
xlim([-0.01 0.015])
ylim([-20 70])
Graph_Title=['SST'];
title(Graph_Title) % write the tittle of the graph
xlabel('Delta Vm (V)') % label the x axis
ylabel('Delta FR (Hz)') % label the y axis
expression=['r=', num2str(R_SST(1,2))];
text(ax, -0.008, 60, expression, 'FontSize',8)
expression=['p=',num2str(P_SST(1,2))];
text(ax, -0.008, 50, expression, 'FontSize',8)


%% SAVE THE RESULT FIGURES

disp('Saving Figure')
pause(0.5)

Expression=[PathSaveFigures filesep '12_Whisking_Onset_DeltaFRvsVm'];

print('-painters', '-depsc', Expression)
print('-painters', '-djpeg', Expression)

disp('DONE')
pause(0.5)



