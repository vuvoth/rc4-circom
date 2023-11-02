var assert = require("assert");
const wasm_tester = require("circom_tester/wasm/tester");
const md5 = require("md5");
const path = require("path");

describe("Md5 circuit", function () {
  it("md5 hash function", async function () {
    let m = md5("They are deterministic");
    const circuit = await wasm_tester(
      path.join(__dirname, "../", "circuits", "md5.circom")
    );

    let m_input = [
        0x54686579, 0x20617265, 0x20646574, 0x65726d69, 0x6e697374, 0x69638000,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0x000000b0,
      ];

    console.log(m_input);
    let witness = await circuit.calculateWitness({
      m: m_input
    });

    console.log(witness);
  });
});
