#!/usr/bin/env nextflow

process CALLPEAK{
    container "ghcr.io/bf528/macs3:latest"
    label "process_medium"
    publishDir params.outdir

    input:
    tuple val(replicate), path(IP), path(CONTROL)

    output:
    tuple val(replicate), path("*.narrowPeak"), emit: peaks

    shell:
    """
    macs3 callpeak -t $IP -c $CONTROL -n $replicate -f BAM -g hs
    """
}