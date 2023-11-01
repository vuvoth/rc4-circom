pragma circom 2.0.0;


template md5(N) {
    signal input m[N];
    signal output abcd[4] // md5 hash function result

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