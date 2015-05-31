function images = loadMNISTImages(filename)
% loadMNISTImages returns a [number of MNIST images]x[28x28] matrix containing
% raws of MNIST images. 
% For example, image[i][j] is the jth pixel of the ith image

fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);

magic = fread(fp, 1, 'int32', 0, 'ieee-be');
assert(magic == 2051, ['Bad magic number in ', filename, '']);

numImages = fread(fp, 1, 'int32', 0, 'ieee-be');
numRows   = fread(fp, 1, 'int32', 0, 'ieee-be');
numCols   = fread(fp, 1, 'int32', 0, 'ieee-be');

images    = fread(fp, inf, 'unsigned char');
images    = reshape(images, numCols * numRows, numImages);

images    = double(images)' / 255;
fclose(fp);
end
