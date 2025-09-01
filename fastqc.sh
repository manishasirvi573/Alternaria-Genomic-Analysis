#fastqc for raw reads
#!/bin/bash
__conda_setup="$('/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
eval "$__conda_setup"
THREADS=8
SAMPLES=(2 8 20 24 25 26 34 35 37 38 54 56 58 59 60 64 66 73 79 80 82 89 96 116)
conda activate trim_quality
for fq in ~/my_materials/project/Arborescens_Sequences/*.fq
do
  fastqc $fq -o ~/my_materials/project/fastqc_reports
  echo "Finished: $fq "
done