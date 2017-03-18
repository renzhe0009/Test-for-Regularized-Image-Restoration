function testfor2X
%画像サイズ
Nx=10;
Ny=10;
%原画像X
x=randn(Nx,Ny);
X=reshape(x',Nx*Ny,1);
%AとQの係数行列
a=randn(3,3); 
q=randn(3,3); 
[ax,ay]=size(a);
[qx,qy]=size(q);
%AとQを求める
A = getmatrixaA(a,Nx,Ny);
Q = getmatrixaA(q,Nx,Ny);

%観測画像Y=AX+Nを生成する
%y=randn(Nx,Ny);
y = filter2(a,x,'same');   
n = randn(Nx,Ny);% Noise 
y = y + n;
%y = imnoise(y,'salt & pepper', 0.02);
Y=reshape(y',Nx*Ny,1);
%正則化パラメータ
alpha=0.5;


%逆行列による求める方法(1)
tic
X1=(A'*A+alpha*Q'*Q) \ (A'*Y); %復元したX1
toc



%iterationによる求める方法(2)
iter = 1;
beta = 0.01;
y1=Y;%初期X
d=10^(-9); %iter回数を揃えるため
tic
while iter <= 100000%iter回数を揃えるですから、大きいほうがいい
    
    G=(A'*A+alpha*Q'*Q)*y1-A'*Y;
    y1 = y1 - beta * G;
    
    %iter回数を揃える
    y11 = y1 - beta * G;
    d1=y1-y11;
    d2=norm(d1);
    d3=norm(y1);
    d4=d2/d3;
    if d4<d
        break
    end;
    iter = iter + 1;
end
toc
X2=y1;%復元したX2




%iterationによる(行列)求める方法(3)
iterr = 1;
alpha1 =0.5;
beta = 0.01;
d=10^(-9); %iter回数を揃えるため
y2=y;%初期X

AT=A';
QT=Q';


q1 = getfiltermatrixb(QT,qx,qy, Nx,Ny);
a1 = getfiltermatrixb(AT,ax,ay, Nx,Ny);
tic
while iterr <=20000%iter回数を揃えるですから、大きいほうがいい
     %ATAXn
    Y1 = filter2(a,y2,'same');   
    G1 = filter2(a1,Y1,'same');
     %QTQXn
    Y2 = filter2(q,y2,'same');   
    G2 = filter2(q1,Y2,'same');
     %ATY
    G3 = filter2(a1,y,'same');
    G4 = zeros(size(y2));
    G4(:, :) = (G1(:,:) + alpha1* G2(:, :)- G3(:,:));
    y2(:, :) = y2(:, :) - beta * G4(:, :);
    
    %iter回数を揃える
    y22(:, :) = y2(:, :) - beta * G4(:, :);
    d1=y2-y22;
    d2=norm(d1);
    d3=norm(y2);
    d4=d2/d3;
    error(iterr)=d4;
%     if d4<d
%         break
%     end;
    iterr = iterr + 1;
end
toc
X3=y2;
X3=reshape(X3',Nx*Ny,1);%復元したX3

%iterationの安定性を示す
plot(log(error));
xlabel('iteration回数');
ylabel('log(error)');

% %X1とX2誤差検証
% err=sqrt(mean((X1(:)-X2(:)).^2));
% disp(err)
% 
% if err<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
%     disp('正解')
% else
%     disp('不正解')
% end
% 
% 
% 
% 
% %X1とX3誤差検証
% err1=sqrt(mean((X1(:)-X3(:)).^2));
% disp(err1)
% 
% if err1<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
%     disp('正解')
% else
%     disp('不正解')
% end

%X1とX誤差検証
err=sqrt(mean((X1(:)-X(:)).^2));
disp(err)

if err<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
    disp('正解')
else
    disp('不正解')
end

%X2とX誤差検証

err=sqrt(mean((X2(:)-X(:)).^2));
disp(err)

if err<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
    disp('正解')
else
    disp('不正解')
end

%X3とX誤差検証
err=sqrt(mean((X3(:)-X(:)).^2));
disp(err)

if err<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
    disp('正解')
else
    disp('不正解')
end

end