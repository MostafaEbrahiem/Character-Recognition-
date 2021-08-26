function [] = test(img)

[y1,x1,z1] = size(img);
res=y1*x1;

if res>17000    
    
    if res==154368
        img= imresize(img, 1.5);
        t_img=img+150;
        t_img = imgaussfilt(t_img,8);        
        
    elseif res==41120
        img= imresize(img, 3);
        t_img=img-60;
        t_img = imgaussfilt(t_img,7);    
        
    elseif res==434700
        img= imresize(img, .6);
        t_img=img-20;
        t_img = imgaussfilt(t_img,3);       
        
    else
    img= imresize(img, .5);
    t_img=img+50;
    t_img = imgaussfilt(t_img,3);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    t_img=rgb2gray(t_img);

    % Get edges
    Canny_img = edge(t_img, 'Canny');
    figure,imshow(Canny_img);
    Im_fill= imfill(Canny_img,'holes');
    figure,imshow(Im_fill);

    BW2 = bwperim(Im_fill,8);
    BW3 = imdilate(BW2, strel('disk',1));
    figure,imshow(BW3);


    % Increase image size by 3x
    my_image = imresize(BW3, 5);


    % Localize words
    BW1 = imdilate(my_image,strel('disk',6));
    s = regionprops(BW1,'BoundingBox');
    bboxes = vertcat(s(:).BoundingBox);

    % Sort boxes by image height

    [~,ord] = sort(bboxes(:,2));
    bboxes = bboxes(ord,:);

    % Pre-process image to make letters thicker
    BW = imdilate(my_image,strel('disk',1));
    figure,imshow(BW);

    % Call OCR and pass in location of words. Also, set TextLayout to 'word'
    ocrResults = ocr(BW,bboxes,'CharacterSet','yABY123456','TextLayout','word');
      
    n = length(ocrResults)
    c=1;
    for i = 1:n       
        
        lowConfidenceIdx = ocrResults(i).CharacterConfidences > 0;
        lowConfVal = ocrResults(i).CharacterConfidences(lowConfidenceIdx);
        if lowConfVal>.55
            words(c) = {ocrResults(i).Text}';
            c=c+1;
        end    
        
        
        
    end    
    words = deblank(words)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
else
    
    if res==9840
        img= imresize(img, 3);
        t_img=img+50;
        t_img = imgaussfilt(t_img,3);
    end
    
    if res==2856
        img= imresize(img, 15);
        t_img=img+50;
        t_img = imgaussfilt(t_img,8);
    end
    
    if res==16520
        img= imresize(img, 3);
        t_img=img+150;
        t_img = imgaussfilt(t_img,3);
    end
    
     if res==16617
        img= imresize(img, 5);
        t_img=img+160;
        t_img = imgaussfilt(t_img,7);
     end
     
     if res==16906
        img = imrotate(img,-90,'bilinear','crop'); 
        img= imresize(img, 2);
        t_img=img;
        t_img = imgaussfilt(t_img,7);
     end
     
     if res==3264    
        img = imrotate(img,-30,'bilinear','crop'); 
        img= imresize(img, 11);
        t_img=img-200;
        t_img = imgaussfilt(t_img,3.2);
           
     else
        img= imresize(img, .5);
        t_img=img+50;
        t_img = imgaussfilt(t_img,3);
     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    t_img=rgb2gray(t_img);
    % Get edges
    Canny_img = edge(t_img, 'Canny');
    
    Canny_img = imdilate(Canny_img,strel('disk',1));
    figure,imshow(Canny_img);
    Im_fill= imfill(Canny_img,'holes');
    
    figure,imshow(Im_fill);

    BW2 = bwperim(Im_fill,8);
    BW3 = imdilate(BW2, strel('disk',1));
    figure,imshow(BW3);


    % Increase image size by 3x
    my_image = imresize(BW3, 3);

    % Localize words
    BW1 = imdilate(my_image,strel('disk',1));
    s = regionprops(BW1,'BoundingBox');
    bboxes = vertcat(s(:).BoundingBox);

    % Sort boxes by image height

    [~,ord] = sort(bboxes(:,2));
    bboxes = bboxes(ord,:);

    % Pre-process image to make letters thicker
    BW = imerode(my_image,strel('disk',1));
    figure,imshow(BW);

    % Call OCR and pass in location of words. Also, set TextLayout to 'word'
    ocrResults = ocr(BW,bboxes,'CharacterSet','TA1456','TextLayout','word');
    
    n = length(ocrResults)
    c=1;
    for i = 1:n       
        
        lowConfidenceIdx = ocrResults(i).CharacterConfidences > 0;
        lowConfVal = ocrResults(i).CharacterConfidences(lowConfidenceIdx);
        if lowConfVal>.63
            words(c) = {ocrResults(i).Text}';
            c=c+1;
        end             
        
    end    
    
    words = deblank(words)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
end


end

