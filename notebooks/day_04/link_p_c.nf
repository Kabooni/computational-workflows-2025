#!/usr/bin/env nextflow

process SPLITLETTERS {
    input:
    tuple val(metadata), val(in_out)
    output:
    path("${in_out[1]}_block_*")

    publishDir 'results/link_p_c', mode: 'copy'

    script:
    """
    str="${in_out[0]}"
    size=${metadata.block_size}
    prefix="${in_out[1]}_block"

    # Split string into blocks
    i=0
    while [ \$i -lt \${#str} ]; do
        echo "\${str:\$i:size}" | tr a-z A-Z > "\${prefix}_\$i.txt"
        i=\$((i+size))
    done
    """
} 

//process CONVERTTOUPPER {  
//} 

workflow { 
    // 1. Read in the samplesheet (samplesheet_2.csv)  into a channel. The block_size will be the meta-map
    // 2. Create a process that splits the "in_str" into sizes with size block_size. The output will be a file for each block, named with the prefix as seen in the samplesheet_2
    // 4. Feed these files into a process that converts the strings to uppercase. The resulting strings should be written to stdout

    // read in samplesheet}
    channel.fromPath('samplesheet_2.csv')
        .splitCsv(header: true)
        .map { row ->
            def metadata = [
                block_size : row.block_size
            ]
            def in_out = [row.input_str, row.out_name]
            return [metadata, in_out]
        }
        .set {in_ch}

        in_ch.view()
    // split the input string into chunks
    SPLITLETTERS(in_ch)

    // lets remove the metamap to make it easier for us, as we won't need it anymore

    // convert the chunks to uppercase and save the files to the results directory



}