function testfor3X
%画像サイズ
 Nx=10;
 Ny=10;
%原画像X
x=10*randn(Nx,Ny)+128;
% x=double(imread('lenna.bmp'));%256x256
% x=imresize(x,0.1);%1/10サイズ
% [Nx,Ny]=size(x);
X=reshape(x',Nx*Ny,1);
%AとQの係数行列
a=randn(3,3); 
q=randn(3,3); 
[ax,ay]=size(a);
[qx,qy]=size(q);
%AとQを求める
A = getmatrixaA(a,Nx,Ny);
Q = getmatrixaA(q,Nx,Ny);

%観測画像Yを生成する
%y=randn(Nx,Ny);
y = filter2(a,x,'same');   
n = 2*randn(Nx,Ny);% Noise 
y =  y+ n;
Y=reshape(y',Nx*Ny,1);
%正則化パラメータ
alpha=0.5;


%逆行列による求める方法(1)
tic
X1=(A'*A+alpha*Q'*Q) \ (A'*Y); %復元したX1
toc

result1=reshape(X1',Nx,Ny);

 result1=result1';
figure,imshow(result1,[]);
% 
%iterationによる(行列)求める方法(2)
iter = 1;
beta = 0.01;
y1=Y;%初期X
d=10^(-9); %iter回数を揃えるため
tic
while iter <= 20000%iter回数を揃えるですから、大きいほうがいい
    
    G=(A'*A+alpha*Q'*Q)*y1-A'*Y;
    y1 = y1 - beta * G;
    
    %iter回数を揃える
    y11 = y1 - beta * G;
    d1=y1-y11;
    d2=norm(d1);
    d3=norm(y1);
    d4=d2/d3;
    errorr(iter)=d4;
    if d4<d
        break
    end;
    iter = iter + 1;
end
toc

X2=y1;%復元したX2

%iterationの安定性を示す
disp(iter)
% plot(log(errorr));
% xlabel('iteration回数');
% ylabel('log(error)');
% err(2,:)=errorr;

result2=reshape(X2',Nx,Ny);

 result2=result2';
figure,imshow(result2,[]);

% figure,
% for i=1:20,
% subplot(5,4,i),
% plot(log(err(i,:)));
% xlabel('iteration回数');
% ylabel('log(error)');
% end





%iterationによる(画像)求める方法(3)
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
    if d4<d
        break
    end;
    iterr = iterr + 1;
end
toc
X3=y2;
 figure,imshow(X3,[]);
 X3=reshape(X3',Nx*Ny,1);%復元したX3

%iterationの安定性を示す
disp(iterr)
% plot(log(error));
% xlabel('iteration回数');
% ylabel('log(error)');


% figure,
% for i=1:20,
% subplot(5,4,i),
% plot(log(error(i,:)));
% xlabel('iteration回数');
% ylabel('log(error)');
% end

%X1とX2誤差検証
err=sqrt(mean((X1(:)-X(:)).^2));
disp(err)

if err<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
    disp('正解')
else
    disp('不正解')
end




%X1とX3誤差検証
err1=sqrt(mean((X2(:)-X(:)).^2));
disp(err1)

if err1<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
    disp('正解')
else
    disp('不正解')
end

%X2とX3誤差検証
err2=sqrt(mean((X3(:)-X(:)).^2));
disp(err2)

if err2<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
    disp('正解')
else
    disp('不正解')
end



% [P,m1] = PSNR(x,reshape(X1',Nx,Ny));
% disp(P)
% [P,m2] = PSNR(x,reshape(X2',Nx,Ny));
% disp(P)
% [P,m3] = PSNR(x,reshape(X3',Nx,Ny));
% disp(P)


% %X1とX誤差検証
% err=sqrt(mean((X1(:)-X(:)).^2));
% disp(err)
% 
% if err<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
%     disp('正解')
% else
%     disp('不正解')
% end
% 
% %X2とX誤差検証
% 
% err=sqrt(mean((X2(:)-X(:)).^2));
% disp(err)
% 
% if err<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
%     disp('正解')
% else
%     disp('不正解')
% end
% 
% %X3とX誤差検証
% err=sqrt(mean((X3(:)-X(:)).^2));
% disp(err)
% 
% if err<1e-003  %sqrt(eps)は小さい過ぎる、ここ用いてない
%     disp('正解')
% else
%     disp('不正解')
% end

end