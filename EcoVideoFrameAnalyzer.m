function [L_ED, L_ES, d_pap_ED, d_pap_ES, d_mitral_ED, d_mitral_ES, d_apex_ED, d_apex_ES] = EcoVideoFrameAnalyzer(v1,v2,v3,v4)
% INPUTS: 
% v1 is the four chamber heart view .avi video
% v2 is mitral valve view .avi video
% v3 is the papillary muscle view .avi video
% v4 is the apex view .avi video
%
% OUTPUTS:
% L_ED - Long axis of left ventricle in end-diastole
% L_ES - Long axis of left ventricle in end-systole
% d_pap_ED - Diameter of left ventricle in papillary view in end-diastole
% d_pap_ES - Diameter of left ventricle in papillary view in end-systole
% d_mitral_ED - Diameter of left ventricle in mitral view in end-diastole
% d_mitral_ES - Diameter of left ventricle in mitral view in end-systole
% d_apex_ED - Diameter of left ventricle in apex view in end-diastole
% d_apex_ES - Diameter of left ventricle in apex view in end-systole
%
% This code analyzes 4 videos and calculates the appropriate diameters and
% length of the long axis of the left ventricle for both end-diastole and
% end-systole. Note that the defaults on this code is for the videos 
% associated with Voluneteer 2 taken on April 2, 2018

%% Copy all 4 video files in same folder of Hw3.m

uiwait(msgbox({'Please input copies of the 4 video files in the same folder as the .m file.';...
'Those videos are the 4 Chamber Heart view, Mitral Valve view, Papillary Muscle view, and Apex view.'},'','help'));

quest = 'Have you copied the 4 videos into the folder?';
answer = questdlg(quest);

switch answer
    case 'Yes'
        vidName_fourch = v1;
    case 'No'
        uiwait(msgbox('Please input copies of the 4 video files in the same folder as the code.','','Error'));

        vidName_fourch = v1;
    case 'Cancel'
        quit cancel;

end

%% Pixels to cm

fourch_vid = VideoReader(vidName_fourch);
fourch = read(fourch_vid);

fig = figure;
colormap(gray)
% reads the first frame of the video stack of images
imagesc(squeeze(fourch(:,:,1,1)))

quest = {'Please calibrate the scale.';...
    'Place points on the scale where it measures 5cm.';...
    'This will calculate pixels per cm.';'';'Would you like to redifine the points?'};
answer = questdlg(quest);

switch answer
    case 'Yes'
        [x_scale,y_scale] = ginput(2);
    case 'No'
        % default settings identified previously
        x_scale = [354.6244; 354.6244];
        y_scale = [161.4679; 262.7624];
    case 'Cancel'
        quit cancel;
end

%% Identify the frame number for the 4 chamber view at end-diastole and end-systole

implay(vidName_fourch)

uiwait(msgbox({'Step through the frames on the movie player.';...
    'Note the frame number at end-diastole and end-systole.';'';...
    'DO NOT Press ''OK''';'';...
    'Press ''OK'' when you are ready to input the frame numbers.'},'','help'));

prompt = {'End-diastole frame number:','End-systole frame number:'};
name = 'Input dialog';
defaultans = {'25','35'}; % frames that I have previously identified that
numlines = 1;
answer = inputdlg(prompt, name, numlines, defaultans);
fourch_ED_frame = str2num(answer{1});
fourch_ES_frame = str2num(answer{2});

uiwait(msgbox({'Please close out of Movie Viewer.'},'','help'));


%% Idenitify points at end-diastole four chamber view and calculate long axis of the left ventricle

fig = figure;
colormap(gray)
% reads the frame that was identified as the diastole
imagesc(squeeze(fourch(:,:,1,fourch_ED_frame)))

quest = {'The left ventricle is at end-diastole.';'Place points on the bottom and top of left ventricle.';...
    'This measures the long axis of the left ventricle.'; '';...
    'Would you like to redefine the points?'};
answer = questdlg(quest);

switch answer
    case 'Yes'
        [x_fourch_ED,y_fourch_ED] = ginput(2);
    case 'No'
        % default settings identified previously
        x_fourch_ED = [242.1083; 228.0438];
        y_fourch_ED = [234.6808; 119.3455];
    case 'Cancel'
        quit cancel;
end

l_pixel_cm = (sqrt((x_scale(2)-x_scale(1))^2 + (y_scale(1)-y_scale(2))^2))/5;
L_ED_pixels = sqrt((x_fourch_ED(2)-x_fourch_ED(1))^2 + (y_fourch_ED(1)-y_fourch_ED(2))^2);

L_ED = L_ED_pixels/l_pixel_cm;

%% Idenitify points at end-systole four chamber view and calculate long axis of the left ventricle

