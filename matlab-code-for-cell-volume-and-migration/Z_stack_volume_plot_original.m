clear all
close all
clc

% Change the path of the folder where you save your images
fileFolder=fullfile('C:');

dirOutput=dir(fullfile(fileFolder,'*'));
fileNames={dirOutput.name}';

[totfram,aa]=size(fileNames);


% Cell dependent adjustable variables
thred = 0.05; % binary threshold value, 0.04-0.06 preferred
disk_number = 1; % dialte function parameter, 3-5 preferred
piecethred =10,000; % thredshold to filter out discrete pieces

% Parameters from Video
z_interval = 0.5; % unit of um
xy_interval = 0.1354874; % unit of um

k=1;

for z=3:totfram % Make this start from 4 for Mac
    
    zz=z-2;
    convertname_1=cell2mat(fileNames(z));
    imageName_ref_1=strcat(convertname_1);
    im=imread(imageName_ref_1);
    imblackwhite=im2bw(im,thred);
    imnobleb=bwareaopen(imblackwhite,piecethred);
    imedge = edge(imnobleb,'canny');
    dilatedImage = imdilate(imedge,strel('disk',disk_number));
    thinedImage = bwmorph(dilatedImage,'thin',inf);
    
    CC = bwconncomp(thinedImage);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    finalsketch=logical(zeros(size(im,1),size(im,2)));
    if idx ~= 0
        finalsketch(CC.PixelIdxList{idx}) = 1;
    end

    implane=imfill(finalsketch,'holes');
    
    if sum(imnobleb(:))/sum(implane(:))>2
        implane=imclose(imnobleb,strel('disk',20));
    end
    
    finalsketch_2=edge(implane,'canny');
    imsum=imfuse(im,finalsketch_2);

    figure()
    subplot(2,2,1)
    imshow(implane)
    subplot(2,2,2)
    imshow(im)
    title(['Frame # ',num2str(zz)])
    subplot(2,2,3)
    imshow(finalsketch_2)
    
%     figure()
%     imshow(imsum)

    areaunit(zz)=bwarea(implane)*xy_interval^2;
    [m,n] = size(finalsketch_2);
    for i=1:m
        for j=1:n
            if finalsketch_2(i,j) > 0
                check_plot(k,1)=i*xy_interval;
                check_plot(k,2)=j*xy_interval;
                check_plot(k,3)=zz*z_interval;
                k=k+1;
            end
        end
    end
    
end

temp_area_sum=0;

for i=2:zz-1
    temp_area_sum = temp_area_sum + areaunit(i);
end

total_area = temp_area_sum + (areaunit(1)+areaunit(zz))/2;
cell_volume = total_area * z_interval

figure()
scatter3(check_plot(:,1),check_plot(:,2),check_plot(:,3),1,'filled'); axis equal

figure()
x=check_plot(:,1);
y=check_plot(:,2);
z=check_plot(:,3);
Interpo_method=TriScatteredInterp(x,y,z,'natural');
[qx,qy]=meshgrid(min(x):0.1:max(x),min(y):0.1:max(y));
qz=Interpo_method(qx,qy);
mesh(qx,qy,qz), axis equal
