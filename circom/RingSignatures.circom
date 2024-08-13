pragma circom 2.0.0;

include "circomlib/circuits/ed25519.circom";

template RingSignature(N) {
    signal input priv_key; // Private key as input
    signal output is_valid; // Output signal to indicate valid signature
    
    // Public keys array
    signal input pub_keys[N]; // Array of public keys (size N)
    
    // Computed public key from the private key
    signal computed_pub_key[2];

    // Calculate the public key from the private key using Ed25519
    component pub_key_gen = EdDSAPubKey();
    pub_key_gen.privateKey <== priv_key;
    computed_pub_key[0] <== pub_key_gen.A[0];
    computed_pub_key[1] <== pub_key_gen.A[1];

    // Initialize polynomial to 1 (as we will multiply the terms)
    signal polynomial = 1;

    // Loop through all public keys and compute (computed_pub_key - pub_key_i)
    for (var i = 0; i < N; i++) {
        signal diff = computed_pub_key[0] - pub_keys[i];
        polynomial *= diff;
    }

    // Check if the polynomial equals 0 (i.e., computed_pub_key is in pub_keys)
    is_valid <== (polynomial === 0);
}

component main = RingSignature(3);
