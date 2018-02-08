%% Description
%{
ggggggg
This code will help for the characterization of SIATA measurements. The
principal analyses will be those regarding daily and yearly cycles, and the
main statictical metrics. As the presetn data present large quantities of
missing values, frequency analysis will not be a principal processing tool.

After the meeting of July 27, 2017 with Laura Herrera in SIATA
headquarters, it was known that SIATA measuremetns do not undergo complex
processing: only some data-removal conditions are taken into account. The
data presents some periods with an observable bias (zero-shift) which is
caused by equipment calibration. The current administration took control as
of 2016, so there is little information about the conditions, processing
and possible errors contained in previous data.

The units corresponding to the variables of interest are:
    - co: ppm
    - nox: ppb
    - so2: ppb
    - o3: ppb
    - pmx: ug/m3

% Note: this script is missing details in some figures: Titles, Labels, and
Formatting. 

%}
%% Configuration

% Location of SIATA data g
% Path='/home/wagm/slrestrepo/Documents/GITHUB/DATA/SIATA/';
% Path='C:\Users\SANTIAGO\Documents\SIATA\';

%{

The units corresponding to the variables of interest are:
    - co: ppm
    - nox: ppb
    - so2: ppb
    - o3: ppb
    - pmx: ug/m3

%}
close all
% Get list of SIATA data files
% Directories=dir(Path);
% Directories=Directories([Directories.isdir]);
% Directories=Directories(3:end);
% Directories={Directories.name};
% Path=strcat(Path,'/',Directories,'/');
% Path=strcat(Path,Directories,'/');
% Suffix=strcat('Station',Directories);
load Suffix
Variable=cell(1,length(Suffix));
%% Configuration

% load /mnt/dutita2/wagm/slrestrepo/Documents/GITHUB/LOTOS-EUROS/src/MAT_FILES/new_SIATA
% load /mnt/dutita2/wagm/slrestrepo/Documents/GITHUB/LOTOS-EUROS/src/MAT_FILES/LOTOS
load C:\Users\SANTIAGO\Documents\GITHUB\LOTOS-EUROS\src\MAT_FILES\new_SIATA
load C:\Users\SANTIAGO\Documents\GITHUB\LOTOS-EUROS\src\MAT_FILES\LOTOS
% Variables of interest
VarSIATA={'co','no2','ozono','so2','pm25','pm10'};
VarLOTOS={'co','no2','o3','so2','tpm25','tpm10'};
VarName={'Carbon monoxide','Nitrogen dioxide','Ozone','Sulphur dioxide',...
    'PM2.5','PM10'};
VarUnits={'ppm','ppb','ppb','ppb','ug/m3','ug/m3'};
StationName=cellfun(@(x) regexprep(x,'\d*',' $0'),Suffix,'UniformOutput',0);

% Plotting properties
FigProp={'Units','Position','PaperPosition'};
FigVal={'inches',[0,0.2604,20.0000,10.0208],[0,0.2604,20.0000,10.0208]};
AxesProp={'TickLabelInterpreter','FontSize'};
AxesVal={'latex',14};
TextProp={'Interpreter','FontSize'};
TextVal1={'latex',20};
TextVal2={'latex',18};
TextVal3={'latex',14};


SIATA=new_SIATA;


% %===Station order==
% 1'Station11' %     2'Station12' %    3 'Station25' %   4  'Station28' %    5 'Station3'
%   6  'Station31'%    7 'Station37'%    8 'Station38' %    9 'Station4' %   10  'Station40'
%   11  'Station41' %    12 'Station43' %    13 'Station44' %    14 'Station45' %   15  'Station46'
%   16  'Station47' %    17 'Station48' %   18  'Station6'

