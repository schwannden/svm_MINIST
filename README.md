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
└── svmTrain.m                  # To be finished by Vincent
```

### To Vincent
As you can see from the file structure, I've included the MNIST database so you don't have download it.

The main program is ``svm.m``, and you need to finish ``svmTrain.m``. I use a different ``loadMNISTImages.m`` and ``loadMNISTLabels.m`` then the one provided on Google drive, so please use mine.

The specification of each function is written clearly in the header of each file :)
