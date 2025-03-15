function [best_pattern, results] = identify_bayer_pattern(cfa_image, rgb_image, start_row, end_row, start_column, end_column)
% Define Bayer patterns
patterns = {'gbrg', 'grbg', 'bggr', 'rggb'};
results = zeros(1, 4);
% Analyze image fragment
rgb_fragment = rgb_image(start_row:end_row, start_column:end_column, :);
% Identify Bayer matrix pattern
for i = 1:4
    demosaiced_image = demosaic(cfa_image, patterns{i});
    demosaiced_fragment = demosaiced_image(start_row:end_row, start_column:end_column, :);
    results(i) = immse(demosaiced_fragment, rgb_fragment);
end
% Select the best pattern
[~, best_index] = min(results);
best_pattern = patterns{best_index};
end

function run_bayer_identification()
    % Call the function
    cfa_image = imread('demo_CFA.png');
    rgb_image = imread('demo_srgb.png');
    start_row = 80;
    end_row = 180;
    start_column = 90;
    end_column = 190;
    [best_pattern, errors] = identify_bayer_pattern(cfa_image, rgb_image, start_row, end_row, start_column, end_column);
    
    % Display results
    disp(['Best Bayer matrix pattern: ', best_pattern]);
    disp('MSE errors for each pattern:');
    disp(errors);
    
    % Demosaicing with the best pattern and display
    best_demosaiced_image = demosaic(cfa_image, best_pattern);
    
    % Focusing on the analyzed fragment
    crop_rect = [start_column start_row end_column-start_column end_row-start_row]; % [x y width height]
    best_demosaiced_cropped = imcrop(best_demosaiced_image, crop_rect);
    figure(1);
    imshow(best_demosaiced_cropped);
    title(best_pattern);
    
    % Save demosaiced fragment
    imwrite(best_demosaiced_cropped, 'best_demosaiced.png');
    
    % Save demosaiced fragments for each pattern
    patterns = {'gbrg', 'grbg', 'bggr', 'rggb'};
    
    for i = 1:4
        demosaiced_image = demosaic(cfa_image, patterns{i});
        demosaiced_cropped = imcrop(demosaiced_image, crop_rect); % Crop to the analyzed fragment
        imwrite(demosaiced_cropped, ['demosaiced_', patterns{i}, '.png']);
    end
    
    % Save raw image fragment
    cfa_fragment = imcrop(cfa_image, crop_rect);
    imwrite(cfa_fragment, 'raw_image.png');
    
    % Save RGB image fragment
    rgb_fragment = imcrop(rgb_image, crop_rect);
    imwrite(rgb_fragment, 'rgb_image.png');
end

run_bayer_identification()