%% Variable cycle

 station=6;
    
    Time=[SIATA.(Suffix{station}).Date SIATA.(Suffix{station}).Time.Data];
    Month={'Jan ','Feb ','Mar ','Apr ','May ','Jun ','Jul ','Aug ','Sep ',...
        'Oct ','Nov ','Dec '};
    DateString=strcat(Month(Time(:,2))',{' '},...
        arrayfun(@num2str,Time(:,3),'UniformOutput',0),{', '},...
        arrayfun(@num2str,Time(:,1),'UniformOutput',0));
    
 var=3;
        Signal=SIATA.(Suffix{station}).(VarSIATA{var}).Data;
        SignalLOTOS=double(LOTOS.(Suffix{station}).(VarLOTOS{var}).Data);
        % This limits for missing data values were defined empirically.
        Signal(Signal<-900)=NaN;
        Signal(Signal>900)=NaN;
        
        % Data density is a measure of the quantity of missing data and the
        % total length of the signal.
        DataDensity=1-sum(isnan(Signal))/length(Signal);
        
        if DataDensity>0 % If there is data available.
            
            %% Time Analysis
            % Plotting configuration
            FigTime=figure(1);
            set(FigTime,FigProp,FigVal)
            
            % Plot
            plot(1:length(Signal),medfilt1(10*SignalLOTOS,24),'LineWidth',2), 
            hold on
            plot(1:length(Signal),medfilt1(Signal,24),'LineWidth',2), legend('LOTOS-EUROS*10','SIATA')
            Taux=strcat('\textbf{',StationName{station},'}');
            TextYlabel=strcat('\textbf{',VarName{var},'(',VarUnits{var},')','}');
            title(Taux,TextProp,TextVal1)
            ylabel(TextYlabel,TextProp,TextVal2)
            A=gca;
            A.XLim=[1 length(Signal)];
            A.XTickLabel=DateString(A.XTick);
            A.XTickLabelRotation=30;
            set(A,AxesProp,AxesVal)
            grid          

            %% Day Cycle
            GO=[0.313725501298904 0.313725501298904 0.313725501298904];  %Gris Oscuro
            GM=[0.501960813999176 0.501960813999176 0.501960813999176];  %Gris Medio
            GC=[0.831372559070587 0.815686285495758 0.7843137383461];    %Gris Claro
            Bl=[1 1 1];   %Blanco
            color={GO,GO,GO,GO,GO,GO,GM,GM,GM,GC,GC,Bl,Bl,Bl,GC,GC,GM,GM,GM,GO,GO,GO,GO,GO,GO};
            x=0:length(color);
            y=max(Signal)*1.1*ones(1,length(x));
            
            % Plot for all data in one figure
            FigDay=figure(2);
            set(FigDay,FigProp,FigVal)
            clf
            %SIATA
            cond=~isnan(Signal);
            X=Signal(cond);
            TimeX=Time(cond,:); 
            subplot(2,1,1)
            for i=1:length(color)
            bar(x(i),y(i),1,'FaceColor',color{i},'EdgeColor',color{i}),ylim([0 max(y)]),xlim([-0.5 23.5])
            hold on
            end
            set(gca,'Xtick',[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23])
            scatter(TimeX(:,4)+0.05*(TimeX(:,2)-6),(X),300,TimeX(:,2),'.')
            colormap jet
%             set(gca,'XLim',[-0.5 24.5])
            xlabel('Hour of day',TextProp,TextVal2)
            Taux=strcat('\textbf{',StationName{station},'-SIATA','}');
            TextYlabel=strcat('\textbf{',VarName{var},'(',VarUnits{var},')','}');
            title(Taux,TextProp,TextVal1)
            ylabel(TextYlabel,TextProp,TextVal2)
            set(gca,AxesProp,AxesVal)
            caxis([1 12])
            CBar=colorbar;
            set(CBar,AxesProp,AxesVal)
            CBar.Ticks=1:12;
            CBar.TickLabels=Month(CBar.Ticks);
            %LOTOS
            
            cond=~isnan(SignalLOTOS);
            X=SignalLOTOS(cond);
            y=max(SignalLOTOS)*1.1*ones(1,length(x));
            TimeX=Time(cond,:); 
            subplot(2,1,2)
            for i=1:length(color)
            bar(x(i),y(i),1,'FaceColor',color{i},'EdgeColor',color{i}),ylim([0 max(y)]),xlim([0 23])
            hold on
            end
            set(gca,'Xtick',[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23])
            scatter(TimeX(:,4)+0.05*(TimeX(:,2)-6),(X),300,TimeX(:,2),'.')
            colormap jet
