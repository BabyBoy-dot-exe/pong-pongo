import processing.sound.*;

float posX, posY;
float kecepatanX, kecepatanY;

float lebarPaddle = 10;
float tinggiPaddle = 50;

float posPaddleA, posPaddleB;
boolean gerakAtasA, gerakBawahA;
float kecepatanPaddleB = 5; // Kecepatan paddle B

int skorA = 0;
int skorB = 0;

boolean gameBerjalan = true;
float waktuSisa = 60.0;

SoundFile bunyiPaddle;
SoundFile bunyiMelewati;
SoundFile backSound;

void setup() {
  size(800, 600);
  posX = width / 2;
  posY = height / 2;

  kecepatanX = 3;
  kecepatanY = 3;

  posPaddleA = height / 2 - tinggiPaddle / 2;
  posPaddleB = height / 2 - tinggiPaddle / 2;

  // Inisialisasi file suara
  bunyiPaddle = new SoundFile(this, "suara_paddle.wav");
  bunyiMelewati = new SoundFile(this, "suara_melewati.wav");
  backSound = new SoundFile(this, "suara_backsound.wav"); // Ganti "backsound.mp3" dengan nama file suara backsound
  
  // Putar backsound dengan volume
  backSound.play();
  backSound.amp(0.3); // Atur volume backsound di sini
  backSound.loop();
}

void draw() {
  background(0, 128, 0);

  stroke(255);
  strokeWeight(2);
  line(width / 2, 0, width / 2, height);

  if (gameBerjalan) {
    waktuSisa -= 0.02;
    if (waktuSisa <= 0) {
      gameBerjalan = false;
      waktuSisa = 0;
      backSound.stop(); // Hentikan backsound saat permainan berakhir
    }
  }

  ellipse(posX, posY, 20, 20);

  fill(255, 3, 36);
  rect(0, posPaddleA, lebarPaddle, tinggiPaddle);

  fill(255, 230, 0);
  rect(width - lebarPaddle, posPaddleB, lebarPaddle, tinggiPaddle);

  if (gameBerjalan) {
    posX += kecepatanX;
    posY += kecepatanY;
  }

  if (posY > height || posY < 50) {
    kecepatanY *= -1;
  }

  if (posX < lebarPaddle && posY > posPaddleA && posY < posPaddleA + tinggiPaddle) {
    kecepatanX *= -1;
    bunyiPaddle.play();
  }

  if (posX > width - lebarPaddle && posY > posPaddleB && posY < posPaddleB + tinggiPaddle) {
    kecepatanX *= -1;
    bunyiPaddle.play();
  }

  if (posX < 0) {
    skorB++;
    resetBola();
    bunyiMelewati.play();
  }

  if (posX > width) {
    skorA++;
    resetBola();
    bunyiMelewati.play();
  }

  fill(0, 128, 255);
  rect(0, 0, width / 3 + 10, 50);
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Pemain A: " + skorA, width / 6, 25);

  fill(255, 128, 0);
  rect(width / 3 + 10, 0, width / 3, 50);
  fill(255);
  textAlign(CENTER, CENTER);
  text("Waktu:  " + floor(waktuSisa) + " detik", width / 2, 25);

  fill(0, 128, 255);
  rect(2 * width / 3 + 10, 0, width / 3, 50);
  fill(255);
  textAlign(CENTER, CENTER);
  text("Pemain B: " + skorB, 5 * width / 6, 25);

  if (gerakAtasA && posPaddleA > 50) {
    posPaddleA -= 5;
  }
  if (gerakBawahA && posPaddleA < height - tinggiPaddle) {
    posPaddleA += 5;
  }

  // Perbarui posisi paddle B berdasarkan input panah atas dan bawah
  if (keyPressed && keyCode == UP && posPaddleB > 50) {
    posPaddleB -= kecepatanPaddleB;
  }
  if (keyPressed && keyCode == DOWN && posPaddleB < height - tinggiPaddle) {
    posPaddleB += kecepatanPaddleB;
  }
  // Batasi posisi paddle B agar tidak keluar dari layar
  posPaddleB = constrain(posPaddleB, 50, height - tinggiPaddle);

  if (!gameBerjalan) {
    String pemenang = "";
    if (skorA > skorB) {
      pemenang = "Pemain A";
    } else if (skorA < skorB) {
      pemenang = "Pemain B";
    } else {
      pemenang = "Seri";
    }

    textSize(32);
    textAlign(CENTER, CENTER);
    fill(255);
    if (pemenang.equals("Seri")) {
      text("Permainan Seri!", width / 2, height / 2);
    } else {
      text("Pemenang: " + pemenang, width / 2, height / 2);
    }
  }
}

void resetBola() {
  posX = width / 2;
  posY = height / 2;
  kecepatanX = 3;
  kecepatanY = 3;
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    gerakAtasA = true;
  }
  if (key == 's' || key == 'S') {
    gerakBawahA = true;
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    gerakAtasA = false;
  }
  if (key == 's' || key == 'S') {
    gerakBawahA = false;
  }
}
