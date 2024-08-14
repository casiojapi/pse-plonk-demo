## Compile the Circuit
```bash
circom circom/main.circom --r1cs --wasm --sym
```
> compiling the circuit: This command compiles the main.circom file into several output files:
>    - main.r1cs: The circuit's Rank-1 Constraint System (R1CS), representing the circuit as a system of equations.
>    - main.wasm: WebAssembly code for generating witnesses.
>    - main.sym: A symbol file for debugging and understanding the constraint system.


## Powers of Tau Ceremony

### Start the Ceremony:
```bash
snarkjs powersoftau new bn128 16 pot16_0000.ptau -v
```
Starting the Ceremony: This starts the Powers of Tau ceremony using the bn128 elliptic curve with 2^16 constraints. The output is the initial Powers of Tau file, pot16_0000.ptau, which will be the basis for further contributions.

### Contribute to the Ceremony:

```bash
snarkjs powersoftau contribute pot16_0000.ptau pot16_0001.ptau --name="magaiba so gentle" -v
```
Adding Entropy: This command contributes additional entropy to the Powers of Tau file. The new file pot16_0001.ptau contains this additional contribution, making the setup more secure.

### Prepare for Circuit-Specific Phase (Phase 2):

```bash
snarkjs powersoftau prepare phase2 pot16_0001.ptau pot16_final.ptau -v
```

Finalizing Phase 1: This prepares the Powers of Tau file for use in the circuit-specific setup (Phase 2). The output pot16_final.ptau is ready for use in either Groth16 or PLONK setups.
3. Groth16 Setup
Trusted Setup for Groth16:
bash
Copy code
snarkjs groth16 setup main.r1cs pot16_final.ptau circuit_groth16_0000.zkey
What's Happening:

Circuit-Specific Setup: This command uses the R1CS and the finalized Powers of Tau file to create a zero-knowledge key (circuit_groth16_0000.zkey) specifically for Groth16. This setup is necessary to generate and verify Groth16 proofs.
Contribute to Phase 2 (Groth16):

bash
Copy code
snarkjs zkey contribute circuit_groth16_0000.zkey circuit_groth16_0001.zkey --name="roberto" -v
What's Happening:

Enhancing Security: Similar to the Powers of Tau phase, additional entropy is added to the zero-knowledge key in the circuit-specific phase. The result is a more secure key (circuit_groth16_0001.zkey).
Final Contribution to Phase 2 (Groth16):

bash
Copy code
snarkjs zkey contribute circuit_groth16_0001.zkey circuit_groth16_final.zkey --name="ricardo" -v
What's Happening:

Finalizing the Setup: This is the final contribution to the Groth16 key, resulting in a secure and final zero-knowledge key (circuit_groth16_final.zkey).
Generate Groth16 Verification Key:

bash
Copy code
snarkjs zkey export verificationkey circuit_groth16_final.zkey groth16_verification_key.json
What's Happening:
Extracting the Verification Key: This command extracts the verification key from the final Groth16 zero-knowledge key. The verification key (groth16_verification_key.json) will be used to verify Groth16 proofs.
4. PLONK Setup
bash
Copy code
snarkjs plonk setup main.r1cs pot16_final.ptau circuit_plonk_final.zkey
What's Happening:

Setting Up PLONK: This command uses the R1CS and the finalized Powers of Tau file to create a universal zero-knowledge key (circuit_plonk_final.zkey) for PLONK. Unlike Groth16, PLONK doesn't require a circuit-specific trusted setup, making this process simpler.
Generate PLONK Verification Key:

bash
Copy code
snarkjs zkey export verificationkey circuit_plonk_final.zkey plonk_verification_key.json
What's Happening:
Extracting the Verification Key: Similar to Groth16, this command extracts the verification key from the PLONK zero-knowledge key. The verification key (plonk_verification_key.json) will be used to verify PLONK proofs.
5. Generate Proofs
Create a Witness:
bash
Copy code
node main_js/generate_witness.js main_js/main.wasm input.json witness.wtns
What's Happening:

Generating the Witness: This command uses the WebAssembly file (main.wasm) and input values (input.json) to generate a witness (witness.wtns). The witness contains all intermediate values needed to create a zero-knowledge proof.
Generate Groth16 Proof:

bash
Copy code
snarkjs groth16 prove circuit_groth16_final.zkey witness.wtns groth16_proof.json public.json
What's Happening:

Creating the Proof: This command generates a zero-knowledge proof (groth16_proof.json) using the final Groth16 zero-knowledge key and the witness. The public inputs and outputs are stored in public.json.
Generate PLONK Proof:

bash
Copy code
snarkjs plonk prove circuit_plonk_final.zkey witness.wtns plonk_proof.json public.json
What's Happening:
Creating the Proof: Similar to Groth16, this command generates a zero-knowledge proof (plonk_proof.json) using the PLONK zero-knowledge key and the witness. The public inputs and outputs are stored in public.json.
6. Verify Proofs
Verify Groth16 Proof:
bash
Copy code
snarkjs groth16 verify groth16_verification_key.json public.json groth16_proof.json
What's Happening:

Verifying the Proof: This command verifies the Groth16 proof using the verification key and the public inputs/outputs. A successful verification will confirm the integrity and correctness of the proof.
Verify PLONK Proof:

bash
Copy code
snarkjs plonk verify plonk_verification_key.json public.json plonk_proof.json
What's Happening:
Verifying the Proof: This command verifies the PLONK proof in the same way as the Groth16 proof, ensuring that the proof is valid.
7. Bonus: Generate Solidity Verifiers
Generate PLONK Solidity Verifier:
bash
Copy code
snarkjs zkey export solidityverifier circuit_plonk_final.zkey plonk_verifier.sol
What's Happening:

Exporting the Verifier: This command exports a Solidity smart contract (plonk_verifier.sol) that can be deployed on a blockchain to verify PLONK proofs on-chain.
Generate Groth16 Solidity Verifier:

bash
Copy code
snarkjs zkey export solidityverifier circuit_groth16_final.zkey groth16_verifier.sol
What's Happening:
Exporting the Verifier: Similarly, this command exports a Solidity smart contract (groth16_verifier.sol) to verify Groth16 proofs on-chain.
8. Decode Witness to JSON (Optional)
sh
Copy code
snarkjs wtns export json witness.wtns witness.json
What's Happening:
Converting Witness to JSON: This command converts the binary witness file (witness.wtns) to a human-readable JSON format (witness.json). This is useful for debugging or analysis purposes.
