function identify_bayer_pattern(cfa_image, rgb_image, roi_row, roi_col)
% Define Bayer patterns
patterns = {'gbrg', 'grbg', 'bggr', 'rggb'};

% Analyze image fragment
rgb_fragment = rgb_image(roi_row, roi_col, :);
cfa_fragment = cfa_image(roi_row, roi_col);

% Identify Bayer matrix pattern
for i = 1:length(patterns)
    demosaiced_image = demosaic(cfa_image, patterns{i});
    demosaiced_fragment = demosaiced_image(roi_row, roi_col, :);

    describedImage_post = insertText(demosaiced_fragment, [5 5], patterns{i}, 'FontSize', 8, 'TextColor', 'black', 'BoxOpacity', 0.4);
    imwrite(describedImage_post, ['demosaiced_', patterns{i}, '.png']);
end

% Konwersja surowego fragmentu do RGB (powielanie kanałów)
raw_image = cat(3, cfa_fragment, cfa_fragment, cfa_fragment);

% Save raw image fragment
raw_image_post = insertText(raw_image, [5 5], 'raw image', 'FontSize', 8, 'TextColor', 'black', 'BoxOpacity', 0.4);
imwrite(raw_image_post, 'raw_image.png');

% Save RGB image fragment
rgb_image_post = insertText(rgb_fragment, [5 5], 'rgb image', 'FontSize', 8, 'TextColor', 'black', 'BoxOpacity', 0.4);
imwrite(rgb_image_post, 'rgb_image.png');
end

cfa_image = imread('IMG_003_srgb_CFA.png');
rgb_image = imread('IMG_003_srgb.png');
roi_row = 80:180;
roi_col = 90:190;
identify_bayer_pattern(cfa_image, rgb_image, roi_row, roi_col);