% Script para visualizar una se;al de concentracion de gases en una paleta
% de color
clear all
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
% colorstring = 'gbyrk';
A={[224/255 255/255 255/255],[204/255 255/255 255/255],[153/255 255/255 225/255],[153/255 255/255 153/255],[178/255 255/255 102/255],[255/255 255/255 102/255],[255/255 255/255 72/255],[255/255 240/255 62/255],[255/255 215/255 51/255],[255/255 153/255 25/255],[255/255 140/255 0/255],[204/255,102/255,0],[204/255 55/255 0/255],[204/255 0/255 0/255],[153/255 0/255 0/255],[125/255 0/255 0/255],[103/255 0/255 0/255],[73/255 0/255 0/255]};

dates = datenum('January 1, 2017 0:00'):1/24:datenum('December 31, 2017 23:00');

for i=1:1000 -1
 for j=1:n
    if (0+(Particiones)*(j-1)<=Station(i) && Station(i)<Minimo_Station+Particiones*(j))
      plot(dates(i),Station(i),'*','Color', A{j});
      ylim([0 250]);
      title('SIATA station # 6 (NO)')
      xlabel('Year 2017') % x-axis label
      ylabel('ppb') % y-axis label
      dynamicDateTicks
      hold on      
      break
    end
  end
end
