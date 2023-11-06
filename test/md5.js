var assert = require("assert");
const { utf8 } = require("charenc");
const wasm_tester = require("circom_tester/wasm/tester");
const crypt = require("crypt");
const { bytesToWords, bytesToHex } = require("crypt");
const md5 = require("md5");
const path = require("path");

describe("Md5 circuit", function () {
  it("md5 hash function", async function () {
    let hash = md5("They are deterministic");
    const circuit = await wasm_tester(
      path.join(__dirname, "../", "circuits", "md5.circom")
    );

    let bytes = utf8.stringToBytes("They are deterministic");

    let m = bytesToWords(bytes);
    let l = bytes.length * 8;

    for (var i = 0; i < m.length; i++) {
      m[i] =
        (((m[i] << 8) | (m[i] >>> 24)) & 0x00ff00ff) |
        (((m[i] << 24) | (m[i] >>> 8)) & 0xff00ff00);
      m[i] = m[i];
    }
    m[l >>> 5] |= 0x80 << (bytes.length * 8) % 32;

    while (m.length % 14 != 0) {
      m.push(0);
    }
    m.push(bytes.length * 8);
    m.push(0);

    for (let i = 0; i < m.length; ++i) {
      m[i] = m[i] >>> 0;
    }

    let witness = await circuit.calculateWitness({
      m: m,
    });

    let hash_bytes = crypt.hexToBytes(hash);
    let h = witness[1];
    for (let i = 15; i >= 0; --i) {
      assert(BigInt(hash_bytes[i]) == h % 256n);
      h = h >> 8n;
    }
  });
});
