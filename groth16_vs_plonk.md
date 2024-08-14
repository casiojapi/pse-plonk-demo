# porque compararlo con groth16?

En este momento, la mayoria de las aplicaciones que hay en produccion usando zk, usan groth16 o plonk. 

Algunos ejemplos de groth16:
+ tornado cash
+ zcash
Some projects that use Groth16 include ZCash, Loopring, Hermez, Celo, and Filecoin.
Algunos ejemplos de PLONK:
Some projects that use PlonK include Aztec, ZKSync, and Dusk.

# intro groth16

more info: http://www.zeroknowledgeblog.com/index.php/groth16

## PLONK IS FASTER THAN GROTH!1!1!!!

Context. Groth16 requires a circuit-specific trusted setup; proving satisfiability of a new circuit requires running a new trusted setup. Plonk has a universal setup, meaning that a single setup supports all circuits up to a specified size bound. One might expect that the Plonk prover should pay a performance price for achieving a universal setup, yet many people believe that the Plonk prover is actually faster than the Groth16 prover. 

The truth is more nuanced.

Details. Plonk cannot support R1CS without overheads. Groth16 targets R1CS but cannot support Plonkish circuits. As a result, the types of circuits they support are incomparable. But both do support circuits with addition and multiplication gates of fan-in two, and when applied to such circuits Groth16 is actually faster than Plonk. 

Specifically, Plonk requires the prover to do 11 multi-scalar-multiplications (MSMs), each of length equal to the number of gates in the circuit, meaning both multiplication and addition gates.

Groth16 needs just 3 MSMs on group G1 and 1 MSM on G2 (where G1  and G2 are groups equipped with a pairing). Moreover, for Groth16 each of these MSMs is of size equal only to the number of multiplication gates only (addition gates are “free” in Groth16). MSMs over G2 are roughly 2-to-3 times slower than over G1, so this equates to 5 to 6 MSMs over G1, each of size equal to the number of multiplication gates. This could be many times faster than the Plonk prover’s work, depending on the number of addition gates.

Many people believe that Plonk is faster than Groth16 because, for some important applications, Plonkish circuits can be substantially smaller than R1CS instances capturing the same application (examples include MinRoot and Pedersen hashing). But taking advantage of this requires having the time and expertise to write an optimized Plonkish circuit (unless, of course, someone else has already done that work). This work is often done by hand, although it’s conceivable that future compilers may be able to automatically leverage the full expressive power of Plonkish circuits. The way it’s done today is time-intensive and difficult (and any error in specifying the Plonkish constraint system will destroy the security of the system). 

Moreover, as mentioned in #5 above, many people don’t realize that Groth16 and its predecessors can be modified to support arbitrary degree-2 constraints, not only rank-one. (Non-rank-one constraints are sometimes called custom constraints.) The limitation of Groth16 is in being unable to move beyond degree-2 constraints, not in lack of support for custom constraints. (Another little-known fact is that predecessors of Groth16 such as Zaatar can handle high-degree constraints, but they yield two-round, private-coin arguments, so they do not allow on-chain verification.) 

The bottom line. Plonk can yield a faster prover than Groth16 – but not always. And even when it can, making this happen often requires considerable expertise and time investment on the part of the developer.


# efficiency comparison

graph
