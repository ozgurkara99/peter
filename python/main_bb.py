from pydoc import apropos
from re import M
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


argpar = argparse.ArgumentParser()
argpar.add_argument("--w", type=int, default=256)
argpar.add_argument("--h", type=int, default=256)
argpar.add_argument("--img_folder", type=str, default="python/images_data/deniz_dogs")
argpar.add_argument("--dst_folder", type=str, default="python/images_data/dataset_256")
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



def get_coloured_mask(mask):
  colours = [[0, 255, 0],[0, 0, 255],[255, 0, 0],[0, 255, 255],[255, 255, 0],[255, 0, 255],[80, 70, 180],[250, 80, 190],[245, 145, 50],[70, 150, 250],[50, 190, 190]]
  r = np.zeros_like(mask).astype(np.uint8)
  g = np.zeros_like(mask).astype(np.uint8)
  b = np.zeros_like(mask).astype(np.uint8)
  r[mask == 1], g[mask == 1], b[mask == 1] = colours[random.randrange(0,10)]
  coloured_mask = np.stack([r, g, b], axis=2)
  return coloured_mask



def get_prediction(img_path, confidence, width, height):
  img = Image.open(img_path)
  img_return = img.resize((width, height), Image.BILINEAR)
  transform = T.Compose([T.ToTensor()])
  img = transform(img_return).cuda()
  pred = model([img])
  pred_score = list(pred[0]['scores'].cpu().detach().numpy())
  pred_t = [pred_score.index(x) for x in pred_score if x>confidence][-1]
  pred_class = [COCO_CLASS_NAMES[i] for i in list(pred[0]['labels'].cpu().detach().numpy())]
  dog_index = pred_class.index("dog")
  masks = (pred[0]['masks']>0.5).squeeze().detach().cpu().numpy()
  if len(np.shape(masks)) == 2:
    masks = np.expand_dims(masks, axis=0)
  masks = np.expand_dims(masks[dog_index], axis=0)
  
  pred_class = pred_class[:pred_t+1]
  return masks, pred_class, img_return.convert('RGB')




def segment_instance(img_path, width, height, dst, confidence=0.5):
  masks, pred_cls, img = get_prediction(img_path, confidence, width, height)
  print(pred_cls)
  x = np.asarray(img)
  masks = masks.astype(int)

  masks_summed = np.sum(np.squeeze(masks,axis=0), axis = 1) # sum column by column
  indices = np.nonzero(masks_summed)
  top, bottom = indices[0][0], indices[0][-1]

  masks_summed_2 = np.sum(np.squeeze(masks), axis = 0) # sum column by column
  indices = np.nonzero(masks_summed_2)
  left, right = indices[0][0], indices[0][-1]

  # result = img[]
  # result = np.multiply(masks,x)
  result = x[top:bottom,left:right,:].astype(np.uint8)
  img_path = img_path.replace("\\", "/")
  fp = os.path.join(dst, img_path.split("/")[-1])

  plt.imsave(fp, result)

  # plt.show()




# from os import listdir
# from os.path import isfile, join
# from tqdm import tqdm


# onlyfiles = [f for f in listdir(args.img_folder) if isfile(join(args.img_folder, f))]
# onlyfiles_dst = [f for f in listdir(args.dst_folder) if isfile(join(args.dst_folder, f))]
# onlyfiles = list(set(onlyfiles) - set(onlyfiles_dst))
# for file in tqdm(onlyfiles):
#   try:
#     file_p = os.path.join(args.img_folder, file)
#     segment_instance(file_p, args.w, args.h, confidence=0.5)
#   except:
#     pass
