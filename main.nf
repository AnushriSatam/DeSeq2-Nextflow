#!/usr/bin/env nextflow
nextflow.enable.dsl=2
// Define parameters for input files
params.rscript="deseq2_analysis.R"
params.count=null
params.meta=null

// --- 3. Define the DESeq2 Process ---
process DESEQ2_ANALYSIS {
input:
path rscript
path count
path meta

output:
path "deseq2_results.csv", emit:results_csv

script:
    """
    Rscript ${rscript} ${count} ${meta}
    mkdir -p $baseDir/results
    cp deseq2_results.csv $baseDir/results/
    """
}

workflow {
    
    // Parameter Validation
    if (params.count == null || params.meta == null) {
        error "ERROR: Please provide the count matrix file and the metadata file."
    }

    // Call the process
    DESEQ2_ANALYSIS(
        file(params.rscript),
        file(params.count),
        file(params.meta)
    )
    DESEQ2_ANALYSIS.out.results_csv.view { file ->
    log.info "DESeq2 Analysis COMPLETE! Results copied to: $baseDir/results/${file.name}"
    }
}
