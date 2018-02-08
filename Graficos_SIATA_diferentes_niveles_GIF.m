% Script para visualizar una se;al de concentracion de gases en una paleta
% de color
clear all
close all
clc
% Importa el vector a graficar

load new_SIATA.mat;

Station=new_SIATA.Station6.no.Data;
Maximo_Station=max(Station);
Minimo_Station=min(Station);

load Suffix
Variable=cell(1,length(Suffix));
% Variables of interest
VarSIATA={'co','no2','ozono','so2','pm25','pm10','no'};
VarLOTOS={'co','no2','o3','so2','tpm25','tpm10'};
VarName={'Carbon monoxide','Nitrogen dioxide','Ozone','Sulphur dioxide',...
    'PM2.5','PM10','Nitrogen oxide'};
VarUnits={'ppm','ppb','ppb','ppb','ug/m3','ug/m3','ppb'};
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

% Importa el vector a graficar

load new_SIATA.mat;
station=18;
var=7;

Rango=Maximo_Station-Minimo_Station;
n=18;
Particiones=Rango/n;

j=1;
c=1;
% colorstring = 'gbyrk';
A={[224/255 255/255 255/255],[204/255 255/255 255/255],[153/255 255/255 225/255],[153/255 255/255 153/255],[178/255 255/255 102/255],[255/255 255/255 102/255],[255/255 255/255 72/255],[255/255 240/255 62/255],[255/255 215/255 51/255],[255/255 153/255 25/255],[255/255 140/255 0/255],[204/255,102/255,0],[204/255 55/255 0/255],[204/255 0/255 0/255],[153/255 0/255 0/255],[125/255 0/255 0/255],[103/255 0/255 0/255],[73/255 0/255 0/255]};
L={'Good','Good','Normal','Normal','Moderate','Moderate','Unhealthy for sensitive groups','Unhealthy for sensitive groups','Unhealthy','Unhealthy','Very unhealthy','Very unhealthy','Hazardous','Hazardous','Hazardous','Hazardous','Hazardous','Hazardous'};
dates = datenum('January 1, 2017 0:00'):1/24:datenum('December 31, 2017 23:00');
ventana=300;
ventanear=0;
h2=plot(1,Station(1));
for i=1:(length(Station)/48) -54
 for j=1:n
    if (0+(Particiones)*(j-1)<=Station(i)&& Station(i)<Minimo_Station+Particiones*(j))
        if i>ventana 
        delete(h1(i-ventana))
        end
            delete(h2)
            h2=plot(dates(i),Station(i),'Marker','o','MarkerSize',18,'Color','k');
            h1(i)=plot(dates(i),Station(i),'.','Color', A{j},'MarkerSize',30);
            %legend(L{j})
            ylim([-5 200]);
          Taux=strcat('\textbf{',StationName{station},'-SIATA','}');
          TextYlabel=strcat('\textbf{',VarName{var},'(',VarUnits{var},')','}');
          title(Taux,TextProp,TextVal1)
          ylabel(TextYlabel,TextProp,TextVal2)
          xlabel('\textbf{Time}',TextProp,TextVal2) % x-axis label
          set(gca,AxesProp,AxesVal)
            dynamicDateTicks
            hold all
%             axes('pos',[.05 .6 .5 .3])
%             [im,map,alpha]=imread('P7.png');
%             hold on
%             f=imshow(im);
%             set(f,'AlphaData',alpha);
%             addgradient;
      
      
    
      
      break
    end
   
  end
end
% plot(Station,'LineStyle','--','Color','k')

% setDateAxes(gca, 'XLim', [datenum('January 1, 2017') datenum('December 31, 2017')]);


