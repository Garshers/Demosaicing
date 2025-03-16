function identify_bayer_patterns(cfa_image, rgb_image, roi_row, roi_col)
% Define Bayer patterns
patterns = {'gbrg', 'grbg', 'bggr', 'rggb'};

% Analyze image fragment
rgb_fragment = rgb_image(roi_row, roi_col, :);
cfa_fragment = cfa_image(roi_row, roi_col);

% Identify different demosaiced image fragment
for i = 1:length(patterns)
    demosaiced_image = demosaic(cfa_image, patterns{i});
    demosaiced_fragment = demosaiced_image(roi_row, roi_col, :);

    % Save demosaiced image fragment
    describedImage_post = insertText(demosaiced_fragment, [5 5], patterns{i}, 'FontSize', 8, 'TextColor', 'black', 'BoxOpacity', 0.4);
    imwrite(describedImage_post, ['demosaiced_', patterns{i}, '.png']);
end

% Raw fragment conversion to RGB (channel duplication)
raw_image_rgb = cat(3, cfa_fragment, cfa_fragment, cfa_fragment);
% This operation doesn't make color image (image is sill black and white)
% But it enables to save it as a standard RGB (np. .png, .jpg)

% Save raw image fragment
raw_image_post = insertText(raw_image_rgb, [5 5], 'raw image', 'FontSize', 8, 'TextColor', 'black', 'BoxOpacity', 0.4);
imwrite(raw_image_post, 'raw_image.png');

% Save RGB image fragment
rgb_image_post = insertText(rgb_fragment, [5 5], 'rgb image', 'FontSize', 8, 'TextColor', 'black', 'BoxOpacity', 0.4);
imwrite(rgb_image_post, 'rgb_image.png');
end

function demosaicing_nearest_neighbor(cfa_image, rgb_image, roi_row, roi_col, output_prefix)
% Resize CFA image using nearest neighbor (400%)
cfa_resized = imresize(cfa_image, 4, 'nearest');
cfa_resized_rgb = cat(3, cfa_resized, cfa_resized, cfa_resized); % Convert to RGB

% Demosaicing using nearest neighbor (simplified, assumes 'rggb' pattern)
demosaiced_nn = demosaic(cfa_image, 'rggb');
demosaiced_nn_resized = imresize(demosaiced_nn, 4, 'nearest');

% Resized roi values
roi_row_resized = roi_row(1)*4:roi_row(end)*4;
roi_col_resized = roi_col(1)*4:roi_col(end)*4;

% Calculate PSNR
psnr_value = psnr(demosaiced_nn, rgb_image);
disp(['PSNR for ', output_prefix, ': ', num2str(psnr_value)]);

% Save CFA img
imwrite(cfa_resized_rgb, [output_prefix, '_cfa.png']);
cfa_roi_zoom = cfa_resized_rgb(roi_col_resized, roi_row_resized, :);
cfa_roi_with_text = insertText(cfa_roi_zoom, [5*4 5*4], 'Raw image (CFA)', 'FontSize', 6 * 4, 'TextColor', 'black', 'BoxOpacity', 0.4);
imwrite(cfa_roi_with_text, [output_prefix, '_cfa_signed.png']);

% Save demosaiced img (NN)
imwrite(demosaiced_nn, [output_prefix, '_nn.png']);
demosaiced_nn_zoom = demosaiced_nn_resized(roi_col_resized, roi_row_resized, :);
nn_roi_with_text = insertText(demosaiced_nn_zoom, [5*4 5*4], sprintf('NN (PSNR = %.2f)', psnr_value), 'FontSize', 6 * 4, 'TextColor', 'black', 'BoxOpacity', 0.4);
imwrite(nn_roi_with_text, [output_prefix, '_nn_signed.png']);

% Save RGB img (GT)
imwrite(rgb_image, [output_prefix, '_gt.png']);
rgb_image_zoom = rgb_image(roi_col, roi_row, :);
rgb_roi_with_text = insertText(rgb_image_zoom, [5 5], 'Reference image (GT)', 'FontSize', 6, 'TextColor', 'black', 'BoxOpacity', 0.4);
imwrite(rgb_roi_with_text, [output_prefix, '_gt_signed.png']);
end

cfa_image = imread('IMG_012_srgb_CFA.png');
rgb_image = imread('IMG_012_srgb.png');
roi_row = 30:130;
roi_col = 150:250;
identify_bayer_patterns(cfa_image, rgb_image, roi_row, roi_col);
demosaicing_nearest_neighbor(cfa_image, rgb_image, roi_row, roi_col, 'image2_012');