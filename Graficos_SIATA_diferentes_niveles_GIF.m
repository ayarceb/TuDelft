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

Rango=Maximo_Station-Minimo_Station;
n=18;
Particiones=Rango/n;

j=1;
c=1;
% colorstring = 'gbyrk';
A={[224/255 255/255 255/255],[204/255 255/255 255/255],[153/255 255/255 225/255],[153/255 255/255 153/255],[178/255 255/255 102/255],[255/255 255/255 102/255],[255/255 255/255 72/255],[255/255 240/255 62/255],[255/255 215/255 51/255],[255/255 153/255 25/255],[255/255 140/255 0/255],[204/255,102/255,0],[204/255 55/255 0/255],[204/255 0/255 0/255],[153/255 0/255 0/255],[125/255 0/255 0/255],[103/255 0/255 0/255],[73/255 0/255 0/255]};
L={'Good','Good','Normal','Normal','Moderate','Moderate','Unhealthy for sensitive groups','Unhealthy for sensitive groups','Unhealthy','Unhealthy','Very unhealthy','Very unhealthy','Hazardous','Hazardous','Hazardous','Hazardous','Hazardous','Hazardous'};
dates = datenum('January 1, 2017 0:00'):1/24:datenum('December 31, 2017 23:00');
ventana=238;
ventanear=0;
h2=plot(1,Station(1));
for i=1:(length(Station)/18) -46
 for j=1:n
    if (0+(Particiones)*(j-1)<=Station(i)&& Station(i)<Minimo_Station+Particiones*(j))
        if i>ventana 
        delete(h1(i-ventana))
        end
            delete(h2)
            h2=plot(dates(i),Station(i),'Marker','o','MarkerSize',20,'Color','k');
            h1(i)=plot(dates(i),Station(i),'*','Color', A{j},'MarkerSize',10);
            %legend(L{j})
            ylim([0 250]);
            title('SIATA Station # 6 (NO)');
            xlabel('Year 2017');
            ylabel('ppb');
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

