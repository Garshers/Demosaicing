# Bayer Pattern Identification and Image Interpolation

This MATLAB script performs Bayer pattern identification and image interpolation on a given Color Filter Array (CFA) image and its corresponding RGB image.

## Description

The script includes two main functionalities:

1.  **Bayer Pattern Identification:** Identifies the Bayer pattern of a CFA image by comparing demosaiced results with a corresponding RGB image fragment.
2.  **Image Interpolation:** Resizes the CFA and demosaiced images using specified interpolation methods (nearest or bilinear) and calculates the Peak Signal-to-Noise Ratio (PSNR).

## Functions

### `identify_bayer_patterns(cfa_image, rgb_image, roi_row, roi_col)`

-   **Input:**
    -   `cfa_image`: The CFA image.
    -   `rgb_image`: The corresponding RGB image.
    -   `roi_row`: Row coordinates defining the region of interest.
    -   `roi_col`: Column coordinates defining the region of interest.
-   **Functionality:**
    -   Defines the four standard Bayer patterns (GBRG, GRBG, BGGR, RGGB).
    -   Extracts the region of interest from the RGB and CFA images.
    -   Demosaics the CFA image using each pattern.
    -   Saves the demosaiced fragments with pattern labels.
    -   Saves the raw CFA fragment and the RGB fragment.
-   **Output:**
    -   Saves image fragments to files: `demosaiced_gbrg.png`, `demosaiced_grbg.png`, `demosaiced_bggr.png`, `demosaiced_rggb.png`, `raw_image.png`, `rgb_image.png`.

### `interpolation(cfa_image, rgb_image, roi_row, roi_col, output_prefix, interpolation_method)`

-   **Input:**
    -   `cfa_image`: The CFA image.
    -   `rgb_image`: The corresponding RGB image.
    -   `roi_row`: Row coordinates defining the region of interest.
    -   `roi_col`: Column coordinates defining the region of interest.
    -   `output_prefix`: Prefix for output file names.
    -   `interpolation_method`: Interpolation method ('nearest' or 'bilinear').
-   **Functionality:**
    -   Resizes the CFA image using the specified interpolation method.
    -   Demosaics the CFA image and resizes the result.
    -   Calculates the PSNR between the resized demosaiced image and the resized RGB image.
    -   Saves the resized CFA and demosaiced images with labels and PSNR values.
    -   Saves the original RGB image and its ROI.
-   **Output:**
    -   `included_time`: Time taken for `imresize` function.
    -   `oryginal_time`: Time taken for `image_interpolation` function.
    -   Saves images to files: `output_prefix_cfa.png`, `output_prefix_nn_cfa_signed.png` (or `output_prefix_bl_cfa_signed.png`), `output_prefix_nn_rgb.png` (or `output_prefix_bl_rgb.png`), `output_prefix_nn_rgb_signed.png` (or `output_prefix_bl_rgb_signed.png`),`output_prefix_dem.png`, `output_prefix_dem_signed.png`, `output_prefix_gt.png`, `output_prefix_gt_signed.png`.

### `image_interpolation(image, n, method)`
-   **Input:**
    -   `image`: The input image.
    -   `n`: The scaling factor.
    -   `method`: Interpolation method ('nearest' or 'bilinear').
-   **Functionality:**
    -   Resizes the input image using either nearest neighbor or bilinear interpolation.
-   **Output:**
    -   `resized_image`: The resized image.

## Usage

1.  Place your CFA image as `IMG_010_srgb_CFA.png` and your corresponding RGB image as `IMG_010_srgb.png` in the same directory as the script.
2.  Open MATLAB and navigate to the script's directory.
3.  Run the script.
4.  The script will execute the `identify_bayer_patterns` and `interpolation` functions.
5.  The script will save the output images as described above.
6.  The console will display the PSNR values and timing information.

## Dependencies

-   MATLAB Image Processing Toolbox (for `demosaic`, `imresize`, `psnr`, `insertText`, `imwrite`, `imread`).

## Example Images

-   `IMG_010_srgb_CFA.png`: Example CFA image.
-   `IMG_010_srgb.png`: Example RGB image.

## Output Files

-   `demosaiced_gbrg.png`, `demosaiced_grbg.png`, `demosaiced_bggr.png`, `demosaiced_rggb.png`: Demosaiced image fragments using each of the four Bayer patterns.
-   `raw_image.png`: Raw CFA image fragment.
-   `rgb_image.png`: RGB image fragment.
-   `image3_010_srgb_cfa.png`: Resized CFA image.
-   `image3_010_srgb_nn_cfa_signed.png`, `image3_010_srgb_bl_cfa_signed.png`: Resized CFA ROI with labels.
-   `image3_010_srgb_nn_rgb.png`, `image3_010_srgb_bl_rgb.png`: Resized RGB images.
-   `image3_010_srgb_nn_rgb_signed.png`, `image3_010_srgb_bl_rgb_signed.png`: Resized RGB ROI with labels and PSNR.
-   `image3_010_srgb_dem.png`: Resized demosaiced image.
-   `image3_010_srgb_dem_signed.png`: Resized demosaiced ROI with labels and PSNR.
-   `image3_010_srgb_gt.png`: Original RGB image.
-   `image3_010_srgb_gt_signed.png`: Original RGB ROI with labels.

## Recommendation

For a deeper understanding of the concepts involved, consider reading this article:

[Noise Removal in the Developing Process of Digital Negatives](https://www.mdpi.com/1424-8220/20/3/902# "Noise Removal in the Developing Process of Digital Negatives")