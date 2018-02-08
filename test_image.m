figure
plot((1:10).^2)
axes('pos',[.1 .6 .5 .3])
[im,map,alpha]=imread('P7.png');
f=imshow(im);
set(f,'AlphaData',alpha);
fig = gcf;
ax = fig.CurrentAxes;