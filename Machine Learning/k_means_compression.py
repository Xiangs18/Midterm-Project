from __future__ import absolute_import

import k_means_clustering as km 
import matplotlib.pyplot as plt
import numpy as np
import scipy
from scipy import misc

def main():
    datafile = 'bird_small.png'
    # This creates a three-dimensional matrix bird_small whose first two indices
    # identify a pixel position and whose last index represents red, green, or blue.
    bird_small = scipy.misc.imread(datafile)

    print("bird_small shape is ", bird_small.shape)
    plt.imshow(bird_small)
    # Divide every entry in bird_small by 255 so all values are in the range of 0 to 1
    bird_small = bird_small / 255.

    # Unroll the image to shape (16384,3) (16384 is 128*128)
    bird_small = bird_small.reshape(-1, 3)

    # Run k-means on this data, forming 16 clusters, with random initialization
    clusters, centroid_history = km.run_k_means(bird_small, km.choose_random_centroids(bird_small, K=16), n_iter=10)
    final_centroids = centroid_history[-1]
    

    # Now I have 16 centroids, each representing a color.
    # Let's assign an index to each pixel in the original image dictating
    # which of the 16 colors it should be

    # Now loop through the original image and form a new image
    # that only has 16 colors in it
    n = clusters.shape[0]
    final_image = np.zeros((clusters.shape[0], 3))
    for i in range(n):
        cluster = int(clusters[i])
        final_image[i] = final_centroids[cluster]

    # Reshape the original image and the new, final image and draw them
    # To see what the "compressed" image looks like
    plt.figure()
    plt.imshow(bird_small.reshape(128, 128, 3))
    plt.figure()
    plt.imshow(final_image.reshape(128, 128, 3))

    plt.show()


if __name__ == '__main__':
    main()
