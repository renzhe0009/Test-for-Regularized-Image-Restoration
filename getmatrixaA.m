function A = getmatrixA(b,Nx,Ny)
% �摜�򉻃��f���ɂ�����򉻍s��A�����߂�D
% b: �򉻃t�B���^�W��
% Nx,Ny: �摜�T�C�Y

[Ky,Kx]=size(b);
if mod(Kx,2)==0
    b = cat(2,zeros(Ky,1),b);
    Kx = Kx+1;
end
if mod(Ky,2)==0
    b = cat(1,zeros(1,Kx),b);
    Ky = Ky+1;
end
Kx = (Kx-1)/2; % ���S����Б��̒����ɕϊ�����
Ky = (Ky-1)/2;
A = zeros(Ny*Nx);
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
        X(j3:j4,i3:i4) = b(j1:j2,i1:i2);
        X = X.';
        A(c,:) = X(:).';
        c = c+1;
    end
end     