fig = figure;
colormap(gray)
% reads the frame that was identified at end-systole
imagesc(squeeze(fourch(:,:,1,fourch_ES_frame)))

quest = {'The left ventricle is at end-systole.';'Place points on the bottom and top of left ventricle.';...
    'This measures the long axis of the left ventricle.';'';...
    'Would you like to redefine the points?'};
answer = questdlg(quest);

switch answer
    case 'Yes'
        [x_fourch_ES,y_fourch_ES] = ginput(2);
    case 'No'
        % default settings identified previously
        x_fourch_ES = [234.0714; 224.0253];
        y_fourch_ES = [214.6224; 118.3426];
    case 'Cancel'
        quit cancel;
end

L_ES_pixels = sqrt((x_fourch_ES(2)-x_fourch_ES(1))^2 + (y_fourch_ES(1)-y_fourch_ES(2))^2);

L_ES = L_ES_pixels/l_pixel_cm;

%% Identify the frame number for the mitral valve view at end-diastole and end-systole

vidName_mitral = v2;
implay(vidName_mitral)

uiwait(msgbox({'Step through the frames on the movie player';...
    'Note the frame number at end-diasole and end-systole';'';...
    'DO NOT Press ''OK''';'';...
    'Press ''OK'' when you are ready to input the frame numbers'},'','help'));

prompt = {'End-diasole frame number:','End-systole frame number:'};
name = 'Input dialog';
defaultans = {'28','39'}; % frames that I have previously identified that
numlines = 1;
answer = inputdlg(prompt, name, numlines, defaultans);
mitral_ED_frame = str2num(answer{1});
mitral_ES_frame = str2num(answer{2});

uiwait(msgbox({'Please close out of Movie Viewer'},'','help'));

%% Idenitify points on the diastole mitral valve view and calculate the diameter

mitral_vid = VideoReader(vidName_mitral);
mitral = read(mitral_vid);

fig = figure;
colormap(gray)
% reads the frame that was identified at end-diastole
imagesc(squeeze(mitral(:,:,1,mitral_ED_frame)))

quest = {'The mitral valve is at end-diastole.';'Place points on the bottom and top of diameter.';...
    'This measures the diameter of the mitral valve.'; '';...
    'Would you like to redefine the points?'};
answer = questdlg(quest);

switch answer
    case 'Yes'
        [x_mitral_ED,y_mitral_ED] = ginput(2);
    case 'No'
        % default settings identified previously
        x_mitral_ED = [239.0945; 227.0392];
        y_mitral_ED = [271.7886; 168.4883];
    case 'Cancel'
        quit cancel;
end

d_mitral_ED_pixels = sqrt((x_mitral_ED(2)-x_mitral_ED(1))^2 + (y_mitral_ED(1)-y_mitral_ED(2))^2);

d_mitral_ED = d_mitral_ED_pixels/l_pixel_cm;

%% Idenitify points at end-systole mitral valve view and calculate the diameter

fig = figure;
colormap(gray)
% reads the frame that was identified at end-systole
imagesc(squeeze(mitral(:,:,1,mitral_ES_frame)))

quest = {'The mitral valve view is at end-systole.';'Place points on the bottom and top of diameter.';...
    'This measures the diameter of the mitral valve.';'';...
    'Would you like to redefine the points?'};
answer = questdlg(quest);

switch answer
    case 'Yes'
        [x_mitral_ES,y_mitral_ES] = ginput(2);
    case 'No'
        % default settings identified previously
        x_mitral_ES = [245.1221; 243.1129];
        y_mitral_ES = [259.7536; 186.5408];
    case 'Cancel'
        quit cancel;
end


d_mitral_ES_pixels = sqrt((x_mitral_ES(2)-x_mitral_ES(1))^2 + (y_mitral_ES(1)-y_mitral_ES(2))^2);

d_mitral_ES = d_mitral_ES_pixels/l_pixel_cm;

%% Identify the frame number for the papillary muscle view at end-diastole and end-systole

vidName_pap = v3;
implay(vidName_pap)

uiwait(msgbox({'Step through the frames on the movie player';...
    'Note the frame number at end-diasole and end-systole';'';...
    'DO NOT Press ''OK''';'';...
    'Press ''OK'' when you are ready to input the frame numbers'},'','help'));

prompt = {'End-diasole frame number:','End-systole frame number:'};
name = 'Input dialog';
defaultans = {'45','33'}; % frames that I have previously identified that
numlines = 1;
answer = inputdlg(prompt, name, numlines, defaultans);
pap_ED_frame = str2num(answer{1});
pap_ES_frame = str2num(answer{2});

uiwait(msgbox({'Please close out of Movie Viewer'},'','help'));

%% Idenitify points at end-diastole papillary muscle view and calculate the diameter

pap_vid = VideoReader(vidName_pap);
pap = read(pap_vid);

