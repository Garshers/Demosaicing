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

function [included_time, oryginal_time] = interpolation(cfa_image, rgb_image, roi_row, roi_col, output_prefix, interpolation_method)
    % Check if the interpolation method is valid
    if ~strcmp(interpolation_method, 'nearest') && ~strcmp(interpolation_method, 'bilinear')
        error('Invalid interpolation method. Use ''nearest'' or ''bilinear''.');
    end
    
    % Resize CFA image
    n = 4;
    %cfa_resized = imresize(cfa_image, n, interpolation_method);
    cfa_resized = image_interpolation(cfa_image, n, interpolation_method);
    cfa_resized_rgb = cat(3, cfa_resized, cfa_resized, cfa_resized);
    
    % Resize RGB image
    tic;
    %cfa_resized = imresize(rgb_image, n, interpolation_method);
    rgb_resized = image_interpolation(rgb_image, n, interpolation_method);
    oryginal_time = toc;
    
    tic;
    rgb_resized2 = imresize(rgb_image, n, interpolation_method);
    included_time = toc;
    
    % Demosaicing
    demosaiced = demosaic(cfa_image, 'bggr');
    
    % Resized ROI values
    roi_row_resized = roi_row(1)*n:roi_row(end)*n;
    roi_col_resized = roi_col(1)*n:roi_col(end)*n;
    
    % Calculate PSNR
    psnr_dem = psnr(demosaiced, rgb_image);
    psnr_rgb = psnr(rgb_resized, rgb_resized2);
    disp(['PSNR for demosaic: ', num2str(psnr_dem)]);
    disp(['PSNR for ', interpolation_method, ': ', num2str(psnr_rgb)]);
    
    % Save interpolated img
    imwrite(rgb_resized, [output_prefix, '_' interpolation_method(1:2) '_rgb.png']); %ne or bi
    
    interpolated_rgb_roi_zoom = rgb_resized(roi_row_resized, roi_col_resized, :);
    interpolated_rgb_roi_with_text = insertText(interpolated_rgb_roi_zoom, [5*n 5*n], sprintf('%s (PSNR = %.2f)', upper(interpolation_method(1:2)), psnr_rgb), 'FontSize', 6*n, 'TextColor', 'black', 'BoxOpacity', 0.4);
    imwrite(interpolated_rgb_roi_with_text, [output_prefix, '_' interpolation_method(1:2) '_rgb_signed.png']);
    
    % Save CFA img
    imwrite(cfa_resized_rgb, [output_prefix, '_' interpolation_method(1:2) '_cfa.png']);
    
    cfa_roi_zoom = cfa_resized_rgb(roi_row_resized, roi_col_resized, :);
    cfa_roi_with_text = insertText(cfa_roi_zoom, [5*n 5*n], 'Raw image (CFA)', 'FontSize', 6 * n, 'TextColor', 'black', 'BoxOpacity', 0.4);
    imwrite(cfa_roi_with_text, [output_prefix, '_' interpolation_method(1:2) '_cfa_signed.png']);
    
    % Save demosaiced img
    imwrite(demosaiced, [output_prefix, '_' interpolation_method(1:2) '_dem.png']);
    
    demosaiced_zoom = demosaiced(roi_row, roi_col, :);
    demosaiced_roi_with_text = insertText(demosaiced_zoom, [5 5], sprintf('DE (PSNR = %.2f)', psnr_dem), 'FontSize', 6, 'TextColor', 'black', 'BoxOpacity', 0.4);
    imwrite(demosaiced_roi_with_text, [output_prefix, '_' interpolation_method(1:2) '_dem_signed.png']);
    
    % Save RGB img (GT)
    imwrite(rgb_image, [output_prefix, '_gt.png']);
    
    rgb_image_zoom = rgb_image(roi_row, roi_col, :);
    rgb_roi_with_text = insertText(rgb_image_zoom, [5 5], 'Reference image (GT)', 'FontSize', 6, 'TextColor', 'black', 'BoxOpacity', 0.4);
    imwrite(rgb_roi_with_text, [output_prefix, '_' interpolation_method(1:2) '_gt_signed.png']);
    
    figure;
    subplot(1, 3, 1);
    imshow(rgb_image(roi_row, roi_col, :));
    title('rgb image');
    
    subplot(1, 3, 2);
    imshow(demosaiced_zoom);
    title('demosaiced');
    
    subplot(1, 3, 3);
    imshow(interpolated_rgb_roi_zoom);
    title([interpolation_method, ' interpolation']);
end

function resized_image = image_interpolation(image, n, method)
    [original_height, original_width, num_channels] = size(image);
    new_height = round(original_height * n);
    new_width = round(original_width * n);
    resized_image = -ones(new_height, new_width, num_channels, class(image)); % Output image (all -1)
    
    if strcmp(method, 'nearest') % Nearest neighbor interpolation
        for new_y = 1:new_height
            for new_x = 1:new_width
                % Give value to each pixel in the resized image taking the nearest pixel in the original image
                original_x = floor((new_x - 1) / n) + 1; % Edge cases not included <--
                original_y = floor((new_y - 1) / n) + 1;
                
                % Copy the original pixel value to the resized image
                resized_image(new_y, new_x, :) = image(original_y, original_x, :);
            end
        end
    elseif strcmp(method, 'bilinear') % Bilinear interpolation
        % Calculate scaling ratios for x and y coordinates
        x_ratio = (original_width - 1) / max(new_width - 1, 1);
        y_ratio = (original_height - 1) / max(new_height - 1, 1);
    
        for new_y = 1:new_height
            for new_x = 1:new_width
                % Map coordinates using scaling ratios
                x = (new_x - 1) * x_ratio + 1;
                y = (new_y - 1) * y_ratio + 1;
    
                % Find the four neighboring pixels
                x1 = floor(x);
                y1 = floor(y);
                x2 = min(x1 + 1, original_width);
                y2 = min(y1 + 1, original_height);
    
                % Calculate weights
                dx = x - x1;
                dy = y - y1;
    
                % Process each channel
                for channel = 1:num_channels
                    % Get neighboring pixel values
                    pixel1 = double(image(y1, x1, channel));
                    pixel2 = double(image(y1, x2, channel));
                    pixel3 = double(image(y2, x1, channel));
                    pixel4 = double(image(y2, x2, channel));
    
                    % Bilinear interpolation
                    interpolated_pixel = (1 - dx) * (1 - dy) * pixel1 + dx * (1 - dy) * pixel2 + ...
                                         (1 - dx) * dy * pixel3 + dx * dy * pixel4;
    
                    resized_image(new_y, new_x, channel) = interpolated_pixel;
                end
            end
        end
    else
        error('Unknown method. Select "nearest" or "bilinear".');
    end
end

cfa_image = imread('IMG_010_srgb_CFA.png');
rgb_image = imread('IMG_010_srgb.png');
roi_row = 30:130;
roi_col = 150:250;

%identify_bayer_patterns(cfa_image, rgb_image, roi_row, roi_col);
%[~, ~] = interpolation(cfa_image, rgb_image, roi_row, roi_col, 'image2_010_srgb', 'nearest');
[~, ~] = interpolation(cfa_image, rgb_image, roi_row, roi_col, 'image3_010_srgb', 'bilinear');