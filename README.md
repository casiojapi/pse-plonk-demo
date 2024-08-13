# plonk and groth16 demo


### compile the circuit:

```bash
circom circom/main.circom --r1cs --wasm --sym
```

### powers of tau ceremony

start powers of tau ceremony:
```bash
snarkjs powersoftau new bn128 16 pot16_0000.ptau -v
```

contribute to powers of tau ceremony:
```bash
snarkjs powersoftau contribute pot16_0000.ptau pot16_0001.ptau --name="magaiba so gentle" -v
```

prepare powers of tau setup for phase 2 (circuit-specific phase):
```bash
snarkjs powersoftau prepare phase2 pot16_0001.ptau pot16_final.ptau -v
```

### GROTH16 setup:

perform a trusted setup for Groth16 (circuit-specific):
```bash
snarkjs groth16 setup main.r1cs pot16_final.ptau circuit_groth16_0000.zkey
```

contribute to phase2 cerem of groth16:
```bash
snarkjs zkey contribute circuit_groth16_0000.zkey circuit_groth16_0001.zkey --name="roberto" -v
```

last contribution to phase2 cerem of groth16:
```bash
snarkjs zkey contribute circuit_groth16_0001.zkey circuit_groth16_final.zkey --name="ricardo" -v
```

generate groth16 verification key:
```bash 
snarkjs zkey export verificationkey circuit_groth16_final.zkey groth16_verification_key.json
```

### PLONK setup:
```bash
snarkjs plonk setup main.r1cs pot16_final.ptau circuit_plonk_final.zkey
```

Groth16 requires a trusted ceremony for each circuit. PLONK and FFLONK do not require it, it's enough with the powers of tau ceremony which is universal.


```bash
snarkjs zkey export verificationkey circuit_plonk_final.zkey plonk_verification_key.json
```


### generate proof (groth16):

Create a witness using the input.json file:
```bash
node main_js/generate_witness.js main_js/main.wasm input.json witness.wtns
```

Generate a proof with the previously created witness:
```bash
snarkjs groth16 prove circuit_groth16_final.zkey witness.wtns groth16_proof.json public.json
```

### verify proof (groth16):
Verify the proof using the public inputs and the verification key.
```bash
snarkjs groth16 verify groth16_verification_key.json public.json groth16_proof.json
```

### generate proof (PLONK):
Similar to Groth16, generate the witness.
```bash
node main_js/generate_witness.js main_js/main.wasm input.json witness.wtns
```

Generate a proof with the previously created witness:
```bash
snarkjs plonk prove circuit_plonk_final.zkey witness.wtns plonk_proof.json public.json
```

### Verify Proof (PLONK)

Verify the proof using the public inputs and the verification key.
```bash
snarkjs plonk verify plonk_verification_key.json public.json plonk_proof.json
```

### BONUS TRACK

+ generate plonk solidity verifier:
```bash
snarkjs zkey export solidityverifier circuit_plonk_final.zkey plonk_verifier.sol
```

+ generate groth16 solidity verifier:
```bash
snarkjs zkey export solidityverifier circuit_groth16_final.zkey groth16_verifier.sol
```

+ deploy verifier on-chain

+ verify proofs on-chain



### decode witness to JSON
```sh
snarkjs wtns export json witness.wtns witness.json
```