fig = figure;
colormap(gray)
% reads the frame that was identified at end-diastole
imagesc(squeeze(pap(:,:,1,pap_ED_frame)))

quest = {'The papillary muscle is at end-diastole.';'Place points on the bottom and top of diameter.';...
    'This measures the diameter of the papillary muscle.'; '';...
    'Would you like to redefine the points?'};
answer = questdlg(quest);

switch answer
    case 'Yes'
        [x_pap_ED,y_pap_ED] = ginput(2);
    case 'No'
        % default settings identified previously
        x_pap_ED = [235.0760; 229.0484];
        y_pap_ED = [253.7362; 154.4475];
    case 'Cancel'
        quit cancel;
end


d_pap_ED_pixels = sqrt((x_pap_ED(2)-x_pap_ED(1))^2 + (y_pap_ED(1)-y_pap_ED(2))^2);

d_pap_ED = d_pap_ED_pixels/l_pixel_cm;

%% Idenitify points at end-systole papillary muscle view and calculate the diameter

fig = figure;
colormap(gray)
% reads the frame that was identified at end-systole
imagesc(squeeze(pap(:,:,1,pap_ES_frame)))

quest = {'The papillary muscle view is at end-systole.';'Place points on the bottom and top of diameter.';...
    'This measures the diameter of the papillary muscle.';'';...
    'Would you like to redefine the points?'};
answer = questdlg(quest);

switch answer
    case 'Yes'
        [x_pap_ES,y_pap_ES] = ginput(2);
    case 'No'
        % default settings identified previously
        x_pap_ES = [233.0668; 227.0392];
        y_pap_ES = [226.6574; 165.4796];
    case 'Cancel'
        quit cancel;
end

d_pap_ES_pixels = sqrt((x_pap_ES(2)-x_pap_ES(1))^2 + (y_pap_ES(1)-y_pap_ES(2))^2);

d_pap_ES = d_pap_ES_pixels/l_pixel_cm;

%% Identify the frame number for the apex view at end-diastole and end-systole

vidName_apex = v4;
implay(vidName_apex)

uiwait(msgbox({'Step through the frames on the movie player';...
    'Note the frame number at end-diasole and end-systole';'';...
    'DO NOT Press ''OK''';'';...
    'Press ''OK'' when you are ready to input the frame numbers'},'','help'));

prompt = {'End-diasole frame number:','End-systole frame number:'};
name = 'Input dialog';
defaultans = {'23','10'}; % frames that I have previously identified that
numlines = 1;
answer = inputdlg(prompt, name, numlines, defaultans);
apex_ED_frame = str2num(answer{1});
apex_ES_frame = str2num(answer{2});

uiwait(msgbox({'Please close out of Movie Viewer'},'','help'));

%% Idenitify points at end-diastole apex view and calculate the diameter

apex_vid = VideoReader(vidName_apex);
apex = read(apex_vid);

fig = figure;
colormap(gray)
% reads the frame that was identified at end-diastole
imagesc(squeeze(apex(:,:,1,apex_ED_frame)))

quest = {'The apex is at end-diastole.';'Place points on the bottom and top of diameter.';...
    'This measures the diameter of the apex.'; '';...
    'Would you like to redefine the points?'};
answer = questdlg(quest);

switch answer
    case 'Yes'
        [x_apex_ED,y_apex_ED] = ginput(2);
    case 'No'
        % default settings identified previously
        x_apex_ED = [228.0438; 226.0346];
        y_apex_ED = [184.5350; 137.3980];
    case 'Cancel'
        quit cancel;
end

d_apex_ED_pixels = sqrt((x_apex_ED(2)-x_apex_ED(1))^2 + (y_apex_ED(1)-y_apex_ED(2))^2);

d_apex_ED = d_apex_ED_pixels/l_pixel_cm;

%% Idenitify points at end-systole apex view and calculate the diameter

fig = figure;
colormap(gray)
% reads the frame that was identified at end-systole
imagesc(squeeze(apex(:,:,1,apex_ES_frame)))

quest = {'The apex view at end-systole.';'Place points on the bottom and top of diameter.';...
    'This measures the diameter of the apex.';'';...
    'Would you like to redefine the points?'};
answer = questdlg(quest);

switch answer
    case 'Yes'
        [x_apex_ES,y_apex_ES] = ginput(2);
    case 'No'
        % default settings identified previously
        x_apex_ES = [243.1129; 240.0991];
        y_apex_ES = [167.4854; 144.4184];
    case 'Cancel'
        quit cancel;
end

d_apex_ES_pixels = sqrt((x_apex_ES(2)-x_apex_ES(1))^2 + (y_apex_ES(1)-y_apex_ES(2))^2);

d_apex_ES = d_apex_ES_pixels/l_pixel_cm;

end
