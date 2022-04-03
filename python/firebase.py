import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
from firebase_admin import firestore
import requests
import os

def fire():

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
        #print(f'{doc.id} => {doc.to_dict()}')

        a = doc.to_dict()
        image_url = a["pets"][0]["image"]
        img_data = requests.get(image_url).content
        with open(os.path.join("python/firebase_images", a["pets"][0]["name"] + ".jpg"), 'wb') as handler:
            handler.write(img_data)