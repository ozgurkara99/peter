import os
from os.path import isfile, join
import random
import shutil
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--n", type=int, default=5)
args = parser.parse_args()

def data_generator(num_images):
    onlyfolders = [f for f in os.listdir(r"D:\images\Images") if os.path.isdir((os.path.join(r"D:\images\Images", f)))]
    # returns list of folders
    for folder in onlyfolders:
        onlyfiles = [l for l in os.listdir((os.path.join(r"D:\images\Images", folder))) if os.path.isfile((os.path.join(r"D:\images\Images", folder, l)))]
        # returns list of files
        listed_elements = random.sample(onlyfiles, num_images)
        for k in listed_elements:
            shutil.copyfile((os.path.join(r"D:\images\Images", folder, k)), os.path.join(r"C:\Users\ercih\Desktop\aspava-yildiz\python\images", k))

data_generator(args.n)