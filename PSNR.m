function PSN=PSNR(A,B)
 [h,w]=size(A);
MAX=255;          %?‘œ—L‘½­ŠD“x?
MES=sum(sum((A-B).^2))/(h*w);     %‹Ï•û·
PSN=20*log10(MAX/sqrt(MES));           %•ô?Mš„”ä
end