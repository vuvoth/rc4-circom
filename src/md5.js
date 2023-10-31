// one word 4 bytes or 32 bits
function pad(data = []) {
    let len = data.length;
    let padded = data; 

    for (let i = 0; i < len % 14; ++i) {
        padded.push(0);
    }
    
    if (len <= 4294967295) {
        padded.push(0);
        padded.push(len);
    } else {
        // bug resolve later
        padded.push(len >>> 32);
        padded.push(len);
    }
}


function F(x, y, z) {
    return (x & y) | (~x & y);
}

function G(x, y, z) {
    return (x & z) | (y & ~ z)
}

function H(x, y, z) {
    return x^ y ^ z;
}

function I(x, y, z) {
    return y ^ (x | ~z)
}

function FF(a, b, c, d, k, s, i) {
    
}
function md5(data = []) {

}


