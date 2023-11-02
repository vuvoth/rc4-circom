pragma circom 2.0.0;



// Rotate 
template Rotate(s) {
    signal input num; 
    signal output rotate_number;   

    rotate_number <-- (num << s) | (num >> (32 - s));
}


// (a + b) % 32;
// check security later
template AddMod32() {
    signal input a;
    signal input b;
    signal output c;
    signal sum;
    signal q; 
    var m = 1 << 32;
    sum <== a + b;

    q <-- sum \ m;

    c <-- sum % m;

    sum === q * m + c;
}

template Add2Mod32() {
    signal input a;
    signal input b;
    signal input c; 
    signal input d; 

    component x = AddMod32(); 
    x.a <== a; 
    x.b <== b; 
    
    component y = AddMod32();
    y.a <== c;
    y.b <== d; 

    component z = AddMod32();
    z.a <== x.c; 
    z.b <== x.c;

    signal output r; 

    r <== z.c;    
}

template FF() {
    signal input A_in;
    signal input B_in;
    signal input C_in; 
    signal input D_in; 
    signal input x; 
    signal input t; 

    signal output A_out;
    
    // a = b + ((a + F(b, c, d) + X[k] + T[i]) <<< s)
    
    signal f; 
    f <-- (B_in & C_in)  | (~B_in & D_in);

    component add2 = Add2Mod32();
    add2.a <== A_in;
    add2.b <== f;
    add2.c <== x;
    add2.d <== t;

    component rotate = Rotate(32);
    rotate.num <== add2.r;

    component add = AddMod32();

    add.a <== B_in; 
    add.b <== rotate.rotate_number;

    A_out <== add.c;    
}

template GG() {
    signal input A_in;
    signal input B_in;
    signal input C_in; 
    signal input D_in; 
    signal input x; 
    signal input t; 

    signal output A_out;
    
    // a = b + ((a + G(b, c, d) + X[k] + T[i]) <<< s)
    
    signal f; 
    f <-- (B_in & D_in)  | (C_in & ~ D_in);

    component add2 = Add2Mod32();
    add2.a <== A_in;
    add2.b <== f;
    add2.c <== x;
    add2.d <== t;

    component rotate = Rotate(32);
    rotate.num <== add2.r;

    component add = AddMod32();

    add.a <== B_in; 
    add.b <== rotate.rotate_number;

    A_out <== add.c;    
}


template HH() {
    signal input A_in;
    signal input B_in;
    signal input C_in; 
    signal input D_in; 
    signal input x; 
    signal input t; 

    signal output A_out;
    
    // a = b + ((a + G(b, c, d) + X[k] + T[i]) <<< s)
    
    signal h; 
    h <-- (B_in ^ C_in ^ D_in);

    component add2 = Add2Mod32();
    add2.a <== A_in;
    add2.b <== h;
    add2.c <== x;
    add2.d <== t;

    component rotate = Rotate(32);
    rotate.num <== add2.r;

    component add = AddMod32();

    add.a <== B_in; 
    add.b <== rotate.rotate_number;

    A_out <== add.c;    
}

template II() {
    signal input A_in;
    signal input B_in;
    signal input C_in; 
    signal input D_in; 
    signal input x; 
    signal input t; 

    signal output A_out;
    
    // a = b + ((a + G(b, c, d) + X[k] + T[i]) <<< s)
    
    signal i; 
    i <-- (C_in ^ (B_in | ~D_in));

    component add2 = Add2Mod32();
    add2.a <== A_in;
    add2.b <== i;
    add2.c <== x;
    add2.d <== t;

    component rotate = Rotate(32);
    rotate.num <== add2.r;

    component add = AddMod32();

    add.a <== B_in; 
    add.b <== rotate.rotate_number;

    A_out <== add.c;    
}


template md5(N) {
    signal input m[N];
    signal output abcd[4]; // md5 hash function result

    signal X[N/16][16];

    signal A[N/16];
    signal B[N/16];
    signal C[N/16];
    signal D[N/16];

    for (var i = 0; i < N / 16; i++) {
        for (var j = 0; j < 16; j++) {
            X[i][j] <== m[i * 16 + j];
        }

        
    } 
}

component main = FF();