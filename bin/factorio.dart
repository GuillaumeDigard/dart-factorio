import 'dart:convert';
import 'dart:io';

abstract class Connectable {}

abstract class Updatable {
  void update();
}

abstract class Usine implements Connectable, Updatable {
  bool active;
  int production;
  int consommation;
  int stockRessource;
  int stockProduit;
  Ressource ressource;
  Produit produit;

  Usine(){
    active = false;
  }

  void produire(){
    while(stockRessource>=consommation){
      for(int i=0 ; i<production; i++){
        stockProduit += 1;
        stockRessource -= consommation;
      }
    }
  }
  
  void update(){
    this.produire();
  }
}

// Scierie, fabrique, ...
class Scierie extends Usine {
  Scierie(){
    bool active = true;
    int production = 200;
    int consommation = 4;
    int stockRessource = 0;
    int stockProduit = 0;
    Ressource ressource = Bois();
    Produit produit = Planche();
  }
}
class Produit {

}

class Planche extends Produit{

}
class Ressource {
  final int kilo = 1;
  String nom;
  int valeur;
  int densite;
}
// Bois, fer, ...

class Bois extends Ressource {
  Bois(){
    nom = "Bois";
    valeur = 3;
    densite = 350;
  }
}

class Deposit implements Connectable, Updatable {
  Ressource ressource;
  int nbRessources;

  void extraire(int nbRessources){
    this.nbRessources -= nbRessources;
  }

  void regenerer(){
    this.nbRessources += 50;
  }

  void update(){
    this.regenerer();
  }
}

// Foret, Mine,
class Foret extends Deposit {
  Foret(){
    ressource = Bois();
    nbRessources = 5000;
  }
}

class Ville implements Connectable, Updatable {
  String nom;

  void update(){

  }
}

class Connection implements Updatable {
  Connection(Connectable c1, Connectable c2);
  void update(){}
}

/*
R1 ---> Usine1  \
R2 ---> Usine2  -\--> Usine3  ---> City

foret --> scierie --> planche
mine de fer --> fabrique de clous  --> clous

planche + clous  --> fabrique de meubles --> meuble

meuble --> ville --> argent;

*/
enum EnumInput {CLOSE,BUILD,PASS,SAVE}

class Jeu {
  EnumInput inputE;
  String input;
  bool flag = true;
  final updatables =<Updatable>[];
  void run(){
    print(clean());
    while (flag) {
      print(toString());
      input = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
      gererDeroulement(input);
      print(clean());
    }
  }

  void gererDeroulement(String action) {
    switch (action) {
      case "1": 
        flag = false;
        break;
      case "2":
        construire();
        break;
      case "3":
        passerTour();
        break;
      case "4":
        passerTour();
        break;
      default:
    }
  }

  void construire(){
    updatables.add(Ville());
  }

  void passerTour(){
    updatables.forEach((element) {element.update();});
  }

  String clean(){
    return "\x1b[2J\x1b[H";
  }


  String toString(){
    return "allo";
  }

}

void main(List<String> arguments) {
  var jeu = Jeu();
  jeu.run();
}
