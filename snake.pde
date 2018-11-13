int bodysize = 20;
int maxx, maxy;
Snake snk;
Food food = new Food();

int xvel = 1, yvel = 0, xvl = 0, yvl = 0, spd = 25, score = 0, st = 0, backgnd = 0, spdtmp = 0;

void setup() {
    size(800, 500);
    background(backgnd);
    frameRate(100);
    maxx = width/bodysize;
    maxy = height/bodysize;
    snk = new Snake();
    food.generate();
    spd = 25;
    spdtmp = spd;
    score = 0;
    textSize(10);
}

void draw() {
    if (st == 0) {
        if (frameCount % (spdtmp) == 0) {
            xvl = xvel;
            yvl = yvel;
            snk.move(xvel, yvel);
            if (snk.dead == true) {
                end();
            }
            if (snk.bd[0].x == food.food.x && snk.bd[0].y == food.food.y) {
                food.generate();
                snk.score();
                if (spd > 6) {
                    spd--;
                }
                score++;
            }
            snk.drw();
        }
        stroke(0);
        rectMode(CORNER);
        fill(0);
        rect(width-20, 0, 20, 10);
        stroke(255);
        fill(255);
        text(score, width-20, 10);
    } else {
        stroke(255);
        fill(255);
        rectMode(CORNER);
        rect(0, 0, width, height);
        stroke(0);
        fill(0);
        textSize(20);
        text("Pontuacao: " + score, (width/2) - 60, height/2);
        rectMode(CENTER);
        fill(100);
        rect(width/2, height/2 + 30, 70, 20);
        textSize(12);
        fill(0);
        text("Recomecar", width/2 - 30, height/2+35);
        if (mousePressed) {
            if (mouseX > width/2 - 35 && mouseX < width/2 + 35 && mouseY > height/2 + 20 && mouseY < height/2 + 40) {
                st = 0;
                setup();
            }
        }
    }
}

void end() {
    st = 1;
}

void keyPressed() {
    if (key == 'x') {
        snk.score();
    }
    if (keyCode == UP) {
        if (xvl != 0 && yvl != -1) {
            xvel = 0;
            yvel = -1;
            spdtmp = spd;
        } else {
            if (xvl == 0 && yvl == -1) {
                if (spdtmp > 4) {
                    spdtmp--;
                }
            }
        }
    }
    if (keyCode == DOWN) {
        if (xvl != 0 && yvl != 1) {
            xvel = 0;
            yvel = 1;
            spdtmp = spd;
        } else {
            if (xvl == 0 && yvl == 1) {
                if (spdtmp > 8) {
                    spdtmp -= 2;
                }
            }
        }
    }
    if (keyCode == RIGHT) {
        if (xvl != 1 && yvl != 0) {
            xvel = 1;
            yvel = 0;
            spdtmp = spd;
        } else {
            if (xvl == 1 && yvl == 0) {
                if (spdtmp > 8) {
                    spdtmp -= 2;
                }
            }
        }
    }
    if (keyCode == LEFT) {
        if (xvl != -1 && yvl != 0) {
            xvel = -1;
            yvel = 0;
            spdtmp = spd;
        } else {
            if (xvl == -1 && yvl == 0) {
                if (spdtmp > 8) {
                    spdtmp -= 2;
                }
            }
        }
    }
}

class body {
    int x = 0, y = 0, type;
    void drw() {
        if (type == 0) {
            stroke(255, 0, 0);
            fill(255, 0, 0);
        }
        if (type == 1) {
            stroke(0, 255, 0);
            fill(0, 255, 0);
        }
        rectMode(CORNER);
        rect((x)*(bodysize), (y)*(bodysize), bodysize-2, bodysize-2);
    }
    void ers() {
        stroke(backgnd);
        fill(backgnd);
        rectMode(CORNER);
        rect((x)*(bodysize), (y)*(bodysize), bodysize, bodysize);
    }
    body(int a) {
        type = a;
    }
}

class Snake {    
    int level = 0;
    boolean dead = false;
    body[] bd = new body[maxx*maxy];
    Snake() {
        bd[0] = new body(0);
    }
    void score() {
        level++;
        bd[level] = new body(0);
        bd[level].x = -1;
        bd[level].y = -1;
    }
    void move(int x, int y) {
        for (int i = 0; i <= level; i++) {
            bd[i].ers();
        }
        for (int i = level; i > 0; i--) {
            bd[i].x = bd[i-1].x;
            bd[i].y = bd[i-1].y;
        }
        bd[0].x += x;
        bd[0].y += y;
        bd[0].x %= maxx;
        bd[0].y %= maxy;
        if (bd[0].x == -1) {
            bd[0].x = maxx-1;
        }
        if (bd[0].y == -1) {
            bd[0].y = maxy-1;
        }
        for (int i = 0; i <= level; i++) {
            for (int j = i; j <= level; j++) {
                if (bd[i].x == bd[j].x && bd[i].y == bd[j].y && i != j) {
                    dead = true;
                }
            }
        }
    }
    void drw() {
        for (int i = 0; i <= level; i++) {
            bd[i].drw();
        }
    }
}

int repeat() {
    for (int i = 0; i <= snk.level; i++) {
        if (snk.bd[i].x == food.food.x && snk.bd[i].y == food.food.y) {
            return 1;
        }
    }
    return 0;
}

class Food {
    body food = new body(1);
    int x, y;
    void generate() {
        while (repeat() == 1) {
            x = (int)random(width/bodysize);
            y = (int)random(height/bodysize);
            food.x = x;
            food.y = y;
        }
        food.drw();
    }
}
