import 'dart:developer';

List finderListGenerator(petList) {
  final users = ['Özgür', 'Deniz', 'Arda', 'Ercihan', 'Nilay'];
  List cards = [];

  for (int i = 0; i < users.length; i++) {
    for (int j = 0; j < petList[users[i]].length; j++) {
      var temp = {
        "imageURL": petList[users[i]][j]['image'],
        "date": petList[users[i]][j]['date'],
        "location": petList[users[i]][j]['location'],
        "similarity": petList[users[i]][j]['similarity'],
        "name": petList[users[i]][j]['name'],
        "type": petList[users[i]][j]['type'],
        "vaccinated": petList[users[i]][j]['vaccinated'],
      };
      cards.add(temp);
    }
  }

  return cards;
}


List adopterListGenerator(petList) {
  final users = ['Özgür', 'Arda', 'Deniz'];
  List cards = [];

  for (int i = 0; i < users.length; i++) {
    for (int j = 0; j < petList[users[i]].length; j++) {
      var temp = {
        "imageURL": petList[users[i]][j]['image'],
        "date": petList[users[i]][j]['date'],
        "location": petList[users[i]][j]['location'],
        "name": petList[users[i]][j]['name'],
        "type": petList[users[i]][j]['type'],
        "vaccinated": petList[users[i]][j]['vaccinated'],
      };
      cards.add(temp);
    }
  }

  return cards;
}
