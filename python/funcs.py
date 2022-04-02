import os

SRC_DATASET = r"C:\Users\ercih\Desktop\aspava-yildiz\python\images_data\dataset_256_aug"
DST_DATASET = r"C:\Users\ercih\Desktop\aspava-yildiz\python\images_data\siamese_256"

onlyfiles = [f for f in os.listdir(SRC_DATASET) if os.path.isfile((os.path.join(SRC_DATASET, f)))]
class_name = []

for file in onlyfiles:
        arr = file.split('_')
        class_name.append("_".join(arr[:2]))
setted = list(set(class_name))

for x in setted:
    path = os.path.join(DST_DATASET, x)
    os.mkdir(path)


import shutil

class_name_file = []
for file in onlyfiles:
    array = file.split('_')
    name = "_".join(array[:2])
    class_name_file.append(name)
    shutil.copy(os.path.join(SRC_DATASET, file), os.path.join(DST_DATASET, name))