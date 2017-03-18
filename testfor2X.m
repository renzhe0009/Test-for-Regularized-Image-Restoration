function testfor2X
%�摜�T�C�Y
Nx=10;
Ny=10;
%���摜X
x=randn(Nx,Ny);
X=reshape(x',Nx*Ny,1);
%A��Q�̌W���s��
a=randn(3,3); 
q=randn(3,3); 
[ax,ay]=size(a);
[qx,qy]=size(q);
%A��Q�����߂�
A = getmatrixaA(a,Nx,Ny);
Q = getmatrixaA(q,Nx,Ny);

%�ϑ��摜Y=AX+N�𐶐�����
%y=randn(Nx,Ny);
y = filter2(a,x,'same');   
n = randn(Nx,Ny);% Noise 
y = y + n;
%y = imnoise(y,'salt & pepper', 0.02);
Y=reshape(y',Nx*Ny,1);
%�������p�����[�^
alpha=0.5;


%�t�s��ɂ�鋁�߂���@(1)
tic
X1=(A'*A+alpha*Q'*Q) \ (A'*Y); %��������X1
toc



%iteration�ɂ�鋁�߂���@(2)
iter = 1;
beta = 0.01;
y1=Y;%����X
d=10^(-9); %iter�񐔂𑵂��邽��
tic
while iter <= 100000%iter�񐔂𑵂���ł�����A�傫���ق�������
    
    G=(A'*A+alpha*Q'*Q)*y1-A'*Y;
    y1 = y1 - beta * G;
    
    %iter�񐔂𑵂���
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
X2=y1;%��������X2




%iteration�ɂ��(�s��)���߂���@(3)
iterr = 1;
alpha1 =0.5;
beta = 0.01;
d=10^(-9); %iter�񐔂𑵂��邽��
y2=y;%����X

AT=A';
QT=Q';


q1 = getfiltermatrixb(QT,qx,qy, Nx,Ny);
a1 = getfiltermatrixb(AT,ax,ay, Nx,Ny);
tic
while iterr <=20000%iter�񐔂𑵂���ł�����A�傫���ق�������
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
    
    %iter�񐔂𑵂���
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
X3=reshape(X3',Nx*Ny,1);%��������X3

%iteration�̈��萫������
plot(log(error));
xlabel('iteration��');
ylabel('log(error)');

% %X1��X2�덷����
% err=sqrt(mean((X1(:)-X2(:)).^2));
% disp(err)
% 
% if err<1e-003  %sqrt(eps)�͏������߂���A�����p���ĂȂ�
%     disp('����')
% else
%     disp('�s����')
% end
% 
% 
% 
% 
% %X1��X3�덷����
% err1=sqrt(mean((X1(:)-X3(:)).^2));
% disp(err1)
% 
% if err1<1e-003  %sqrt(eps)�͏������߂���A�����p���ĂȂ�
%     disp('����')
% else
%     disp('�s����')
% end

%X1��X�덷����
err=sqrt(mean((X1(:)-X(:)).^2));
disp(err)

if err<1e-003  %sqrt(eps)�͏������߂���A�����p���ĂȂ�
    disp('����')
else
    disp('�s����')
end

%X2��X�덷����

err=sqrt(mean((X2(:)-X(:)).^2));
disp(err)

if err<1e-003  %sqrt(eps)�͏������߂���A�����p���ĂȂ�
    disp('����')
else
    disp('�s����')
end

%X3��X�덷����
err=sqrt(mean((X3(:)-X(:)).^2));
disp(err)

if err<1e-003  %sqrt(eps)�͏������߂���A�����p���ĂȂ�
    disp('����')
else
    disp('�s����')
end

end