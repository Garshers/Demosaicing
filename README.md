# Bayer Pattern Identification

This MATLAB script identifies the Bayer pattern of a given Color Filter Array (CFA) image by comparing demosaiced results with a corresponding RGB image fragment.

## Description

The script takes a CFA image and its corresponding RGB image as input, along with the coordinates of a specific region of interest. It then attempts to demosaic the CFA image using each of the four possible Bayer patterns (GBRG, GRBG, BGGR, and RGGB). The mean squared error (MSE) between the demosaiced results and the known RGB image fragment is calculated for each pattern. The pattern that yields the lowest MSE is identified as the best match.

## Functions

### `identify_bayer_pattern(cfa_image, rgb_image, start_row, end_row, start_column, end_column)`

-   **Input:**
    -   `cfa_image`: The CFA image.
    -   `rgb_image`: The corresponding RGB image.
    -   `start_row`, `end_row`, `start_column`, `end_column`: Coordinates defining the region of interest.
-   **Output:**
    -   `best_pattern`: The identified Bayer pattern (e.g., 'rggb').
    -   `results`: A vector containing the MSE for each Bayer pattern.
-   **Functionality:**
    -   Defines the four standard Bayer patterns.
    -   Extracts the region of interest from the RGB image.
    -   Demosaics the CFA image using each pattern.
    -   Calculates the MSE between each demosaiced result and the RGB fragment.
    -   Identifies the pattern with the lowest MSE.

### `run_bayer_identification()`

-   **Functionality:**
    -   Loads the CFA image (`demo_CFA.png`) and the RGB image (`demo.png`).
    -   Defines the region of interest.
    -   Calls `identify_bayer_pattern()` to determine the best Bayer pattern.
    -   Displays the identified pattern and MSE results.
    -   Demosaics the CFA image using the best pattern and displays the cropped result.
    -   Saves the cropped demosaiced images for all 4 bayer patterns.
    -   Saves the raw cfa fragment and the rgb fragment.

## Usage

1.  Place your CFA image as `demo_CFA.png` and your corresponding RGB image as `demo.png` in the same directory as the script.
2.  Open MATLAB and navigate to the script's directory.
3.  Run the `run_bayer_identification()` function.
4.  The script will display the identified Bayer pattern and the MSE results.
5.  The script will also display the demosaiced cropped image using the best bayer pattern.
6.  The script will save the cropped demosaiced images from all 4 bayer patterns, the raw cfa fragment and the rgb fragment.

## Dependencies

-   MATLAB Image Processing Toolbox (for `demosaic`, `immse`, `imcrop`, and `imshow`).

## Example Images

-   `demo_CFA.png`: Example CFA image.
-   `demo.png`: Example RGB image.

## Output Files

-   `best_demosaiced.png`: Demosaiced image fragment using the best identified Bayer pattern.
-   `demosaiced_gbrg.png`, `demosaiced_grbg.png`, `demosaiced_bggr.png`, `demosaiced_rggb.png`: Demosaiced image fragments using each of the four Bayer patterns.
-   `raw_image.png`: Raw cfa image fragment.
-   `rgb_image.png`: RGB image fragment.