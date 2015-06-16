# SVM for MNIST
svm for [MNIST handwriting digit database](http://yann.lecun.com/exdb/mnist/)

### File Structure
```
├── MNIST                       # The MNIST database
│   ├── t10k-images.idx3-ubyte  # Training data
│   ├── t10k-labels.idx1-ubyte  # Training labels
│   ├── train-images.idx3-ubyte # Testing Data
│   └── train-labels.idx1-ubyte # Testing Labels
├── README.md                   # This File
├── arg2vars.m                  # An utility function facilitating list assignment
├── loadMNISTImages.m           # Load image files
├── loadMNISTLabels.m           # Load label files
├── svm.m                       # Main program
└── smoTrain.m                  # Vincent's optimization algorithm
```

### To Rum
run ``svm.m``
