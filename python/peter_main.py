# trying to create a file where bb is applied to the images from firebase then upload the siamese result to the firebase too.
from PIL import Image
import matplotlib.pyplot as plt
import torch
import torchvision.transforms as T
import torchvision
import numpy as np

import cv2
import random
import warnings
import argparse
import os

import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
from firebase_admin import firestore
import requests

from main_bb import *
from firebase import fire

from os import listdir
from os.path import isfile, join
from tqdm import tqdm

import matplotlib.pyplot as plt
import numpy as np
import random
from PIL import Image
import PIL.ImageOps    

import torchvision
import torchvision.datasets as datasets
import torchvision.transforms as transforms
from torch.utils.data import DataLoader, Dataset
import torchvision.utils
import torch
from torch.autograd import Variable
import torch.nn as nn
from torch import optim
import torch.nn.functional as F

class SiameseNetwork(nn.Module):

    def __init__(self):
        super(SiameseNetwork, self).__init__()

        # Setting up the Sequential of CNN Layers
        self.cnn1 = nn.Sequential(
            nn.Conv2d(3, 96, kernel_size=11,stride=4),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(3, stride=2),
            
            nn.Conv2d(96, 256, kernel_size=5, stride=1),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(2, stride=2),

            nn.Conv2d(256, 384, kernel_size=3,stride=1),
            nn.ReLU(inplace=True)
        )

        # Setting up the Fully Connected Layers
        self.fc1 = nn.Sequential(
            nn.Linear(384, 1024),
            nn.ReLU(inplace=True),
            
            nn.Linear(1024, 256),
            nn.ReLU(inplace=True),
            
            nn.Linear(256,2)
        )
        
    def forward_once(self, x):
        # This function will be called for both images
        # Its output is used to determine the similiarity
        output = self.cnn1(x)
        output = output.view(output.size()[0], -1)
        output = self.fc1(output)
        return output

    def forward(self, input1, input2):
        # In this function we pass in both images and obtain both vectors
        # which are returned
        output1 = self.forward_once(input1)
        output2 = self.forward_once(input2)

        return output1, output2

net = SiameseNetwork()
net.load_state_dict(torch.load(r"C:\Users\ercih\Desktop\aspava-yildiz\model.pb"))

import cv2
from PIL import Image
import torch.nn.functional as F

class ContrastiveLoss(torch.nn.Module):
    def __init__(self, margin=2.0):
        super(ContrastiveLoss, self).__init__()
        self.margin = margin

    def forward(self, output1, output2):
      # Calculate the euclidean distance and calculate the contrastive loss
      euclidean_distance = F.pairwise_distance(output1, output2, keepdim = True)


      return euclidean_distance

loss = ContrastiveLoss()

def inference(f1, f2):
    img0_pil = Image.open(f1).convert("RGB")
    # img0_flipped_pil = Image.fromarray(cv2.flip(np.asarray(img0_pil), 0))
    img0_flipped_pil = Image.open(f2).convert("RGB")
    transformation = transforms.Compose([transforms.Resize((100,100)),
                                        transforms.ToTensor()
                                    ])
    img0 = transformation(img0_pil)
    img0_flipped = transformation(img0_flipped_pil)
    output1, output2 = net(torch.unsqueeze(img0, dim=0), torch.unsqueeze(img0_flipped, dim=0))
    dist = loss(output1, output2)
    return dist

# get data from deniz
# Fetch the service account key JSON file contents
cred = credentials.Certificate(r'python/secret_key.json')
# Initialize the app with a service account, granting admin privileges

firebase_admin.initialize_app(cred)
db = firestore.client()


doc_ref = db.collection(u'users').document(u'1JCfGKVqtcW3BReDEcb6')
print(doc_ref)


users_ref = db.collection(u'users')
docs = users_ref.stream()

for doc in docs:
  a = doc.to_dict()
  image_url = a["pets"][0]["image"]
  img_data = requests.get(image_url).content
  if a["name"] == "davut":    
    with open(os.path.join("python/firebase_images","dogx.jpg"), 'wb') as handler:
      handler.write(img_data)
    break

