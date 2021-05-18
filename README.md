# structural_motifs

A program for calculating enriched structural motifs using constraints from RNA proximity ligation experiments.

## Background

RNA proximity ligation methods such as CLASH, HiC, PARIS, SPLASH, and COMRADES generate chimeric reads that represent RNA-RNA interactions.

Structural_motifs inputs a tab-delimited file with chimeric reads (with the sequences of arms 1 and 2 of each chimera in separate columns), and outputs a graph with structural motif enrichments

### Prerequisites

Linux operating system

UNAFold http://unafold.rna.albany.edu/?q=DINAMelt/software

bedtools v2.16.2

### Installation

```
# clone package using git:
git clone https://github.com/gkudla/structural_motifs.git
```

Add installation location to your PATH:

```
export PATH="path-to-installation-folder/structural_motifs/bin:$PATH"
```

## Running the scripts

To test the programs, first copy the example input files from structural_motifs/data into a folder of your choice, then run the commands below. Typical run time on the test data is less than 1 minute 

generate folding constraints

```
structural_motifs JKD_RNaseY_RPMI_JOIN_intermolecular_hybs_filtered.txt
```

## Outputs
 
```
# plot with structural motif frequencies on the X axis and motif enrichment on the Y axis
JKD_RNaseY_RPMI_JOIN_intermolecular_hybs_filtered.pdf

```

## Author

* Grzegorz Kudla, 2020

## License

This project is licensed under the GNU General Public License v3 - see the [LICENSE.md](LICENSE.md) file for details
