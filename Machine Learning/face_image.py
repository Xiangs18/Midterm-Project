import matplotlib.pyplot as plt
import numpy as np
import pylab
import scipy.io
import scipy.misc

import pca as pca

#from solution.pca import feature_normalize, get_usv, project_data, recover_data


def get_datum_img(row):
    """
    Creates an image object from a single np array with shape 1x1032
    :param row: a single np array with shape 1x1032
    :return: the constructed image
    """
    row = np.reshape(row,(32,32))
    row = np.transpose(row )
    return row
    


def display_data(samples, num_rows, num_columns):
    """
    Function that picks the first 100 rows from X, creates an image from each,
    then stitches them together into a 10x10 grid of images, and shows it.
    """
    width, height = 32, 32
    num_rows, num_columns = num_rows, num_columns

    big_picture = np.zeros((height * num_rows, width * num_columns))

    row, column = 0, 0
    for index in range(num_rows * num_columns):
        if column == num_columns:
            row += 1
            column = 0
        img = get_datum_img(samples[index])
        big_picture[row * height:row * height + img.shape[0], column * width:column * width + img.shape[1]] = img
        column += 1
    plt.figure(figsize=(10, 10))
    img = scipy.misc.toimage(big_picture)
    plt.imshow(img, cmap=pylab.gray())


def fe_normalize(samples):
    sam = np.copy(samples)
    col = sam.shape[1]
    for i in range(col):
        std_mean = np.mean(sam[ : ,i])
        sam[ : ,i] = sam[ : ,i] - std_mean
    return sam

def main():
    datafile = 'faces.mat'
    mat = scipy.io.loadmat(datafile)
    samples = mat['X']

    # Feature normalize
    samples_norm = fe_normalize(samples)
    
    # Run SVD
    U, S = pca.get_usv(samples_norm)
    # Visualize the top 36 eigenvectors found
    top_eigen_36 = U[:,0:36]
    print(top_eigen_36)
    # Project each image down to 36 dimensions
    rep = pca.project_data(samples_norm, U, 36)
    # Attempt to recover the original data
    recovered_samples = pca.recover_data(rep, U, 36)
    # Plot the dimension-reduced data
    display_data(recovered_samples,6,6)
    
    # Plot the original data 
    display_data(samples, 6,6)
    plt.show()


if __name__ == '__main__':
    main()
