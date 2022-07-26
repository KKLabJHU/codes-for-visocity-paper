function [speed, velocity, persistence, cut] = speedmeasurements(num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%num=xlsread('xls');
clear speed velocity persistence displacement
[r,c]=size(num);
speed=[];
velocity=[];
persistence=[];
%displacement=[];
%meanspeed=[];
cut=[];
%deltat=160;

j=1;
for i=1:r-1
    if num(i,2)~=num(i+1,2) 
        cut(1,j)=i;        
        j=j+1;
    elseif num(i,2)==num(i+1,2) && num(i+1,3)~=num(i,3)+1
        cut(1,j)=i;
        j=j+1;
    end
    
    if i==r-1
        cut(1,j)=i+1;
    end
end

numtracks=length(cut);

k=1;
for i=1:numtracks

%    clear ptpspeed; 
%    ptpspeed=[];
%    m=1;
%     for j=k:1:cut(1,i)-1
%         if i==1
%         ptpspeed(1,j)=abs(num(j+1,8)-num(j,8))/(num(j+1,6)-num(j,6));
%         else 
%         ptpspeed(1,m)=abs(num(j+1,8)-num(j,8))/(num(j+1,6)-num(j,6));
%         m=m+1;
%         end            
%     end
    

    
%     for j=k:1:cut(1,i)
%         if num(j,6)==num(k,6)+deltat
%             displacement(1,i)=sqrt((num(j,4)-num(k,4))^2+(num(j,5)-num(k,5))^2);   
%         else if num(j,6)<num(k,6)+deltat && num(j,6)==num(cut(1,i),6)
%             displacement(1,i)=sqrt((num(j,4)-num(k,4))^2+(num(j,5)-num(k,5))^2);
%         end
%         end
%     end
    
    speed(1,i)=60*num(cut(1,i),8)/(num(cut(1,i),6)-num(k,6));
    velocity(1,i)=60*sqrt((num(cut(1,i),4)-num(k,4))^2+(num(cut(1,i),5)-num(k,5))^2)/(num(cut(1,i),6)-num(k,6));
    persistence(1,i)=velocity(1,i)./speed(1,i);
%   meanspeed(1,i)=60*mean(ptpspeed);
    
    
    
    if i==1
        k=k+cut(1,i);
    else
        k=k+cut(1,i)-cut(1,i-1);
    end
    
end

ls=length(speed);
%ld=length(displacement);
lp=length(persistence);
lv=length(velocity);

for i=1:ls
    speed(i,1)=speed(1,i);
end

% for i=1:ld
%      displacement(i,1)=displacement(1,i);
% end

for i=1:lp
    persistence(i,1)=persistence(1,i);
end

for i=1:lv
    velocity(i,1)=velocity(1,i);
end