%             set(gca,'XLim',[-0.5 24.5])
            Taux=strcat('\textbf{',StationName{station},'-SIATA','}');
            TextYlabel=strcat('\textbf{',VarName{var},'(',VarUnits{var},')','}');
            title(Taux,TextProp,TextVal1)
            ylabel(TextYlabel,TextProp,TextVal2)
            xlabel('Hour of day',TextProp,TextVal2)
            set(gca,AxesProp,AxesVal)
            caxis([1 12])
            CBar=colorbar;
            set(CBar,AxesProp,AxesVal)
            CBar.Ticks=1:12;
            CBar.TickLabels=Month(CBar.Ticks);
                        

            %% Monthly averages
            
            % Each subplot is a different year.
            
            %--------------------------------------------------------------
            % Representation 1:
            % THe X-Axis represents an hour of day, whilst each line is a
            % different month of the year.
            
            %SIATA
            FigMonth=figure(3);
            set(FigMonth,FigProp,FigVal)
            clf
            subplot(2,1,1)
            y=max(Signal)*1.1*ones(1,length(x));
            for i=1:length(color)
            bar(x(i),y(i),1,'FaceColor',color{i},'EdgeColor',color{i}),ylim([0 max(y)*0.5])
            hold on
            end
            set(gca,'Xtick',[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23])
            X=Signal(cond);
%             year=length(Years);
                year=2016;
                cond1=TimeX(:,1)==year;
                Xaux=X(cond1);
                TimeXaux=TimeX(cond1,:);
                XMonth=unique(TimeXaux(:,2));
                
                hold on
                CMap=colormap('jet');
                CMap=CMap(round(linspace(1,64,12)),:);
                for month=1:length(XMonth)
                    cond2=TimeXaux(:,2)==XMonth(month);
                    Y=Xaux(cond2);
                    YTime=TimeXaux(cond2,:);
                    YHours=unique(YTime(:,4));
                    Y=arrayfun(@(x) median(Y(YTime(:,4)==x)),YHours);
                    plot(Y,'Color',CMap(XMonth(month),:),'LineWidth',1.5)
                end
                caxis([1 12])
                set(gca,'XLim',[1 23])
                CBar=colorbar;
                hold off
                Taux=strcat('\textbf{',StationName{station},'-SIATA','}');
                TextYlabel=strcat('\textbf{',VarName{var},'(',VarUnits{var},')','}');
                title(Taux,TextProp,TextVal1)
                ylabel(TextYlabel,TextProp,TextVal2)
                xlabel('Hour of day',TextProp,TextVal2)
                set(gca,AxesProp,AxesVal)
                set(CBar,AxesProp,AxesVal)
                CBar.Ticks=1:12;
                CBar.TickLabels=Month(CBar.Ticks);
            end
            %LOTOS
            subplot(2,1,2)
            y=max(SignalLOTOS)*1.1*ones(1,length(x));
            for i=1:length(color)
            bar(x(i),y(i),1,'FaceColor',color{i},'EdgeColor',color{i}),ylim([0 max(y)*0.5])
            hold on
            end
            set(gca,'Xtick',[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23])
            X=SignalLOTOS(cond);
             year=2016;
                cond1=TimeX(:,1)==2016;
                Xaux=X(cond1);
                TimeXaux=TimeX(cond1,:);
                XMonth=unique(TimeXaux(:,2));
                
                hold on
                CMap=colormap('jet');
                CMap=CMap(round(linspace(1,64,12)),:);
                for month=1:length(XMonth)
                    cond2=TimeXaux(:,2)==XMonth(month);
                    Y=Xaux(cond2);
                    YTime=TimeXaux(cond2,:);
                    YHours=unique(YTime(:,4));
                    Y=arrayfun(@(x) median(Y(YTime(:,4)==x)),YHours);
                    plot(Y,'Color',CMap(XMonth(month),:),'LineWidth',1.5)
                end
                caxis([1 12])
                set(gca,'XLim',[1 23])
                CBar=colorbar;
                hold off
                Taux=strcat('\textbf{',StationName{station},'-SIATA','}');
                TextYlabel=strcat('\textbf{',VarName{var},'(',VarUnits{var},')','}');
                title(Taux,TextProp,TextVal1)
                ylabel(TextYlabel,TextProp,TextVal2)
                xlabel('Hour of day',TextProp,TextVal2)
                set(gca,AxesProp,AxesVal)
                set(CBar,AxesProp,AxesVal)
                CBar.Ticks=1:12;
                CBar.TickLabels=Month(CBar.Ticks);
            
            %--------------------------------------------------------------
            % 
        
        
   


