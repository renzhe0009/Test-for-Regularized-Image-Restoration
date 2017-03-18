function b = getfiltermatrixb(A,Kx,Ky, Nx,Ny)
% �摜�򉻃��f���ɂ�����W���򉻍s��b�����߂�D
% A: �򉻍s��
% Nx,Ny: �摜�T�C�Y
% Kx,Ky:�W���򉻍s��size

Kx = (Kx-1)/2; % ���S����Б��̒����ɕϊ�����
Ky = (Ky-1)/2;
c = 1;
for j=1:Ny
    for i=1:Nx
        X = zeros(Ny,Nx);
        if j-Ky<1 % y���W��0�ȉ��ɂȂ�Ƃ��̗�O����
            j3=1;
            j1=Ky-j+2;
        else
            j3=j-Ky;
            j1=1;
        end
        if i-Kx<1 % x���W��0�ȉ��ɂȂ�Ƃ��̗�O����
            i3=1;
            i1=Kx-i+2;
        else
            i3=i-Kx;
            i1=1;
        end
        if j+Ky>Ny % y���W��Ny�𒴂���Ƃ��̗�O����
            j4=Ny;
            j2=2*Ky+1-(j+Ky-Ny);
        else
            j4=j+Ky;
            j2=2*Ky+1;
        end
        if i+Kx>Nx % x���W��Nx�𒴂���Ƃ��̗�O����
            i4=Nx;
            i2=2*Kx+1-(i+Kx-Nx);
        else
            i4=i+Kx;
            i2=2*Kx+1;
        end
        
         X(:)= A(c,:) ;
         X=X.';
        b(j1:j2,i1:i2) = X(j3:j4,i3:i4);
        c = c+1;
    end
end     
% Kx = (Kx+1)*2; % ���S����Б��̒����ɕϊ�����
% Ky = (Ky+1)*2;
% 
% if mod(Kx,2)==0
%     b = cat(2,zeros(Ky,1),b);
%     Kx = Kx+1;
% end
% if mod(Ky,2)==0
%     b = cat(1,zeros(1,Kx),b);
%     Ky = Ky+1;
% end