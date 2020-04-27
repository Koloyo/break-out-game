// Initalisation des variables.
float width = 1300;
float height = 800;

// Life 
int life = 3;

// Level
int level = 0;

// Gravity and speed
float speedX = 0;
float speedY = 0;
// Direction of the ball, can be negative | Sers à donner le sens dans lequel va la blle
float dirX = 1;
float dirY = 1;

// Ball variable
float ballCenterX = width/2; 
float ballCenterY = height/2; 
float ballDiam = 40; 

//Brics Variables, en deux premier on a les coordonnées. Ensuite on a la longueur de l'écran divisé par 10 pour avoir des briques de longueur égales. 40 est la hauteur de la brique.
int brickX = 0;
int brickY = 0;
int brickL = int(width/10);
int brickH = 40;

//Moving Stick Variables. 
// En premier on dit que le stick est au milieu de l'écran & ensuite on montre qu'il est bas de l'écran, puis on définit sa longueur puis hauteur.
float StickX = width/2;
int StickY = 680;
int StickLength = 200;
int StickHeight = 10; 

//Compteur = variable qui devient 1...2...3 
int c = 0;

//Le type de la variable est liste d'entiers, mais le nom est "array" car j'ai utilisé des tableaux au début  pour les briques mais que c'était devenu compliqué quand on a voulu
//retirer une brique, on peut plus facilement atteindre chaque élément de la liste. On fait une liste pour toute les coordonnées des briques X & Y. 

IntList arrayBrickX;
IntList arrayBrickY; 

//Autre liste d'entier avec la vie des briques et le nombre de coups qu'elle peut encore prendre. Le float consistue au niveau d'opacité.
IntList arrayHit;
float decreaseOpacity;

//Liste pour les couleurs.
IntList arrayColorR;
IntList arrayColorG;
IntList arrayColorB;
//Tableaux car plus facile à construire et qu'on n'a pas besoin de modifier les valeurs des couleurs. 
// Dans les listes y'a des fonctions pour modifier les éléments, les enlever ect mais les tableaux sont plus simples. Cela se lit par colonne pour ce trio qui permet de faire les 5 
// couleurs demandées. Le maximum est 255. 
int[] arrayR = {240, 200, 20, 20, 240};
int[] arrayG = {20, 20, 200, 100, 200};
int[] arrayB = {20, 200, 20, 250, 0};

int r;

//Setup
void setup(){
size(1300,800);
background(0);

//nouvelles listes à partir des variables mises dans des tableaux.

arrayBrickX = new IntList();
arrayBrickY = new IntList();
arrayColorR = new IntList();
arrayColorG = new IntList();
arrayColorB = new IntList();
arrayHit = new IntList();
}

//Click to start the game, quand on va cliquer le logiciel va vérifier si la balle est à l'arrêt et si les vies sont supérieures à zéro.
void mousePressed(){
 if (speedX == 0 && speedY == 0 && life > 0){ //condition
 // Resume, si oui on va juste utiliser 6 x la direction. ( direction est égale soit à 1 soit à -1 suivant dans quel sens il va)
 speedX = 6*dirX;
 speedY = 6*dirY;
 }
 else {
 // Pause  
 // Quand on clique, on garde en mémoire la direction en calculant la valeur absolue de speedX/Y divisé par speedX/Y (par exemple -6/6 => -1 donc la balle va vers la gauche)
 dirX = abs(speedX)/speedX;
 dirY = abs(speedY)/speedY;
 // On arrête la balle 
 speedX = 0;
 speedY = 0;
 }
}

