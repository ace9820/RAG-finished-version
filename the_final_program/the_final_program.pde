//import de librairies nécessaires au son
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// Variable globale
int FPS=60;
PFont startT;
int startTimer=1000*FPS;
int musicTimer=0;

//players
float rotationP1;
float rotationP2=PI;
float player1X;
float player1Y;
float player2X;
float player2Y;
float vitesseP1;
float vitesseP2;
float positionP1X;
float positionP1Y;
float positionP2X;
float positionP2Y;
int playerMouv=1;
int winCounterP1;
int winCounterP2;
int mouv=1;
int vieP1;
int vieP2;
int CDvieP1=0;
int CDvieP2=0;


// sprtes
PImage mouv1a;
PImage mouv2a;
PImage mouv3a;
PImage mouv1b;
PImage mouv2b;
PImage mouv3b;
PImage coeur1;
PImage coeur2;






//Shot
int shotCD1=330;
int shotCD2=330;

//Tubes
float diametreTube1;
float diametreTube2;
int a;
float wTube1=1;
float wTube2=1;

//Couleur du fond
float blue=1; float red=0; float yeal=49;
float vBlue=0.3; float vRed=0.5; float vYeal=0.7;
PImage ecran;


//Objets
int nbObjets;
float vitesseObjets;
float[][] objets;
PImage obstacle;
int objetN=0;
float z;

// Variable spécifique aux intervalles d'attente 

int tempsObjets=-1000*FPS;
int attenteObjets;

