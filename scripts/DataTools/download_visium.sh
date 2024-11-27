# Download Visium dataset

# Create the directory if it does not exist
mkdir -p data/Visium/input

# Change to the input directory
cd data/Visium/input || exit

# Download single nucleus count matrix for female mice
if [ ! -f "5705STDY8058280_filtered_feature_bc_matrix.h5" ]; then
    wget https://www.ebi.ac.uk/biostudies/files/E-MTAB-11115/5705STDY8058280_filtered_feature_bc_matrix.h5
fi
if [ ! -f "cell_annotation.csv" ]; then
    wget https://www.ebi.ac.uk/biostudies/files/E-MTAB-11115/cell_annotation.csv
fi

# Download spatial count matrix and coordinates for female mice
if [ ! -f "ST8059048_filtered_feature_bc_matrix.h5" ]; then
    wget https://www.ebi.ac.uk/biostudies/files/E-MTAB-11114/ST8059048_filtered_feature_bc_matrix.h5
fi
if [ ! -f "ST8059048_spatial.tar.gz" ]; then
    wget https://www.ebi.ac.uk/biostudies/files/E-MTAB-11114/ST8059048_spatial.tar.gz
fi

# Extract the spatial data if not already extracted
if [ ! -d "spatial" ]; then
    tar -xvzf ST8059048_spatial.tar.gz
fi

echo "Download Visium dataset completed"