function A = getmatrixA(b,Nx,Ny)
% 画像劣化モデルにおける劣化行列Aを求める．
% b: 劣化フィルタ係数
% Nx,Ny: 画像サイズ

[Ky,Kx]=size(b);
if mod(Kx,2)==0
    b = cat(2,zeros(Ky,1),b);
    Kx = Kx+1;
end
if mod(Ky,2)==0
    b = cat(1,zeros(1,Kx),b);
    Ky = Ky+1;
end
Kx = (Kx-1)/2; % 中心から片側の長さに変換する
Ky = (Ky-1)/2;
A = zeros(Ny*Nx);
c = 1;
for j=1:Ny
    for i=1:Nx
        X = zeros(Ny,Nx);
        if j-Ky<1 % y座標が0以下になるときの例外処理
            j3=1;
            j1=Ky-j+2;
        else
            j3=j-Ky;
            j1=1;
        end
        if i-Kx<1 % x座標が0以下になるときの例外処理
            i3=1;
            i1=Kx-i+2;
        else
            i3=i-Kx;
            i1=1;
        end
        if j+Ky>Ny % y座標がNyを超えるときの例外処理
            j4=Ny;
            j2=2*Ky+1-(j+Ky-Ny);
        else
            j4=j+Ky;
            j2=2*Ky+1;
        end
        if i+Kx>Nx % x座標がNxを超えるときの例外処理
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
