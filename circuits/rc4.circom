pragma circom 2.0.0;


template right(N){
    signal input in;
    var x = 2;
    var t = 5;
    if(in > N){
      t = 2;
    }
}

component main = right(10);