//Mainn qui est recaclculé sans cesse.
void draw(){
  
//coordonates of every brics 
// on regarde si la liste est vide. Si la liste de brique est vide, le niveau monte de un. On met la vitesse à zéro car il n'y a plus de briques. On met
// la balle au centre.
if (arrayBrickX.size() == 0){
level++;
speedX = 0; 
speedY = 0; 
ballCenterX = width/2; 
ballCenterY = height/2;
// for = une boucle est comme un petit draw que le logiciel va run plusieurs fois. for int ( si y'a pas de briques en y/x, si elles sont minimum à 5/10, et bah on en ajoute une avec ++

for(int y = 0; y < 5; y++){
    for(int x = 0; x < 10; x++){ // x sera géré en priorité
    int brickX_tmp = brickX + x*brickL; // première itération be like: brickX_tmp = 0  + 0 * 100 = 0 puis après =1 et ça fait le trait de la brique en longueur 1 puis 2 puis 3 ect
    int brickY_tmp = brickY + y*brickH;  //tmp = temporary 2eme iteration: brickY_tmp = 0 + 0 * 40 = 0. 1
    arrayBrickX.append(brickX_tmp); // append=ajouter
    arrayBrickY.append(brickY_tmp);
    r = int(random(0,5)); //r = un nombre random entre 0 ou 5 pour donner une couleur random à la brique parmis les 5 qu'on a intégré dans le settu
    arrayColorR.append(arrayR[r]); // on utilise le tableau de couleur avec entre parenthèses le nombre random
    arrayColorG.append(arrayG[r]);
    arrayColorB.append(arrayB[r]);
    arrayHit.append(level); // arrayHit = vie de la brique qui dépend du level
    }
   } 
}
    
background(0);

//Ball
ellipse(ballCenterX, ballCenterY, ballDiam, ballDiam); // ( position x, position y, largeur, hauteur)
noStroke();
ballCenterX = ballCenterX + speedX; //on ajoute la vitesse au centre de la balle pour qu'elle bouge
ballCenterY = ballCenterY + speedY;

// ball that rebounds on the paddle
// temporary variables to set edges for testing
float testX = ballCenterX; //position de la balle qu'on va utiliser pour  voir si elle rebondit sur les bords du stick
float testY = ballCenterY;

// which edge is closest ? // bords du stick
if (ballCenterX < StickX)    {  //on regarde si la balle est à gauche du stick
testX = StickX; //si testX est égal au bord du stick
}   // test left edge
  else if (ballCenterX > StickX + StickLength) { testX = StickX + StickLength; //sinon est-ce que c'est à droite du stick? on prend stickX + sa longueur. alors on fait testX à la 
  //droit du stick
} // right edge

//c'est pareil pour y on regarde juste si la balle est en dessus ou au dessus du stick
if (ballCenterY < StickY) {  
  testY = StickY;  
} // top edge
  else if (ballCenterY > StickY + StickHeight) { testY = StickY + StickHeight;  }// bottom edge
  
// get distance from closest edges, on va calculer la distance entre la balle et le stick pour savoir si on est en train de toucher le stick ou non. 
float distX = ballCenterX-testX;
float distY = ballCenterY-testY;
float distance = sqrt( (distX*distX) + (distY*distY) ); //sqrt = racine carré avec fonction de la distance entre deux points. 

// if the distance is less than the radius, collision!
if (distance <= ballDiam/2) { //si la distance est plus petite ou également au rayon de la balle alors il y a collision. 
    if (ballCenterY != testY){ //on va regarder si la balle est sur le stick ou non 
      speedY = -speedY;    //si elle n'est pas sur le stick alors on va inverser la vitesse verticale = elle rebondit.
    }
}

// Check life
textSize(20); //juste pour afficher le texte ça, taille du texte(20)
text("LIFE: "+ life, 1200, 650); //position ou le texte est mis
text("LEVEL: "+ level, 100, 650); //idem, le + sert à montrer la valeur de life/level

if (life == 0){
  speedX = 0;
  speedY = 0;
  textSize(26);
  text("GAME OVER", (width-150)/2, (height-100)/2); //si il y a plus de vie ni de vitesse = game over
}
// Reset of the ball in the center when a life is lost 
if (ballCenterY - ballDiam >= StickY + StickHeight) { //regarder la position de la balle en Y et que le diamètres ne soit plus visible sur l'écran, et qu'il soit inférieur au 
//stick en haut et en hauteur
  ballCenterX= width/2; //remettre la balle au milieu
  ballCenterY= height/2;
  dirX = 1; //remettre la direction comme quand on commençait le jeu
  dirY = 1;
  speedX = 0; //comme au début aussi
  speedY = 0;
  life--; //et je retire une vie
  }

//Rebound Right
if(ballCenterX >= width-ballDiam/2) { // la balle rebondit vraiment quand ça touche le bord au diamètre près
speedX= -speedX;  //inverser la vitesse pour faire rebondir
}

//Rebound Left
if(ballCenterX <= ballDiam/2 ) { //même chose dans l'autre sens, il y a as width car x = 0 dans ce cas pour le bord gauche
speedX= -speedX;
}

//Up Rebound
if(ballCenterY <= ballDiam/2 ) { // même chose en haut
speedY= -speedY;  
}


//Rebound brick
for(c=0; c < arrayBrickX.size(); c=c+1){ //une boucle (for), elle va porter sur les briques qui existent encore. compteur, arrayBrickX.size() c'est la taille de la liste 
//cette liste correspond au nombre de brique qui existe encore
  
// temporary variables to set edges for testing
testX = ballCenterX; //c'est ce sur quoi on va regarder si il y a collision ou pas. 
testY = ballCenterY;

// which edge is closest?
// test left edge
if (ballCenterX < arrayBrickX.get(c))    { //get = rendre l'élément à la position (c) qui eut aller de zéro jusqu'à la taille de la liste.
testX = arrayBrickX.get(c); //si je sais que la balle est à gauche, on va regarder si elle touche le bord gauche de la brique
}   
// right edge
  else if (ballCenterX > arrayBrickX.get(c) + brickL) { testX = arrayBrickX.get(c) + brickL; //sinon, si la balle est à droite de la brique
  //on va faire en sorte de regarder si la balle touche. 
} 

// top edge
if (ballCenterY < arrayBrickY.get(c)) {  //regarder si la balle est au dessus
  testY = arrayBrickY.get(c);  
} 
  else if (ballCenterY > arrayBrickY.get(c)+brickH) { testY = arrayBrickY.get(c)+brickH;  }// bottom edge, regarder si elle est en dessous

// get distance from closest edges
distX = ballCenterX-testX;
distY = ballCenterY-testY;
distance = sqrt( (distX*distX) + (distY*distY) ); //distance entre la balle et la brique avec la racine carrée, on va regarder si la distance est plus petite que le rayon 
//il y a collision. 

// if the distance is less than the radius, collision!
if (distance <= ballDiam/2) { 
    if (ballCenterX != testX){
      speedX = -speedX;    //la vitesse change de sens, il y a rebond 
    }
    if (ballCenterY != testY){
      speedY = -speedY;    //contrairement au stick, la vitesse pourrait éventuellement changer verticalement comme horizontalement
    }
    arrayHit.set(c, arrayHit.get(c)-1); // toute cette accolade avec les remove et tout c'est seulement si il y a collision. on va retirer une vie à la brique. arrayHit = nombre de vie. 
 //set = changer la valeur de la position c dans la liste. get = l'afficher 
    if (arrayHit.get(c) == 0){ //est-ce que les briques ont encore des vies (array Hit)?  c= compteur de briques alive
    arrayBrickX.remove(c);
    arrayBrickY.remove(c); 
    arrayColorR.remove(c);
    arrayColorG.remove(c);
    arrayColorB.remove(c);
    arrayHit.remove(c); //si elle a plus de vie, elle perd tout ce qui est énoncé précédemment, et donc elle n'existe plus.
    }
  }
} //fin de la fat boucle

//Brics
for(c=0 ;c < arrayBrickX.size(); c=c+1){ //une autre boucle pour dessiner les briques encore en vie. 
  // Formula to avoid being below 50% opacity
  if (level != 1){ //si le niveau est différent de 1 , le != veut dire 'différent'
  decreaseOpacity = 0.5 + 0.5 * ( (float(arrayHit.get(c)) - 1.0) / (float(level) - 1.0 ) ); //50% x le nombre de vie qu'il reste - 1 et tout cela divisé par le nombre maximum de vie 
  //de la brique (level) moins 1. ( par exemle au niveau 3 pour une brique qu'on a déjà touché une fois (2 - 1) divisé par (3 - 1 ) fois 50% ça fait 25% que je rajoute au 50% de base 
  //puisqu'on ne peut pas aller en dessous de 50%
}
  else decreaseOpacity = 1.0; //si le niveau est 1 l'opacité reste à 100%

  fill(arrayColorR.get(c), arrayColorG.get(c), arrayColorB.get(c), int(255.0*decreaseOpacity)); //couleurs à l'intérieur des briques. 255 (max de la luminosité) divisé par 
  //l'opacité à enlever si elle existe. 
  stroke(255); //contour blanc

  rect(arrayBrickX.get(c),arrayBrickY.get(c),brickL,brickH); // c = numéro de la brique, permet de parler de toutes les briques car le compteur est dans une boucle. 
}


tint(255,255); // tentative de transparence qui n'a pas marché 
fill(255);
noStroke();
//Stick
rect(StickX, StickY, StickLength, StickHeight); 
} 
//fin du draw
//Stick Moving Right
void keyPressed (){ //quand une touche est pressée
if (keyCode == RIGHT){
  fill (0); 
  rect (StickX,StickY,StickLength,StickHeight); //on fait un rectangle noir à l'endroit où il y avait le stick

//Stick RIGHT
StickX=StickX+50; // on en recrée un à droite + 50 pixel à droite
if (StickX > 1090){ // on vérifie qu'il ne soit pas en dehors de l'écran sur l'horizontalité
  StickX = 1090; //on le force à se stopper si c'est le cas
  }

// // white rectangle 50 pixels further on the right
fill(255);
rect(StickX, StickY, StickLength, StickHeight); //on redéssine le rectangle blanc à droite
}

//Stick Moving LEFT
if (keyCode == LEFT){
fill(0);
rect(StickX, StickY, StickLength, StickHeight); 

//Stick LEFT
StickX=StickX-50;
if (StickX < 10){
StickX = 10; //même manip sur la gauche
  
}

// white rectangle 50 pixels further on the left
fill(255);
rect(StickX, StickY, StickLength, StickHeight); //recréation du stick blanc

}


}