%% Discussion
%{
Preliminar analysis results:

- Station11

    pm10: Presents a subit rise of amplitude between Sept 30 2016 and Oct 5
    2016.

- Station 12

    co: Few negative values before May 2 2016. Odd beahviour (negative
    values and rise of bias) from June 2016 onwards.

- Station 25

    no2: Sudden bias from Jul 8 2016 to Jul 11 2016. Odd behavior (missing
    data and negative values) from Sep 30 2016 to Oct 13 2016.

    o3: Periods of negative values between Jun 14 2016 to Sep 8 2016.

- Station 44
    
    o3: Region with negative values from Aug 30 2014 to Sep 16 2014. 

    pm25: Two singular (negative) values: Oct 21 2016 and Dec 4 2016.

- Station 28

    no2: Few negatives values at Dec 26 2015. Periods with negative values
    from May 4 2016 and Oct 17 2016.

    pm25: Single negative value at May 11 2016. Extreme value at May 25
    2016. Constant value period from Jun 30 2016 to Jul 4 2016.

- Station 3

    co: Seemingly quantized data from Sept 3 2015 to Dec 1 2015.
    Calibration bias steadily rising from Jan 4 2016 ro Feb 6 2016.
    Negative values around May 4 2016. Off-set region from May 4 2016 to
    May 20 2016. Negative values Sep 28-29 2016. 

    no2: Decreasing bias (including negative values) from Apr 29 2016 to
    Jun 27 2016. Region with negative values from Sep 10 2016 to Nov 5
    2016. Negative values from Dec 10 2016 to Dec 19 2016. Region with
    negative values from Jan 21 2017 to Feb 3 2017.

    so2: Raised bias from Aug 3 2016 to Sep 1 2016. Increasing bias from
    Oct 21 2016 to Dec 27 2016.

- Station 37

    no2: Region with negative values from May 24 2016 to Sep 6 2016. 

- Station 40

    o3: Few negative values between Nov 24 2016 and Dec 19 2016, and
    between Jan 23 2017 and Feb 5 2017.

- Station 41

    o3: Oddly increasing values (bias) from Nov 24 2016 to Nov 28 2016.
    Negative values Nov 28-29 2016.

- Station 45

    pm10: single negative value at Jan 16 2017.

- Station 47
    
    pm10: Single negative value at May 11 2016. Region with negative values
    between Oct 17 2016 and Jan 29 2017.

- Station 48

    co: Region with negative values Apr 29 2016 to May 24 2016. Region with
    a lot of negaive values from Jul 5 2016 to Sep 1 2016. Few negative
    values from Oct 17 2016 to Jan 11 2017.

    no2: Regions with negative values from Apr 13 2016 and Nov 15 2016.

%}





