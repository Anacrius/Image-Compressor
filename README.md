# Image-Compressor
Haskell project of an image comrpessor

This image compressor code returns an alternative version of the input with less different colors (mostly common usage is for reducing the size of an image)

## How to run
At the root of the repo you can find the exe 'imageCompressor' (simply run a make to rebuild another one)
```
USAGE: ./imageCompressor n e IN v
	n	number of colors in the final image (integer between 1 and 255)
	e	convergence limit (float e.g 0.8)
	IN      path to the file containing the colors of the pixels
	v       turn visualizer on (1) or off (0)

```

## IN file
The IN file has the following format: __(x,y) (r,g,b)__
```
  (0,0) (0,255,255)
  (0,1) (120,255,120)
  (1,0) (255,255,255)
  (1,1) (0,0,0)
```
Each line represent a pixel where (x,y) is the 2D position of the pixel on the picture and (r,g,b) is the RGB color of the pixel

##  Examples
On the sampler folder (/sampler) you can find a creator of IN format that you can run with:
```
cd sampler
./sampler > **filename of your choice**
```

![visualizer example](https://i.ibb.co/0f3Zkpz/image.png)

With the textual output (i.e v at 0) let's write in a file named 4pix.txt : __(no \n on the last line)__
```
(0,0) (245,0,0)
(0,1) (255,0,0)
(1,0) (0,0,255)
(1,1) (0,0,245)
```
Then run ./imageCompressor 2 0.8 4pix 0

The resulting output may be:
```
--
(250,0,0)
-
(0,0) (245,0,0)
(0,1) (255,0,0)
--
(0,0,250)
-
(1,0) (0,0,255)
(1,1) (0,0,245)
```

Under each ```--``` you can find the newly assigned color of the pixels under the sigle ```-```

## Notes
The visualizer feature was mainly for testing purposes so it was voluntarily capped:
- do not set a n parameter higher than 16 since (in order to avoid more depedencies), only 16 colors are handled on
- in order to avoid too-larged pictures to be printed on the terminal, only a maximum size of 20x20pixels are allowed (you can use larger ones with the visualizer off)
- the output is basically a 20x20 empty characters with a black background then colorized with the output

Please note that the clusters (i.e the newly assigned colors) are based on random values so you may end up with not-so-well disposed colors (for the 4pix example, you may get the 4 pixels under the same cluster which means that your final image will only render 1 color)

## Contributors
@Aubi0ne (cluster generation and pixel assignements)
@Anacrius (file parsing, error handling and visualizer)
