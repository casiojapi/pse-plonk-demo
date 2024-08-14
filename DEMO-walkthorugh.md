## Compile the Circuit
```bash
circom circom/main.circom --r1cs --wasm --sym
```
> compiling the circuit: this command compiles the main.circom file into several output files:
>    - main.r1cs: the circuit's rank-1 constraint system (r1cs), representing the circuit as a system of equations.
>    - main.wasm: webassembly code for generating witnesses.
>    - main.sym: a symbol file for debugging and understanding the constraint system.


## Powers of Tau Ceremony

### Start the Ceremony:
```bash
snarkjs powersoftau new bn128 16 pot16_0000.ptau -v
```
> starting the ceremony: this starts the powers of tau ceremony using the bn128 elliptic curve with 2^16 constraints. the output is the initial powers of tau file, pot16_0000.ptau, which will be the basis for further contributions.

### Contribute to the Ceremony:

```bash
snarkjs powersoftau contribute pot16_0000.ptau pot16_0001.ptau --name="magaiba so gentle" -v
```
> This command contributes additional entropy to the Powers of Tau file. The new file pot16_0001.ptau contains this additional contribution.

### Prepare for Circuit-Specific Phase (Phase 2):

```bash
snarkjs powersoftau prepare phase2 pot16_0001.ptau pot16_final.ptau -v
```

> this prepares the powers of tau file for use in the circuit-specific setup (phase 2). the output pot16_final.ptau is ready for use in either groth16 or plonk setups.

## Groth16 Setup
```bash
snarkjs groth16 setup main.r1cs pot16_final.ptau circuit_groth16_0000.zkey
```

> This command uses the R1CS and the finalized ptau file to create a zero-knowledge key (circuit_groth16_0000.zkey) specifically for Groth16. This setup is necessary to generate and verify Groth16 proofs.

### Contribute to Phase 2 (Groth16):

```bash
snarkjs zkey contribute circuit_groth16_0001.zkey circuit_groth16_final.zkey --name="ricardo" -v
```
> similar to the powers of tau phase, additional entropy is added to the zero-knowledge key in the circuit-specific phase. the result is a more secure key (circuit_groth16_0001.zkey).

### generate groth16 verification key:

```bash
snarkjs zkey export verificationkey circuit_groth16_final.zkey groth16_verification_key.json
```
> this command extracts the verification key from the final groth16 zero-knowledge key.

### PLONK Setup

```bash
snarkjs plonk setup main.r1cs pot16_final.ptau circuit_plonk_final.zkey
```
> plonk: this command uses the r1cs and the finalized powers of tau file to create a zkey (circuit_plonk_final.zkey) for plonk. unlike groth16, plonk doesn't require a circuit-specific trusted setup, making this process simpler.

### Generate PLONK Verification Key:

```bash
snarkjs zkey export verificationkey circuit_plonk_final.zkey plonk_verification_key.json
```

> similar to groth16, this command extracts the verification key from the plonk zkey.


## Generate Proofs

```bash
node main_js/generate_witness.js main_js/main.wasm input.json witness.wtns
```
> this command uses the webassembly file (main.wasm) and input values (input.json) to generate a witness (witness.wtns). the witness contains all intermediate values needed to create a zk proof.

### Generate Groth16 Proof:

```bash
snarkjs groth16 prove circuit_groth16_final.zkey witness.wtns groth16_proof.json public.json
```

> this command generates a zk proof (groth16_proof.json) using the final groth16 zkey and witness. the public inputs and outputs are stored in public.json.


### Generate PLONK Proof:
```bash
snarkjs plonk prove circuit_plonk_final.zkey witness.wtns plonk_proof.json public.json
```
> similar to groth16, this command generates a zk proof (plonk_proof.json) using the plonk zkey and witness. the public inputs and outputs are stored in public.json.


## Verify Proofs

### Verify Groth16 Proof:
```bash
snarkjs groth16 verify groth16_verification_key.json public.json groth16_proof.json
```

> this command verifies the groth16 proof using the verification key and the public inputs/outputs.


### Verify PLONK Proof:

```bash
snarkjs plonk verify plonk_verification_key.json public.json plonk_proof.json
```
> this command verifies the plonk proof in the same way as the groth16 proof, ensuring that the proof is valid.

## Generate Solidity Verifiers

#### Plonk
```bash
snarkjs zkey export solidityverifier circuit_plonk_final.zkey plonk_verifier.sol
```

#### Groth16
```bash
snarkjs zkey export solidityverifier circuit_groth16_final.zkey groth16_verifier.sol
```

## Decode Witness to JSON (Optional)
```bash
snarkjs wtns export json witness.wtns witness.json
```
