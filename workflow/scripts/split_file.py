#!/usr/bin/env python3

import re
import os
from multiprocessing import Pool
import tempfile

memeHeader = '''MEME version 4

ALPHABET= ACGT

strands: + -

Background letter frequencies
A 0.25 C 0.25 G 0.25 T 0.25

'''

dbFilePath = snakemake.input['db_file']
all_kmers = snakemake.input['kmers']
numFiles = snakemake.threads
k_min = snakemake.config['min_word_length']
k = snakemake.config['word_length']    
subMers = k - k_min
dbFileName = snakemake.config['tf_database_file']

files = []
for i in range(numFiles):
    f = tempfile.NamedTemporaryFile(mode='w+t')
    if i > 0: f.write(memeHeader)
    files.append(f)

with open(dbFilePath, "r") as fp:
    i = 0
    motif = []
    for line in fp:
        if line.startswith('MOTIF'):
            files[i%numFiles].write('\n'.join(motif))
            i+=1
            motif = [line.strip()]
        elif line.startswith('URL'):
            motif.append(line)
            freqData = motif[2:-1]
            curK = len(freqData)
            if curK > k:
                motifName = motif[0].strip()
                headerValues = re.findall('\d+', motif[1])
                url = motif[-1]
                motif = []
                for startInd in range(curK - k_min + 1):
                    for endInd in range(k_min + startInd - 1, min(curK, startInd + k_min + subMers)):
                        subMotifName = f'{motifName}_{startInd}_{endInd}'
                        subMotif = freqData[startInd:endInd + 1]
                        motif.append(subMotifName)
                        motif.append(f'letter-probability matrix: alength= {headerValues[0]} w= {len(subMotif)} nsites= {headerValues[2]} E= {headerValues[3]}')
                        motif += subMotif
                        motif.append(url)
                    
        else:
            motif.append(line.strip())

for f in files:
    f.seek(0)

def run_fimo(i, fileName):
    out = f'{os.environ["TMPDIR"]}/{dbFileName}.{k}_{k_min}mers.{i}.fimo.txt'
    print(f'running fimo {i} on input {fileName}')
    os.system(f'fimo --skip-matched-sequence {fileName} {all_kmers} > {out}')
    print(f'fimo output {i} written to {out}')

with Pool(numFiles) as pool:
    pool.starmap(run_fimo, enumerate(map(lambda f: f.name, files)))

for f in files:
    f.close()