//Music
AudioPlayer startSound;
AudioPlayer music;
Minim minim;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Fonction principale
void setup(){
  vieP1=3;
  vieP2=3;
  coeur1 = loadImage("coeur1.png");
  coeur2 = loadImage("coeur2.png");
  ecran = loadImage("ecran.png");
  mouv1a = loadImage("P1.png");
  mouv2a = loadImage("P2.png");
  mouv3a = loadImage("P3.png");
  mouv1b = loadImage("P1b.png");
  mouv2b = loadImage("P2b.png");
  mouv3b = loadImage("P3b.png");
  startT = createFont("epicFont.ttf", 80);
  size (600,600,P3D);
  background (255,255,255);
  player1X = 35;
  player1Y = 65;
  player2X = 35;
  player2Y = 65;
  vitesseP1 = 0.25;
  vitesseP2 = 0.25;
  nbObjets = 10;
  vitesseObjets = 1.05;
  objets = new float[nbObjets][5];
  z = width;

  minim = new Minim(this);
  music = minim.loadFile("music.mp3");
  startSound = minim.loadFile("music2.mp3");
  diametreTube1 = 1;
  diametreTube2 = 1;

for(int cA = 0;cA < nbObjets;cA++){
creerObjets(vitesseObjets, cA);}

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Fonction draw
void draw(){
  frameRate(FPS);
  background (blue, red, yeal);
  image(ecran,0,0);
  backgroundColor ();
  maxTubes();
  noFill();
  if (startTimer>6*FPS){ startSound.play();}
  if (startTimer<6*FPS){ music.play();}
  calculePXY(); //Donne la position des joueur a tout instant
  shotLight();
  tempsObjets++;
  startTimer--;
  startTitle();
  musicTimer++;
  if(musicTimer>245*FPS){
    music.rewind();
    musicTimer=0;
  }
  if (CDvieP1>0){
    CDvieP1--;}
  if (CDvieP2>0){
    CDvieP2--;}

  

  
  //Timer pour l'animation des joueur
  if (playerMouv>FPS/4) { mouv=-mouv; }
  if (playerMouv==0) { mouv=-mouv; }
  playerMouv= playerMouv+mouv;
  
  creerPlayer1(rotationP1);
  creerPlayer2(rotationP2);

  parametresObjets ();

  effetObstacle (positionP1X, positionP1Y);
  effetObstacle (positionP2X, positionP2Y);

  pvP1();
  pvP2();
  endGame();

if(startTimer>10*FPS){
  background(blue, red, yeal);

  textAlign(CENTER,CENTER);
  textSize(40);
  fill(#9FB236);
  text("ADAM C." , 69, z-50);
  fill(#18F0D5);
  text("REMI Y.", z/2, z-50); 
  fill(#FF00A2);
  text("GAEL D.", z-69, z-50);
  fill(#2AC102);
  text("Right: P1-M P2-D  Left: P1-K P2-Q",z/2, 80);
  text("SHOOT: P1-L P2-S",z/2, 120);
  textSize(100);
  fill(250,250,0);
  text("Press Enter",z/2 , z/2-30);
  text("to START",z/2 , z/2+30);
  
  
  noFill();
}






}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FOND
//paramétres de la couleur du fond;

void startTitle (){
    textFont (startT);
  if (startTimer<290 && startTimer>160){
    textSize (80);
    text("READY",z/2,z/2); }
  if (startTimer<=150 && startTimer>=20){
    textSize (80);
    text("set", z/2, z/2); }
//  if (startTimer<=19 && startTimer>=18){
  //  startT = createFont("epicFont.ttf", 170); }
  if (startTimer<=10 && startTimer>=-180){
    textSize (170);
    text("GO", z/2, z/2); }
}
  

void backgroundColor (){
  blue=blue+vBlue;
  red=red+vRed;
  yeal=yeal-vYeal;
  if (blue>80){    vBlue=-vBlue;}
  if (red>80){     vRed=-vRed;}
  if (yeal<1){     vYeal=-vYeal;}
  if (blue<1){     vBlue=-vBlue;}
  if (red<1){      vRed=-vRed;}
  if (yeal>80){    vYeal=-vYeal;}

  strokeWeight(1);
  stroke(200,230,200);
  fill(200,250,200);
  line(0,z,z,0);
  line(z*0.75,z,z/4,0);
  line(z/4,z,z*0.75,0);
  line(0,0,z,z);
  noFill();
}

//fonction que dessine les tubes
void drawTube(){
//  strokeWeight(1);

  diametreTube1 = diametreTube1*1.05;
  diametreTube2 = diametreTube2*1.05;
  wTube1=0.02*diametreTube1;
  wTube2=0.02*diametreTube2; 

  strokeWeight(wTube1);
  stroke(200,230,200);
  ellipse(width/2, height/2, diametreTube1, diametreTube1);
  noStroke();

  strokeWeight(wTube2);
  stroke(200,230,200);
  ellipse(width/2, height/2, diametreTube2, diametreTube2);
  noStroke();

}

//limites des tubes
void maxTubes(){
  drawTube();
  if (diametreTube1 >= height*1.5){
    diametreTube1 = 1;

    drawTube();
  }
  if (diametreTube2 >= height*1.5){
    diametreTube2 = 1;
    drawTube();
  }
  if(a==0){ //crée une distance entre tube
    if (diametreTube1>=width){
    a=2;
    diametreTube2=width/25;
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//PLAYERS:
// Fonction créant le premier joueur
void creerPlayer1(float angle){
  pushMatrix();
  translate(z/2,z/2);
  rotate(angle);
  if (shotCD1>3*FPS-FPS/6 && startTimer<0) { image(mouv3a,-50,z/8-5); }
  if (shotCD1<=3*FPS-FPS/6 || startTimer>0) {
    if (playerMouv<=FPS/8) { image(mouv1a,-60,z/4); }
    if (playerMouv>=FPS/8) { image(mouv2a,-60,z/4); }
  }
  popMatrix();
}

// Fonction créant le deuxième joueur
void creerPlayer2(float angle){
//  angle = angle-PI;
  pushMatrix();
  translate(z/2,z/2);
  rotate(angle);
  if (shotCD2>3*FPS-FPS/6 && startTimer<0) { image(mouv3b,-31,z/6+10); }
  if (shotCD2<=3*FPS-FPS/6 || startTimer>0) {
    if (playerMouv<=FPS/8) { image(mouv1b,-60,z/4); }
    if (playerMouv>=FPS/8) { image(mouv2b,-60,z/4); }
  }
  popMatrix();
}

void pvP2(){
  if(vieP2>0){
    image(coeur2,20,20,20,20);
    if(vieP2>1){
      image(coeur2,40,20,20,20);
      if(vieP2>2){
        image(coeur2,60,20,20,20);
      }
    }
  }
}

void pvP1(){
  if(vieP1>0){
    image(coeur1,560,20,20,20);
    if(vieP1>1){
      image(coeur1,540,20,20,20);
      if(vieP1>2){
        image(coeur1,520,20,20,20);
      }
    }
  }
}


void endGame(){
  if (vieP1==0){
    winCounterP2++;
    noLoop();
    fill(200,50,50);
    textSize(170);
    text("WINNER",z/2,200);
    textSize(100);
    text(winCounterP2,z/2-20,290);
    textSize(170);
    fill(50,50,200);
    text("LOOSER",z/2,z-150);
    textSize(100);
    text(winCounterP1,z/2,z-210);
    }
    
  if (vieP2==0){
    winCounterP1++;
    noLoop();
    fill(50,50,200);
    textSize(170);
    text("WINNER",z/2,z-150);
    textSize(100);
    text(winCounterP1,z/2,z-210);
    noFill();
    
    textSize(170);
    fill(200,50,50);
    text("LOOSER",z/2,200);
    textSize(100);
    text(winCounterP2,z/2,290);
  }
}


float calculeDistance (float x1, float y1, float x2, float y2) {
  float d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
  return d;
}

void calculePXY() {
  positionP1X=(z/-3)*sin(rotationP1)+width/2;
  positionP1Y=(z/3)*cos(rotationP1)+width/2;
  positionP2X=(z/-3)*sin(rotationP2)+width/2;
  positionP2Y=(z/3)*cos(rotationP2)+width/2;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//POUVOIRS DES JOUEURS
//Fonction gérant les collision et la recharge de laser du 1er joueur
void shot1 () {
  float x1=-positionP1X+width;
  float y1=-positionP1Y+width;
  float d;
  if (shotCD1==0) {
    d=calculeDistance(x1, y1, positionP2X, positionP2Y);
    if (d<30){
      if(startTimer<0){
        if(CDvieP2==0){
          vieP2--;
          CDvieP2=2*FPS;
        }
      }
    }
    shotCD1=3*FPS;
  }
}

//Fonction gérant les collision et la recharge de laser du 2ème joueur
void shot2 () {
  float x1=-positionP2X+width;
  float y1=-positionP2Y+width;
  float d;
  if (shotCD2==0) {
    d=calculeDistance(x1, y1, positionP1X, positionP1Y);
    if (d<30){
      if(startTimer<0){
        if(CDvieP1==0){
          vieP1--;
          CDvieP1=2*FPS;
        }
      }
    }
    shotCD2=3*FPS;
  }
}

//Fonction gérant l'animation des lasers
void shotLight () {
  if (shotCD1>0) { shotCD1--; }
  
  if (shotCD1>3*FPS-FPS/6 && startTimer<0){
    strokeWeight(4);
    stroke(#FEFF00);
    line(positionP1X, positionP1Y, -positionP1X+width, -positionP1Y+width);
    noStroke();
  }
  if (shotCD2>0) { shotCD2--; }
  
  if (shotCD2>3*FPS-FPS/6 && startTimer<0){
    strokeWeight(4);
    stroke(#FEFF00);
    line(positionP2X, positionP2Y, -positionP2X+width, -positionP2Y+width);
    noStroke();
  }

 // Dessin de l'indicateur de recharge
  if (shotCD1<1){
    strokeWeight(4);
    stroke(255,255,0);
    ellipse(z-50,z-30,10,10);
    noStroke();
  }
  if (shotCD2<1){
    strokeWeight(4);
    stroke(255,255,0);
    ellipse(50,z-30,10,10);
    noStroke();
  }

}
  

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//OBJETS:
// Fonction remplissant le tableau objets
void creerObjets(float v, int k){
//  for(int i = 0;i < nbObjets;i++){
    objets[k][0] = random(-v,v); // VitesseY
    objets[k][1] = random(-v,v); // VitesseY
    objets[k][2] = 1; //Diametre initial
    objets[k][3] = 1;
    objets[k][4] = 1;
//  }
}

// Fonction dessinant chaque objets
void dessinerObjets(float d , int k){
  pushMatrix();
  translate(z/2,z/2);
  fill(red+100,blue+200,yeal+200);
  noStroke();
  lights();
  translate(objets[k][0], objets[k][1], 0);
  sphere(d);
  popMatrix();
}

// Timer, paramètre et animation des objets
void parametresObjets () {
  if (objetN==nbObjets){
    objetN=0;
    }

  if (tempsObjets>FPS/2){
    if(sqrt(objets[objetN][0]*objets[objetN][0])>2*width){
      creerObjets(vitesseObjets,objetN);
      
    }
    objets[objetN][3]=vitesseObjets;
    objets[objetN][4]=1.03;
    tempsObjets=0;
   }

  objetN++;

  for(int k = 0;k < nbObjets;k++){
    objets[k][0] = objets[k][0] * objets[k][3];
    objets[k][1] = objets[k][1] * objets[k][3];
    dessinerObjets(objets[k][2], k);
//    if (objets[k][2]<25){
      objets[k][2] = objets[k][2] * objets[k][4];
  //  }
  }
}

void effetObstacle (float x, float y){
 float d;
 for(int k = 0;k < nbObjets;k++){
   d=calculeDistance(objets[k][0]+width/2,objets[k][1]+width/2, x, y);
   if (d<objets[k][2]/2){
     if (x==positionP1X){
       if(startTimer<0){
         if(CDvieP1==0){
          vieP1--;
          CDvieP1=2*FPS;
         }
       }
     }
     if (x==positionP2X){
       if(startTimer<0){
         if(CDvieP2==0){
           vieP2--;
           CDvieP2=2*FPS;
         }
       }
     }
   }
 }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//COMMANDES:
// Fonction gérant les entrées clavier
void keyPressed(){
  if (key=='k' || key=='K') {
    rotationP1 = rotationP1 + vitesseP1;
    if (rotationP1 - rotationP2 >= -0.15){
      rotationP1 = rotationP1 - vitesseP1;
    }
  }
  if (key=='m' || key=='M') {
    rotationP1 = rotationP1 - vitesseP1;
    if (rotationP1 - rotationP2 <= -2*PI){
      rotationP1 = rotationP1 + vitesseP1;
    }
  }
  if (key=='q' || key=='Q') {
    rotationP2 = rotationP2 + vitesseP2;
    if (rotationP1 - rotationP2 <= -2*PI){
      rotationP2 = rotationP2 - vitesseP2;
    }
  }
  if (key=='d' || key=='D') {
    rotationP2 = rotationP2 - vitesseP2;
    if (rotationP1 - rotationP2 >= 0){
      rotationP2 = rotationP2 + vitesseP2;
    }
  }
  if (key=='l' || key=='L') {
    shot1(); }
  if (key=='s' || key=='S') {
    shot2(); }
  if (keyCode == ENTER) {
    loop();
    startTimer=340;
    shotCD1=330;
    shotCD2=330;
    
    vieP1=3;
    vieP2=3;
    tempsObjets=-300;
    rotationP1=0;
    rotationP2=PI;
//    music.rewind();
  }
}