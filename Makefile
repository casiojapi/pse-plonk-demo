INPUT := t5
output := output

tau:
	snarkjs powersoftau new bn128 17 powersoftau16.ptau
	snarkjs powersoftau prepare phase2 powersoftau16.ptau final.ptau

build:
	mkdir -p ${output}
	circom ./circom/main.circom --r1cs --sym --wasm -o ${output}
	snarkjs groth16 setup ${output}/main.r1cs final.ptau crs.zkey
	snarkjs zkey export verificationkey crs.zkey crs.vkey

run:
	node ${output}/main_js/generate_witness.js ${output}/main_js/main.wasm ./inputs/${INPUT}.inputs.json ${output}/${INPUT}.trace.wtns
	snarkjs wtns export json ${output}/${INPUT}.trace.wtns ${output}/${INPUT}.trace.wtns.json
	#jq < ${output}/${INPUT}.trace.wtns.json

bnr: build run

proof: trace.wtns
	snarkjs groth16 prove crs.zkey ${INPUT}.trace.wtns proof.json public.json

clean:
	rm -r main.r1cs main_js main.sym plonk_verification_key.json groth16_verification_key.json groth16_proof.json plonk_proof.json final.ptau public.json witness.* pot16_0000.ptau pot16_0001.ptau powersoftau16.ptau *.sol
