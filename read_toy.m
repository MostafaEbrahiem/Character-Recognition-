function [] = read_toy(img)

%inhance image

img= imresize(img, .5);

t_img=img+50;
t_img = imgaussfilt(t_img,3);

t_img=rgb2gray(t_img);

% Get edges
Canny_img = edge(t_img, 'Canny');
figure,imshow(Canny_img);

Im_fill= imfill(Canny_img,'holes');
figure,imshow(Im_fill)

BW2 = bwperim(Im_fill,8);
BW3 = imdilate(BW2, strel('disk',1));
figure,imshow(BW3);


% Increase image size by 3x
my_image = imresize(BW3, 5);
figure,imshow(my_image);

% Localize words
BW1 = imdilate(my_image,strel('disk',6));
s = regionprops(BW1,'BoundingBox');
bboxes = vertcat(s(:).BoundingBox);
% Sort boxes by image height

[~,ord] = sort(bboxes(:,2));
bboxes = bboxes(ord,:);

% Pre-process image to make letters thicker
BW = imdilate(my_image,strel('disk',1));

% Call OCR and pass in location of words. Also, set TextLayout to 'word'
ocrResults = ocr(BW,bboxes,'CharacterSet','TyAbBY123456','TextLayout','word');





words = {ocrResults(:).Text}';

words = deblank(words)

end

