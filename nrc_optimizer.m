function [r0, r1, mae, mte] = nrc_optimizer (l)
f = dlmread('optdigitsubset.txt');
zs2 = f(1:554,:);
os2 = f(555:1125,:);
r0 = rand(1,size(zs2,2)) * 256;
r1 = rand(1,size(os2,2)) * 256;
g = 0.01;
zs = zs2(floor(rand * size(zs2,1)),:);
os = os2(floor(rand* size(os2,1)),:);
precision = 0.0001;
prev1 = 1;
prev0 = 1;
mx = 10000;
it =0;
for k=1:50
    zs = zs2(floor(rand * size(zs2,1)),:);
    os = os2(floor(rand* size(os2,1)),:);
while (prev1 >= precision) && (prev0 >= precision)
   temp0 = r0;
   temp1 = r1;
   
   dr0 = zeros(1,64);
   dr1 = zeros(1,64);
   for i=1:size(zs,1)
       sm = 0;
       for j=1:64
          dr0(j) = dr0(j) - 2*(zs(j)-r0(j))/size(zs,1);
       end
   end
   for i=1:size(os,1)
       sm = 0;
       for j=1:64
          dr1(j) = dr1(j) - 2*(os(j)-r1(j))/size(os,1);
       end
    end 
  
   for i=1:64
       if r0(i) > r1(i)
           dr0(i) = dr0(i) + l;
           dr1(i) = dr1(i) - l;
       end
       if r0(i) < r1(i)
           dr0(i) = dr0(i) - l;
           dr1(i) = dr1(i) + l;
       end
   end
   r0 = r0 - g*dr0;
   r1 = r1 - g*dr1;
   prev1 = mean(abs(temp1 - r1));
   prev0 = mean(abs(temp0 - r0));
   it = it + 1;
   if it > mx
       break
   end
end
ae(k) = mean(abs(r0 - zs))/2 + mean(abs(r1-os))/2;
te(k) = mean(abs(r0-zs2(floor(rand*size(zs2,1)),:)))/2 + mean(abs(r1-os2(floor(rand*size(os2,1)),:)))/2;
mte = mean(te);
mae = mean(ae);
end
