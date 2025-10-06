params.step = 0


workflow{

    // Task 1 - Read in the samplesheet.

    if (params.step == 1) {
        channel.fromPath('samplesheet.csv').splitCsv(header: true).view()
    }

    // Task 2 - Read in the samplesheet and create a meta-map with all metadata and another list with the filenames ([[metadata_1 : metadata_1, ...], [fastq_1, fastq_2]]).
    //          Set the output to a new channel "in_ch" and view the channel. YOU WILL NEED TO COPY AND PASTE THIS CODE INTO SOME OF THE FOLLOWING TASKS (sorry for that).

    if (params.step == 2) {
        channel.fromPath('samplesheet.csv')
        .splitCsv(header: true)
        .map { row ->
            def metadata = [
                sample : row.sample,
                strandedness: row.strandedness
            ]
            def fastqs = [row.fastq_1, row.fastq_2]
            return [metadata, fastqs]
        }
        .set {in_ch}

        in_ch.view()
    }

    // Task 3 - Now we assume that we want to handle different "strandedness" values differently. 
    //          Split the channel into the right amount of channels and write them all to stdout so that we can understand which is which.

    if (params.step == 3) {
        channel.fromPath('samplesheet.csv')
        .splitCsv(header: true)
        .map { row ->
            def metadata = [
                sample : row.sample,
                strandedness: row.strandedness
            ]
            def fastqs = [row.fastq_1, row.fastq_2]
            return [metadata, fastqs]
        }
        .set {in_ch}

        def auto_ch = in_ch.filter {it[0].strandedness == "auto"}
        def forward_ch = in_ch.filter {it[0].strandedness == "forward"}
        def reverse_ch = in_ch.filter {it[0].strandedness == "reverse"}

        auto_ch
        .map { it -> ["auto channel:", it] }
        .view()
        forward_ch
        .map { it -> ["forward channel:", it] }
        .view()
        reverse_ch
        .map { it -> ["reverse channel:", it] }
        .view()
        
    }

    // Task 4 - Group together all files with the same sample-id and strandedness value.

    if (params.step == 4) {
        channel.fromPath('samplesheet.csv')
        .splitCsv(header: true)
        .map { row ->
            def metadata = [
                sample : row.sample,
                strandedness: row.strandedness
            ]
            def fastqs = [row.fastq_1, row.fastq_2]
            return [metadata, fastqs]
        }
        .set {in_ch}

        in_ch
        .groupTuple()
        .set { grouped_ch }

        grouped_ch.view()
        
    }



}