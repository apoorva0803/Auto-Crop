close all; clc; clear;
displayVis = false;

folder_name = 'E:\Fall 16\Digital Image Processing\challenge\2\data\';

inputImageN0 = 1;
inputImageN1 = 25;

% start the timer
tStart = tic;

%load ground truth
fn = sprintf ( '%struth.csv%', folder_name, i );
    gt = csvread ( fn );
    
points = 0;

for i = inputImageN0:inputImageN1
    
    %load input image
    input_im_name = sprintf ( '%sinput_%d.jpg', ...
        folder_name, i );
    f = imread ( input_im_name );
    

    %run auto_crop
    [sx, sy, sWidth, sHeight] = auto_crop(f);
    
    %load ground truth for this image
    x = gt(i,1);
    y = gt(i,2);
    width = gt(i,3);
    height = gt(i,4);
    
    %score
    bboxA = [x,y,width,height];
    bboxB = [sx, sy, sWidth, sHeight];
    fprintf('\n Original %d%  \n', i)
    fprintf(' %d %d %d %d', x,y,width,height);
    fprintf('\n Calculated ')
    fprintf('%d %d %d %d', sx,sy,sWidth,sHeight);
    fprintf('\n');
    % Display some results, can be taken out due to spam of photos
    if ( displayVis == true )
        g = f;
        
        g = insertShape ( g, 'Rectangle', bboxA,'Color','green', ...
            'LineWidth', 5 );

        g = insertShape ( g, 'Rectangle', bboxB,'Color','red', ...
            'LineWidth', 5 );
       
        
        
%         figure; imshow ( g );
    end

    % Compute % of overlap
    overlapRatio = bboxOverlapRatio(bboxA,bboxB);
    
    % If overlap is 80% correct then give 2 pts, or 1 pt if 50% correct
    if(overlapRatio*100 >= 80)
        points = points+2;
    elseif(overlapRatio*100 >= 50)
        points = points+1;
    end
    
    elapsedTime = toc(tStart);
    
     fprintf ( 'Image[%.0f] - Percent Overlap[%.1f] - Final Score[%.2f] - Time[%.3f sec]\n', i, overlapRatio*100, points, elapsedTime  );
end