users_ref = db.collection(u'users')
docs = users_ref.stream()
dic_data = {}
for doc in docs:
  #print(f'{doc.id} => {doc.to_dict()}')

  a = doc.to_dict()
  dic_data[doc.id] = a
  image_url = a["pets"][0]["image"]
  img_data = requests.get(image_url).content
  with open(os.path.join("python/firebase_images", a["pets"][0]["name"] + ".jpg"), 'wb') as handler:
    handler.write(img_data)


argpar = argparse.ArgumentParser()
argpar.add_argument("--w", type=int, default=256)
argpar.add_argument("--h", type=int, default=256)
argpar.add_argument("--img_folder", type=str, default=r"C:\Users\ercih\Desktop\aspava-yildiz\python\firebase_images")
argpar.add_argument("--dst_folder", type=str, default=r"C:\Users\ercih\Desktop\aspava-yildiz\python\firebase_images_segmented")
args = argpar.parse_args()

warnings.filterwarnings('ignore')

# load model
model = torchvision.models.detection.maskrcnn_resnet50_fpn(pretrained=True).cuda()
# set to evaluation mode
model.eval()

if not os.path.exists(args.dst_folder):
  os.mkdir(args.dst_folder) 

# load COCO category names
COCO_CLASS_NAMES = [
    '__background__', 'person', 'bicycle', 'car', 'motorcycle', 'airplane', 'bus',
    'train', 'truck', 'boat', 'traffic light', 'fire hydrant', 'N/A', 'stop sign',
    'parking meter', 'bench', 'bird', 'cat', 'dog', 'horse', 'sheep', 'cow',
    'elephant', 'bear', 'zebra', 'giraffe', 'N/A', 'backpack', 'umbrella', 'N/A', 'N/A',
    'handbag', 'tie', 'suitcase', 'frisbee', 'skis', 'snowboard', 'sports ball',
    'kite', 'baseball bat', 'baseball glove', 'skateboard', 'surfboard', 'tennis racket',
    'bottle', 'N/A', 'wine glass', 'cup', 'fork', 'knife', 'spoon', 'bowl',
    'banana', 'apple', 'sandwich', 'orange', 'broccoli', 'carrot', 'hot dog', 'pizza',
    'donut', 'cake', 'chair', 'couch', 'potted plant', 'bed', 'N/A', 'dining table',
    'N/A', 'N/A', 'toilet', 'N/A', 'tv', 'laptop', 'mouse', 'remote', 'keyboard', 'cell phone',
    'microwave', 'oven', 'toaster', 'sink', 'refrigerator', 'N/A', 'book',
    'clock', 'vase', 'scissors', 'teddy bear', 'hair drier', 'toothbrush'
]


onlyfiles = [f for f in listdir(args.img_folder) if isfile(join(args.img_folder, f))]
# onlyfiles_dst = [f for f in listdir(args.dst_folder) if isfile(join(args.dst_folder, f))]
# onlyfiles = list(set(onlyfiles) - set(onlyfiles_dst))
for file in tqdm(onlyfiles):
  #try:
    file_p = os.path.join(args.img_folder, file)
    segment_instance(file_p, args.w, args.h, args.dst_folder, confidence=0.5)
    if file == "dogx.jpg":
      file_dogx = file_p
      break
dist_dict = {}
for file in tqdm(onlyfiles):
  #try:
    file_p = os.path.join(args.img_folder, file)
    segment_instance(file_p, args.w, args.h, args.dst_folder, confidence=0.5)
    if file == "dogx.jpg":
      continue
    dist = inference(file_p, file_dogx)
    dist_dict[file[:-4]] = float(dist.item())
    print(f"Distance between {file} and dogx is {dist}")

dist_dict["dogx"] = np.finfo(np.float32).eps

list_dict = np.array([1/x for y,x in dist_dict.items()])
list_dict = list_dict - np.min(list_dict)
list_dict = list_dict / np.max(list_dict)

for i,(key,val) in enumerate(dic_data.items()):
  dist_dict[key] = round(list_dict[i]*100,2)

for i,(key,val) in enumerate(dic_data.items()):

  if val["pets"][0]["name"] == "dogx":
    val["pets"][0]["similarity"] = 0
  else:
    val["pets"][0]["similarity"] = int(round(dist_dict[val["pets"][0]["name"]],2) * 100)
  db.collection(u'users').document(key).set(val)
