function PSN=PSNR(A,B)
 [h,w]=size(A);
MAX=255;          %?���L�����D�x?
MES=sum(sum((A-B).^2))/(h*w);     %�ϕ���
PSN=20*log10(MAX/sqrt(MES));           %��?�M����
end